Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892619B5BB;
	Thu,  6 Jun 2024 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683071; cv=none; b=lNlkjMWKR7L0mcmV2sLUpu19lXXvnbJ/jzyCeDFi1isnISqYQvOuK4UT4DBY/1SbRkDtCStFdKggY6FHN/DPcSG+7R/+sIIUby5b0wK8kFNsyqfLZiEEnZA3vzNzUZyQ5DZd5nOoz1gTN80QptS0yi8wMWwytykQ1U/2IEhheCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683071; c=relaxed/simple;
	bh=ypdF/gJnRtOTj5kcklSFX+QalW/r8veraK8GY8+96PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4d/T5wx+LdaWQ3TRDcJNGeO56JlF6MRt+bDXTNcoqs0MOjO/qdTLh0op341MERQNcYb2KUIG3cTrybE86gcaY8TYC0nwrTTudEhbBxu54uVXbLC4S3IP+6lSCWjUlAWQikH0UW5Ru6D1hw9gx+Ig4R3eiCefIJJ+hnoZLLcf2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTMmwtD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTMmwtD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17370C4AF0E;
	Thu,  6 Jun 2024 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683071;
	bh=ypdF/gJnRtOTj5kcklSFX+QalW/r8veraK8GY8+96PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTMmwtD1JVSjFyTz4WelTdP7C4riUVnyCJixp557kixKbH/TFDWtAlXxpnZ3n1fQe
	 N0nm39iusJYb5KPNUFSnEA6azc0Seo3PAUHGr4hXI3s+i9wlFIo/g4I/Vy4t96rSgv
	 vB0xsW2nOkt0e5G9lW6X3RaVnGFd68bsCtC4Seqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 333/374] block: stack max_user_sectors
Date: Thu,  6 Jun 2024 16:05:12 +0200
Message-ID: <20240606131703.010109029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit e528bede6f4e6822afdf0fa80be46ea9199f0911 ]

The max_user_sectors is one of the three factors determining the actual
max_sectors limit for READ/WRITE requests.  Because of that it needs to
be stacked at least for the device mapper multi-path case where requests
are directly inserted on the lower device.  For SCSI disks this is
important because the sd driver actually sets it's own advisory limit
that is lower than max_hw_sectors based on the block limits VPD page.
While this is a bit odd an unusual, the same effect can happen if a
user or udev script tweaks the value manually.

Fixes: 4f563a64732d ("block: add a max_user_discard_sectors queue limit")
Reported-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20240523182618.602003-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9d6033e01f2e1..15319b217bf3f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -751,6 +751,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	unsigned int top, bottom, alignment, ret = 0;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
+	t->max_user_sectors = min_not_zero(t->max_user_sectors,
+			b->max_user_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
-- 
2.43.0



