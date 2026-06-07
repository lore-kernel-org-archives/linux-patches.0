Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5C731F9B3;
	Sun,  7 Jun 2026 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827774; cv=none; b=svwCtF0H/nvYfjGvFGM1tNZz9c+hqQdsCDsoK7EOm5Qz7iyZnK0ZgmRehUnfTLg6jvoXP1UGcyNJvPtEmG5pVIbMmXbHNWzAHfmKq0ohDCjG0u/+Sk4LjvGxMkg7c6MWgAwRnP4lPyg0LCtz6Rn3otxoSa+asb0O5ANdngZHTT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827774; c=relaxed/simple;
	bh=+AlRXEMKGRcVA4OsYAOwguwxKHVOW9MClrxPumbV1C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSDUx68WDMHW0p3BlO+b7Fx/bpQ3xQMFLZiXyS4hmBoJYr35nFWPBphSM0TwMU/ATMUSA6rT91EeqqrWQwvLN2ODxIpD5XkFNc6CGztyMca6W4e5Mmw3nBqApS9siFqmmSeBLokNdyh43vod83rwUpAUOdftH6OKJr69fuKgcZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLuvzA/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLuvzA/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2431F00893;
	Sun,  7 Jun 2026 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827772;
	bh=ZrMw85aBJaXyVw0zaE0N9ilmSL2VuHMPFUr5yDtHdHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLuvzA/tX5Ev+zVxxKGkAzbtOsPa1ELFyKa3/WGq4Xtv9oPLrrTVWtLTWHf2wssy/
	 otEakGEDCvnGzRro1YjqkWfglqOgbj/EJzoPd3xNVvyGUgsqR94FhpGUW48i66r+LL
	 fk+6U7RZbLWkofAzGfBzZKvLof6PVRH9/4d6CDuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/307] net/handshake: Drain pending requests at net namespace exit
Date: Sun,  7 Jun 2026 11:58:02 +0200
Message-ID: <20260607095730.895146349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 net/handshake/request.c |  5 ++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 86a12c9125d403..e49041cc0f9d70 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -205,13 +205,19 @@ static void __net_exit handshake_net_exit(struct net *net)
 	 */
 	spin_lock_bh(&hn->hn_lock);
 	set_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags);
-	list_splice_init(&requests, &hn->hn_requests);
+	list_splice_init(&hn->hn_requests, &requests);
+	list_for_each_entry(req, &requests, hr_list)
+		get_file(req->hr_file);
 	spin_unlock_bh(&hn->hn_lock);
 
 	while (!list_empty(&requests)) {
+		struct file *file;
+
 		req = list_first_entry(&requests, struct handshake_req, hr_list);
-		list_del(&req->hr_list);
+		file = req->hr_file;
+		list_del_init(&req->hr_list);
 		handshake_complete(req, -ETIMEDOUT, NULL);
+		fput(file);
 	}
 }
 
diff --git a/net/handshake/request.c b/net/handshake/request.c
index 35bc6290e12033..96f80e0df67b50 100644
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
 
 	spin_lock_bh(&hn->hn_lock);
-	if (!list_empty(&req->hr_list)) {
+	if (!test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags) &&
+	    !list_empty(&req->hr_list)) {
 		__remove_pending_locked(hn, req);
 		ret = true;
 	}
-- 
2.53.0



