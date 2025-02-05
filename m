Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B01126C18;
	Wed,  5 Feb 2025 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763392; cv=none; b=g0O5ghTPrhFfk6xNot2k48oPDjBY79D0UmoeVwgjTMUM0CfG+nNefdHZxjY2VWd3FjRiWCMlvEM4bvDW0EpbGMfRSJLX62807MrnqpK5b7iNZB3dwLMEe8oeolre9lmqA0GuxqGLOM+AfthmwCg9mS8/lE7cOkigsKTdwInLyIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763392; c=relaxed/simple;
	bh=2Ick2i8k8bDhfSQAUPmu8OC1uMcENJTV+9+5DMTvhDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDgnre0btrICj2hdX4td8qg16dIYnniOTKHsUxKLkJKuZEseP1Qfw8YduRykGRM36E1aXJ3EzaOSmiX/CtAs9X6wYbnEOws1YaVAsG/7k23xovROYEH1MGZcUm5nL77CZW+iZ1T8vff6vo5etVdQfSdec6TtBA/J+4tYJBM0Pl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqP+fBx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqP+fBx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144DFC4CED6;
	Wed,  5 Feb 2025 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763392;
	bh=2Ick2i8k8bDhfSQAUPmu8OC1uMcENJTV+9+5DMTvhDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqP+fBx0XGV+xCpanPnPzLMHXKPBeOsqzNUXAneeoJsKfNd7A1jYOLPjbBUBTrIAC
	 HdK7zxcBPBAG9d5spKJumrHwgkrt7HgMEr2mj7nAE5E7DfDCkWcT9LWilhpHdklKKw
	 dpm+btpHKtb+FB0v55OGtVCPNllOIb/A9Na8dW8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/590] afs: Fix cleanup of immediately failed async calls
Date: Wed,  5 Feb 2025 14:36:02 +0100
Message-ID: <20250205134455.513571809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9750be93b2be12b6d92323b97d7c055099d279e6 ]

If we manage to begin an async call, but fail to transmit any data on it
due to a signal, we then abort it which causes a race between the
notification of call completion from rxrpc and our attempt to cancel the
notification.  The notification will be necessary, however, for async
FetchData to terminate the netfs subrequest.

However, since we get a notification from rxrpc upon completion of a call
(aborted or otherwise), we can just leave it to that.

This leads to calls not getting cleaned up, but appearing in
/proc/net/rxrpc/calls as being aborted with code 6.

Fix this by making the "error_do_abort:" case of afs_make_call() abort the
call and then abandon it to the notification handler.

Fixes: 34fa47612bfe ("afs: Fix race in async call refcounting")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-25-dhowells@redhat.com
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h          |  9 +++++++++
 fs/afs/rxrpc.c             | 12 +++++++++---
 include/trace/events/afs.h |  2 ++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index c9d620175e80c..d9760b2a8d8de 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1346,6 +1346,15 @@ extern void afs_send_simple_reply(struct afs_call *, const void *, size_t);
 extern int afs_extract_data(struct afs_call *, bool);
 extern int afs_protocol_error(struct afs_call *, enum afs_eproto_cause);
 
+static inline void afs_see_call(struct afs_call *call, enum afs_call_trace why)
+{
+	int r = refcount_read(&call->ref);
+
+	trace_afs_call(call->debug_id, why, r,
+		       atomic_read(&call->net->nr_outstanding_calls),
+		       __builtin_return_address(0));
+}
+
 static inline void afs_make_op_call(struct afs_operation *op, struct afs_call *call,
 				    gfp_t gfp)
 {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 9f2a3bb56ec69..a122c6366ce19 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -430,11 +430,16 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
 	return;
 
 error_do_abort:
-	if (ret != -ECONNABORTED) {
+	if (ret != -ECONNABORTED)
 		rxrpc_kernel_abort_call(call->net->socket, rxcall,
 					RX_USER_ABORT, ret,
 					afs_abort_send_data_error);
-	} else {
+	if (call->async) {
+		afs_see_call(call, afs_call_trace_async_abort);
+		return;
+	}
+
+	if (ret == -ECONNABORTED) {
 		len = 0;
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, NULL, 0, 0);
 		rxrpc_kernel_recv_data(call->net->socket, rxcall,
@@ -445,6 +450,8 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
 	call->error = ret;
 	trace_afs_call_done(call);
 error_kill_call:
+	if (call->async)
+		afs_see_call(call, afs_call_trace_async_kill);
 	if (call->type->done)
 		call->type->done(call);
 
@@ -602,7 +609,6 @@ static void afs_deliver_to_call(struct afs_call *call)
 	abort_code = 0;
 call_complete:
 	afs_set_call_complete(call, ret, remote_abort);
-	state = AFS_CALL_COMPLETE;
 	goto done;
 }
 
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index a0aed1a428a18..9a75590227f26 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -118,6 +118,8 @@ enum yfs_cm_operation {
  */
 #define afs_call_traces \
 	EM(afs_call_trace_alloc,		"ALLOC") \
+	EM(afs_call_trace_async_abort,		"ASYAB") \
+	EM(afs_call_trace_async_kill,		"ASYKL") \
 	EM(afs_call_trace_free,			"FREE ") \
 	EM(afs_call_trace_get,			"GET  ") \
 	EM(afs_call_trace_put,			"PUT  ") \
-- 
2.39.5



