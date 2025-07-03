Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D3F2EAB95;
	Thu,  3 Jul 2025 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554606; cv=none; b=eUHb0zU/kKM28MPOu0q4R7erroF48IQKTAZlTgzYMwp1/VoVg6cInIsY+fdEH770rIQZunptFKzBEwn98peN9gHQ35B8fRHRevnKCniyS2x1iwg95S1c5UTUu643J+OrtrvobHAgQZT2hDw5tp3XUhyFOqokA4FVlPfrzU9GE4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554606; c=relaxed/simple;
	bh=Q3gYPpQ207F7bPhMo60CC/D58ND5F/GadeZFd5yX3H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZKyUY2P1ckNcgqZ1SSLfNWa1X+4cZ3bRSjHf/ErXM17hHghPCtpwWXol5pOrt83UbL/3lkOYP4sXrAeVBxLckv1aE3o4O15NRDZehZdhM4RvCE3Z7yyFhhIb8+xVSxltIgmXAoRzhusgt5/iwULpdaDG4NGAX3Kgc2XzaqayGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnSN9XGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnSN9XGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB364C4CEE3;
	Thu,  3 Jul 2025 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554606;
	bh=Q3gYPpQ207F7bPhMo60CC/D58ND5F/GadeZFd5yX3H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnSN9XGKE3lmVWaO9zL5lV5E7TAN91ZEG19OdO2wkMhFTSrw/CMdIMKlpd8/6rGSV
	 lV4Cb6GpOdZjAoPVWntZqmdS1Q8fyMo5GXtup84B2FwhAsUvCBvALKXG8oSeM9oqfT
	 vvKcK+I0CvwsxspxhLSkaLn5GSq6DjEk4r2PITgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Kerling <pkerling@casix.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 022/263] ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension
Date: Thu,  3 Jul 2025 16:39:02 +0200
Message-ID: <20250703144005.188252587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6b990c93bfa7..a9f9426e91acb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2875,7 +2875,7 @@ int smb2_open(struct ksmbd_work *work)
 	int req_op_level = 0, open_flags = 0, may_flags = 0, file_info = 0;
 	int rc = 0;
 	int contxt_cnt = 0, query_disk_id = 0;
-	int maximal_access_ctxt = 0, posix_ctxt = 0;
+	bool maximal_access_ctxt = false, posix_ctxt = false;
 	int s_type = 0;
 	int next_off = 0;
 	char *name = NULL;
@@ -2904,6 +2904,27 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -2926,9 +2947,11 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -3086,28 +3109,6 @@ int smb2_open(struct ksmbd_work *work)
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



