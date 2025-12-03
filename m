Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9C3587D8;
	Wed,  3 Dec 2025 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778851; cv=none; b=uKIhBPKRyKjSYzDTKMES68Hlf37pXP+lKc4XvDTYM6R4cwMP/7HxIo1L+wO5LRLG3ewwD7Mrz0/fjsK7Gq482d/RrJ7JXV7zEbtQ940phnVCrrOlUYeAPdt/UAdF03hD3LWbJY1tshB/HrGMN5Ms8VZoDmI+08jMVdyvs7QwYVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778851; c=relaxed/simple;
	bh=+ZLl+6I3V+iZVzWnfjBBVd3hlOWum935Eu9P+zGrmUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCBZMbYPX4o2zP9Z72KtlPANOD4Tzjlqt4GEdrBVAW8c4m9RFOg/uzlP7aeeJZZpFbUBfEMxLCfyE9Twzs3f26jnPQyP/DDgNK0iLdNQhMwOWoBD2mnNo1YayQX6T0vwJSy+q6pQyTLyrZropRYWGfbYE/flfnr5ucVCqgCfAd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CekpXzcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CekpXzcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DF3C4CEF5;
	Wed,  3 Dec 2025 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778851;
	bh=+ZLl+6I3V+iZVzWnfjBBVd3hlOWum935Eu9P+zGrmUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CekpXzcGyuprA+8zjsjSpP3plRxoqhATExLwsgH9CBjOa6uQZv6AUvc70GrO0h2Ye
	 B2YODObAEuoQBCCUcrXDCvj1yNW6nN5YQB7yf4Ax/ajPVa79uUiVH86f8X9USCqq04
	 Ldvy0tUlOu95evbLWLkGWWOFZwUwEx1coFn1Q/4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mahmoud Adam <mngyadam@amazon.de>
Subject: [PATCH 6.1 080/568] block: open code __generic_file_write_iter for blkdev writes
Date: Wed,  3 Dec 2025 16:21:22 +0100
Message-ID: <20251203152443.650679183@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 727cfe976758b79f8d2f8051c75a5ccb14539a56 upstream.

Open code __generic_file_write_iter to remove the indirect call into
->direct_IO and to prepare using the iomap based write code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20230801172201.1923299-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[fix contextual changes]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -515,6 +515,30 @@ static int blkdev_close(struct inode *in
 	return 0;
 }
 
+static ssize_t
+blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	size_t count = iov_iter_count(from);
+	ssize_t written;
+
+	written = kiocb_invalidate_pages(iocb, count);
+	if (written) {
+		if (written == -EBUSY)
+			return 0;
+		return written;
+	}
+
+	written = blkdev_direct_IO(iocb, from);
+	if (written > 0) {
+		kiocb_invalidate_post_direct_write(iocb, count);
+		iocb->ki_pos += written;
+		count -= written;
+	}
+	if (written != -EIOCBQUEUED)
+		iov_iter_revert(from, count - iov_iter_count(from));
+	return written;
+}
+
 /*
  * Write data to the block device.  Only intended for the block device itself
  * and the raw driver which basically is a fake block device.
@@ -524,7 +548,8 @@ static int blkdev_close(struct inode *in
  */
 static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct file *file = iocb->ki_filp;
+	struct block_device *bdev = file->private_data;
 	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	struct blk_plug plug;
@@ -553,7 +578,23 @@ static ssize_t blkdev_write_iter(struct
 	}
 
 	blk_start_plug(&plug);
-	ret = __generic_file_write_iter(iocb, from);
+	ret = file_remove_privs(file);
+	if (ret)
+		return ret;
+
+	ret = file_update_time(file);
+	if (ret)
+		return ret;
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		ret = blkdev_direct_write(iocb, from);
+		if (ret >= 0 && iov_iter_count(from))
+			ret = direct_write_fallback(iocb, from, ret,
+					generic_perform_write(iocb, from));
+	} else {
+		ret = generic_perform_write(iocb, from);
+	}
+
 	if (ret > 0)
 		ret = generic_write_sync(iocb, ret);
 	iov_iter_reexpand(from, iov_iter_count(from) + shorted);


