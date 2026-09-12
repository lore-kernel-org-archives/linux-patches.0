Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD882AD3C;
	Sat, 12 Sep 2026 15:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227985; cv=none; b=FpgCi081a7zQphJCai+I3X3rBh2/hRNxF76u5OTO39+/8Hvg1H6s3AJISMgFtdhf3eEWdyh3KQjehIVoKANYsG53YOSe8pMw4z8LbL+vDlZDBz415pQM+GyN/adAR34PAAuE39zhRgS6tq5fwWHHdSpkhHpBkrs8VRBccRxa144=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227985; c=relaxed/simple;
	bh=0vBHWv+5ler9ZhJvMf9m1h2VIUOt8xjSEV1VFFEpXvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASrETA5+DbKoMNDcYkn104APnWCmKc2EMOU0HYKAgrn/Ux/zFMj9b98M4rW0W4cyDDCILVBhOErq5xe/EFr2a/lHeG1Bk/iK8ww8xRk5uC4kSYDsE1D0NeZ83eQt+ghFgVGKGxkmrWrgrWd2R7dzX15pXo2FuaWsW6GKuKMcJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS5XOi+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS5XOi+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177431F000FF;
	Sat, 12 Sep 2026 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227984;
	bh=sWIAUJOlRyLyHd5fVFGSG/hMqhkIH09YdKDpr1pNyLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HS5XOi+TBTJPxSalba7GfHatq2vXR3N6zCO7gdy4LLCrUi87MWuZTncPNr5PB2dfy
	 tp/uoAxvidRYI6u66lHnWYew0ePI1I+gWU86XOLRLkyKn7cMNC2nUTkBW25MuPm7Xl
	 tFDu1/ZKX9bWr+4eZDG3xvHQYOxygprs7TVFD39E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0294/1191] block: flag zoned disks with GENHD_FL_NO_PART
Date: Sat, 12 Sep 2026 08:50:22 +0200
Message-ID: <20260912065554.833950879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 3f9c7a108c0e8f14425384912017071b71341e3b upstream.

Zoned block devices do not support partitions. However, the partition
table is nevertheless still inspected, and any partition found ignored
with a warning in add_partition(). While this is generally not a problem,
and in fact beneficial to the user as it indicates an invalid use of a
zoned block device, scanning for a partition table on the device may
result in issuing read operations to offline zones (e.g. after a disk head
is depopulated for disks that support head management operations).

Since partitions are ignored anyway, completely disable partition scanning
for zoned gendisks by setting the flag GENHD_FL_NO_PART in __add_disk().
The existing check in add_partition() is left as-is to ensure that we
still get a warning if for whatever reason, despite GENHD_FL_NO_PART, we
still endup trying to add partitions.

Flagging zoned disks with GENHD_FL_NO_PART also has the benefit to expose
through sysfs the ext_range attribute with the value of 1 instead of the
default DISK_MAX_PARTS, thus correctly advertizing the fact that zoned
disks do not support partitions.

Fixes: 5eac3eb30c9a ("block: Remove partition support for zoned block devices")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://patch.msgid.link/20260831025050.667758-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -428,6 +428,13 @@ int __must_check device_add_disk(struct
 	elevator_init_mq(disk->queue);
 
 	/*
+	 * We do not support partitions with zoned block devices, so do not try
+	 * to scan the partitions table.
+	 */
+	if (blk_queue_is_zoned(disk->queue))
+		disk->flags |= GENHD_FL_NO_PART;
+
+	/*
 	 * If the driver provides an explicit major number it also must provide
 	 * the number of minors numbers supported, and those will be used to
 	 * setup the gendisk.


