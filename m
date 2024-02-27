Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0792C78B61;
	Tue, 27 Feb 2024 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042600; cv=none; b=n3yMMxY+GocDhGxLRaCKpXkHM2jR0AZ01dbKz0/ZPlYm1zlX/4TR53ydc4UJPWlueY9etvnyOZzgT2rcHo08GnW9Zmxgl6ibemg0DVV96oxZ+eSgd05CtafWAKeD7A3Fwg8twO4qFXAzynjfFePwHRRzwS0QFF5s52J9MSz1rFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042600; c=relaxed/simple;
	bh=fqgXT4qp7JeMqUwnKwZhCUyYuGkwnk57+001eSjWBXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAwP5jyC/1OdRGiqNXgbwuKEr7Q7Uj9THRoJFsvyXJL1igpd3czKsOLWNmm/c7CSttnD4uiptKL9Jqv3VgA3qYASnVRTkFKK5dd8+And3KBvqzYGR2pXOYjb9EWpEFyRjsGgo/Tg+q3+LXfF42kBPDMBcOkitVOHau0Jj92aD18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSbkIXsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSbkIXsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D463C433F1;
	Tue, 27 Feb 2024 14:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042599;
	bh=fqgXT4qp7JeMqUwnKwZhCUyYuGkwnk57+001eSjWBXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSbkIXsiqFMeW0jeejO7H4358taB8M4fEQ04nqXxdtghSF1rAOnqq52lq/dar6bWK
	 qOT0FCg6SJHXk+coe4CwYoUKtfwFQYbsanQ6B9th8Ua5tg7uA30g/CQOkvtHxRiQl5
	 s2D4gTwaW0RudCvUGRpeThCpulnVc1qF3DPPMWGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/245] fs/ntfs3: Modified fix directory element type detection
Date: Tue, 27 Feb 2024 14:24:00 +0100
Message-ID: <20240227131616.815729237@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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



