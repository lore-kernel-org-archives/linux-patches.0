Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A911FCFF3;
	Tue,  8 Apr 2025 12:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116510; cv=none; b=pC0lc3GMdkGJgHrE05SCUy1JU37U778vls68NbUpFcLK9h3YuuANi2YRvj/OzWswTSItFH8xfbBhH2oPTxAyRZ6QOTAynI5033YYifuSjb4QVZynSbgwZfDnhsMdFkESmXjfOd1vrjfm58HRtWvulAHtZA4/4gd5oSJ8Jd/lKN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116510; c=relaxed/simple;
	bh=lJaSAtjqfhGffMJ6/ReDr7+MgihMB0+TnQmaz5Gr79o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0K794a2UQSj0DePFif470r2WmbTO7ClQK0tzRZyqumPNMm+rJcngId43OIlYmXkTLWIk84ShpxiCSeHQXBdp++kA1z36lK9MJrkk7j2Z/9zBjkFKZy5rQ/F1bCBP89VtKLLsr/soqGqxHiI2ymj9kiO2d+NKogHGEjGdS61qus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5WizYgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5WizYgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C2BC4CEE5;
	Tue,  8 Apr 2025 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116510;
	bh=lJaSAtjqfhGffMJ6/ReDr7+MgihMB0+TnQmaz5Gr79o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5WizYgNkfuSgu14hwo66LGVPyXSoeZsej1p3k9vPtN4H3AkaCzOWwDy22nwDhTF/
	 sWEwI6Qr39iAmxxViuZibezI/6Vlj6r+nL9b5BwWxKHnjhkmHl99GeDgVzx/52tJK0
	 AJOxg613EhoNsHIOQkBtO7d/qhxhaPh9FXd4dwH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.12 165/423] fs/ntfs3: Update inode->i_mapping->a_ops on compression state
Date: Tue,  8 Apr 2025 12:48:11 +0200
Message-ID: <20250408104849.581718958@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index da1a9312e61a0..dd459316529e8 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2663,8 +2663,9 @@ int attr_set_compress(struct ntfs_inode *ni, bool compr)
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
index f704ceef95394..7976ac4611c8d 100644
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
index 175662acd5eaf..608634361a302 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3431,10 +3431,12 @@ int ni_set_compress(struct inode *inode, bool compr)
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



