Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210868;
	b=JnHQlfm0rrtR9bx0pQEtMfWSePh+bQRCye1WMR190F6GnY+9xVJ1uuN33IQeuw8d9vNw
	 q4qx2QxAw+uabwopjxdq005Fn8T1ztFQh7PwAyzqiqeds8eke8GrenDExNq5oB50Dpu6G
	 FzhUfPaddYPu5OJ7l2UYgNVnP7jA+56yYZAI0OH1r7OSNmNLTUA51Oc3KAs1sSB2BHcrq
	 KjaAzPxXjfOLFsAiN/wAU9z3f+rtWTY0zVkpt4vSFwaafCBW7vleWnO69EX8egEBMGL+2
	 HDCa0KEfj3Zw3f+n2FrDHIaARYfjG7qDsFSLttEhJFvAHLQLSf/9QVPDVzdR/WyxJ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mBeRpaPsRwMJ6Y18acolkratN9OltlT2wk2/WJvLdNo=;
	b=xWZgvVh+RtV8HuoUcgKdrUCdkvgLhM/8/f6AT99HToM6EXLiPOXNqoksClYeTpBUaHPg
	 /lhyYQ8CYhgiyLmzN9FLs7xTpng386/7LosHYeUrFAEkt++MbskEtRzUSWzM4Zk1UCXlE
	 OKdwm2QoTupZ4eB40lOYrWxaiLAx7Fe7x8/J6ws6tQXUaQluJ9I6G0cUeGT74PslvjVHe
	 MJwpak4AhwPPR9VU2KlwkA3/BddEKJtx3aZlmmV4++lH9J8P6LprJO9U56D0pvlqG/lSm
	 BP3Jhu6jC/W354/SRbtXZUTXbOIFIZdxH4tPzgJMrsilJ/Bm3ZseGhbospfrzXyTzOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uF61UmC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32087606A31E;
	Wed, 28 Oct 2026 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uF61UmC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890061F01825;
	Wed, 28 Oct 2026 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210868;
	bh=mBeRpaPsRwMJ6Y18acolkratN9OltlT2wk2/WJvLdNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uF61UmC5qfQbplR9vWyzi6ta+BtsXslWdoT7oAwGx6JFSMYqFAwWPsqqpB6vH6+tC
	 eYLZon68r63x1ucuIO9qfBD99SJoGc87jri92cFY2xKa1gQFJCrf1zUlvK9ViHbenm
	 jhrc5c5l4caX/Q6RG8plYS2gMowewcgQIEc2wKTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/571] smb: client: close completed creates on compound wait errors
Date: Wed, 28 Oct 2026 17:54:40 +0100
Message-ID: <20261028170011.174020303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 6c5c547f037bc18f0b8d0b5db5a648f8f630ce85 ]

compound_send_recv() waits for responses in order. If a later wait is
interrupted, or if a later MID fails during response synchronization, an
earlier CREATE may already have opened a remote handle. The earlier mid
is then released without invoking handle_cancelled_mid(), leaving the
remote handle open because no FID was copied to the caller.

Mark completed earlier mids as cancelled when a compound wait or MID
synchronization aborts. Keep their response buffers attached while the
MIDs are synchronized, and transfer them only after synchronization of
the processed responses, so the release path can inspect successful
CREATE responses and queue SMB2_close() after a later failure. Account for
a remote open only after the close work is allocated and before it is
queued, since the caller has not yet updated num_remote_opens. Mark the
create+close compound used by smb2_unlink() so it is not closed again.
Non-CREATE responses and compounds that already include a close keep their
existing behavior.

Fixes: e0bba0b85481 ("cifs: add compound_send_recv()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ adapted MID cancellation to use MID_WAIT_CANCELLED with GlobalMid_Lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c  |  9 ++++---
 fs/cifs/transport.c | 62 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index c8171dc04bf43..40c7e4fac055c 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -787,7 +787,8 @@ smb2_cancelled_close_fid(struct work_struct *work)
  */
 static int
 __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
-			    __u64 persistent_fid, __u64 volatile_fid)
+			    __u64 persistent_fid, __u64 volatile_fid,
+			    bool account_remote_open)
 {
 	struct close_cancelled_open *cancelled;
 
@@ -801,6 +802,8 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 	cancelled->cmd = cmd;
 	cancelled->mid = mid;
 	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
+	if (account_remote_open)
+		atomic_inc(&tcon->num_remote_opens);
 	WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
 
 	return 0;
@@ -837,7 +840,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
-					 persistent_fid, volatile_fid);
+					 persistent_fid, volatile_fid, false);
 	if (rc)
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_close);
 
