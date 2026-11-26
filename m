Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705068;
	b=0kMwYf3qoaKrADtpKw0v54tVXyoWJ3bHrVHHBllPPC3NIkl/RhGV9XCjitM4js/kBqgi
	 vRzpOjzbCXlceCDRoZbqPx9D34k3xpinxv5WQlMt+PTaohjL3cD4/LHMUX3iD3WToPAid
	 fk0hSb63/mfuiYml+JdlbWA3sjtZnsUywtY5GLEpSyjSfvxaSPsEmn4atbTcA8TT/CuSj
	 lcO6Tj2Y5zRTyw+N7bJpwRJj96+oec1JjpLXOBE0sZYfDsbiMTkypyEa1xp46pgG8Ewa4
	 DMgDpPaB9PbPJLuPyoWv1En5aX6uwF/AR21QaTVQe4IGiYi9u45C+psPOO93ZKLm4Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6LJ7p9I1q5HUxMkCyi8Qy+FZ/maOkSOFZTokoG9f6xQ=;
	b=pEnD6fIko/mAEnjJTIQh/CYQB/MiEqmYj1e7AbzEqSl9hxoQzdP4jRfoV/YnGZ9BQGWx
	 oyphvpcA2+jlGmwc60DYy7K489I7m3kbpPDNYLfcfla3oMZaSGc9lCh5tBgxhooGNsoIK
	 yar+pGC6w2PfLd72rrY/HxtSnKYUdpup0LXe+nsyQogro/8Xx9cJx05HYLyfg8WfT69/h
	 5BMfi2Ry/rysv1jYwZ4pRvtRJBtWeDugJEFRWteIirtChBeurI8jaxL5iAuN8YGkcplql
	 U+7URNbYLxgcaz+7h5l+pVfTuUY1E3ElSIXivuTUswerwBWvBSRc9ZR5fNhkmXXxc3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU4SOhks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55138606A33B;
	Thu, 26 Nov 2026 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU4SOhks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690921F000EC;
	Thu, 26 Nov 2026 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705067;
	bh=6LJ7p9I1q5HUxMkCyi8Qy+FZ/maOkSOFZTokoG9f6xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LU4SOhksj4VPHkxiZa83Us9mz4QC1VNoiLHgCQOiZtsNAZ1PRs4yqOtASysUk0Kxw
	 1dcvBPOrjkto76ebPobhAieiLURAEG4BiSecSCLq5jRfa6Uv8tGhAaIYHIOjQRGhxu
	 +w8CNJrrCrdGUPW5M8O8sW8LgQQdxFiuP0atOzzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaditya Kansal <aadityakansal390@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/319] ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH in smb server
Date: Thu, 26 Nov 2026 15:37:18 +0100
Message-ID: <20261126144008.319992987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Aaditya Kansal <aadityakansal390@gmail.com>

[ Upstream commit e4442b2e95baf0901830c924d0a197b100aca970 ]

Add STATUS_INFO_LENGTH_MISMATCH mapping to EMSGSIZE.
Currently, STATUS_INFO_LENGTH_MISMATCH has no mapping to any error code,
making it difficult to distinguish between invalid parameters and length
mismatch.

Map STATUS_INFO_LENGTH_MISMATCH to EMSGSIZE while keeping the EINVAL for
invalid parameters. Although the buf_len check only checks for buf_size
being less than required, there was no error code for lower buf_size.
Hence, EMSGSIZE is used.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: e49296d51ccb ("ksmbd: require NUL-terminated EA names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a3b4b09d22814..e992775476981 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6103,7 +6103,6 @@ static int set_file_mode_info(struct ksmbd_file *fp,
  * @share:	ksmbd_share_config pointer
  *
  * Return:	0 on success, otherwise error
- * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISMATCH
  */
 static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 			      struct smb2_set_info_req *req,
@@ -6116,14 +6115,14 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_BASIC_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_basic_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_basic_info(fp, (struct smb2_file_basic_info *)buffer, share);
 	}
 	case FILE_ALLOCATION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_alloc_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_allocation_info(work, fp,
 						(struct smb2_file_alloc_info *)buffer);
@@ -6131,7 +6130,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_END_OF_FILE_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_eof_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_end_of_file_info(work, fp,
 					    (struct smb2_file_eof_info *)buffer);
@@ -6139,7 +6138,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_RENAME_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_rename_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_rename_info(work, fp,
 				       (struct smb2_file_rename_info *)buffer,
@@ -6148,7 +6147,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_LINK_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_link_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return smb2_create_link(work, work->tcon->share_conf,
 					(struct smb2_file_link_info *)buffer,
@@ -6158,7 +6157,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_DISPOSITION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
@@ -6172,7 +6171,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 
 		if (buf_len < sizeof(struct smb2_ea_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return smb2_set_ea((struct smb2_ea_info *)buffer,
 				   buf_len, &fp->filp->f_path, true);
@@ -6180,14 +6179,14 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_POSITION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_pos_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_position_info(fp, (struct smb2_file_pos_info *)buffer);
 	}
 	case FILE_MODE_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_mode_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_mode_info(fp, (struct smb2_file_mode_info *)buffer);
 	}
@@ -6294,6 +6293,8 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_ACCESS_DENIED;
 	else if (rc == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+	else if (rc == -EMSGSIZE)
+		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
 	else if (rc == -ESHARE)
 		rsp->hdr.Status = STATUS_SHARING_VIOLATION;
 	else if (rc == -ENOENT)
-- 
2.53.0



