Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167471EBFE0;
	Tue, 12 Aug 2025 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022871; cv=none; b=cLW7sCfTIHhM5JOFyiccJSOXyJlyCbXoYYWNGEwbLjSUm47t+Hz3Nz3HyEIua06CU2r7yINWSrla5f+WzWK88gE7pQtEOkbBKRTi6DLzHsh8RShWDUD5YabyMnbyHxZ5TdJXCMLDUk6O0YGTGJf+ZGSXQwxzSKPxpc3WQ/kH+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022871; c=relaxed/simple;
	bh=x+ZcKecv9focak/tnSEbHHbdYGdLGw9D9U2FAx4LfQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbL3BoIMR4SCfz/0RiJWwAyAJgsbaZA6qPjY70kHCbwb8gRnZ4GPhkGziZOKtxiC2QWcB3g8QqdJidZo18uIFRA9fteFtcUCJ82dVkv239EocC2v4mMyKtcvqv9jSfN8GCI/4gaexpGdz8iA971k7WjqntwKkWCIImWIXRnaErw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icfPuEpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icfPuEpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79233C4CEF0;
	Tue, 12 Aug 2025 18:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022871;
	bh=x+ZcKecv9focak/tnSEbHHbdYGdLGw9D9U2FAx4LfQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icfPuEpV/rqN5WwW8dKR8dEruyuGfve+R2MjtyBaoBBiGrBwcCI3y7v42se5moM0F
	 ma+TtAdUPF1uueO9H31T+awRiHgsa3IexY7UZGNaw83Iu7avvzR0UoLcLcBHsh7up+
	 4MODVwU9ITPau07Fk7EQy2T3NPLiki/w/fm0Qb20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8c1d60e95df65e827d4@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/369] f2fs: fix KMSAN uninit-value in extent_info usage
Date: Tue, 12 Aug 2025 19:29:08 +0200
Message-ID: <20250812173024.204067616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index fb09c8e9bc57..2ccc86875099 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -381,7 +381,7 @@ void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage)
 	struct f2fs_extent *i_ext = &F2FS_INODE(ipage)->i_ext;
 	struct extent_tree *et;
 	struct extent_node *en;
-	struct extent_info ei;
+	struct extent_info ei = {0};
 
 	if (!__may_extent_tree(inode, EX_READ)) {
 		/* drop largest read extent */
-- 
2.39.5



