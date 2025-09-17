Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CD6194C86;
	Wed, 17 Sep 2025 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112565; cv=none; b=GPyBt3ZJbf4342mMpPwmh82ujrZqejzlh2K5Z0iyq0HkfYYplQ4z54mzX1p55j7MadzXPl22Gp1qjsJTuu6Pp1BncOGj1PzKgQ06ICpXyNmqAmI3scOLmyqEK59+LLrdjBhOq/+iSR1orv6aegFjy7c6srgr5XhfevKZx7S6O9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112565; c=relaxed/simple;
	bh=5lcXVeGRu71fFiWcTunxtV9JkLlytGsx1MhLrxN88h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwEokYeFioYFy8g1YNPJOLr4oDpuGK7z5L29G50UddNUxxhpXNfyFdEihngDBo8Ap1PfwOrV1kkP0fPrxgfwuAR9Yun6YqgW04fEkIK8UH01cqbjwhpk0MUWIBPfJs2DPW4nQV2Mu3+f+udJpRZIzuJC9iznm+RDJoTkhlMESbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gk6CqW9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gk6CqW9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9E7C4CEF0;
	Wed, 17 Sep 2025 12:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112563;
	bh=5lcXVeGRu71fFiWcTunxtV9JkLlytGsx1MhLrxN88h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gk6CqW9CNpOJU7ijfvi0dlnZ1gGcYljcQt0NqnORq6m5Yk7HNguWJisQqaOF3OBO/
	 7Zx0vIhn0gedKR50XPOYN+bbqg9UKuyXa7AVIc/9VinwN2YT1xaCV6DxA353/w7o9N
	 V99fSQyfpxvivPSTDF29iSG5asD73qOlgYXB0CV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 001/189] fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA availability
Date: Wed, 17 Sep 2025 14:31:51 +0200
Message-ID: <20250917123351.882864565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d072148a8631f102de60ed5a3a827e85d09d24f0 ]

Currently the kernel will happily route io_uring requests with metadata
to file operations that don't support it.  Add a FMODE_ flag to guard
that.

Fixes: 4de2ce04c862 ("fs: introduce IOCB_HAS_METADATA for metadata")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/20250819082517.2038819-2-hch@lst.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c       | 3 +++
 include/linux/fs.h | 3 ++-
 io_uring/rw.c      | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 1309861d4c2c4..e7bfe65c57f22 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
+#include <linux/blk-integrity.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/uio.h>
@@ -672,6 +673,8 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 
 	if (bdev_can_atomic_write(bdev))
 		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+	if (blk_get_integrity(bdev->bd_disk))
+		filp->f_mode |= FMODE_HAS_METADATA;
 
 	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
 	if (ret)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 040c0036320fd..d6716ff498a7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -149,7 +149,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* Expect random access pattern */
 #define FMODE_RANDOM		((__force fmode_t)(1 << 12))
 
-/* FMODE_* bit 13 */
+/* Supports IOCB_HAS_METADATA */
+#define FMODE_HAS_METADATA	((__force fmode_t)(1 << 13))
 
 /* File is opened with O_PATH; almost nothing can be done with it */
 #define FMODE_PATH		((__force fmode_t)(1 << 14))
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 52a5b950b2e5e..af5a54b5db123 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -886,6 +886,9 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (req->flags & REQ_F_HAS_METADATA) {
 		struct io_async_rw *io = req->async_data;
 
+		if (!(file->f_mode & FMODE_HAS_METADATA))
+			return -EINVAL;
+
 		/*
 		 * We have a union of meta fields with wpq used for buffered-io
 		 * in io_async_rw, so fail it here.
-- 
2.51.0



