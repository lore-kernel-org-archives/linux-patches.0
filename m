Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413AE7FBB7;
	Fri, 28 Jun 2024 21:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719609839; cv=none; b=O8jfzw08Euj5hjLRsSb1cksLo98UDNSDRsHCfRaQb+Tk6oIPvI+ejKNa2FvVoUrqZrfOF6Yxi1pBsf3AXYiSut+8UX0piXKDWxH6YGT54K0Aho8WUGRXRbV0uVoE+AzHeHsMc99q08zPGZpsbyoqaSj3kW1Kq+C61RACkVWDMko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719609839; c=relaxed/simple;
	bh=Pt+AfLPtElLAgxHz6cS6LMSaOLKaSO6l0qTixvIWcWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n7FnMhIZiZM1H36HdkIyA28V0+9MGQiEnpUQdmlJY0nYiYWu4oyOL6JVbxsk4kGvQNWyef/TXAvcD5OzROWe5Uv5/sGoElbHhfr6PlePhfrRxD+HODIgdE2bClwySfZglBTRZszDGbQcNl6IosrhaArTcGW09kyOLfnPZjHVsD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4l2ZMKjL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4l2ZMKjL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5yZ6JVpJckl3jVdfEKlR4529wtL7JYIzrL/5IKzZ48U=; b=4l2ZMKjLXebadulX4O/7qPOvix
	mSmeOgHU/uGjuS0TIzlgzilhjyDRrSfQT1k4ttD2c+x6DbnuvYB8+HKnBUb7FhRUQSTDxQty6rrP7
	Ki/vnhxJuvHFnB02Y4Xxv0uYmYz5XgmUkkV4/N5DABcJ/sI1HdzFVDQu7mYfkl67PxRSddCdiSZds
	3DIfBU/lpmxIThdfwA5y1UFdWrXUw4NTnfHcTGxdYA0N109r3n3Z10h/OisL8abc4//uLGH/3OuJR
	W9Er4D9fTPp5r9dkA2DusnFeMRt5s6W+9I39J7L152lO17F4u7QXjuXyn0Rb2WalnwEh0bm+uyjJD
	PVWNDY7g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNJ4T-0000000F0kA-3gWb;
	Fri, 28 Jun 2024 21:23:53 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: p.raghav@samsung.com,
	hare@suse.de,
	kbusch@kernel.org,
	david@fromorbit.com,
	neilb@suse.de
Cc: mcgrof@kernel.org,
	gost.dev@samsung.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	patches@lists.linux.dev
Subject: [RFC] bdev: use bdev_io_min() for statx DIO min IO
Date: Fri, 28 Jun 2024 14:23:50 -0700
Message-ID: <20240628212350.3577766-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We currently rely on the block device logical block size for the
offset alignment. While this *works* it doesn't work with performance
in mind. That's exactly what the minimum_io_size attribute is for.

This would for example enhance performance for DIO on 4k IU drives which
have for example an LBA format of 512 bytes for both HDDs and NVMe.
Another use case is to ensure that DIO will be used with 16k IOs on
existing market 16k IU drives with an LBA format of 4k or 512 bytes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 1b4af2cc3b1e..5d0874aa8661 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1282,7 +1282,7 @@ void bdev_statx(struct inode *backing_inode, struct kstat *stat,
 
 	if (request_mask & STATX_DIOALIGN) {
 		stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
-		stat->dio_offset_align = bdev_logical_block_size(bdev);
+		stat->dio_offset_align = (unsigned int) bdev_io_min(bdev);
 		stat->result_mask |= STATX_DIOALIGN;
 	}
 
-- 
2.43.0

