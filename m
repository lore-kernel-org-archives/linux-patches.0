Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621343;
	b=Kq7fEmLPQ1ISDkm1mo3Po41WiIsjMPDHw4TH3zvgFkewhT6XR4EHj+55kJ0kqr4wUJle
	 et2TwFzeFLfv9De7YOQ2IaC3SkA7wMLIJmU+3x+MkoSUGDv+zYIuLD6Sjnynmf6Hl25Qy
	 NpkKiGhRZcE54914DmWOrs6ZhEbNjEFPlwTGebAHN4t8mztTstO/mW8MLJQHEytvfFXji
	 vbBuPfOdRoW4AZbTS7hK8bD47VGMU4LEmvWjO/kS1rMAyY0fBVNUzuOefCzjNwZQtY4ol
	 4zWkh2qt776hTsvfxIsGIgOxbmiLUp8OpcKKYGY9qyuNTlTXuvp7iHfAUWO65CX+UTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aJJNElapjM5lZgMacpxeNRI/DieRJu5BwTsylZ+79Fg=;
	b=1nlk1MiQqhK7RqMn52Xpugeex7VJb3pg0dMZUUEeCuMHNrLSQUB4LahbahzGdfuaOQed
	 zdl0y5SEwxL7VJtYd53pnuUNxZ0B6wtZqPIxDY098vuvyIVCmtk3tPEhSkK5GpvxxDwzw
	 pHTrzM2+9U47ItYW3KBXToQusSKkBn2a86ZqzAFB9dJBRGvLC0sxI4PbKCrdY5yQhI4bg
	 DwNxM0Bvz+YA5xxZVFJ80NQ8Ok0e0BfYdH2Ph0prs61x3jEIwF/YIre75l2GMdu6Pdxv0
	 0fNLXjEt3VugG5y2IS2lbvejTyw1ZfmTe8WxOT42Wri5f/rc2o0lL0wxDfP0xdGuwFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIltzkvr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A2E606A693;
	Wed, 25 Nov 2026 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIltzkvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440581F000C6;
	Wed, 25 Nov 2026 15:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621342;
	bh=aJJNElapjM5lZgMacpxeNRI/DieRJu5BwTsylZ+79Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIltzkvr0CtdBNW1h+62pKM79XG0QcrIXpx/9LMkFkzIVU4DErLpoaa23PZVIVSsr
	 viJEeLPlIJjb+fnjAT9yb/LrbJ70ZR2INgwjyJkaqDfvwFAJrmCRzKYs3F2SzkqMEB
	 3LAO4OndPGgc/sfEyRt1rNFJWhLQwP7Xz+SN8WM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaditya Kansal <aadityakansal390@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/990] ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH in smb server
Date: Wed, 25 Nov 2026 15:26:02 +0100
Message-ID: <20261125143826.662125940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 94a18e0ee9c20..56dc2134d8bac 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6769,7 +6769,6 @@ static int set_file_mode_info(struct ksmbd_file *fp,
  * @share:	ksmbd_share_config pointer
  *
  * Return:	0 on success, otherwise error
- * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISMATCH
  */
 static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 			      struct smb2_set_info_req *req,
@@ -6782,14 +6781,14 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
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
@@ -6797,7 +6796,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_END_OF_FILE_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_eof_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_end_of_file_info(work, fp,
 					    (struct smb2_file_eof_info *)buffer);
@@ -6805,7 +6804,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_RENAME_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_rename_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_rename_info(work, fp,
 				       (struct smb2_file_rename_info *)buffer,
@@ -6816,7 +6815,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		struct smb2_file_link_info *file_info;
 
 		if (buf_len < sizeof(struct smb2_file_link_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		file_info = (struct smb2_file_link_info *)buffer;
 		if (file_info->ReplaceIfExists && !(fp->daccess & FILE_DELETE_LE)) {
@@ -6831,7 +6830,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	case FILE_DISPOSITION_INFORMATION:
 	{
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return set_file_disposition_info(work, fp,
 						 (struct smb2_file_disposition_info *)buffer);
@@ -6845,7 +6844,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 
 		if (buf_len < sizeof(struct smb2_ea_info))
-			return -EINVAL;
+			return -EMSGSIZE;
 
 		return smb2_set_ea((struct smb2_ea_info *)buffer,
 				   buf_len, &fp->filp->f_path, true);
@@ -6853,14 +6852,14 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
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
@@ -6968,6 +6967,8 @@ int smb2_set_info(struct ksmbd_work *work)
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



