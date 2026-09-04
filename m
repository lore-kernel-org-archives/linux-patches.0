Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C51415F29;
	Fri,  4 Sep 2026 06:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501810; cv=none; b=nYOQisxSb36Ef8XklFPZjGcWxiFKuFyQ4LbOo5Ijdhc+yDrLy4c2m6KXVbhisaDI87n8HYxena0QOlgCX7nEdJ0zvg5LM40j3zFMnzdEjpWoQsv9F1k3iZzI+9bbFtnx08p3w6+Jf1HjrIlz0pTPickeLcEXdrN1BbtSVzwg+Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501810; c=relaxed/simple;
	bh=wstLkAp2E25rdC3iA4Io5ofatm/l9zsXs4nY/CAcF7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbTYudCPvcM+bGCYVjZ5IfuA2ZKI4q8axfGxW2g3qceLuM6O2SJPAm/kJvpc4Jtuu/H1fNFtTA0/S7cO61O26Wtg4c6hQCnFzshPmYIqHV77v6jXbpfQqPe9RQVvK93X6R6rJObwdBTB7pt6L98bAZetV3y4oS7woxYDWORcPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7E4Y3GE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7E4Y3GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A075E1F00A3D;
	Fri,  4 Sep 2026 06:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501809;
	bh=t66usvJv/yUDvVVQNeYIdsoo6gLoS8rnnapxI0Yig7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7E4Y3GEL8fsPiH+3GreA5C8Zr9PWd0iWjK4AxNeB31O5NyzesT20qgYTwYoXtFrc
	 GG5tOD48wcfKGK7z7g5TRhcAbb6xFHaOGSS0UFIK4xdFFS8p34N/s2jno44SFOEN2B
	 4N21J3ohNbqReDY7DAhCrmfouQvUORIBOvqQRAN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 541/552] zloop: truncate finished zones to zone capacity
Date: Fri,  4 Sep 2026 07:01:38 +0200
Message-ID: <20260904045802.874646518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 72e67c118642634c25465db0c8bcfa54c4ce086c upstream.

The size of a sequential zone backing file records the amount of data
written and is used to restore the zone state. A backing file whose size
is equal to the zone capacity is restored as a full zone, while a file
larger than the zone capacity is rejected as invalid.

However, zloop_finish_zone() currently truncates the backing file to the
zone size. For devices with a reduced zone capacity, finishing a zone
therefore creates a backing file larger than the zone capacity. After the
device is removed and later re-added, that zone file is rejected instead
of being restored as a full zone.

Truncate finished sequential zones to the zone capacity, matching the
persistent representation accepted by zloop_update_seq_zone() for a full
zone.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/B39E5FD81D1A07F4+20260804023403.939767-1-raoxu@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/blockdev/zoned_loop.rst |    9 ++++-----
 drivers/block/zloop.c                             |    3 ++-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/blockdev/zoned_loop.rst
+++ b/Documentation/admin-guide/blockdev/zoned_loop.rst
@@ -30,11 +30,10 @@ indicates the position of the write poin
 
 When resetting a sequential zone, its backing file size is truncated to zero.
 Conversely, for a zone finish operation, the backing file is truncated to the
-zone size. With this, the maximum capacity of a zloop zoned block device created
-can be larger configured to be larger than the storage space available on the
-backing file system. Of course, for such configuration, writing more data than
-the storage space available on the backing file system will result in write
-errors.
+zone capacity. With this, a zloop zoned block device can be configured with a
+larger capacity than the storage space available on the backing file system. Of
+course, for such configuration, writing more data than the storage space
+available on the backing file system will result in write errors.
 
 The zoned loop block device driver implements a complete zone transition state
 machine. That is, zones can be empty, implicitly opened, explicitly opened,
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -319,7 +319,8 @@ static int zloop_finish_zone(struct zloo
 	    zone->cond == BLK_ZONE_COND_FULL)
 		goto unlock;
 
-	if (vfs_truncate(&zone->file->f_path, zlo->zone_size << SECTOR_SHIFT)) {
+	if (vfs_truncate(&zone->file->f_path,
+			 zlo->zone_capacity << SECTOR_SHIFT)) {
 		set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
 		ret = -EIO;
 		goto unlock;


