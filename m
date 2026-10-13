Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70380155C87;
	Tue, 13 Oct 2026 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892558; cv=none; b=R7zN3zHMK8cCKhQxZoCMjfgJvhdBGf4xBefFgzwwoqLwBm3qtMOdxwfeoJEHJe4B3mYLfoYVbdq03vCHA3KN+IXkhW6WTHc0FuIAwpLudwuaXUcuny8r5cDKIe7GoQ8vcCrS1eVGTdCxfQo1Z+Q9YKA7oFWCHqwpfhTwHqP19dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892558; c=relaxed/simple;
	bh=eTkJEyIIIVQb4Ox0n5otheQ2gOzRaaD36VzStaz/uvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXXEKQ3nYyglLEYWTUbJ9m5Zzf69OhCjSWZrz8tIHR4su97bpeOHadwaIt+VIJmgpKFU0hqAWyMVVaaW5F4SiVhXzG2DCBL+WZ1A5PrYfdrFugjJoOovEkkrrEAsRXzGSLkODvlS+nnbwaBGm34M2l5UkGgFOjvrOzF28/pcCY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOjifoS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOjifoS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87121F000FF;
	Tue, 13 Oct 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892557;
	bh=yLIFhKkUF/h5sjnTcX7U3O6mEi1X8NuQaV3q60bxrXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOjifoS/856PPO3mAxw6esAEti6MF/DCkHCEqriD01VxrMO1/RLjZV9k8b5c+/sVE
	 9DgUdw2UxAHADm2Pgx+mHXoWmMf16eCG+PeXlT9zjDVWhOUDYKowBKh0eT7fdC4p6C
	 NjeA9c/Gpx7zqY7dorrpz31yMKbgU68QkPhhDHFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 211/281] btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
Date: Tue, 13 Oct 2026 13:38:47 +0200
Message-ID: <20261013112900.283629448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 80a8dbb30d2b00b9c671b02bd73f700f6d20100f ]

If all bios finish before btrfs_encoded_read_regular_fill_pages()
returns, it calls btrfs_uring_read_extent_endio() and previously
returned the I/O status.  A negative errno then made
btrfs_uring_read_extent() unlock and free while
btrfs_uring_read_finished() did the same again.

Return -EIOCBQUEUED so only the deferred path cleans up.

Reported-by: Yue Sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun1006219@gmail.com/
Suggested-by: Jens Axboe <axboe@kernel.dk>
Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7fe0a63d690a3..579b82e27b5ac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9622,7 +9622,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 	struct completion sync_reads;
 	unsigned long i = 0;
 	struct btrfs_bio *bbio;
-	int ret;
 
 	/*
 	 * Fast path for synchronous reads which completes in this call, io_uring
@@ -9669,10 +9668,10 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 
 	if (uring_ctx) {
 		if (refcount_dec_and_test(&priv->pending_refs)) {
-			ret = blk_status_to_errno(READ_ONCE(priv->status));
-			btrfs_uring_read_extent_endio(uring_ctx, ret);
+			int error = blk_status_to_errno(READ_ONCE(priv->status));
+
+			btrfs_uring_read_extent_endio(uring_ctx, error);
 			kfree(priv);
-			return ret;
 		}
 
 		return -EIOCBQUEUED;
-- 
2.53.0



