Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2333B6BFE;
	Sat, 17 Oct 2026 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258915; cv=none; b=BFl1gNkwkTu19xgNfSbW6DIR3xjesPi6RHNu/LbX/F3q5DhxIGPDNVx3nZCaxp1qtDaWP6lwu3XdMHsRPv08wU79IgF4nIIkzS03gOPk9kWb1My4HTovKT5To/8WRovzoJa/0cWl9HgiGTsyqnTaXDM9HPcLa7Rr3J+51Pq+eWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258915; c=relaxed/simple;
	bh=sx7YkDwi95UDFEvIqAFWOSDia0ll6x2FxgJtE3siCQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj0ppzeHP3feMBAXfSuzlqJWqBt+kR5lP75f25QlJugvUvTUs8d/tVj89XqVCZtJWCB3TcIC0v/sxtpZMy9phgzi3XZZqeHVmL24OMSkMbWMwNTmUt7AUixV2kv630B1dPpi58IBFx9O5rmZpDWoEhvu1wAdPNZNTutsjCsQiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOsCk94z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOsCk94z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C271F000C4;
	Sat, 17 Oct 2026 17:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258914;
	bh=jT4Vr/exEu9GCaeT9PvMX6e7UnGHp96CbwAjzkbUQXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOsCk94zLIyyQ8r49jyQBAUUHlcueqCly7vTccuFlX3YnN9U2nwXfG6wracnk9Qn9
	 5VoJdBZ0FeJI7hEZLDC4LKqSQwiKgkEeJBkoiv2g81jcMqmMIKvbaMnyZqMAHAIXes
	 XSO2SoZWePU8HYLwRDz4kkMIFebWO2YCmVlddXBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1041/1674] net/handshake: Drain pending requests at net namespace exit
Date: Sat, 17 Oct 2026 17:55:13 +0200
Message-ID: <20261017160457.853785091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ea5fe6a73ca57e5150b8a38b341aef2636eb72f0 ]

The arguments to list_splice_init() in handshake_net_exit() are
reversed. The call moves the local empty "requests" list onto
hn->hn_requests, leaving the local list empty, so the subsequent
drain loop runs zero iterations. Pending handshake requests that
had not yet been accepted are not torn down when the net namespace
is destroyed; each one keeps a reference on a socket file and on
the handshake_req allocation.

Pass the source and destination in the documented order
(list_splice_init(list, head) moves list onto head) so the pending
list is transferred to the local scratch list and drained through
handshake_complete().

Fixing the splice direction exposes a list-corruption race. After
the splice each req->hr_list still has non-empty link pointers,
threading the stack-local scratch list rather than hn_requests.
A concurrent handshake_req_cancel() -- for example, from sunrpc's
TLS timeout on a kernel socket whose netns reference was not
taken -- finds the request through the rhashtable, calls
remove_pending(), and sees !list_empty(&req->hr_list).
__remove_pending_locked() then list_del_init()s an entry off the
scratch list while the drain iterates, corrupting it. The same
call arriving after the drain loop has run list_del() on an
entry hits LIST_POISON instead.

Have remove_pending() check HANDSHAKE_F_NET_DRAINING under
hn_lock and report not-found when drain is in progress. The
drain has already taken ownership; handshake_complete()'s existing
test_and_set on HANDSHAKE_F_REQ_COMPLETED still arbitrates
between drain and cancel for who calls the consumer's hp_done. Use
list_del_init() rather than list_del() in the drain so req->hr_list
does not carry LIST_POISON after drain releases the entry.

The DRAINING guard in remove_pending() makes cancel return false,
but cancel still falls through to test_and_set_bit on
HANDSHAKE_F_REQ_COMPLETED and drops the request's hr_file reference.
Without another pin, if that is the last reference, sk_destruct frees
the request while it is still linked on the drain loop's local list.
Pin each request's hr_file under hn_lock before releasing the list,
and drop that drain pin after the loop finishes with the request.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260525-handshake-file-pin-v3-8-66c616906ead@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/netlink.c | 10 ++++++++--
 net/handshake/request.c | 15 ++++++++++-----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 80c7302692c74..3771f00c21e04 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -205,12 +205,17 @@ static void __net_exit handshake_net_exit(struct net *net)
 	 */
 	spin_lock(&hn->hn_lock);
 	set_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags);
-	list_splice_init(&requests, &hn->hn_requests);
+	list_splice_init(&hn->hn_requests, &requests);
+	list_for_each_entry(req, &requests, hr_list)
+		sock_hold(req->hr_sk);
 	spin_unlock(&hn->hn_lock);
 
 	while (!list_empty(&requests)) {
+		struct sock *sk;
+
 		req = list_first_entry(&requests, struct handshake_req, hr_list);
-		list_del(&req->hr_list);
+		sk = req->hr_sk;
+		list_del_init(&req->hr_list);
 
 		/*
 		 * Requests on this list have not yet been
@@ -218,6 +223,7 @@ static void __net_exit handshake_net_exit(struct net *net)
 		 */
 
 		handshake_complete(req, -ETIMEDOUT, NULL);
+		sock_put(sk);
 	}
 }
 
diff --git a/net/handshake/request.c b/net/handshake/request.c
index 5df102534a596..f67f33c318af4 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -163,13 +163,16 @@ static void __remove_pending_locked(struct handshake_net *hn,
  * otherwise %false.
  *
  * If @req was on a pending list, it has not yet been accepted.
+ * Returns %false when the net namespace is draining; the drain
+ * loop has taken ownership of the pending list.
  */
 static bool remove_pending(struct handshake_net *hn, struct handshake_req *req)
 {
 	bool ret = false;
 
 	spin_lock(&hn->hn_lock);
-	if (!list_empty(&req->hr_list)) {
+	if (!test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags) &&
+	    !list_empty(&req->hr_list)) {
 		__remove_pending_locked(hn, req);
 		ret = true;
 	}
@@ -259,18 +262,20 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 		goto out_unlock;
 	if (!__add_pending_locked(hn, req))
 		goto out_unlock;
+
+	/* Prevent socket release while a handshake request is pending */
+	sock_hold(req->hr_sk);
 	spin_unlock(&hn->hn_lock);
 
 	ret = handshake_genl_notify(net, req->hr_proto, flags);
 	if (ret) {
 		trace_handshake_notify_err(net, req, req->hr_sk, ret);
-		if (remove_pending(hn, req))
+		if (remove_pending(hn, req)) {
+			sock_put(req->hr_sk);
 			goto out_err;
+		}
 	}
 
-	/* Prevent socket release while a handshake request is pending */
-	sock_hold(req->hr_sk);
-
 	trace_handshake_submit(net, req, req->hr_sk);
 	return 0;
 
-- 
2.53.0



