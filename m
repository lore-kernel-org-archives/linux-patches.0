Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21E51FF7C5;
	Tue, 12 Aug 2025 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022906; cv=none; b=Fvu3pvcQyJBDZ554fnpFK6cCGWaIoNj+4z2Ttx5E3PHxSxA8aq7jXSF0fP25opsgzbchoXbZbimIJ4dWzC4YQFkg9cuECU9ObR5jh3rQKlmKhMNYQqh/frx6ikW8vdLUbjnOIC9jVKa2G1y5m9MfEl6tUEQJOYCAHJTPv2k7XW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022906; c=relaxed/simple;
	bh=Qu8mqSjG+nFD9x2SLn5e+E4Z5FgHGkoC4ZDFKDvTzJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbWIyLLIKIIFrEnPt2Hkq2KJT3DueYvBWb12HBWeAtU2v1sD8nZgOKqySkz0ooLQJITMe9z6bds0GgRghmjfw61Q3D69H5ZhcMvNyCfSzHT7kku0a3NyCYRsZJeZguT29oavNhU17AbgGORLl7nXHiZ9wPD/BiPMyX97loMqhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3kHF/7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3kHF/7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D31C4CEF0;
	Tue, 12 Aug 2025 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022906;
	bh=Qu8mqSjG+nFD9x2SLn5e+E4Z5FgHGkoC4ZDFKDvTzJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3kHF/7P/it4TMeudJuOQ8Uo8yu1x0kk6ddwRxESkMnNdOceK7kLKSo/dZI/4rkft
	 9ACl4/IQhhLN4FC2x9emUG4bYtdssMDPt/HqUD8XzP1PNycBJAh+hRNtK1MTumUHrt
	 Fl7pZ+Lp+2pb8Ol6fccxslwQMCy2lbNM1LtlVTMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/369] block: ensure discard_granularity is zero when discard is not supported
Date: Tue, 12 Aug 2025 19:29:52 +0200
Message-ID: <20250812173027.826109661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit fad6551fcf537375702b9af012508156a16a1ff7 ]

Documentation/ABI/stable/sysfs-block states:

  What: /sys/block/<disk>/queue/discard_granularity
  [...]
  A discard_granularity of 0 means that the device does not support
  discard functionality.

but this got broken when sorting out the block limits updates.  Fix this
by setting the discard_granularity limit to zero when the combined
max_discard_sectors is zero.

Fixes: 3c407dc723bb ("block: default the discard granularity to sector size")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250731152228.873923-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 7858c92b4483..22ce7fa4fe20 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -320,12 +320,19 @@ static int blk_validate_limits(struct queue_limits *lim)
 	lim->max_discard_sectors =
 		min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors);
 
+	/*
+	 * When discard is not supported, discard_granularity should be reported
+	 * as 0 to userspace.
+	 */
+	if (lim->max_discard_sectors)
+		lim->discard_granularity =
+			max(lim->discard_granularity, lim->physical_block_size);
+	else
+		lim->discard_granularity = 0;
+
 	if (!lim->max_discard_segments)
 		lim->max_discard_segments = 1;
 
-	if (lim->discard_granularity < lim->physical_block_size)
-		lim->discard_granularity = lim->physical_block_size;
-
 	/*
 	 * By default there is no limit on the segment boundary alignment,
 	 * but if there is one it can't be smaller than the page size as
-- 
2.39.5



