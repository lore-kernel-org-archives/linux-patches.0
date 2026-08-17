Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEE644239E;
	Mon, 17 Aug 2026 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977470; cv=none; b=KDLgqhdI0CyYJ6ily14n3HAqjbw55I/8rGbEKd1IJMTk4NmRyUjHjHH6N2D6UTjxmagsZzZy7rSjmvNY9zIZ3wenA4flY0NdJfhR1D1KckZ8LV4r2gHpPsu72FaKodcou+AN91y5k68ibNg6GFXy/ovqyf89kGZO3jw5Z9XeSEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977470; c=relaxed/simple;
	bh=NkYIXEQSdVwFhkkgowYKGI3iy7x87JJzd0PVlRtjM+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYaZemAdEfjSNafHupMo4O/uezvwxqUcYGYS/J8uqWz8Nkjx6Z+91i94yVptzf1ywMsujFDC+OjE02asieMO7D1wjDdpLhqt6XJt0gZGrQHFpt7YDgKT6HcMU4vw89D/dXDmre0j5GbC+qhKo9uCU3l8dLLyiN5X+TauS/YutMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uslSVYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uslSVYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773241F00A3A;
	Mon, 17 Aug 2026 14:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977469;
	bh=B8eEVffnpY6s56Ew4RbO2wzqDk923qv4+dLcRWSoCA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uslSVYyCm6aa3XZrOgnSrqhuJe3uhGwObTQTx4/SGjpyAArYtv9bsNNj/KVDhkNM
	 P8tNtePMynNyzhEa3ibMf26Kwm14RN8IeoI3D/uaV11QT7OUTBO/I8PW/OIQsNopey
	 pRt3K0l4CySgbrT83kJw5nLB0H7C/J7QfAzzMfDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 313/456] net/smc: fix socket use-after-free during link group termination
Date: Mon, 17 Aug 2026 15:31:43 +0200
Message-ID: <20260817132551.980273762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit f621d6ebeebb6374342571e4ddf45fdbc420f6cd upstream.

__smc_lgr_terminate() drops conns_lock after finding a connection in
lgr->conns_all, but before taking a reference on its socket. The connection
is embedded in the socket, and its registration reference protects it only
while the connection remains in the tree.

A concurrent close can unregister the connection and drop that reference,
freeing the socket before the termination worker reaches sock_hold().

The race is reachable when close overlaps link group termination.
Local stress testing reproduced the use-after-free and KASAN reported:

  BUG: KASAN: slab-use-after-free in __smc_lgr_terminate.part.0 [smc]
  Write of size 4 by task kworker/3:3
  Workqueue: events smc_lgr_terminate_work [smc]
  __smc_lgr_terminate.part.0 [smc]

The socket was allocated by smc_create(), freed through
slab_free_after_rcu_debug(), and was followed by:

  refcount_t: addition on 0; use-after-free.
  __smc_lgr_terminate.part.0 [smc]

Take the socket reference while conns_lock still protects the tree entry.
The unregister path then cannot drop the last reference until termination
has finished using the socket.

Fixes: 69318b5215f2 ("net/smc: improve abnormal termination locking")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Link: https://patch.msgid.link/20260723105454.87016-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1304,10 +1304,10 @@ static void __smc_lgr_terminate(struct s
 	read_lock_bh(&lgr->conns_lock);
 	node = rb_first(&lgr->conns_all);
 	while (node) {
-		read_unlock_bh(&lgr->conns_lock);
 		conn = rb_entry(node, struct smc_connection, alert_node);
 		smc = container_of(conn, struct smc_sock, conn);
 		sock_hold(&smc->sk); /* sock_put below */
+		read_unlock_bh(&lgr->conns_lock);
 		lock_sock(&smc->sk);
 		smc_conn_kill(conn, soft);
 		release_sock(&smc->sk);


