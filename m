Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2A24DE722;
	Wed, 30 Sep 2026 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784614; cv=none; b=N4vbK5xLB7tVxqid0y9Fsmb3S4xxaMNr4eVMdkSa0lM4EvUC5fdYfK3EqGhV0VzH45lxoWhI56Vkl1hSDv3iXG8JFW0FTFCo5PpBUoxN3unXNMeI+d3z5YTCp0yWecF96AbqhHrhQfrBcsXobLKCvDF0tjZCOJ7u4RPmHs2uOCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784614; c=relaxed/simple;
	bh=aUiKHMyP9WzFsW1fpQ1nHiErIdpbKKWk9e59jc/4Uh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN5uonWjaK5TgF2OdFG7eyTaAGpNPpufpdUGy0C/MTYPUk/UlrrtsdCzDs1yP8eCOBIf+9lFDPwJfUPyLt5JtZI4+lSke7Ita64hoaCoudXBi9HpRrkzgGV2Dd7GixubNRJHrDumINDakGN3RDuSfoqpDhr9dfCLwX+SzXwoGp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHl7wrsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHl7wrsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DADC1F000FF;
	Wed, 30 Sep 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784609;
	bh=WM48ch9HMdEgBs6rs26Kpaexpt+KfpcymzRNq7CSDyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHl7wrsWnSiTdfqUwsDh9up4g7QiP5PmIJcjsUOBXH6yBP8luETePfRV85A15ofgL
	 d3i0ya5HVQyLzo09P3zSEmhLOc6K1ssu9H2k/HlMqQlJ7ML82EUz5WqIVpGvYt4BRx
	 AVO8dl5K9hA9e1qmhZiAe6mZZ5kCkSYU8A1SnWik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/982] ksmbd: align SMB2 oplock break ack handling
Date: Wed, 30 Sep 2026 17:15:53 +0200
Message-ID: <20260930152421.467597645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 80a56d4a826c6c84430286fcf7d8655f7c5b0868 ]

Handle SMB2 oplock break acknowledgments according to the server-side
validation rules in MS-SMB2.

Return STATUS_INVALID_DEVICE_STATE when an ACK arrives while the open is
not breaking, reject SMB2_OPLOCK_LEVEL_LEASE with
STATUS_INVALID_PARAMETER, allow BATCH acknowledgments to EXCLUSIVE, and
make invalid ACK levels fail with STATUS_INVALID_OPLOCK_PROTOCOL after
lowering the oplock to NONE.

Update the successful response from the final granted oplock level instead
of relying on the oplock transition helpers, which could turn invalid ACKs
into successful responses.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 104 ++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 58 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7d47f7749cdc9..4765edcff9dbd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8177,11 +8177,10 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	struct smb2_oplock_break *rsp;
 	struct ksmbd_file *fp;
 	struct oplock_info *opinfo = NULL;
-	__le32 err = 0;
-	int ret = 0;
+	__le32 status = STATUS_SUCCESS;
+	int ret;
 	u64 volatile_id, persistent_id;
 	char req_oplevel = 0, rsp_oplevel = 0;
-	unsigned int oplock_change_type;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -8207,71 +8206,55 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 		return;
 	}
 
