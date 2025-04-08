Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561D021ADAE;
	Tue,  8 Apr 2025 11:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111480; cv=none; b=BHj1Xf5E/SBgGNQ33yL+1wmTkeFwXWvdhyOoVz9k8M9AbMTeFXhqXBK+EGlKWIHGQQt8gC4pjGfHHz3y/1qaMRGCYgxddb/LFNMCIbAh76DXpWFjYcu3EGnx4SPBcAbCdwHw36kjxCoFIokvXoZQCV9Zl/byIz/i2rkSOiWPEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111480; c=relaxed/simple;
	bh=QmQUy6JGHQyCa1c1EW7Gd/Vwj+nwJFJvH+0U0EKbBVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkQHjuW+Oyr9qCLxgw8R5GY0P1Zit5f6MS/nHAkJrPZL09z8BU5N3j3ajgx1WQmx5oKO70vDwPY+OMdCLh0ZEL9tH8h+d4+VOyyUpX8ekRxeJ+izQhLCKXSbJcj2Tj7vzYdDuLUlSgR7gZDmceO9XhjkIfsfo4nW0sT39T1YaJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B3yJpow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B3yJpow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3C1C4CEE5;
	Tue,  8 Apr 2025 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111480;
	bh=QmQUy6JGHQyCa1c1EW7Gd/Vwj+nwJFJvH+0U0EKbBVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B3yJpowMZ4tE4tqCoCefcUS6U5uFRyLb6XD8qQ2HFFPLrhKtYyeDYJCiSeTVyPkh
	 MA/6Syh/kPyMRDIRGxWywodCD16NnbJCa5aHV4vHri0Vi28pvb1/Y9y8gPEYQif4Lw
	 HB5boqr6I7KpPmeW04xJPwrcGZOZ41D6Tk5fHd1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.14 446/731] fs/ntfs3: Update inode->i_mapping->a_ops on compression state
Date: Tue,  8 Apr 2025 12:45:43 +0200
Message-ID: <20250408104924.646697049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit b432163ebd15a0fb74051949cb61456d6c55ccbd ]

Update inode->i_mapping->a_ops when the compression state changes to
ensure correct address space operations.
Clear ATTR_FLAG_SPARSED/FILE_ATTRIBUTE_SPARSE_FILE when enabling
compression to prevent flag conflicts.

v2:
Additionally, ensure that all dirty pages are flushed and concurrent access
to the page cache is blocked.

Fixes: 6b39bfaeec44 ("fs/ntfs3: Add support for the compression attribute")
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.edu.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c  |  3 ++-
 fs/ntfs3/file.c    | 22 ++++++++++++++++++++--
 fs/ntfs3/frecord.c |  6 ++++--
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index af94e3737470d..e946f75eb5406 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2664,8 +2664,9 @@ int attr_set_compress(struct ntfs_inode *ni, bool compr)
 		attr->nres.run_off = cpu_to_le16(run_off);
 	}
 
-	/* Update data attribute flags. */
+	/* Update attribute flags. */
 	if (compr) {
+		attr->flags &= ~ATTR_FLAG_SPARSED;
 		attr->flags |= ATTR_FLAG_COMPRESSED;
 		attr->nres.c_unit = NTFS_LZNT_CUNIT;
 	} else {
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 3f96a11804c90..e9f701f884e72 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -101,8 +101,26 @@ int ntfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
 	/* Allowed to change compression for empty files and for directories only. */
 	if (!is_dedup(ni) && !is_encrypted(ni) &&
 	    (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
-		/* Change compress state. */
-		int err = ni_set_compress(inode, flags & FS_COMPR_FL);
+		int err = 0;
+		struct address_space *mapping = inode->i_mapping;
+
+		/* write out all data and wait. */
+		filemap_invalidate_lock(mapping);
+		err = filemap_write_and_wait(mapping);
+
+		if (err >= 0) {
+			/* Change compress state. */
+			bool compr = flags & FS_COMPR_FL;
+			err = ni_set_compress(inode, compr);
+
+			/* For files change a_ops too. */
+			if (!err)
+				mapping->a_ops = compr ? &ntfs_aops_cmpr :
+							 &ntfs_aops;
+		}
+
+		filemap_invalidate_unlock(mapping);
+
 		if (err)
 			return err;
 	}
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 5df6a0b5add90..81271196c5571 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3434,10 +3434,12 @@ int ni_set_compress(struct inode *inode, bool compr)
 	}
 
 	ni->std_fa = std->fa;
-	if (compr)
+	if (compr) {
+		std->fa &= ~FILE_ATTRIBUTE_SPARSE_FILE;
 		std->fa |= FILE_ATTRIBUTE_COMPRESSED;
-	else
+	} else {
 		std->fa &= ~FILE_ATTRIBUTE_COMPRESSED;
+	}
 
 	if (ni->std_fa != std->fa) {
 		ni->std_fa = std->fa;
-- 
2.39.5



