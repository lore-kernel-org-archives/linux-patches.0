Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862721D0493;
	Wed,  2 Oct 2024 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880448; cv=none; b=MvE0f1gi9DgaqA8266lAjvdVRUYP2FPupZInG7vsv6puEepkAvKPBwUp3aHZYUTRFRrU5hWLh8TG53WVfUK14ChG+grcBI338akyYyIyoZPTeDhjobumZZdtsp7PnyHxyFKRvExw17ost7HPH4oJ02PtjkUPVzkAKt4wuDxIl0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880448; c=relaxed/simple;
	bh=DByu+BY/1xKkkJetk5Oesu8pgpTp22mJEN4tk5XlLiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTwGmRT1kES0fq64lO/awhjR+MGOTWhkF+nqNoAkfSXzNDcEDzYM0ln3MF6KG5442r/HRNXZvfxrnlXRyVIll33OTgHGhWaWqkx09FgVeJM3bRSfePz9F8b2wSGjF0gGMnlTq9Q/nzNXFLR+ZAkYXCEc4Mo1uhK7Tj4zBuGl+ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mch5EI4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mch5EI4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA0C4CECD;
	Wed,  2 Oct 2024 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880448;
	bh=DByu+BY/1xKkkJetk5Oesu8pgpTp22mJEN4tk5XlLiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mch5EI4nMvrMG9L5WZiRGRj00rdSEYFrFmSc8s0Jem9vw1EOib5ixFMBVdqpApKF+
	 +jX4VqgE8j9RfaS0hCNKA274cH2wnXIYGvTFe68/48wjtYUQSyj7c3KAlubR6tUdo4
	 QQFlelHdCBtV20i6HsN9ikLofRbXoRbOKN+ns04g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 461/538] f2fs: fix several potential integer overflows in file offsets
Date: Wed,  2 Oct 2024 15:01:40 +0200
Message-ID: <20241002125810.641854379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -367,7 +367,7 @@ static unsigned int __free_extent_tree(s
 static void __drop_largest_extent(struct extent_tree *et,
 					pgoff_t fofs, unsigned int len)
 {
-	if (fofs < et->largest.fofs + et->largest.len &&
+	if (fofs < (pgoff_t)et->largest.fofs + et->largest.len &&
 			fofs + len > et->largest.fofs) {
 		et->largest.len = 0;
 		et->largest_updated = true;
@@ -457,7 +457,7 @@ static bool __lookup_extent_tree(struct
 
 	if (type == EX_READ &&
 			et->largest.fofs <= pgofs &&
-			et->largest.fofs + et->largest.len > pgofs) {
+			(pgoff_t)et->largest.fofs + et->largest.len > pgofs) {
 		*ei = et->largest;
 		ret = true;
 		stat_inc_largest_node_hit(sbi);
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2687,7 +2687,7 @@ static int f2fs_defragment_range(struct
 	 * block addresses are continuous.
 	 */
 	if (f2fs_lookup_read_extent_cache(inode, pg_start, &ei)) {
-		if (ei.fofs + ei.len >= pg_end)
+		if ((pgoff_t)ei.fofs + ei.len >= pg_end)
 			goto out;
 	}
 


