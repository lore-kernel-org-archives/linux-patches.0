Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243A613B78A;
	Tue, 27 Feb 2024 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041791; cv=none; b=au7pGHTVQHwZo13/1ASHNlRQr5HBys/Xr7Fl7jEtsMDNcZeMGj8l0c79pEBniaJCBQCLHQ9k6FYRDuSA4HaUh3DcufRXM//FRXkPcDLaD59Z19NmuP6BwjLcVDzwiG6Ij/ydsi+YOToy+8ntmb0OPkPIHplh8+pqdptNeNG7O6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041791; c=relaxed/simple;
	bh=ar15W5HQG3EEikNw49bKItNkoVdiPLTs58eeDAd0Cjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBsPsa9dzb0VTpTm5mOQtPgF7kpI+JjP74ReOeNz9mWymalTE+/6FoLKat/dFozydbWbKKvGtqW58fOwzzOi63FcD1mB7gaHs5wMf5Pbi06fr0EjVOyrEddcVqfIqrg/Qfu8kprvlnslMuW91KGLcZAt3MYrfD8STVUjvIZ+PvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+gJec5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+gJec5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A944CC433F1;
	Tue, 27 Feb 2024 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041791;
	bh=ar15W5HQG3EEikNw49bKItNkoVdiPLTs58eeDAd0Cjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+gJec5LtWCByBCaP/AMlpJ+NDsNWPAlFBXT9Gtt4COSNOimgdoG0Xzt+irD5gSrf
	 s4CYcdb0PWhRh6tDRmhNqtaTgfmgZ7j/3zX0xzGZwoT+Iw3LWU152r2143FMIGZaEj
	 DxzFqfz33ltvjR1/j5DBCF0XaBAl8UKdnLX+7kcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/299] fs/ntfs3: Modified fix directory element type detection
Date: Tue, 27 Feb 2024 14:23:02 +0100
Message-ID: <20240227131628.228948364@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ec0566b322d5d..22ede4da04502 100644
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



