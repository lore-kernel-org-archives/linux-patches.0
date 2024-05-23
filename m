Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4482614B09F;
	Thu, 23 May 2024 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470553; cv=none; b=V0BnBQT0pm18QfaFqyeLNtARqizSHU0Br82FpETL7/xvdBxuBBq7vAe13hex5x1A+HG2RQBvdAs/+5MiM0jdbjNcI4pMr0VwuGpF+UeqGOG+/fZqUBiQPS4Y6OlhPSOfvJRKnwlc02H4eImc3Zczr9KVJRdnxQnvhqMI/SYPy0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470553; c=relaxed/simple;
	bh=kTlUWzVY37SYag5o8RJwmh4RTeKBU6GHpcq7jLjg170=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0zA5nQwzhI4E2O4xexVe2YZgPFA4GtD+bfRkaaiFXXTCWvWvPzN11Me4ePMKeWHztddixyple1+T4vGMibN7nXcylvd2HUifr4v9W/boQbN6osn2AvWwMtysxrBuuHgwufbl35pPLpXl3YtPHC+EEe6PvGB4QNVok5x8diLcD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHaMRvdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHaMRvdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFD3C3277B;
	Thu, 23 May 2024 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470553;
	bh=kTlUWzVY37SYag5o8RJwmh4RTeKBU6GHpcq7jLjg170=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHaMRvdYyvY0Hmb1HpWiu4M6xgdDfQRK46Dy7XNAusrCR6tFePWGhjVtxg/arZnAM
	 Ky2/n93JqZfu9ByAMKRcxaOLxmiEqekJYCeIdbXaEYsibgLw/jfPcPj28oYd9sJdYx
	 mEtGESXsWPsDdxGfmrxWE9uoGzy9qKqbDEWFLYss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 23/23] block: add a partscan sysfs attribute for disks
Date: Thu, 23 May 2024 15:13:50 +0200
Message-ID: <20240523130330.625704586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit a4217c6740dc64a3eb6815868a9260825e8c68c6 upstream.

Userspace had been unknowingly relying on a non-stable interface of
kernel internals to determine if partition scanning is enabled for a
given disk. Provide a stable interface for this purpose instead.

Cc: stable@vger.kernel.org # 6.3+
Depends-on: 140ce28dd3be ("block: add a disk_has_partscan helper")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-block/ZhQJf8mzq_wipkBH@gardel-login/
Link: https://lore.kernel.org/r/20240502130033.1958492-3-hch@lst.de
[axboe: add links and commit message from Keith]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/stable/sysfs-block |   10 ++++++++++
 block/genhd.c                        |    8 ++++++++
 2 files changed, 18 insertions(+)

--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -101,6 +101,16 @@ Description:
 		devices that support receiving integrity metadata.
 
 
+What:		/sys/block/<disk>/partscan
+Date:		May 2024
+Contact:	Christoph Hellwig <hch@lst.de>
+Description:
+		The /sys/block/<disk>/partscan files reports if partition
+		scanning is enabled for the disk.  It returns "1" if partition
+		scanning is enabled, or "0" if not.  The value type is a 32-bit
+		unsigned integer, but only "0" and "1" are valid values.
+
+
 What:		/sys/block/<disk>/<partition>/alignment_offset
 Date:		April 2009
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1044,6 +1044,12 @@ static ssize_t diskseq_show(struct devic
 	return sprintf(buf, "%llu\n", disk->diskseq);
 }
 
+static ssize_t partscan_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", disk_has_partscan(dev_to_disk(dev)));
+}
+
 static DEVICE_ATTR(range, 0444, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, 0444, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, 0444, disk_removable_show, NULL);
@@ -1057,6 +1063,7 @@ static DEVICE_ATTR(stat, 0444, part_stat
 static DEVICE_ATTR(inflight, 0444, part_inflight_show, NULL);
 static DEVICE_ATTR(badblocks, 0644, disk_badblocks_show, disk_badblocks_store);
 static DEVICE_ATTR(diskseq, 0444, diskseq_show, NULL);
+static DEVICE_ATTR(partscan, 0444, partscan_show, NULL);
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
@@ -1103,6 +1110,7 @@ static struct attribute *disk_attrs[] =
 	&dev_attr_events_async.attr,
 	&dev_attr_events_poll_msecs.attr,
 	&dev_attr_diskseq.attr,
+	&dev_attr_partscan.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif


