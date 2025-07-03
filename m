Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA06C2EA149;
	Thu,  3 Jul 2025 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555438; cv=none; b=EYh/huCvOLlYNbEyGChmU1y5OX5VzwtT0HL93kPXBW5zpMbYpzJYgJiqc6Wpn2dlgwlImj4DVZy04WJwHteixFYYLcq9cSzQmHnjqTXSFQhndbl7/JJMXoD5C2cH2ddZyeIJHDa9S9Ry6XABcMypQ9XetMtQEWDH33U18+6EDZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555438; c=relaxed/simple;
	bh=MsYewEeBV0DULp6hQn9WAtdkA+NtLTlvQdwms95hP24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFksUzxRprkLoIGqHr1qWlt90OJ7TNjhxhrsq9LGiUNfKfKn5NNrr7qDQoYxseo5Yx5Zu+V2TokXSImr3MLFVZcOTH7skI/D7zDKILOVzYaQg0LCXEYQzFiKPoLMkKrdjL6xdA6WKn2359nPKzOTTljgwrLx5OCV2Mf7dw5nq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypJxiUR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypJxiUR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CF0C4CEE3;
	Thu,  3 Jul 2025 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555437;
	bh=MsYewEeBV0DULp6hQn9WAtdkA+NtLTlvQdwms95hP24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypJxiUR2++/G6gwX+4YKo/tdcHv8VfF2uDVXJNIYy/bCtPO1SGdKILkq+t+FtgeV6
	 qFmRBkv5VIZzoLi6VW7R0mjUOY/8NyLHzUuUdo1LIyI5vHFWIvlRsD4+xkApRBVqRG
	 sBRPTJHSbPzI/DlvIQd1fwHuOAm9AR2PC42r24FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Kerling <pkerling@casix.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/139] ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension
Date: Thu,  3 Jul 2025 16:41:17 +0200
Message-ID: <20250703143941.732666563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit dc3e0f17f74558e8a2fce00608855f050de10230 ]

If client send SMB2_CREATE_POSIX_CONTEXT to ksmbd, Allow a filename
to contain special characters.

Reported-by: Philipp Kerling <pkerling@casix.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 53 +++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d8325504a1624..b851cd7d19b48 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2862,7 +2862,7 @@ int smb2_open(struct ksmbd_work *work)
 	int req_op_level = 0, open_flags = 0, may_flags = 0, file_info = 0;
 	int rc = 0;
 	int contxt_cnt = 0, query_disk_id = 0;
-	int maximal_access_ctxt = 0, posix_ctxt = 0;
+	bool maximal_access_ctxt = false, posix_ctxt = false;
 	int s_type = 0;
 	int next_off = 0;
 	char *name = NULL;
@@ -2889,6 +2889,27 @@ int smb2_open(struct ksmbd_work *work)
 		return create_smb2_pipe(work);
 	}
 
+	if (req->CreateContextsOffset && tcon->posix_extensions) {
+		context = smb2_find_context_vals(req, SMB2_CREATE_TAG_POSIX, 16);
+		if (IS_ERR(context)) {
+			rc = PTR_ERR(context);
+			goto err_out2;
+		} else if (context) {
+			struct create_posix *posix = (struct create_posix *)context;
+
+			if (le16_to_cpu(context->DataOffset) +
+				le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_posix) - 4) {
+				rc = -EINVAL;
+				goto err_out2;
+			}
+			ksmbd_debug(SMB, "get posix context\n");
+
+			posix_mode = le32_to_cpu(posix->Mode);
+			posix_ctxt = true;
+		}
+	}
+
 	if (req->NameLength) {
 		name = smb2_get_name((char *)req + le16_to_cpu(req->NameOffset),
 				     le16_to_cpu(req->NameLength),
@@ -2911,9 +2932,11 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 		}
 
-		rc = ksmbd_validate_filename(name);
-		if (rc < 0)
-			goto err_out2;
+		if (posix_ctxt == false) {
+			rc = ksmbd_validate_filename(name);
+			if (rc < 0)
+				goto err_out2;
+		}
 
 		if (ksmbd_share_veto_filename(share, name)) {
 			rc = -ENOENT;
@@ -3071,28 +3094,6 @@ int smb2_open(struct ksmbd_work *work)
 			rc = -EBADF;
 			goto err_out2;
 		}
-
-		if (tcon->posix_extensions) {
-			context = smb2_find_context_vals(req,
-							 SMB2_CREATE_TAG_POSIX, 16);
-			if (IS_ERR(context)) {
-				rc = PTR_ERR(context);
-				goto err_out2;
-			} else if (context) {
-				struct create_posix *posix =
-					(struct create_posix *)context;
-				if (le16_to_cpu(context->DataOffset) +
-				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix) - 4) {
-					rc = -EINVAL;
-					goto err_out2;
-				}
-				ksmbd_debug(SMB, "get posix context\n");
-
-				posix_mode = le32_to_cpu(posix->Mode);
-				posix_ctxt = 1;
-			}
-		}
 	}
 
 	if (ksmbd_override_fsids(work)) {
-- 
2.39.5



