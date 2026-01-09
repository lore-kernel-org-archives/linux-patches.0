Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572A1DE885;
	Fri,  9 Jan 2026 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960474; cv=none; b=gcFlcl/1QlcaAwtAAiW6dhFYQ6CKS/tv0R/kOaYawDTJlMvoExyWYM2+HpPqaqoCDm0/4sejal7qWK3XSm95GkqwRfEeyPpnp4mh4l//HKaEhyg1FsAlq0betTTbSTfRBLCTjFd2Ho1xXz6RCWiH7Sq7cydRVhDxLIV65q/RPu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960474; c=relaxed/simple;
	bh=yxRedM2uDTpIe22GUJFyRlofBCbv/3A8XsNOuY3DZPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQMaPyRkAHvtykMKRkDjxbiPX3yZOf5xMwd4tW0q2POehaXcGSmIrIHb50KJVwiBaiT1wZamXtcieIscFAiHFDMLp2Xy7Dt06MqnZ9sM1xaLUGJchT5R4yDxYWjhHj6jQOkzYbP6lurlhBGN5Ie56wiX8vvwQRs2Pa0TImadRrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMDAv0P0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMDAv0P0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EC4C4CEF1;
	Fri,  9 Jan 2026 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960474;
	bh=yxRedM2uDTpIe22GUJFyRlofBCbv/3A8XsNOuY3DZPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMDAv0P0QHkJA83teDSZL7NavY2aAquIkw1qvMSRqBf5ENUl8PqIqPmXceJlnioGg
	 ByJP8w9QiarenvDcS/bI1+U4YjJfhXC3PZq0Vs8rI2/ZO7pp3MhAqNP8DX0MNNrpYl
	 Fz2hEIRkVnjPSVhVVlZ/4fhz1vcTKvILm0UBj654=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 416/737] s390/dasd: Fix gendisk parent after copy pair swap
Date: Fri,  9 Jan 2026 12:39:15 +0100
Message-ID: <20260109112149.644333164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6189,6 +6189,7 @@ static int dasd_eckd_copy_pair_swap(stru
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
 	struct gendisk *gdp;
+	int rc;
 
 	copy = device->copy;
 	if (!copy)
@@ -6223,6 +6224,13 @@ static int dasd_eckd_copy_pair_swap(stru
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


