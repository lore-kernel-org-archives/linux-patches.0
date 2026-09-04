Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D373B19BC;
	Fri,  4 Sep 2026 05:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500908; cv=none; b=HAPAqngHQkzKTbLjD92AGcIYL64diqnjjn8Gv47LTiVxu3aUfzoyulQ7I/eWI4PphrOOeL04bI9san0MjDbYYsr0jKd+nYQvK05IefRik/2RgdmWs5iHrrcFrG7HLlO/zuQW+gJCJFLe4654bUpFYbfpHC1KuO8QwdDiO14ro5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500908; c=relaxed/simple;
	bh=iGhMR7OryEFiDIRKps8pPzjb5IOBuF6oKCLzuAP9ZbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKJkqLSreyvvejrfXAV7Nhg1oai3Xy6NrBcEAzm+GLwvilJMGAl3HDjWLOV2sdx1dBG5BisqDJGHVY7w9XC7Ra26DrF/4aihK6uYjatVf+sIa2mI/edLcJGiO10CtFLJZC+zuptL/cEdG6LkprTHULDep3k6KukYAUtWZhWYGk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qwv9nn53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qwv9nn53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2921F00A3D;
	Fri,  4 Sep 2026 05:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500907;
	bh=O7/ow7aGLAtSViFXKbrCQYHlgOm7uvrAqx9qJYy3pSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qwv9nn53S7WdyePW9Wu3dyNB4MokuIVyR4YMLtGfj1xKk9m1A6l/yqFZ4PfxV28vD
	 HMo5Q287SwqG3lUqNFASp7V0ssC5WYBUfLPyN4dv1DEC1dmUemguW4vEw5//fygTlw
	 PGI//AsCNC6ra6Peaj0sv4K6qTdlRikYtetrMeq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 223/552] block: set QUEUE_FLAG_DYING unconditionally in blk_mark_disk_dead()
Date: Fri,  4 Sep 2026 06:56:20 +0200
Message-ID: <20260904045754.548601833@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 胡连勤 <hulianqin@vivo.com>

commit 7e9a46004b471eaf69b082c473d865316a4158e0 upstream.

Disks created via blk_mq_alloc_disk_for_queue() (e.g. SCSI SD disks)
do not have GD_OWNS_QUEUE set.  Currently __blk_mark_disk_dead() only
sets QUEUE_FLAG_DYING when GD_OWNS_QUEUE is set, so for such disks
blk_queue_enter() and __bio_queue_enter() cannot detect the dying
state via blk_queue_dying() and remain blocked waiting for I/O that
will never complete after surprise removal.

blk_mark_disk_dead() is the explicit "surprise removal" API -- the
caller has already decided the disk is dead.  Setting QUEUE_FLAG_DYING
unconditionally here is appropriate: any in-flight I/O from other
threads should get -ENODEV immediately from blk_queue_enter()
regardless of GD_OWNS_QUEUE ownership.

For disks that already have GD_OWNS_QUEUE set, __blk_mark_disk_dead()
will set the flag again which is harmless.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/PUZPR06MB62247E82E66A3ED46CC3E6C7D2DC2@PUZPR06MB6224.apcprd06.prod.outlook.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -681,6 +681,7 @@ static bool __blk_mark_disk_dead(struct
  */
 void blk_mark_disk_dead(struct gendisk *disk)
 {
+	blk_queue_flag_set(QUEUE_FLAG_DYING, disk->queue);
 	__blk_mark_disk_dead(disk);
 	blk_report_disk_dead(disk, true);
 }


