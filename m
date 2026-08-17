Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07C52E7BD6;
	Mon, 17 Aug 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980078; cv=none; b=ZvN7HAqfKaoKF+dP7Q4YZoC2IalGDb87Ir/Xa97IWDO5CfKhSmb5aHonvvt2tL9+kPLPaCpZeJygk0eiVfbTaKfPIX8pFsMfd3Rac+W5dzN1qyggaBWTjanDuYk4WPgEz1VO/VSoNOcn2WK7Y+vxA5NGl/5TkTZ0PaVaJy8xtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980078; c=relaxed/simple;
	bh=91/lRlppNzPtVJhAMN9idm+q0gabbhkny8a2QiODGqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+ecewK7o44RyunuINI0o+kz6Eg99n9BHhH8RPQ+pZgqjHbX5xnfpejnFUb13U+7HtvYhC4TDVwitY4y+eLe62CuvKA5BaJCex8uAUbJSoYhV9isTrx7UjK3JtE467u+luE8VrJBjfcB5LFXr+eI7/rV6Z4/MrZK1Wsciv7PWT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXUDB6rN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXUDB6rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A2C1F000E9;
	Mon, 17 Aug 2026 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980076;
	bh=ivqI4Vv9ffCxD32tsOmG72paWcakRb8/oAX73O038Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXUDB6rNVoGURbiUN9Ih/R5Lcvwx+90ser+ifgzz/HMdeP+/LGBj4w4sRu3qQOAZD
	 QcW2kI0SXAVZ7TTk8dwcA5wEdnsJhc+EuYOuuZOshWRyLVDS2o+g6dbVSIZczQC874
	 SSAPNTDKXAYhYhJk70sAeFWTmZw4CYrc5oulSr08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 409/609] net/smc: fix socket use-after-free during link group termination
Date: Mon, 17 Aug 2026 15:31:45 +0200
Message-ID: <20260817132557.854438728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1468,10 +1468,10 @@ static void __smc_lgr_terminate(struct s
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


