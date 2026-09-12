Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E733161A1;
	Sat, 12 Sep 2026 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221318; cv=none; b=NiLd2sfh++hemsrPazzzdaqYzABbqhgRDfNdL1G5Qxz+J90ZbkC8XP9szZ4aP97sFHCEhCWUpPPkYQ28vczZpItJEhfg9oh5EnfCtTZkIoZ/erIYGCcKpAI4BFhpq4d1HohchgC4biyze/WcjwQILHqBzV1bzhEEHfjT/Bk7x8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221318; c=relaxed/simple;
	bh=FIUqGToP2x9c6cXb6jKiYYQJicz+hWmvn/PMI+xB5D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb2P+810Xzi/29h0zfFvG21KH6Ffpyg6bU8lLMZy53ihUZSs3tuck+c2uX6d6JI1e66ewlv18P4Ct/7X3oiJ353yp6ji8LAcNhEBxWw6aoELxJjlU64HO2fnLvx1UdSP+RtpUQYpPf/ZG/cC0T6yMV4yUPPv/9dkZ0bioXjyHGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbN2R8BZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbN2R8BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1DD1F000FF;
	Sat, 12 Sep 2026 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221313;
	bh=z7hfNHpjXb8qmyPdp9ocA6BFkJ+wg2p9lKJAtPuhxVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbN2R8BZYpsNoXW7ZiWfv7B6AH9IjBNad/Iqzr1xE5/hCa4sjt6FiuAvzdwB0d9FU
	 QBOsdLDtRRcadJrdui/JTtRLkuN/JU/6/emtMhNlRXey1Y+kJrdC2s/GUt44Hls1w8
	 ageBfGX6LT/FrD9I8WTYzUzfW1nTNsG5g5c4rSIk=
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
Subject: [PATCH 6.6 0358/1424] block: flag zoned disks with GENHD_FL_NO_PART
Date: Sat, 12 Sep 2026 08:46:30 +0200
Message-ID: <20260912065615.305323294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -467,6 +467,13 @@ int __must_check device_add_disk(struct
 		goto out_device_del;
 
 	/*
+	 * We do not support partitions with zoned block devices, so do not try
+	 * to scan the partitions table.
+	 */
+	if (blk_queue_is_zoned(disk->queue))
+		disk->flags |= GENHD_FL_NO_PART;
+
+	/*
 	 * avoid probable deadlock caused by allocating memory with
 	 * GFP_KERNEL in runtime_resume callback of its all ancestor
 	 * devices


