Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4426FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26080C433A0;
	Mon,  3 Apr 2023 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532346;
	bh=lQrjt/QS/+lnPbHF5z1PQxvyTxYOOcorVkUkKiQspQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HC0FxagvbUUf7o0UiOH52RGpPHVZHa9ueqESxi4Nn7Mt67+BZ+BZQCic6n8cILMqL
	 LOZvy3JVM6GZ5SggvCuSFEEWfUl6RXTu8llpbWuOMjvBgY0tWQT1gVUgEVy/75ajnv
	 42mBut41AMqKXgQuKhDG4rwTSAw5Bh9KoQPWnqIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/99] loop: suppress uevents while reconfiguring the device
Date: Mon,  3 Apr 2023 16:09:09 +0200
Message-Id: <20230403140405.018675838@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 498ef5c777d9c89693b70cc453b40c392120ea1b ]

Currently, udev change event is generated for a loop device before the
device is ready for IO. Due to serialization on lo->lo_mutex in
lo_open() this does not matter because anybody is able to open the
device and do IO only after the configuration is finished. However this
synchronization in lo_open() is going away so make sure userspace
reacting to the change event will see the new device state by generating
the event only when the device is setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220330052917.2566582-13-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: bb430b694226 ("loop: LOOP_CONFIGURE: send uevents for partitions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 07cf7a35ae502..032862cce6e4e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -736,6 +736,10 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 
 	if (!file)
 		return -EBADF;
+
+	/* suppress uevents while reconfiguring the device */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
+
 	is_loop = is_loop_device(file);
 	error = loop_global_lock_killable(lo, is_loop);
 	if (error)
@@ -790,13 +794,18 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	fput(old_file);
 	if (partscan)
 		loop_reread_partitions(lo);
-	return 0;
+
+	error = 0;
+done:
+	/* enable and uncork uevent now that we are done */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	return error;
 
 out_err:
 	loop_global_unlock(lo, is_loop);
 out_putf:
 	fput(file);
-	return error;
+	goto done;
 }
 
 /* loop sysfs attributes */
@@ -1203,6 +1212,9 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	/* This is safe, since we have a reference from open(). */
 	__module_get(THIS_MODULE);
 
+	/* suppress uevents while reconfiguring the device */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
+
 	/*
 	 * If we don't hold exclusive handle for the device, upgrade to it
 	 * here to avoid changing device under exclusive owner.
@@ -1309,7 +1321,12 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		loop_reread_partitions(lo);
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(bdev, loop_configure);
-	return 0;
+
+	error = 0;
+done:
+	/* enable and uncork uevent now that we are done */
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	return error;
 
 out_unlock:
 	loop_global_unlock(lo, is_loop);
@@ -1320,7 +1337,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	fput(file);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	return error;
+	goto done;
 }
 
 static int __loop_clr_fd(struct loop_device *lo, bool release)
-- 
2.39.2



