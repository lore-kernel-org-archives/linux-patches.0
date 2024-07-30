Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7361A6192;
	Tue, 30 Jul 2024 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357124; cv=none; b=noComSPnAIO3REKJGZjGrGZHrUyEhrJVc3762wcizqNRS7q3yfjf4KPq3y4gyCKHiPTwHtsHwmo+f1kKKic+KZL9q23ZruBKQ/bVvvPd78hgc57fNCFPL664Fr/4DPj63eao0PwWW3T+pJg/rxJyslXXKMXLT57tOPESqexDNso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357124; c=relaxed/simple;
	bh=uLrBoOhSScPFkLCk7ft48L7quQ4TWMFFaCDHDdom4Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7nzIrM1IDFJhOXVd4pcUWn73PH3BYgxrnLUMAFuev+ti1ysTx98xpwI7kSGr6+ZjTuxIAl4f5ibA5S5eC5L/KPnljurl8xQNwNQ5RP5mpC356AH1AvUiT34NUznZ4TJtfk9s9VSn5X/sPiCCXFWtBd0umzDD5tZHZA2puKJId0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CesM3tYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CesM3tYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B7DC32782;
	Tue, 30 Jul 2024 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357123;
	bh=uLrBoOhSScPFkLCk7ft48L7quQ4TWMFFaCDHDdom4Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CesM3tYRESurBrjgZ/hOPRd6bqzkTxiZ2QGxqbtpj7l/xxD0EjMXZi5X44vM+xtbb
	 0u3Y2RsRSrVwMM8AIzXBZIPW9MyL7iwfFxa73n/fwq6tcuTxGOFRJgsLTfppsTShmr
	 BaB4hgQPnGWzHGyg/pMPt2RkSB+zgviehZuwM5WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/440] fs/ntfs3: Fix getting file type
Date: Tue, 30 Jul 2024 17:47:55 +0200
Message-ID: <20240730151625.306659512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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



