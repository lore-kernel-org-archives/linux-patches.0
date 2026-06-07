Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A0E2AD00;
	Sun,  7 Jun 2026 10:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827369; cv=none; b=FP923J/otkaYKx2SJv5Exvr6jALeQRVKm+ZT/8y5mEJD3uAZ2J4yS7v6rzloOm1BEgTLOZJdyj0w/MGY8uN3lPYWkcBJbed40RDH1kUXC8lHe/J0Bgscb4gvSgW97OKEAQlCtUMz4cIFai5sQti8yT3My7Hjk/FRJCc77sZl+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827369; c=relaxed/simple;
	bh=vQYZ6E8+QBB/WuUBxc8FnJ7p0HfGG8TaMlFaIHavgGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAV2fL7FwlpmNW5cAFao3DWEVhXzFkR2aeIx4VmtXpa8cyos6frPLrW/MzgN740Z+zhc9xIoKaDoKtUxvsq8zuozmJDmRiV2liLGiB94mkHmVq1fyMEafWgUd/8qUT2ynmNbjILDKg4HZz/4hu7tnRiB+U5wnVNao2E85TLuA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSFSY5JO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSFSY5JO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FC61F00893;
	Sun,  7 Jun 2026 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827368;
	bh=oY411OjsxxUELtRMfZJJJd94dEEV4TALC+hNjUJH/nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSFSY5JOGAwx3g+rGTUDDX/6+x/8P6TAqQP2xVLSEOk1dj4tSSRCFyI805yi+sFAk
	 Rg3838FuWuVBfv6PCyLx/RKX0Q5Xi8Ngg8nVSP/IKIvbEalA7cMuExLY/4ZEfuqOyv
	 WXfeq9+XvXeTZfOZ98d3iwZUoReFTVHIzBT9pxQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 087/332] net/handshake: Use spin_lock_bh for hn_lock
Date: Sun,  7 Jun 2026 11:57:36 +0200
Message-ID: <20260607095731.342058596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit cc993e0927ec8bd98ea33377ada03295fcda0f24 ]

nvmet_tcp_state_change(), a socket callback that runs in BH context,
can reach handshake_req_cancel() via nvmet_tcp_schedule_release_queue()
and tls_handshake_cancel().  handshake_req_cancel() acquires
hn->hn_lock with plain spin_lock().  If a process-context thread on
the same CPU holds hn->hn_lock when a softirq invokes the cancel path,
the lock attempt deadlocks.  This is the only caller that invokes
tls_handshake_cancel() from BH context; every other consumer calls it
from process context.

Deferring the cancel to process context in the NVMe target is not
straightforward: nvmet_tcp_schedule_release_queue() must call
tls_handshake_cancel() atomically with its state transition to
DISCONNECTING.  If the cancel were deferred, the handshake completion
callback could fire in the window before the cancel runs, observe the
unexpected state, and return without dropping its kref on the queue.
Reworking that interlock is considerably more invasive than hardening
the handshake lock.  Convert all hn->hn_lock acquisitions from
spin_lock/spin_unlock to spin_lock_bh/spin_unlock_bh so the lock is
never taken with softirqs enabled.

Fixes: 675b453e0241 ("nvmet-tcp: enable TLS handshake upcall")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260525-handshake-file-pin-v3-1-66c616906ead@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/netlink.c |  4 ++--
 net/handshake/request.c | 14 +++++++-------
 net/handshake/tlshd.c   |  2 ++
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index b989456fc4c5ff..97114ec8027a5a 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -202,10 +202,10 @@ static void __net_exit handshake_net_exit(struct net *net)
 	 * accepted and are in progress will be destroyed when
 	 * the socket is closed.
 	 */
-	spin_lock(&hn->hn_lock);
+	spin_lock_bh(&hn->hn_lock);
 	set_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags);
 	list_splice_init(&requests, &hn->hn_requests);
-	spin_unlock(&hn->hn_lock);
+	spin_unlock_bh(&hn->hn_lock);
 
 	while (!list_empty(&requests)) {
 		req = list_first_entry(&requests, struct handshake_req, hr_list);
diff --git a/net/handshake/request.c b/net/handshake/request.c
index 2829adbeb149b0..5d4a17f902d201 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -167,12 +167,12 @@ static bool remove_pending(struct handshake_net *hn, struct handshake_req *req)
 {
 	bool ret = false;
 
-	spin_lock(&hn->hn_lock);
+	spin_lock_bh(&hn->hn_lock);
 	if (!list_empty(&req->hr_list)) {
 		__remove_pending_locked(hn, req);
 		ret = true;
 	}
-	spin_unlock(&hn->hn_lock);
+	spin_unlock_bh(&hn->hn_lock);
 
 	return ret;
 }
@@ -182,7 +182,7 @@ struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
 	struct handshake_req *req, *pos;
 
 	req = NULL;
-	spin_lock(&hn->hn_lock);
+	spin_lock_bh(&hn->hn_lock);
 	list_for_each_entry(pos, &hn->hn_requests, hr_list) {
 		if (pos->hr_proto->hp_handler_class != class)
 			continue;
@@ -190,7 +190,7 @@ struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
 		req = pos;
 		break;
 	}
-	spin_unlock(&hn->hn_lock);
+	spin_unlock_bh(&hn->hn_lock);
 
 	return req;
 }
@@ -249,7 +249,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 	if (READ_ONCE(hn->hn_pending) >= hn->hn_pending_max)
 		goto out_err;
 
-	spin_lock(&hn->hn_lock);
+	spin_lock_bh(&hn->hn_lock);
 	ret = -EOPNOTSUPP;
 	if (test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags))
 		goto out_unlock;
@@ -258,7 +258,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 		goto out_unlock;
 	if (!__add_pending_locked(hn, req))
 		goto out_unlock;
-	spin_unlock(&hn->hn_lock);
+	spin_unlock_bh(&hn->hn_lock);
 
 	ret = handshake_genl_notify(net, req->hr_proto, flags);
 	if (ret) {
@@ -274,7 +274,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 	return 0;
 
 out_unlock:
-	spin_unlock(&hn->hn_lock);
+	spin_unlock_bh(&hn->hn_lock);
 out_err:
 	/* Restore original destructor so socket teardown still runs on failure */
 	req->hr_sk->sk_destruct = req->hr_odestruct;
diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
index 8f9532a15f43f9..af294c6cc71731 100644
--- a/net/handshake/tlshd.c
+++ b/net/handshake/tlshd.c
@@ -425,6 +425,8 @@ EXPORT_SYMBOL(tls_server_hello_psk);
  * Request cancellation races with request completion. To determine
  * who won, callers examine the return value from this function.
  *
+ * Context: May be called from process or softirq context.
+ *
  * Return values:
  *   %true - Uncompleted handshake request was canceled
  *   %false - Handshake request already completed or not found
-- 
2.53.0



