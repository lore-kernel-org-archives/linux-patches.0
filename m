Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80807155354;
	Tue, 18 Jun 2024 12:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715443; cv=none; b=hi8vrNxuTDSR4PvPf3V01mvcT4CbVdO3xeCuyJASY7DbIRNAEGaHA3GqNHMkEHiol+P4SmuWG2XpoeR7Y+LeCr1K916HdWpWJPxpfuTw6exc1GveSuVg8MLgSiiv+HvZ1tACYoj0nnid5RIQEwv4TsDZD+sva7Z0+sC0NehaP68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715443; c=relaxed/simple;
	bh=rrw/kD2ASnsIwUlj3uvt6hW8rAtvCpyxy3fCqjOOcPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1Rydpfg6qCu0RjEgl5//AqW+luDqsxCY0LBsvTk2lYXDPbdmjIcqSOYJNcx9Ybp8o7MNzhRL83G9cNgMk+iXZLSm4EdxeO4xyDqBgONexDdLwG1r8Bt90yUZkUQnmZJwjOLS277zSelZo388ZwjEUc2uKLwUDXyx91YzRWQ+M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TMCOK0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TMCOK0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07229C32786;
	Tue, 18 Jun 2024 12:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715443;
	bh=rrw/kD2ASnsIwUlj3uvt6hW8rAtvCpyxy3fCqjOOcPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TMCOK0nzB7Joj354XIO1PPaO7EzRR3xSTadNZqv5jPT51ZlPlvVjmi9MKVWv8M1P
	 lfwF1RmBXoH//lZl7N879rOB5hLCt54y2vUwhpBLvo8V+J09qoNu+cxQ5+hxP55ZDd
	 ZWrUU2KszqtjGRQRoGh1Owlwq46LCOTC3ogdYh44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/770] NFSD: Capture every CB state transition
Date: Tue, 18 Jun 2024 14:32:12 +0200
Message-ID: <20240618123418.034742667@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8476c69a7fa0f1f9705ec0caa4e97c08b5045779 ]

We were missing one.

As a clean-up, add a helper that sets the new CB state and fires
a tracepoint. The tracepoint fires only when the state changes, to
help reduce trace log noise.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index f5b7ad0847f20..2e6a4a9e59ca1 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -945,20 +945,26 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 	return 0;
 }
 
+static void nfsd4_mark_cb_state(struct nfs4_client *clp, int newstate)
+{
+	if (clp->cl_cb_state != newstate) {
+		clp->cl_cb_state = newstate;
+		trace_nfsd_cb_state(clp);
+	}
+}
+
 static void nfsd4_mark_cb_down(struct nfs4_client *clp, int reason)
 {
 	if (test_bit(NFSD4_CLIENT_CB_UPDATE, &clp->cl_flags))
 		return;
-	clp->cl_cb_state = NFSD4_CB_DOWN;
-	trace_nfsd_cb_state(clp);
+	nfsd4_mark_cb_state(clp, NFSD4_CB_DOWN);
 }
 
 static void nfsd4_mark_cb_fault(struct nfs4_client *clp, int reason)
 {
 	if (test_bit(NFSD4_CLIENT_CB_UPDATE, &clp->cl_flags))
 		return;
-	clp->cl_cb_state = NFSD4_CB_FAULT;
-	trace_nfsd_cb_state(clp);
+	nfsd4_mark_cb_state(clp, NFSD4_CB_FAULT);
 }
 
 static void nfsd4_cb_probe_done(struct rpc_task *task, void *calldata)
@@ -968,10 +974,8 @@ static void nfsd4_cb_probe_done(struct rpc_task *task, void *calldata)
 	trace_nfsd_cb_done(clp, task->tk_status);
 	if (task->tk_status)
 		nfsd4_mark_cb_down(clp, task->tk_status);
-	else {
-		clp->cl_cb_state = NFSD4_CB_UP;
-		trace_nfsd_cb_state(clp);
-	}
+	else
+		nfsd4_mark_cb_state(clp, NFSD4_CB_UP);
 }
 
 static void nfsd4_cb_probe_release(void *calldata)
@@ -995,8 +999,7 @@ static const struct rpc_call_ops nfsd4_cb_probe_ops = {
  */
 void nfsd4_probe_callback(struct nfs4_client *clp)
 {
-	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
-	trace_nfsd_cb_state(clp);
+	nfsd4_mark_cb_state(clp, NFSD4_CB_UNKNOWN);
 	set_bit(NFSD4_CLIENT_CB_UPDATE, &clp->cl_flags);
 	nfsd4_run_cb(&clp->cl_cb_null);
 }
@@ -1009,11 +1012,10 @@ void nfsd4_probe_callback_sync(struct nfs4_client *clp)
 
 void nfsd4_change_callback(struct nfs4_client *clp, struct nfs4_cb_conn *conn)
 {
-	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
+	nfsd4_mark_cb_state(clp, NFSD4_CB_UNKNOWN);
 	spin_lock(&clp->cl_lock);
 	memcpy(&clp->cl_cb_conn, conn, sizeof(struct nfs4_cb_conn));
 	spin_unlock(&clp->cl_lock);
-	trace_nfsd_cb_state(clp);
 }
 
 /*
@@ -1345,7 +1347,7 @@ nfsd4_run_cb_work(struct work_struct *work)
 	 * Don't send probe messages for 4.1 or later.
 	 */
 	if (!cb->cb_ops && clp->cl_minorversion) {
-		clp->cl_cb_state = NFSD4_CB_UP;
+		nfsd4_mark_cb_state(clp, NFSD4_CB_UP);
 		nfsd41_destroy_cb(cb);
 		return;
 	}
-- 
2.43.0



