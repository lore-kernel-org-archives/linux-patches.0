Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F133DAAC8;
	Fri,  4 Sep 2026 05:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499265; cv=none; b=CdsM+lqwQZM96dhjUGIQX4rLG1FhumMT8YJ3yaC6iYdxc9AmDJaCQKlr0QTbKGsHiT6I7jFaE1QYMoI+AMb1aOR5pRlEaddaQZ3Go2fJY2yqp1ehyMYnxc1kdamFmCzxUx0EcQ2Xvsy8wa/pnMjN1tU940xwkpDNmKDxBaKKaoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499265; c=relaxed/simple;
	bh=qLrzuHIt/3+hvd5Kk1xRzCUmzighD/P30ClezowtBJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=falO8lL0FyNK7b98A0rMVoHt/XbYbCWWEI9MR84Wr1Jx94hynxFQUMXXw4eQM9z5aJ+yen6mjBpfilCESnIgWWKLjV7AcQX1BolyRbG+1/Es+JjstP/SbA9qnST/ZEAE/ezgTVGomjC5MbwLLkuiJDp0d3TKjloxCjTmNxZzp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5f0f0qC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5f0f0qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C48E1F00A3D;
	Fri,  4 Sep 2026 05:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499264;
	bh=uAJGnYO0qujReeLijnV1AKAZXEFgdL47S0KgHcev9IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5f0f0qCPzKYYszrdGWFX+vE764e90XrcSZ195rGBHCVaFs/tAtlvW9YP5b9d+U3D
	 pO0Gf1CIlSwB14HaGOtEFUnyzCeSo0tb9PhFjk0FQgR0Gp+cv1A266lkVDuJC+X2w7
	 8OxmZK/tgl/Z9Ak/4oEMxcL3OlLmuLl8bhMPCDhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 313/713] block: set QUEUE_FLAG_DYING unconditionally in blk_mark_disk_dead()
Date: Fri,  4 Sep 2026 06:54:41 +0200
Message-ID: <20260904045810.850251011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


