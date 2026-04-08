Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41803D4134;
	Wed,  8 Apr 2026 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671931; cv=none; b=SdmYFlRjnYw2CXXLpxUDcmAum6xiv9zh/Q4AmLplIBlzMAXuCRY/eUciqWX7AE/J+bgqs3vxjH3t3i1X0hjlA9oX9T8joFQ8zxnUvzBCJQtkCULMAnSfBelDGsHkqkFvEyv6u5N4diBDw9LFHOLR/WKGhlc91EcQanqb5xcs8SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671931; c=relaxed/simple;
	bh=6CNeoDcLAOBbFNX47FgrrE7Wgtc1XntNIN/6+5n34i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr9rKf7aermi+MjweFpas/n1jfek3ghqqYz8aZOT0cbbIFWBxTD0RSw3veo1q/sWirtoQgguh8ruHqpuTBL8PTnt+uQ2710GCVZEjDdlaP3+CRg3Wh2K7LzkUC/SfxHGLaOrGrvkfPzOT3TnDmFzHbkGy0m5LPOmrl2YvxVl/es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5NZ49e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5NZ49e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD29C19421;
	Wed,  8 Apr 2026 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671930;
	bh=6CNeoDcLAOBbFNX47FgrrE7Wgtc1XntNIN/6+5n34i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5NZ49e2kIVdoUu/BhUXDktxmI+FwMwBGd2LgA0DI8LzJOKC96gqUStBX3KzQqzn8
	 MPY6gUB6BDygw54X5Ti6jU/AQZJi+kQcjAk3E/CKptg0eyFTWYBRN+ABSssAaM8WJ6
	 Au322PcUndJGV3a7yYPr9/xTxSuIzxtY97C/o0yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 091/312] ksmbd: replace hardcoded hdr2_len with offsetof() in smb2_calc_max_out_buf_len()
Date: Wed,  8 Apr 2026 20:00:08 +0200
Message-ID: <20260408175937.160311306@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

commit 0e55f63dd08f09651d39e1b709a91705a8a0ddcb upstream.

After this commit (e2b76ab8b5c9 "ksmbd: add support for read compound"),
response buffer management was changed to use dynamic iov array.
In the new design, smb2_calc_max_out_buf_len() expects the second
argument (hdr2_len) to be the offset of ->Buffer field in the
response structure, not a hardcoded magic number.
Fix the remaining call sites to use the correct offsetof() value.

Cc: stable@vger.kernel.org
Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4124,8 +4124,9 @@ int smb2_query_dir(struct ksmbd_work *wo
 	d_info.wptr = (char *)rsp->Buffer;
 	d_info.rptr = (char *)rsp->Buffer;
 	d_info.out_buf_len =
-		smb2_calc_max_out_buf_len(work, 8,
-					  le32_to_cpu(req->OutputBufferLength));
+		smb2_calc_max_out_buf_len(work,
+				offsetof(struct smb2_query_directory_rsp, Buffer),
+				le32_to_cpu(req->OutputBufferLength));
 	if (d_info.out_buf_len < 0) {
 		rc = -EINVAL;
 		goto err_out;
@@ -4392,8 +4393,9 @@ static int smb2_get_ea(struct ksmbd_work
 	}
 
 	buf_free_len =
-		smb2_calc_max_out_buf_len(work, 8,
-					  le32_to_cpu(req->OutputBufferLength));
+		smb2_calc_max_out_buf_len(work,
+				offsetof(struct smb2_query_info_rsp, Buffer),
+				le32_to_cpu(req->OutputBufferLength));
 	if (buf_free_len < 0)
 		return -EINVAL;
 
@@ -4690,8 +4692,9 @@ static void get_file_stream_info(struct
 	file_info = (struct smb2_file_stream_info *)rsp->Buffer;
 
 	buf_free_len =
-		smb2_calc_max_out_buf_len(work, 8,
-					  le32_to_cpu(req->OutputBufferLength));
+		smb2_calc_max_out_buf_len(work,
+				offsetof(struct smb2_query_info_rsp, Buffer),
+				le32_to_cpu(req->OutputBufferLength));
 	if (buf_free_len < 0)
 		goto out;
 
@@ -7740,8 +7743,9 @@ int smb2_ioctl(struct ksmbd_work *work)
 	buffer = (char *)req + le32_to_cpu(req->InputOffset);
 
 	cnt_code = le32_to_cpu(req->CtlCode);
-	ret = smb2_calc_max_out_buf_len(work, 48,
-					le32_to_cpu(req->MaxOutputResponse));
+	ret = smb2_calc_max_out_buf_len(work,
+			offsetof(struct smb2_ioctl_rsp, Buffer),
+			le32_to_cpu(req->MaxOutputResponse));
 	if (ret < 0) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 		goto out;