-	if (opinfo->level == SMB2_OPLOCK_LEVEL_NONE) {
-		rsp->hdr.Status = STATUS_INVALID_OPLOCK_PROTOCOL;
+	if (opinfo->op_state != OPLOCK_ACK_WAIT) {
+		ksmbd_debug(SMB, "unexpected oplock state 0x%x\n",
+			    opinfo->op_state);
+		status = STATUS_INVALID_DEVICE_STATE;
 		goto err_out;
 	}
 
-	if (opinfo->op_state == OPLOCK_STATE_NONE) {
-		ksmbd_debug(SMB, "unexpected oplock state 0x%x\n", opinfo->op_state);
-		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
+	if (req_oplevel == SMB2_OPLOCK_LEVEL_LEASE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_PARAMETER;
 		goto err_out;
 	}
 
-	if ((opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-	     opinfo->level == SMB2_OPLOCK_LEVEL_BATCH) &&
-	    (req_oplevel != SMB2_OPLOCK_LEVEL_II &&
-	     req_oplevel != SMB2_OPLOCK_LEVEL_NONE)) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		oplock_change_type = OPLOCK_WRITE_TO_NONE;
-	} else if (opinfo->level == SMB2_OPLOCK_LEVEL_II &&
-		   req_oplevel != SMB2_OPLOCK_LEVEL_NONE) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		oplock_change_type = OPLOCK_READ_TO_NONE;
-	} else if (req_oplevel == SMB2_OPLOCK_LEVEL_II ||
-		   req_oplevel == SMB2_OPLOCK_LEVEL_NONE) {
-		err = STATUS_INVALID_DEVICE_STATE;
-		if ((opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-		     opinfo->level == SMB2_OPLOCK_LEVEL_BATCH) &&
-		    req_oplevel == SMB2_OPLOCK_LEVEL_II) {
-			oplock_change_type = OPLOCK_WRITE_TO_READ;
-		} else if ((opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE ||
-			    opinfo->level == SMB2_OPLOCK_LEVEL_BATCH) &&
-			   req_oplevel == SMB2_OPLOCK_LEVEL_NONE) {
-			oplock_change_type = OPLOCK_WRITE_TO_NONE;
-		} else if (opinfo->level == SMB2_OPLOCK_LEVEL_II &&
-			   req_oplevel == SMB2_OPLOCK_LEVEL_NONE) {
-			oplock_change_type = OPLOCK_READ_TO_NONE;
-		} else {
-			oplock_change_type = 0;
-		}
-	} else {
-		oplock_change_type = 0;
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_NONE) {
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		goto err_out;
 	}
 
-	switch (oplock_change_type) {
-	case OPLOCK_WRITE_TO_READ:
-		ret = opinfo_write_to_read(opinfo);
-		rsp_oplevel = SMB2_OPLOCK_LEVEL_II;
-		break;
-	case OPLOCK_WRITE_TO_NONE:
-		ret = opinfo_write_to_none(opinfo);
-		rsp_oplevel = SMB2_OPLOCK_LEVEL_NONE;
-		break;
-	case OPLOCK_READ_TO_NONE:
-		ret = opinfo_read_to_none(opinfo);
-		rsp_oplevel = SMB2_OPLOCK_LEVEL_NONE;
-		break;
-	default:
-		pr_err("unknown oplock change 0x%x -> 0x%x\n",
-		       opinfo->level, rsp_oplevel);
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_II &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_NONE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		goto err_out;
 	}
 
-	if (ret < 0) {
-		rsp->hdr.Status = err;
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_BATCH &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_II &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_NONE &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		goto err_out;
+	}
+
+	if (opinfo->level == SMB2_OPLOCK_LEVEL_II &&
+	    req_oplevel != SMB2_OPLOCK_LEVEL_NONE) {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		status = STATUS_INVALID_OPLOCK_PROTOCOL;
 		goto err_out;
 	}
 
+	if (req_oplevel == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		rsp_oplevel = SMB2_OPLOCK_LEVEL_NONE;
+	else
+		rsp_oplevel = req_oplevel;
+
+	opinfo->level = rsp_oplevel;
+
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;
 	rsp->Reserved = 0;
@@ -8279,11 +8262,16 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	rsp->VolatileFid = volatile_id;
 	rsp->PersistentFid = persistent_id;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_oplock_break));
-	if (ret) {
+	if (ret)
+		ksmbd_debug(SMB, "failed to pin oplock break response: %d\n",
+			    ret);
+	goto out;
+
 err_out:
-		smb2_set_err_rsp(work);
-	}
+	rsp->hdr.Status = status;
+	smb2_set_err_rsp(work);
 
+out:
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	opinfo_put(opinfo);
-- 
2.53.0



