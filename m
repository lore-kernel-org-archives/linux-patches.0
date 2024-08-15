Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBE41A00F7;
	Thu, 15 Aug 2024 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729613; cv=none; b=RexrGcmVBFmRjWzMJQRQIlvTeyvgtLInN1dCvpxbxsSTf7INyLUyI8jdCe05rbdwaJdYsT189wARobHNO9AxpYUsyAXlzfpuAvDqhTHTWx0tDX3BvsTPnkOzcmTdHaPag8f+LM2BPT6XPGjCE+InMy4q/r15QbwR7DRQFmN/0Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729613; c=relaxed/simple;
	bh=A9V96QamMjHCUFfIRD58DDZCz9MpZHSbzqy/qKIu3z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbwNdithlzw9i7njCv36pJHKDg3Wtqp350X55ggQgYCZvcUKyxSxdtIeZg5b4//y6CYYc8WLF0OE0roJJolY82bJKthf3q3D0O8qeGcvyXEPgfcbtawb2lLtTHnaDK24PK58TXvkTrZpZPuLY1HZdwoFPH55+GogCOoyj+076Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKM+0UgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKM+0UgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4767EC4AF0A;
	Thu, 15 Aug 2024 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729613;
	bh=A9V96QamMjHCUFfIRD58DDZCz9MpZHSbzqy/qKIu3z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKM+0UgN6hEVUbWEo9y5EdxON63HwVBzw6fVI36CWSpKTVoEy2JSgS8zadrEI+jaq
	 cQa7Qudgm53YEqt5uuYQhSBM04jeUaEEmm0HyjejJ9/s6e7khXHhas/vmORLKuGUY+
	 O/NIui4ZHlfNQi9+haNnG2/JSQ0Bb4Mt9jv3Ql1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/484] fs/ntfs3: Fix getting file type
Date: Thu, 15 Aug 2024 15:20:11 +0200
Message-ID: <20240815131947.326730647@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

[ Upstream commit 24c5100aceedcd47af89aaa404d4c96cd2837523 ]

An additional condition causes the mft record to be read from disk
and get the file type dt_type.

Fixes: 22457c047ed97 ("fs/ntfs3: Modified fix directory element type detection")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 98f57d0c702eb..dcd689ed4baae 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -326,7 +326,8 @@ static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 	 * It does additional locks/reads just to get the type of name.
 	 * Should we use additional mount option to enable branch below?
 	 */
-	if ((fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT) &&
+	if (((fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT) ||
+	     fname->dup.ea_size) &&
 	    ino != ni->mi.rno) {
 		struct inode *inode = ntfs_iget5(sbi->sb, &e->ref, NULL);
 		if (!IS_ERR_OR_NULL(inode)) {
-- 
2.43.0



