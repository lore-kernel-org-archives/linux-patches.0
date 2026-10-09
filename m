Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786524E4308;
	Fri,  9 Oct 2026 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555329; cv=none; b=UFAtIqujjr5yn1SzxCZogU4uVuf727/4mVg3SwUDDo7iHdyrcxMPeBnuOiXnXiBBb3XH1ehRjLrqTnNfq3uLw2qONk3DYiejES/CH0EMxVn1ibhqPP18Gfa8CPQqHVlmKHofC48zvezp/8YB8nT2AtzylhYhmFXJpaPMstj5Euw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555329; c=relaxed/simple;
	bh=8CPDW1II2XLmBixq3KnuigEy94BBN8BB0uN2sGVqj/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7k5xN2gDU4Q5hSdOjOZNEowVxY1RoePNkcbQsUmSnJo7I2E5nafQBEcGm2FXVMyjn13fBYVzk/h3n9sfaSfhzwWYP+JGB7s08tYBE6DTD4p0wXTqEzka4UWyBsZI2JM1WvicnMNJv647rSLbQEiqKU6Dri0/6WxYP7RBFoDVSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnRkRTO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnRkRTO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3191F00893;
	Fri,  9 Oct 2026 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555322;
	bh=a30pEis2Sw0yILap8sWIiJ0BPfSJbbGFKz7Sxv2nXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnRkRTO/Zs6EPy733eunSoOeThwPEiYZVRBq0nGc9wKOOZbbrlug+VsN4oW8I/EOm
	 zXCqCurWFBnhRRFTjaJx6tskjdrRBTcTd0LOp/Br9pWVQZ7bv0E0JAu4rBT1L+HmZU
	 6Oo/pHgqvf8CSf/hufYCFsieM12Zi0E7Qw8Cfk/0=
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
Subject: [PATCH 6.18 018/403] smb: client: close completed creates on compound wait errors
Date: Fri,  9 Oct 2026 16:06:19 +0200
Message-ID: <20261009140952.544784738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c |  2 +-
 fs/smb/client/smb2misc.c  |  9 ++++--
 fs/smb/client/transport.c | 67 +++++++++++++++++++++++++++++++--------
 3 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 19f22e0a9efd0..37a00586f2e75 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1228,7 +1228,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	struct kvec close_iov;
 	int resp_buftype[2];
 	struct cifs_fid fid;
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	__u8 oplock;
 	int rc;
 
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index d701bdfa585f0..34d2401c6c665 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -830,7 +830,8 @@ smb2_cancelled_close_fid(struct work_struct *work)
  */
 static int
 __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
-			    __u64 persistent_fid, __u64 volatile_fid)
+			    __u64 persistent_fid, __u64 volatile_fid,
+			    bool account_remote_open)
 {
 	struct close_cancelled_open *cancelled;
 
@@ -844,6 +845,8 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 	cancelled->cmd = cmd;
 	cancelled->mid = mid;
 	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
+	if (account_remote_open)
+		atomic_inc(&tcon->num_remote_opens);
 	WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
 
 	return 0;
@@ -880,7 +883,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	spin_unlock(&tcon->tc_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
-					 persistent_fid, volatile_fid);
+					 persistent_fid, volatile_fid, false);
 	if (rc)
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_close);
 
@@ -908,7 +911,7 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 					 le16_to_cpu(hdr->Command),
 					 le64_to_cpu(hdr->MessageId),
 					 rsp->PersistentFileId,
-					 rsp->VolatileFileId);
+					 rsp->VolatileFileId, true);
 	if (rc)
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_mid);
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 53db53a78d6c5..342664eae295a 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -804,6 +804,18 @@ cifs_cancelled_callback(struct mid_q_entry *mid)
 	release_mid(mid);
 }
 
+static void
+cifs_mark_compound_mids_cancelled(struct mid_q_entry **mid, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		spin_lock(&mid[i]->mid_lock);
+		mid[i]->wait_cancelled = true;
+		spin_unlock(&mid[i]->mid_lock);
+	}
+}
+
 /*
  * cifs_pick_channel - pick an eligible channel for network operations
  *
@@ -864,6 +876,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
+	int num_processed = 0;
 	struct mid_q_entry *mid[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
@@ -1006,6 +1019,14 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			break;
 	}
 	if (rc != 0) {
+		/*
+		 * A completed CREATE earlier in the compound chain may have
+		 * opened a remote handle even though a later wait was
+		 * interrupted. Mark it cancelled so __release_mid() invokes
+		 * the existing unmatched-open cleanup.
+		 */
+		cifs_mark_compound_mids_cancelled(mid, i);
+
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 mid[i]->mid, le16_to_cpu(mid[i]->command));
@@ -1027,6 +1048,14 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		rc = cifs_sync_mid_result(mid[i], server);
 		if (rc != 0) {
+			/*
+			 * A previous CREATE may have completed before this
+			 * response failed. Mark it cancelled so its remote
+			 * handle is closed when the mid is released.
+			 */
+			cifs_mark_compound_mids_cancelled(mid, i);
+			/* Keep their response buffers for cancelled-mid cleanup. */
+			num_processed = 0;
 			/* mark this mid as cancelled to not free it below */
 			cancelled_mid[i] = true;
 			goto out;
@@ -1036,13 +1065,24 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		    mid[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
+			cifs_mark_compound_mids_cancelled(mid, i);
+			num_processed = 0;
 			goto out;
 		}
 
 		rc = server->ops->check_receive(mid[i], server,
 						flags & CIFS_LOG_ERROR);
+		num_processed = i + 1;
+	}
 
-		if (resp_iov) {
+out:
+	/*
+	 * Delay moving response buffers out of their mids until response
+	 * synchronization completes. This lets cancelled-mid cleanup inspect
+	 * an earlier CREATE response if a later MID fails.
+	 */
+	if (resp_iov) {
+		for (i = 0; i < num_processed; i++) {
 			buf = (char *)mid[i]->resp_buf;
 			resp_iov[i].iov_base = buf;
 			resp_iov[i].iov_len = mid[i]->resp_buf_size +
@@ -1062,21 +1102,22 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	spin_lock(&ses->ses_lock);
-	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
-		struct kvec iov = {
-			.iov_base = resp_iov[0].iov_base,
-			.iov_len = resp_iov[0].iov_len
-		};
-		spin_unlock(&ses->ses_lock);
-		cifs_server_lock(server);
-		smb311_update_preauth_hash(ses, server, &iov, 1);
-		cifs_server_unlock(server);
+	if (num_processed == num_rqst) {
 		spin_lock(&ses->ses_lock);
+		if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+			struct kvec iov = {
+				.iov_base = resp_iov[0].iov_base,
+				.iov_len = resp_iov[0].iov_len
+			};
+			spin_unlock(&ses->ses_lock);
+			cifs_server_lock(server);
+			smb311_update_preauth_hash(ses, server, &iov, 1);
+			cifs_server_unlock(server);
+			spin_lock(&ses->ses_lock);
+		}
+		spin_unlock(&ses->ses_lock);
 	}
-	spin_unlock(&ses->ses_lock);
 
-out:
 	/*
 	 * This will dequeue all mids. After this it is important that the
 	 * demultiplex_thread will not process any of these mids any further.
-- 
2.53.0



