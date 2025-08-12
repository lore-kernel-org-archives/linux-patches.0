Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0C32FE578;
	Tue, 12 Aug 2025 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021607; cv=none; b=PyTc+4V0xfvgdC46ktS8wrxUEjfpUmn8bRBPHUeDzBXlEtGclssDC7a2FdU2Arl1FNxR/D3L1hToo5SPCkGpFJ8Imx/kkes8serLrUzpgY8SgJ5u0GsnF3qGxSf4eVcEwIyOn+Tfs6xD3pxnpZ68Cnlp9JB9wRX/wlhG5DNaJmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021607; c=relaxed/simple;
	bh=736TgbcN3pQWETnL0dMUug4RF3OlTU5G20S7QaBmHX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LokzDTYxAZoStAO7kbHEshAZfudPe32cG2WSk7X8utYAAihl8gvo1z6VnFUWHd1vk19stVEpfJhP18XJDiaKsHX16/TqvHYlfjRg0/jtscOLAFvt8wMhTLzuif/M3lIcisyCY9ZfRxcui1NCCI2wFLnRSDWYG+iecM5Fz5iqEn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLooiEKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLooiEKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF1DC4CEF7;
	Tue, 12 Aug 2025 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021607;
	bh=736TgbcN3pQWETnL0dMUug4RF3OlTU5G20S7QaBmHX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLooiEKzFy/eoVnGe+My1s2zniQSHnyZ8ngs9uD74Dp11srlRio4qULay7euwRjsu
	 izGlhOFU5NsBJZXZvJ2EGaj7acpH7zMI+CXi70cLbSO2W6ChCeOyeK4hIlq5dwaUed
	 GQxv6jr12KO4F9MH0pCIKtiti0sW6A0M0D1EuwDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8c1d60e95df65e827d4@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/262] f2fs: fix KMSAN uninit-value in extent_info usage
Date: Tue, 12 Aug 2025 19:29:20 +0200
Message-ID: <20250812173000.430033723@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bfa2d89dc9ea..6a77581106a9 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -382,7 +382,7 @@ void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage)
 	struct f2fs_extent *i_ext = &F2FS_INODE(ipage)->i_ext;
 	struct extent_tree *et;
 	struct extent_node *en;
-	struct extent_info ei;
+	struct extent_info ei = {0};
 
 	if (!__may_extent_tree(inode, EX_READ)) {
 		/* drop largest read extent */
-- 
2.39.5



