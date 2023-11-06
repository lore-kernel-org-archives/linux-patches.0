Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426A2224D0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1B4Dv3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CDFC433C9;
	Mon,  6 Nov 2023 13:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277240;
	bh=pNrrtNMMAESz17RXWmks4uryZopAa1jPz3Jxr44Obbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1B4Dv3Tf+dPQsBFMKcNemXPgQZe5UYNzRwZUPsjpJkYroI7En2R6mX87RlgA8E87
	 yYVAKx706AHLj11vMUxHhlf8mr00eJcobZjSxgUngNSSl7U/S+QSboxgfF76aYVMyN
	 hUgiZgdaFssyUgRqTGTRY2cwBBS06ZwpG+Nc6v4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/128] fs/ntfs3: Use kvmalloc instead of kmalloc(... __GFP_NOWARN)
Date: Mon,  6 Nov 2023 14:04:05 +0100
Message-ID: <20231106130313.001341448@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit fc471e39e38fea6677017cbdd6d928088a59fc67 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrlist.c | 15 +++++++++++++--
 fs/ntfs3/bitmap.c   |  3 ++-
 fs/ntfs3/super.c    |  2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index 81c22df27c725..0c6a68e71e7d4 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -52,7 +52,8 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 
 	if (!attr->non_res) {
 		lsize = le32_to_cpu(attr->res.data_size);
-		le = kmalloc(al_aligned(lsize), GFP_NOFS | __GFP_NOWARN);
+		/* attr is resident: lsize < record_size (1K or 4K) */
+		le = kvmalloc(al_aligned(lsize), GFP_KERNEL);
 		if (!le) {
 			err = -ENOMEM;
 			goto out;
@@ -80,7 +81,17 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 		if (err < 0)
 			goto out;
 
-		le = kmalloc(al_aligned(lsize), GFP_NOFS | __GFP_NOWARN);
+		/* attr is nonresident.
+		 * The worst case:
+		 * 1T (2^40) extremely fragmented file.
+		 * cluster = 4K (2^12) => 2^28 fragments
+		 * 2^9 fragments per one record => 2^19 records
+		 * 2^5 bytes of ATTR_LIST_ENTRY per one record => 2^24 bytes.
+		 *
+		 * the result is 16M bytes per attribute list.
+		 * Use kvmalloc to allocate in range [several Kbytes - dozen Mbytes]
+		 */
+		le = kvmalloc(al_aligned(lsize), GFP_KERNEL);
 		if (!le) {
 			err = -ENOMEM;
 			goto out;
diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index 3261b69cdac33..21536b72aa5e5 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -667,7 +667,8 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
 		wnd->bits_last = wbits;
 
 	wnd->free_bits =
-		kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
+		kvmalloc_array(wnd->nwnd, sizeof(u16), GFP_KERNEL | __GFP_ZERO);
+
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 33b1833ad525c..fbaf1c84311be 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1136,7 +1136,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto put_inode_out;
 	}
 	bytes = inode->i_size;
-	sbi->def_table = t = kmalloc(bytes, GFP_NOFS | __GFP_NOWARN);
+	sbi->def_table = t = kvmalloc(bytes, GFP_KERNEL);
 	if (!t) {
 		err = -ENOMEM;
 		goto put_inode_out;
-- 
2.42.0



