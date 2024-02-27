Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A350513B2B4;
	Tue, 27 Feb 2024 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043287; cv=none; b=eoJESia8ARnS3xgX24c0rn2POd5QzkyHlYoExARRI2ZoLQi6Pd0vMRl5ZfVtjYvh8aHlbj9/t1EXDJz7h6PdvRIIJ/LxReJWhOw2ttIqm+1aE21MhukViyI0MdFGuRoHcydzKZ06I6yjkW1cvwccENXfbP8g9Lew82qKeT5ZAVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043287; c=relaxed/simple;
	bh=nBksRxYJ/25u8vBfsllNtH9nU41Y5EvxPG9P2YndL6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E72ffpIeyyFXJBQnz/p6H4oYwWskccwIgOx5ks54IFBWKvJUcWPK9UYFTarrf1kpu3Ucs+oKjDsDPxdgwGuCvnOZ1EKa4Avn3TVViDfv2jMYHFEb2IemfKjeEcWoo8e6QlU4GeDPdX7Un/EwUkScMS7n1Ps/Oe51/MCCfsimVRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJpRNPX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJpRNPX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F53FC433F1;
	Tue, 27 Feb 2024 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043287;
	bh=nBksRxYJ/25u8vBfsllNtH9nU41Y5EvxPG9P2YndL6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJpRNPX29jQGxC5vklELnEshjrwy/S9REivyAFJ6SHyopN0IlQoqRMTLBMHTAdt6K
	 ZWGpcBCCwhuZJQcYxr0oaeDNj2A/EOin4z0Q4ZzuULtC7U2+gYfmpFw9XJ0arZfPXP
	 Np9QytE8aCxATiyDr/dvinsLLDRqmkzTiE7tkuW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/195] fs/ntfs3: Modified fix directory element type detection
Date: Tue, 27 Feb 2024 14:25:15 +0100
Message-ID: <20240227131612.294967837@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 22457c047ed971f2f2e33be593ddfabd9639a409 ]

Unfortunately reparse attribute is used for many purposes (several dozens).
It is not possible here to know is this name symlink or not.
To get exactly the type of name we should to open inode (read mft).
getattr for opened file (fstat) correctly returns symlink.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index d4d9f4ffb6d9a..c2fb76bb28f47 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -309,11 +309,31 @@ static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 		return 0;
 	}
 
-	/* NTFS: symlinks are "dir + reparse" or "file + reparse" */
-	if (fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT)
-		dt_type = DT_LNK;
-	else
-		dt_type = (fname->dup.fa & FILE_ATTRIBUTE_DIRECTORY) ? DT_DIR : DT_REG;
+	/*
+	 * NTFS: symlinks are "dir + reparse" or "file + reparse"
+	 * Unfortunately reparse attribute is used for many purposes (several dozens).
+	 * It is not possible here to know is this name symlink or not.
+	 * To get exactly the type of name we should to open inode (read mft).
+	 * getattr for opened file (fstat) correctly returns symlink.
+	 */
+	dt_type = (fname->dup.fa & FILE_ATTRIBUTE_DIRECTORY) ? DT_DIR : DT_REG;
+
+	/*
+	 * It is not reliable to detect the type of name using duplicated information
+	 * stored in parent directory.
+	 * The only correct way to get the type of name - read MFT record and find ATTR_STD.
+	 * The code below is not good idea.
+	 * It does additional locks/reads just to get the type of name.
+	 * Should we use additional mount option to enable branch below?
+	 */
+	if ((fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT) &&
+	    ino != ni->mi.rno) {
+		struct inode *inode = ntfs_iget5(sbi->sb, &e->ref, NULL);
+		if (!IS_ERR_OR_NULL(inode)) {
+			dt_type = fs_umode_to_dtype(inode->i_mode);
+			iput(inode);
+		}
+	}
 
 	return !dir_emit(ctx, (s8 *)name, name_len, ino, dt_type);
 }
-- 
2.43.0



