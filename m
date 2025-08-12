Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578572FFDD4;
	Tue, 12 Aug 2025 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024785; cv=none; b=pcWBpQOsYNpcmprZx2HhcU0935wVw9Rzqrf+qFbWkwWq5VJuk2Apl1N7QJyFk37GR4xC4YgKUVEcAFLq4HcE5BhFUdzx87WoGwx8HRDRoYuqxtJv4xjuRL0b7Iu/iVJbap3bVjC3NlcP90cQYknjkqU4VQDTXIZCrFL2P5xrFCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024785; c=relaxed/simple;
	bh=LHDnqq1eMSlkVRWNEPyacKFRfxoA6cPvYlOazjKppmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLBMGu53h9Ib+3WAiShorTdA9Rnqj+HLmYEeeWqhsnNUaMpkUPBMYDwow+JcOCVaJTXunuYNx2EbTwog8tScGlz5taN0XP7OdjXsmQ6XsELOsxV05PoC0VcCjcil6s7sLH0NHnbstXchdv+brG97g8ONbDaCo0fECuRt/ZWsjS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ev8Ae//j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ev8Ae//j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFD7C4CEF0;
	Tue, 12 Aug 2025 18:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024785;
	bh=LHDnqq1eMSlkVRWNEPyacKFRfxoA6cPvYlOazjKppmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ev8Ae//juP+naJnB99gdOJJjvMgV5q3pDhMP9vgQelilClf960yUOYmWNmu9iUIav
	 1xZEQBgAITVLqudy/QOl9+gFmzEhRlTwsClzm7/E3nv/KZBir195fwQY9IMmV2hhJ6
	 xBj36MlyQaLl+GV0pJOD21O3SaTk1O1ozxYyjA6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8c1d60e95df65e827d4@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 476/627] f2fs: fix KMSAN uninit-value in extent_info usage
Date: Tue, 12 Aug 2025 19:32:51 +0200
Message-ID: <20250812173442.147345640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abinash Singh <abinashlalotra@gmail.com>

[ Upstream commit 154467f4ad033473e5c903a03e7b9bca7df9a0fa ]

KMSAN reported a use of uninitialized value in `__is_extent_mergeable()`
 and `__is_back_mergeable()` via the read extent tree path.

The root cause is that `get_read_extent_info()` only initializes three
fields (`fofs`, `blk`, `len`) of `struct extent_info`, leaving the
remaining fields uninitialized. This leads to undefined behavior
when those fields are accessed later, especially during
extent merging.

Fix it by zero-initializing the `extent_info` struct before population.

Reported-by: syzbot+b8c1d60e95df65e827d4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b8c1d60e95df65e827d4
Fixes: 94afd6d6e525 ("f2fs: extent cache: support unaligned extent")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index cfe925a3d555..4ce19a310f38 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -414,7 +414,7 @@ void f2fs_init_read_extent_tree(struct inode *inode, struct folio *ifolio)
 	struct f2fs_extent *i_ext = &F2FS_INODE(&ifolio->page)->i_ext;
 	struct extent_tree *et;
 	struct extent_node *en;
-	struct extent_info ei;
+	struct extent_info ei = {0};
 
 	if (!__may_extent_tree(inode, EX_READ)) {
 		/* drop largest read extent */
-- 
2.39.5



