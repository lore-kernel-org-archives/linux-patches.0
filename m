Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0363ACEE0;
	Sat, 17 Oct 2026 16:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256208; cv=none; b=CMDNqcrhQp3dcOSUkt2A1sDzP2Vmk7j+nzsUCXAWodk5d151rlLwcIgsCcj76D54O3FzP0KBTHKhZqAmDgzJDbBpaWXExgve8dwaZFpix4f4YW42efMr77z6p0om8nPOjMVr9TAUcxnr/joU0cV9i24Mlk02mfaz3bYl53bKuwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256208; c=relaxed/simple;
	bh=YcQjTqYefTFSahPjroO+NZ3unbkS3Y9cQulzxqS1FLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ+ajrQ3nrSmefrdpo76QbKocLbnlZv+os/Byk6yGsA3c7ZAqpdCih6nmeVzGz75ovjZrK2qUO/etUqUj0Bq9mrHPfkCfSKwDEL2ucCcnV0g5pKzLN4IZIQXcsg42UV3ZiIE85ldZBF78/C6Inkol6m8Vx9DuuWbwWel4eWtsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUUeuA3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUUeuA3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357EA1F000C4;
	Sat, 17 Oct 2026 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256207;
	bh=mW4FkFuSdux2RAIRqOGKPOZIwupaoCqyLpRDt6jLLZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUUeuA3qMs/uF7VLRRZhvbfgcMInISB5w6OVFTur2U+LmVt2+8A/rLcRNfpuQk5ok
	 YDW1Wlf9SQ3EZ7JwmUOL45qyUXgkcynI/Wl4t48zISr+1nzunW74J1Tu5BuED2u8Ds
	 c4dTJWHxeS2JKJXCmEv166ooTOsDKjEdLNQ9uuiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0158/1674] smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()
Date: Sat, 17 Oct 2026 17:40:30 +0200
Message-ID: <20261017160435.214655420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 007da0a699cb0..e1b23e7bd1b61 100644
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



