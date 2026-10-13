Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8B7361957;
	Tue, 13 Oct 2026 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894660; cv=none; b=JVpmTTeExxy6996oENMuOp6kJGDcz16Ot8HWbKcTLfERgSmz5nkYgDYl9rw+DD+Qr7HcUq3jukMTrluOp0DQA59zdaTtViiPgo70LOzxkdDq3vauLKhDf31DcM51LjFmBcgkUoXkSw450eogner/paf9wmj9ulmmLx3+AcoU4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894660; c=relaxed/simple;
	bh=EkpwlfOY3zOivAt2CnpV9o049sbO8es0VJ9N4FsQiQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVyjVGv+efBM6tEvxgCsspPITl6lNmKLZFxZP3b+7txaEV7zNqmCNDzOh3XslDK0KZZsk8b5aE/+AGtaoPMTv/8bHwgsMJkd/dyVxKEO9pVrBkougQz/rs7P3S0GHAVKz/ZINmcTJklnVQ9aA8uTrOvltxPsMgEYAr/FXiXIQFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJlWw0id; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJlWw0id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9539A1F000FF;
	Tue, 13 Oct 2026 12:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894659;
	bh=b+hviIMLI3IwkQi+Bvh1SCVUZKn+4628vtudfuGv7zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJlWw0idZMMzN3pB8t9OpjRdI9UYsrq+a2DjjS6/0eZVuI95Udxi8p8gzaKUmOt9S
	 lZ0EtEKcNUbI6SxT+E4uFMZdWocYzH0jBpTRKg3WyByC7K1RqMm3C53FvyRXJYjkjw
	 dT1NoE9o7fRnAqUl5EW1ej3TbxYI829an7OmMVHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/497] smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()
Date: Tue, 13 Oct 2026 13:33:01 +0200
Message-ID: <20261013112908.218192933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit fc8789bb57e625e5f32ac57ca2e7d3e7b7fda225 ]

SMB2_open() only fills the fixed fields, so a stack-allocated
smb2_file_all_info is sufficient here.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 566820af017e ("smb: client: close handle after create-context parsing failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 82156543f1f91..433dce48a6874 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -343,7 +343,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info *pfile_info = NULL;
+	struct smb2_file_all_info file_info = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -359,20 +359,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	pfile_info = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
-			     GFP_KERNEL);
-
-	if (pfile_info == NULL) {
-		kfree(utf16_path);
-		return  -ENOMEM;
-	}
-
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, pfile_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (pfile_info->EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
@@ -390,7 +382,6 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 qmf_out_open_fail:
 	kfree(utf16_path);
-	kfree(pfile_info);
 	return rc;
 }
 
-- 
2.53.0



