Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD873515C5;
	Wed, 30 Sep 2026 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794562; cv=none; b=fkW1SpXWmX7pCoY8kLT6GxcL+AYa/4smjdZ6wV6kmJAQayhi9E1iQTsJ0Qu0Me7ZVeTRycjhwTCK5HLtRn9TkecPWEDyfpNWZEvkGUDRLxwzw9a3V3+bu6LL/a0/jNWVf9YU7OhOChHXF3aq03Egp+0rZgt+uZSxL+YH9zo/V+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794562; c=relaxed/simple;
	bh=l2wIcRTU2oaMySPBmA3IBSvR6eMsZAJJCLs8MVtLxzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIUGl/GI2WzoOzEo+fWFePgKwjRLtvj5tg1//C6UGtz7q3WA0cQQZrCQ0vV6HdOn7tRU9r8Bq/BziJRUsv6rAnO/ZwuRq1kx2RCffUneOTzivDf+axy2/iJvtm7/j1J5tlLCAtTGM5ga03er8NwCIm0ctUhPfNxK0MmroolYQJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPruzH+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPruzH+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C91F00898;
	Wed, 30 Sep 2026 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794560;
	bh=NMopez99TZjdMu6YNkyXISOGr4NMRDaOL9zbjhdQxGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPruzH+tZFs0UYeeawlav4rp2gqucljnmIn4ry9C3LTw8hnAs4FEEmCN6jqKh87TS
	 uZ6gI3CWBG3v4/zxVfJ6e1D3Kky7XyTk4FrdmtX9SMkRKqMcIiFzeCENA9rO8GI+ju
	 76FjbNT+w35biRHaFlxS0JyD0jC6/jGTE1msnH8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0254/1193] ksmbd: align SMB2 oplock break ack handling
Date: Wed, 30 Sep 2026 17:15:38 +0200
Message-ID: <20260930152439.822108875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 064d6b6db8549..882743b160cf2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8652,11 +8652,10 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
 
@@ -8682,71 +8681,55 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
@@ -8754,11 +8737,16 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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



