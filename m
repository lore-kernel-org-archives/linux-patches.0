Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FAB1422C4;
	Thu, 11 Apr 2024 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829752; cv=none; b=HZ1oPidDkvbxOxAj6aEBXwihU0M3hR0aHcAu/QZ3h7IpYnOQW4vbKUCcquam3yLUDJoUyviOu8jbT+SJ3Rfrgbk6V9zCBAJMQAAH+jsjscWtCYRQtSR3N+nbxQzZljChURYyh/SMI1O7XkmK0ic+eMGEmwbfDbLqlOR+9h7U3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829752; c=relaxed/simple;
	bh=8XgUmww3pfBUb+mBWk44Va54apCXWGTtubu4tL3TOGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BX7mG+3vwqvejZRDEV3eQDr7yfw+axlx/J4WVhn74lHEq9H9ti5vRCwcAeI4g5Fv5xbIPXhO1OIbOQoHnv/sfXwML9H9IE7AJigSZ57ra3TV732nUi3V2bu3zDlYYo/5v+2HR2Y5w60neUiTZGif6bvQ3+5ZUDs6bTMDBJU7cUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMC8bcmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMC8bcmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A198C43390;
	Thu, 11 Apr 2024 10:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829752;
	bh=8XgUmww3pfBUb+mBWk44Va54apCXWGTtubu4tL3TOGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMC8bcmGmjZBe9hHdRJ+PLMPB9g4dsxPP22GKSezGm1swxuR0a8Mn831FF0ahO/2p
	 Bq5PMp3i3fEYCfdMC/+lgtvGuE2bXpSLOtbzRBdAjmmxyGel0Tkefva/gQQoqprGOI
	 QqT8eqEd+izkLRDC1eHNfJOP96o7djscm3tjaPlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	holger@applied-asynchrony.com,
	=?UTF-8?q?Holger=20Hoffst=E4tte?= <holger.hoffstaette@googlemail.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	Benjamin Gordon <bmgordon@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 4.19 094/175] loop: properly observe rotational flag of underlying device
Date: Thu, 11 Apr 2024 11:55:17 +0200
Message-ID: <20240411095422.396299495@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

[ Upstream commit 56a85fd8376ef32458efb6ea97a820754e12f6bb ]

The loop driver always declares the rotational flag of its device as
rotational, even when the device of the mapped file is nonrotational,
as is the case with SSDs or on tmpfs. This can confuse filesystem tools
which are SSD-aware; in my case I frequently forget to tell mkfs.btrfs
that my loop device on tmpfs is nonrotational, and that I really don't
need any automatic metadata redundancy.

The attached patch fixes this by introspecting the rotational flag of the
mapped file's underlying block device, if it exists. If the mapped file's
filesystem has no associated block device - as is the case on e.g. tmpfs -
we assume nonrotational storage. If there is a better way to identify such
non-devices I'd love to hear them.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: holger@applied-asynchrony.com
Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Benjamin Gordon <bmgordon@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -940,6 +940,24 @@ static int loop_prepare_queue(struct loo
 	return 0;
 }
 
+static void loop_update_rotational(struct loop_device *lo)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *file_inode = file->f_mapping->host;
+	struct block_device *file_bdev = file_inode->i_sb->s_bdev;
+	struct request_queue *q = lo->lo_queue;
+	bool nonrot = true;
+
+	/* not all filesystems (e.g. tmpfs) have a sb->s_bdev */
+	if (file_bdev)
+		nonrot = blk_queue_nonrot(bdev_get_queue(file_bdev));
+
+	if (nonrot)
+		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
+}
+
 static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 		       struct block_device *bdev, unsigned int arg)
 {
@@ -1001,6 +1019,7 @@ static int loop_set_fd(struct loop_devic
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_write_cache(lo->lo_queue, true, false);
 
+	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
 	loop_set_size(lo, size);


