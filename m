Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A52427FA1;
	Mon, 17 Aug 2026 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979561; cv=none; b=VZkU0rfrhJS1fKCiICT72OauvnWMj1pbbxVwSBK/52mk1urlOAWpnxPuKWfZuhmpHnS+XVfTVr8+HlbtX62WRIQF8521mqafpAfk/EjZvzfTbaVPPKKTnczQyZtDvX4gZKS+kSZ7oNrEdwmTnlld8n/t023aV6I03kd7zpq7LeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979561; c=relaxed/simple;
	bh=taAnMHpnsJKhlg3R5D7vXRbmJoGo1MQ5wSk5645xbt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7PQGd+eWsIWye0hhEIqQqlrMi/0nvG0azMgrSIphWSfoORTL2zBNRx9YryLuaXsItEIKUk12Z8rLZVs2W6rDNXhx9kTMFaNTsua0i9An/+WkdReldbKGn2rk/rZ3Aky/Q1ltqoNxR5Z7AYHdrQSRC3yff7VMmaiIx4jG7sdgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTAiidPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTAiidPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F8F1F000E9;
	Mon, 17 Aug 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979559;
	bh=02C0zassiC+xGfVEIE8iceJ9sXpX9nBav9vPcHPyM30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTAiidPZy4i9DPOwCXBR16FGQcx2EuDgo+JnMWzY1c2CX69SSwp/0gWk+Yae+w229
	 XFHwruM0/SbJDx5UV5MfZfDJ8kVtiIEJzTPqjKOz7svzhUpikvrfbpsyNAfwpQoCBO
	 64Nj44m2TkbhGKs39D44HYMT/oA2ovfn0BNcEU9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 267/609] net/x25: fix use-after-free in x25_kill_by_neigh()
Date: Mon, 17 Aug 2026 15:29:23 +0200
Message-ID: <20260817132553.048297676@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

commit 5499e0602d2faafd42c580d25f615903c3fbe11b upstream.

x25_kill_by_neigh() walks the global X.25 socket list looking for sockets
attached to a terminating neighbour. x25_list_lock protects list membership
while the lookup is in progress, but it does not pin a socket's lifetime
after the lock is dropped.

The function currently drops x25_list_lock before calling lock_sock(s). A
concurrent close can run x25_release(), remove the same socket from
x25_list, and drop the last socket reference in that window. The neighbour
teardown path can then lock or inspect a freed struct sock/struct x25_sock.

Take sock_hold(s) while x25_list_lock still proves that the list entry is
live, then drop the temporary reference after the socket has been locked,
rechecked, and released. Recheck x25_sk(s)->neighbour after lock_sock(),
because another path may have disconnected the socket before this path
acquired the socket lock. Restart the list walk after each disconnect
because the list lock was dropped and the previous iterator state may no
longer be valid.

A QEMU/KASAN run against origin/master reproduced a slab-use-after-free in
x25_kill_by_neigh().

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20260713104752.241175-1-david.lee@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/af_x25.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1773,15 +1773,19 @@ void x25_kill_by_neigh(struct x25_neigh
 {
 	struct sock *s;
 
+again:
 	write_lock_bh(&x25_list_lock);
 
 	sk_for_each(s, &x25_list) {
 		if (x25_sk(s)->neighbour == nb) {
+			sock_hold(s);
 			write_unlock_bh(&x25_list_lock);
 			lock_sock(s);
-			x25_disconnect(s, ENETUNREACH, 0, 0);
+			if (x25_sk(s)->neighbour == nb)
+				x25_disconnect(s, ENETUNREACH, 0, 0);
 			release_sock(s);
-			write_lock_bh(&x25_list_lock);
+			sock_put(s);
+			goto again;
 		}
 	}
 	write_unlock_bh(&x25_list_lock);


