Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0709355025;
	Tue,  6 Jan 2026 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720184; cv=none; b=roLcbYThHY9GMCgHyJcrbsyrBAi8+HVyD7vdCfmDX6sjM879ftCG7Z6Ac2zvi8rJm6j4zOf3ddv9yE7/whWGSs3oMSo5i7EevRTpusW3EnIzZ9WGfnudc0XJeWHPVvQESry6npQZU/B/USdjYU+hyrPX14OEXsvCjz87gzyaWdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720184; c=relaxed/simple;
	bh=JU0LH47Mmbdu8p1sGOt2y5W7Q9uJHPM+TBFRm4EKe7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak3YLHzvxei0zfCNvD86kJMrQOSrHVNdxey+ysYPBMCGFiiegj48ZGlhfVvsIj4hHkAXeeQX5bE3n9MiWJkKHJHt6dlmxVcFAVRGicZaHSSIVHlzpHrpmOJqUOjvTcpEBlzVCwb20jS2MS3hb2K7kSezJ6B6wPkj5ef1Ypjxn/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srQMMOSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srQMMOSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBBCC116C6;
	Tue,  6 Jan 2026 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720184;
	bh=JU0LH47Mmbdu8p1sGOt2y5W7Q9uJHPM+TBFRm4EKe7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srQMMOSQkSG2ZHsBW7uWQ4JmCNHPWghW/DLloA3VtHjY+hEaANgH4cSmvKFLxmSkv
	 Vf6oXpGOEgZemihtlRbtefNVDHzET9n5ztuZuL/ml2GmQXTJietoRbxvb2xuNjoOjl
	 9/vzkxxYvMTMMD9vbfDsoHlxfYaeoqG3Xqmrpei0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 159/567] s390/dasd: Fix gendisk parent after copy pair swap
Date: Tue,  6 Jan 2026 17:59:01 +0100
Message-ID: <20260106170457.210763492@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6149,6 +6149,7 @@ static int dasd_eckd_copy_pair_swap(stru
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
 	struct gendisk *gdp;
+	int rc;
 
 	copy = device->copy;
 	if (!copy)
@@ -6183,6 +6184,13 @@ static int dasd_eckd_copy_pair_swap(stru
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


