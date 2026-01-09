Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6940C35B158;
	Fri,  9 Jan 2026 12:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962310; cv=none; b=NWMCPP6PX/xk1x3KfJTHTHml5AAwMLr6WyG4Z69O/WJxyb1U7w743ioD9qPZBrzc7+W4afcfOLD5HpPU6kg4UxENy3FJy0JY4t9Cv1MFzIz2yZrLyvQf47gQX4zRA49nQ3dkc5X/sIq27r00sjsENv9Xrm3AsrNkWAfWOhMqOrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962310; c=relaxed/simple;
	bh=8vg8PERlXZNB2xW/UvHFknRJTPxjbY/4abkNR7NsWN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeXgfaI6SvyD/lfYzvkCNf3SkCc9TsVTyR+KFaCwzUvpaxHoj80QRWgC/OjFo2Rb/wV2uUsIzwVckR1cljbb8+DDHo75MOsHr2coHwy4hL7PmVs0ljFXBl0LXm2+2mWv9UI2gWE6yX34p802LluX6iTGXOUFzrJsxQUy307Hamo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+dRU4YH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+dRU4YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9209C4CEF1;
	Fri,  9 Jan 2026 12:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962310;
	bh=8vg8PERlXZNB2xW/UvHFknRJTPxjbY/4abkNR7NsWN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+dRU4YH+nR/WH/T4DYs30NBPxO94POaaqiGGSyha4rwt1uXu3/ls5/5mIEvh3T/j
	 tit+G8LceETj54xQcfumAyR+qWCHT6LSajOD/Cg/uqnppHMfVWuDFgSIsNAOMMxNKW
	 W1WXy0evW+lupxEHisFDlgO5yVt2zhe0d0QOFb84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 321/634] s390/dasd: Fix gendisk parent after copy pair swap
Date: Fri,  9 Jan 2026 12:39:59 +0100
Message-ID: <20260109112129.608989469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Stefan Haberland <sth@linux.ibm.com>

commit c943bfc6afb8d0e781b9b7406f36caa8bbf95cb9 upstream.

After a copy pair swap the block device's "device" symlink points to
the secondary CCW device, but the gendisk's parent remained the
primary, leaving /sys/block/<dasdx> under the wrong parent.

Move the gendisk to the secondary's device with device_move(), keeping
the sysfs topology consistent after the swap.

Fixes: 413862caad6f ("s390/dasd: add copy pair swap capability")
Cc: stable@vger.kernel.org #6.1
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6190,6 +6190,7 @@ static int dasd_eckd_copy_pair_swap(stru
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
 	struct gendisk *gdp;
+	int rc;
 
 	copy = device->copy;
 	if (!copy)
@@ -6224,6 +6225,13 @@ static int dasd_eckd_copy_pair_swap(stru
 	/* swap blocklayer device link */
 	gdp = block->gdp;
 	dasd_add_link_to_gendisk(gdp, secondary);
+	rc = device_move(disk_to_dev(gdp), &secondary->cdev->dev, DPM_ORDER_NONE);
+	if (rc) {
+		dev_err(&primary->cdev->dev,
+			"copy_pair_swap: moving blockdevice parent %s->%s failed (%d)\n",
+			dev_name(&primary->cdev->dev),
+			dev_name(&secondary->cdev->dev), rc);
+	}
 
 	/* re-enable device */
 	dasd_device_remove_stop_bits(primary, DASD_STOPPED_PPRC);


