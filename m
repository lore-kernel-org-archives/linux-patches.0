Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C838A8494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0379BC433A1;
	Fri, 10 Mar 2023 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459112;
	bh=iR2RtzUfFs0qnZrwWCs/8P61EVOIzFIGIofU02+s0Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un2VnrA/B9hXXX4oiYz/fgk1xKBpfyiQVRj8cc96a6dkks7vPF9XNm/v7tKF6SvSz
	 r3LZeUOS5Ntt5/Yvs8rf98N6wtWxEiCi3iosOQ7JZhGcEoLE0Lwsm9gQh0vEGyCUuv
	 iTfvrSdUOoOzCFhX+atUlSr+bX4f/8JZfiLoKnpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 221/357] f2fs: fix information leak in f2fs_move_inline_dirents()
Date: Fri, 10 Mar 2023 14:38:30 +0100
Message-Id: <20230310133744.486241228@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 9a5571cff4ffcfc24847df9fd545cc5799ac0ee5 upstream.

When converting an inline directory to a regular one, f2fs is leaking
uninitialized memory to disk because it doesn't initialize the entire
directory block.  Fix this by zero-initializing the block.

This bug was introduced by commit 4ec17d688d74 ("f2fs: avoid unneeded
initializing when converting inline dentry"), which didn't consider the
security implications of leaking uninitialized memory to disk.

This was found by running xfstest generic/435 on a KMSAN-enabled kernel.

Fixes: 4ec17d688d74 ("f2fs: avoid unneeded initializing when converting inline dentry")
Cc: <stable@vger.kernel.org> # v4.3+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inline.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -402,18 +402,17 @@ static int f2fs_move_inline_dirents(stru
 
 	dentry_blk = page_address(page);
 
+	/*
+	 * Start by zeroing the full block, to ensure that all unused space is
+	 * zeroed and no uninitialized memory is leaked to disk.
+	 */
+	memset(dentry_blk, 0, F2FS_BLKSIZE);
+
 	make_dentry_ptr_inline(dir, &src, inline_dentry);
 	make_dentry_ptr_block(dir, &dst, dentry_blk);
 
 	/* copy data from inline dentry block to new dentry block */
 	memcpy(dst.bitmap, src.bitmap, src.nr_bitmap);
-	memset(dst.bitmap + src.nr_bitmap, 0, dst.nr_bitmap - src.nr_bitmap);
-	/*
-	 * we do not need to zero out remainder part of dentry and filename
-	 * field, since we have used bitmap for marking the usage status of
-	 * them, besides, we can also ignore copying/zeroing reserved space
-	 * of dentry block, because them haven't been used so far.
-	 */
 	memcpy(dst.dentry, src.dentry, SIZE_OF_DIR_ENTRY * src.max);
 	memcpy(dst.filename, src.filename, src.max * F2FS_SLOT_LEN);
 


