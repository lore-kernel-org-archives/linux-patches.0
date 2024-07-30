Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22297155CB3;
	Tue, 30 Jul 2024 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358075; cv=none; b=GKDv7mlpsBJ3sVVyfZfC2QeauVrEvKIamTL13SuZ52xEANrpMyczJCvgq3S62KS93CKj8oYLRcAcf/XOl+8ibUUPcgPfL9ppHgoOVjsRB3u2Vixx1MoVBsvxZL6fdmG7LXy4kYUHJq1yhsmRiAxC6V6R+2Ih7OwJeLEP9VwL6c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358075; c=relaxed/simple;
	bh=e5kb1t8h097vW2hWjIzXnnIEjMW1VkCaH4ZYeoIvIuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhDFQK4QtVAqgJx5Vn5fkdoYBm5ZZbN5I1xMf3siZdKuS+Hp4ZMb6GI0hHJ6nQ0nVyGWbENzzN7Ew6Sx6dk3LwdsglmM/1meA+cDtk57vuCfNGgUJGdGVx5obGomooDbwbkIt8cWlTvgqmh8UuWbIe8en9TxegLI/fzpNphMDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4yd3Ajy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4yd3Ajy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93348C4AF0A;
	Tue, 30 Jul 2024 16:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358075;
	bh=e5kb1t8h097vW2hWjIzXnnIEjMW1VkCaH4ZYeoIvIuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4yd3AjyD/S++8Mu7JpxGj8PoReE+7W/x1jLY+MZ4BFszeCF3gG0IhgPW6peIwszT
	 3CzyKIjTWRWm+/WJ6csEAv3Odv+pqU7xXPurO2rjd6oyuxv1s15YcURWcv1cqwvwzK
	 d3IC2O2/muWk+93o2np8CPT94EPS7YaykxgEqylM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/568] fs/ntfs3: Fix getting file type
Date: Tue, 30 Jul 2024 17:47:10 +0200
Message-ID: <20240730151652.501143270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index ac8eb8657f1a9..9d0a09f00b384 100644
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