@@ -865,7 +868,7 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 					 le16_to_cpu(hdr->Command),
 					 le64_to_cpu(hdr->MessageId),
 					 rsp->PersistentFileId,
-					 rsp->VolatileFileId);
+					 rsp->VolatileFileId, true);
 	if (rc)
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_mid);
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fbf0b154169a5..e729d9150c9e8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1064,6 +1064,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
+	int num_processed = 0;
 	struct mid_q_entry *midQ[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
@@ -1197,6 +1198,17 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			break;
 	}
 	if (rc != 0) {
+		/*
+		 * A completed CREATE earlier in the compound chain may have
+		 * opened a remote handle even though a later wait was
+		 * interrupted. Mark it cancelled so _cifs_mid_q_entry_release()
+		 * invokes the existing unmatched-open cleanup.
+		 */
+		spin_lock(&GlobalMid_Lock);
+		for (j = 0; j < i; j++)
+			midQ[j]->mid_flags |= MID_WAIT_CANCELLED;
+		spin_unlock(&GlobalMid_Lock);
+
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
@@ -1219,6 +1231,17 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		rc = cifs_sync_mid_result(midQ[i], server);
 		if (rc != 0) {
+			/*
+			 * A previous CREATE may have completed before this
+			 * response failed. Mark it cancelled so its remote
+			 * handle is closed when the mid is released.
+			 */
+			spin_lock(&GlobalMid_Lock);
+			for (j = 0; j < i; j++)
+				midQ[j]->mid_flags |= MID_WAIT_CANCELLED;
+			spin_unlock(&GlobalMid_Lock);
+			/* Keep their response buffers for cancelled-mid cleanup. */
+			num_processed = 0;
 			/* mark this mid as cancelled to not free it below */
 			cancelled_mid[i] = true;
 			goto out;
@@ -1228,9 +1251,26 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		    midQ[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
+			spin_lock(&GlobalMid_Lock);
+			for (j = 0; j < i; j++)
+				midQ[j]->mid_flags |= MID_WAIT_CANCELLED;
+			spin_unlock(&GlobalMid_Lock);
+			num_processed = 0;
 			goto out;
 		}
 
+		rc = server->ops->check_receive(midQ[i], server,
+						     flags & CIFS_LOG_ERROR);
+		num_processed = i + 1;
+	}
+
+out:
+	/*
+	 * Delay moving response buffers out of their mids until response
+	 * synchronization completes. This lets cancelled-mid cleanup inspect
+	 * an earlier CREATE response if a later MID fails.
+	 */
+	for (i = 0; i < num_processed; i++) {
 		buf = (char *)midQ[i]->resp_buf;
 		resp_iov[i].iov_base = buf;
 		resp_iov[i].iov_len = midQ[i]->resp_buf_size +
@@ -1241,9 +1281,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			resp_buf_type[i] = CIFS_SMALL_BUFFER;
 
-		rc = server->ops->check_receive(midQ[i], server,
-						     flags & CIFS_LOG_ERROR);
-
 		/* mark it so buf will not be freed by cifs_delete_mid */
 		if ((flags & CIFS_NO_RSP_BUF) == 0)
 			midQ[i]->resp_buf = NULL;
@@ -1253,17 +1290,18 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
-		struct kvec iov = {
-			.iov_base = resp_iov[0].iov_base,
-			.iov_len = resp_iov[0].iov_len
-		};
-		mutex_lock(&server->srv_mutex);
-		smb311_update_preauth_hash(ses, &iov, 1);
-		mutex_unlock(&server->srv_mutex);
+	if (num_processed == num_rqst) {
+		if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+			struct kvec iov = {
+				.iov_base = resp_iov[0].iov_base,
+				.iov_len = resp_iov[0].iov_len
+			};
+			mutex_lock(&server->srv_mutex);
+			smb311_update_preauth_hash(ses, &iov, 1);
+			mutex_unlock(&server->srv_mutex);
+		}
 	}
 
-out:
 	/*
 	 * This will dequeue all mids. After this it is important that the
 	 * demultiplex_thread will not process any of these mids any futher.
-- 
2.53.0



