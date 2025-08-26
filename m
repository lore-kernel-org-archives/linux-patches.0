Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF80D345747;
	Tue, 26 Aug 2025 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215911; cv=none; b=JXznfaFBGPWjsvGxBqJAr0LEumXzm8S9uG+eE8lL6btlUI+KV/0VAO3agIiYggmkJ8ixEYjnGzPJkEhJHYU+bPw/OFFXf4Iq2fSg2ZjWk3IYa9ZGut4n6Z0jBJv/GToFx16kU+9BZTv8XwmIiJfcJhF6YvsXzbV0/cwx6OoHsOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215911; c=relaxed/simple;
	bh=lIEleJ3IWoo4ZXMsMIZCLQFR8ynjZjyPxxESJc+Xb1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UELT5r5Cp11yN4NbLnC/IjcNoU570QGQIMPuZV/rYt8v1B/zIGq6BzKaxPDtCulRYql1XbMJ+9vAIZymrNMzHrChquLVn0iAOshEdtYvz6BVS5rsJfInmQ099xm2MdAjPZ11Zjb/jOIZvRFe/ZnU4ebD2sZe5B7+uwK9B7gdJUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfuENSQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfuENSQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502E2C113CF;
	Tue, 26 Aug 2025 13:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215911;
	bh=lIEleJ3IWoo4ZXMsMIZCLQFR8ynjZjyPxxESJc+Xb1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfuENSQCEYT5Lu1z5Q7YM0kSK9q19WOOHWSiu6rEQHxM7u/cMDA4vk2oVWP4o4IBY
	 4V6+bxwXmdKhUT+1100h+y6WvlETrjb0/Xddfb5hwk+bjhVQjOX8uD++7kywc+yqVt
	 V6WH/cePzpCZ7VuFYQ4BWiyYXztuNb7ICxDTs9pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8c1d60e95df65e827d4@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/644] f2fs: fix KMSAN uninit-value in extent_info usage
Date: Tue, 26 Aug 2025 13:05:03 +0200
Message-ID: <20250826110951.690466611@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 30b8924d1493..5808791efd98 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -365,7 +365,7 @@ static void __f2fs_init_extent_tree(struct inode *inode, struct page *ipage)
 	struct f2fs_extent *i_ext = ipage ? &F2FS_INODE(ipage)->i_ext : NULL;
 	struct extent_tree *et;
 	struct extent_node *en;
-	struct extent_info ei;
+	struct extent_info ei = {0};
 
 	if (!f2fs_may_extent_tree(inode)) {
 		/* drop largest extent */
-- 
2.39.5



