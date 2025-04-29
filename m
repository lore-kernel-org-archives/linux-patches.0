Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409778F58;
	Tue, 29 Apr 2025 17:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947710; cv=none; b=Rzg8df0QuUSpLpFH0tamdkId9a2bH4f5PtGUHyEN8S0Bnl5Jyxq3+l+HwOKYfTPX+Jjwm6/z0Fc5EmFU4vWubcG9cAoWLYw1Kr53ibvnjggPh70lad1bSVYlBOYRY/D0o9l0g4P74fL3/U6LpLMYHlj6NwIQZA9PM97y0yp/b1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947710; c=relaxed/simple;
	bh=kLezcYczjQUSGy6II7pudLcHN/MmMgEuzHfSyhEchhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bff0mgbY78R//YwGwp1rx+JNMqDVUEmGZSN55ooQ3kLDEGLvertpE/bwI1gV7UOrqgnBCC9hBBVH3JFZHnuKtJ8jwsKYofB5B+ql6bwi2qxGhfQh3OAnsMzsmKH6UYBV0teIm1BmdlNoTvnhJcGGwk4Ll4WVHyRT+IrzosZSMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smNbiun9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smNbiun9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70E5C4CEE9;
	Tue, 29 Apr 2025 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947710;
	bh=kLezcYczjQUSGy6II7pudLcHN/MmMgEuzHfSyhEchhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smNbiun9yzYYSd2ObdJCjHS7EDdbzG1xuA732HD6UjN0sTtDkzj7Gle3p5G8nXKZG
	 cPB4Y1qoZXP5ljClC+9foPhTYPiQzAKqaH7wGZeWNWl4njpX3Nt8Qxc5i2IsQ2Uir9
	 W3bLn4uFnRYjYBcbNqdQtj4fcyuZ0HL0AjfhSV3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/280] block: never reduce ra_pages in blk_apply_bdi_limits
Date: Tue, 29 Apr 2025 18:40:23 +0200
Message-ID: <20250429161118.468926954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7b720c720253e2070459420b2628a7b9ee6733b3 ]

When the user increased the read-ahead size through sysfs this value
currently get lost if the device is reprobe, including on a resume
from suspend.

As there is no hardware limitation for the read-ahead size there is
no real need to reset it or track a separate hardware limitation
like for max_sectors.

This restores the pre-atomic queue limit behavior in the sd driver as
sd did not use blk_queue_io_opt and thus never updated the read ahead
size to the value based of the optimal I/O, but changes behavior for
all other drivers.  As the new behavior seems useful and sd is the
driver for which the readahead size tweaks are most useful that seems
like a worthwhile trade off.

Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250424082521.1967286-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 7abf034089cd9..1e63e3dd54402 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -61,8 +61,14 @@ void blk_apply_bdi_limits(struct backing_dev_info *bdi,
 	/*
 	 * For read-ahead of large files to be effective, we need to read ahead
 	 * at least twice the optimal I/O size.
+	 *
+	 * There is no hardware limitation for the read-ahead size and the user
+	 * might have increased the read-ahead size through sysfs, so don't ever
+	 * decrease it.
 	 */
-	bdi->ra_pages = max(lim->io_opt * 2 / PAGE_SIZE, VM_READAHEAD_PAGES);
+	bdi->ra_pages = max3(bdi->ra_pages,
+				lim->io_opt * 2 / PAGE_SIZE,
+				VM_READAHEAD_PAGES);
 	bdi->io_pages = lim->max_sectors >> PAGE_SECTORS_SHIFT;
 }
 
-- 
2.39.5



