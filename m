Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DB8217F35;
	Tue, 12 Aug 2025 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026476; cv=none; b=eh6yeMTs8hd/z36lX2D1SOmoZChayrH+ArQBKOVEAA7U19o//ypJ/9f+IJCnXintteTVd/IdbWS4tlTDrnWfsx7yk7sRO4kcOdcE8uapauJAw3NA+ZFS+2K9WZ4z3c8ROT4a6sK9e4SGmC8it5Vk0wGmipWOuY/jixxmZ2n2lsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026476; c=relaxed/simple;
	bh=40DuclQf4qlyikKlFWxm3FmEtN9J+QquiiQCqgKq7VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+hHjUnxBg4ztZuRBUNB0Hfp65HlGiJIMDIS3Q1YBX1PyBrwbxRgQ7uBnG+pG0L5uPn9r3DPv/uDtrWWThAz0hSMrVrp/LvqW4wFMAEfcxRimbtObYZDxfUeeNGA17CnxMt+Qq5PFajzlnwUrARV2kwuVJKznIRdDSoOKb7FoYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6ZPO2rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6ZPO2rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC31C4CEF1;
	Tue, 12 Aug 2025 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026476;
	bh=40DuclQf4qlyikKlFWxm3FmEtN9J+QquiiQCqgKq7VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6ZPO2rUrUJkqPbGr1X0Gmw0JC8dLxSCsoYK4xJkar1xHRGjtel7A+wot1AODT8WZ
	 lgA5KfEpHDu9nrzy7o97JfkbsxqadVRfm3vLoA+uTyNH2sNU6jAzntCPTkye+aIrzu
	 ybfJ25LrJIahHRl5abhBXuz9rPgDYvZTUK4jIvxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8c1d60e95df65e827d4@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 348/480] f2fs: fix KMSAN uninit-value in extent_info usage
Date: Tue, 12 Aug 2025 19:49:16 +0200
Message-ID: <20250812174411.787184425@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 347b3b647834..c4d79ab0ae91 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -414,7 +414,7 @@ void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage)
 	struct f2fs_extent *i_ext = &F2FS_INODE(ipage)->i_ext;
 	struct extent_tree *et;
 	struct extent_node *en;
-	struct extent_info ei;
+	struct extent_info ei = {0};
 
 	if (!__may_extent_tree(inode, EX_READ)) {
 		/* drop largest read extent */
-- 
2.39.5



