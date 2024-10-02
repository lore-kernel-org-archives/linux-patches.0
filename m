Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EABB1E52C;
	Wed,  2 Oct 2024 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878870; cv=none; b=EZCRV2yLZXCsKYLwCp7Txf31XR69fVEbqQA6udjJWKCqMLudIC1d+sFCNOPg1JQTJC3YDiLKyaCGhCJozHiuRs7ABMihDDcaPDV2VLDy81yFJOOJYJGVyTaH78FMytNTbgXtZdupuI7APlPDipjV7W0X7mT5Ive9k/m+rB7aTEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878870; c=relaxed/simple;
	bh=FTh0B8XLXd8fn2tzzmbupMphsy4vqIKdJRaZVsAPegE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwPzCJKiKar4b8xdHdZGyx8h11CO/Y4X8xUSdfVKQ2d8fsgz50EWKQqcEBvAWJXgQcdGN1MfnFqhSBTjLKo60I5fz3wxQ7ECOTZ4bYBvXasrKVAS/obKzHcQhjHs6Vj8KROf0FWU2LnbsfjfPiuqIo3MLEUuZ1aW56Eh770DtsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6ATBgcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6ATBgcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB47FC4CEC5;
	Wed,  2 Oct 2024 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878870;
	bh=FTh0B8XLXd8fn2tzzmbupMphsy4vqIKdJRaZVsAPegE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6ATBgcMEyyWCJ6K9SgiPFIsJRhYv9gpw2VgqMw5u+nL1R4xIyXudzwJ0lTSQzol4
	 JguBHorAnHrw8m8e0/mFPVKInRFs+BziaZtwJ6eV/3eXG+7c8XU0JQSOQZLrc1OtzT
	 CeqDw+NNpfsIToMObN+y8sc0E3+72JlsmfEGTFf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.10 560/634] f2fs: fix several potential integer overflows in file offsets
Date: Wed,  2 Oct 2024 15:01:00 +0200
Message-ID: <20241002125833.219717568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 1cade98cf6415897bf9342ee451cc5b40b58c638 upstream.

When dealing with large extents and calculating file offsets by
summing up according extent offsets and lengths of unsigned int type,
one may encounter possible integer overflow if the values are
big enough.

Prevent this from happening by expanding one of the addends to
(pgoff_t) type.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: d323d005ac4a ("f2fs: support file defragment")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |    4 ++--
 fs/f2fs/file.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -366,7 +366,7 @@ static unsigned int __free_extent_tree(s
 static void __drop_largest_extent(struct extent_tree *et,
 					pgoff_t fofs, unsigned int len)
 {
-	if (fofs < et->largest.fofs + et->largest.len &&
+	if (fofs < (pgoff_t)et->largest.fofs + et->largest.len &&
 			fofs + len > et->largest.fofs) {
 		et->largest.len = 0;
 		et->largest_updated = true;
@@ -456,7 +456,7 @@ static bool __lookup_extent_tree(struct
 
 	if (type == EX_READ &&
 			et->largest.fofs <= pgofs &&
-			et->largest.fofs + et->largest.len > pgofs) {
+			(pgoff_t)et->largest.fofs + et->largest.len > pgofs) {
 		*ei = et->largest;
 		ret = true;
 		stat_inc_largest_node_hit(sbi);
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2719,7 +2719,7 @@ static int f2fs_defragment_range(struct
 	 * block addresses are continuous.
 	 */
 	if (f2fs_lookup_read_extent_cache(inode, pg_start, &ei)) {
-		if (ei.fofs + ei.len >= pg_end)
+		if ((pgoff_t)ei.fofs + ei.len >= pg_end)
 			goto out;
 	}
 


