Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2F832C933;
	Mon, 29 Dec 2025 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025620; cv=none; b=ruwQnFW1Ab0n4XargwmqL4FBpXmxI/ZFsi/39w89JW64jfbuuJF7cAVTVTFlH0FwUxGw0J5vVLDfkg51BZpk/LxiTXhhZ+AtQJVg29hLizExakonXVFWYfHMPxaBwyojk/LhJXb/GhFpdLIvQeWjgp7Dgzbx6JUWrMfF42bshuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025620; c=relaxed/simple;
	bh=bNw/GBnorZ4Sad3npm3ka7m0fSL5mueJhUIyvS0mufw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES92D3x3kUm5QChs4sKaOTVF9jSPl7uCj37VafjxcQomcyiLMN6HpZrunZjYCEK1BouA6SvGZQNm9UOz0RzkYOcU7X/4sRCoAY2CUV3CHP8gatqgAOx0KECa1KCE/a6kHqdaqgghPZD7LEnjgY3PRXsA6SJHUaZLD0ZbwoiCfqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQ9OqNRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQ9OqNRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF3EC4CEF7;
	Mon, 29 Dec 2025 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025620;
	bh=bNw/GBnorZ4Sad3npm3ka7m0fSL5mueJhUIyvS0mufw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQ9OqNRr318GxEMn0SZSpBrKnQ984NQ+qOd5WlL0nBmVtjr4ShFqtCshmOrABkRMF
	 HvjygaGgD0X4aVyFfHpe0Kmv0Evvgohr6PrKw0nA9hU59rmi1LqmozkmGb0VAZAlyx
	 FCPtxQM/NqsIxs8wZWLX/NwVoG10KbnlfYc609ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 244/430] s390/dasd: Fix gendisk parent after copy pair swap
Date: Mon, 29 Dec 2025 17:10:46 +0100
Message-ID: <20251229160733.332711759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -6150,6 +6150,7 @@ static int dasd_eckd_copy_pair_swap(stru
 	struct dasd_copy_relation *copy;
 	struct dasd_block *block;
 	struct gendisk *gdp;
+	int rc;
 
 	copy = device->copy;
 	if (!copy)
@@ -6184,6 +6185,13 @@ static int dasd_eckd_copy_pair_swap(stru
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


