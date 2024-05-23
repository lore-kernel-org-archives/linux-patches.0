Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A651D545;
	Thu, 23 May 2024 13:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470829; cv=none; b=PgD+iabtMm8e5JBqIAj5WYuJU2Vm0BYFVHn+EW9rhj0Hppx9hj4rAz1E5ELjTshtNtrhrQrjgisTKjDkdiTw5LOQc1mp+MEVaK4qHevLYx7mKJcHmElVcTIN0HOxsyVAp/oj8LC/YTAfQjRIcmZSkVLdUkHPoS84C1AHOyrZs8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470829; c=relaxed/simple;
	bh=Y2YX3KMOFZI6T1S1XiElFW/TZtlie3KWaUDBDuyULJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWj/lmZaVXPGlScqv5ysEBdva+KJnDjDTvQvaDRRO7lpQ8FkdYIQDEMyP/onRU1mEE9PQo/NhOqKk/2VR46zoAjHAhyR1uq24pqGRyx/MfM//nwNwdbsiWmclIA6OCbc1Qz7gY1I917jKSOaYX2UGq8q3lakkV0M0xFHJv8mhoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHkTu/5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHkTu/5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB78C2BD10;
	Thu, 23 May 2024 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470829;
	bh=Y2YX3KMOFZI6T1S1XiElFW/TZtlie3KWaUDBDuyULJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHkTu/5lk/OHzPcTOfGqSkWZ8yLArbReBSRkTLuUaxSS4jgZKLqgajk0Ei+iItvqq
	 GuCoc6jiwBA4DmfTjWuGT44VlL/s7NGT8/EOj/A5PJbfbcMmJE1zljyY3gHNCs9ktr
	 +eBdCVIhAB0OqvYdAXwC1MbqBSoXFSVzopbA775A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 102/102] block: add a partscan sysfs attribute for disks
Date: Thu, 23 May 2024 15:14:07 +0200
Message-ID: <20240523130346.321704879@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1037,6 +1037,12 @@ static ssize_t diskseq_show(struct devic
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
@@ -1050,6 +1056,7 @@ static DEVICE_ATTR(stat, 0444, part_stat
 static DEVICE_ATTR(inflight, 0444, part_inflight_show, NULL);
 static DEVICE_ATTR(badblocks, 0644, disk_badblocks_show, disk_badblocks_store);
 static DEVICE_ATTR(diskseq, 0444, diskseq_show, NULL);
+static DEVICE_ATTR(partscan, 0444, partscan_show, NULL);
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
@@ -1096,6 +1103,7 @@ static struct attribute *disk_attrs[] =
 	&dev_attr_events_async.attr,
 	&dev_attr_events_poll_msecs.attr,
 	&dev_attr_diskseq.attr,
+	&dev_attr_partscan.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif


