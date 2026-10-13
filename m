Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFC44D98E6;
	Tue, 13 Oct 2026 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894410; cv=none; b=ptcVxcKC6yDhXsupfgh74DeEMhv6gH4zHohtwLNx6mlsdLhBmL693NNQ+rM+5zThzIzDa/VVVavL9DVSx0Qw4fWvMaXFLjwJbZQIuw8Rq+9sRu3w2FT45o83C7JU8PwiyzBIRVoZlbgQ6PvtI/8UEd39kes3UuBgkrIWiOR3pZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894410; c=relaxed/simple;
	bh=AU6bSd5UIzkeWHImy6vv8m9wB9eqRTjoiRNCiYacbhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e09pB9r8n5Kf87N5wXuf7K03tbsA/SFTkSIaPcv+g4j0zMYj1l1F2Fo3duAbAB3oS3+QSC/qUnrcVh09tlG5RZgfauz0BhnvqhwSD2afNM4hfZaPD8ys+wguNgn3jXcTVyiqKy/Yw6ki9IC3V96m6/wJTB6DwVzCf2tlPOmxZMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAhy/+xB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAhy/+xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E998B1F000FF;
	Tue, 13 Oct 2026 12:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894409;
	bh=Z+t3QqEFbEWssSfcnro4OuEr1yZWPGblXS1kdroknd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAhy/+xBBt7112uDJCBmje/6zN6bj3aFGa7YD/NAOFbKehiXTeYRDXyDldZKfkYYJ
	 ceLMP0MvIcCmqVEJMSYLNFCA6okawOezzRqHOMliKVeI3FeMOTsdvnQyp/UH1Uy6Ib
	 1KDD3UPSvoTF/AzRMf+fPajtrG8ujBg6plN3nFpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 551/621] btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
Date: Tue, 13 Oct 2026 13:39:06 +0200
Message-ID: <20261013112933.890087787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c63b2f5edae9e..62858d8d66bd6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9499,7 +9499,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 	struct completion sync_reads;
 	unsigned long i = 0;
 	struct btrfs_bio *bbio;
-	int ret;
 
 	/*
 	 * Fast path for synchronous reads which completes in this call, io_uring
@@ -9546,10 +9545,10 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 
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



