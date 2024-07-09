Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3721527713;
	Tue,  9 Jul 2024 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524462; cv=none; b=LgQ+FSxFiNNPWMcqn7fD40g+pbLWUfSqmCgo/14krUBFz0YAeQJPrvZIVmxM+DfhoIz+B1nCi4ZaxqCvSQS4lNtl+EvzMs8mkFK6DWVWcZ2sOHiSb9brtFNQ19b/ru325V918h0+QrUF+Snp9q1MtZh0lU6ZpvREXE3k6gPGu74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524462; c=relaxed/simple;
	bh=44Kmv6LCS4eyGNmAzc9xvVNYhV4tlgz71bLTFO5rSMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAHaWTgcQ2KlY0FUYh0vRMp1xJD+kW13Oub7TwVmNHwdW5OmkEdLqPmhxJ+2+ECZW2rrB2rwjsB5dsD9W1bSzQxtke42WT/cIhVSPfH3lYaRx0iLfe10z11mXNCvK6KGYg29GpXwpDDgN3XQ4XBfPGv1uZgQuqV1GQ/i7LtOP3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOdbTAKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOdbTAKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22A0C3277B;
	Tue,  9 Jul 2024 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524462;
	bh=44Kmv6LCS4eyGNmAzc9xvVNYhV4tlgz71bLTFO5rSMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOdbTAKCQA59CpvMppzudEqyBfVcGsrQPbmOulq/1Z6AiBAkC3ooY6sfPAew+S8pc
	 fg6YwfjFO5BRcmj4wtq0YbFXmw3EWzKeQh1lv7w7Z1c7Yx9X8sKW9tfoht0A71elT0
	 PhXBVujeYvCVI47frN5QCvDGRDNVoDzN4GfMVrBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 188/197] block: check for max_hw_sectors underflow
Date: Tue,  9 Jul 2024 13:10:42 +0200
Message-ID: <20240709110716.217458565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit e993db2d6e5207f1ae061c2ac554ab1f714c741d ]

The logical block size need to be smaller than the max_hw_sector
setting, otherwise we can't even transfer a single LBA.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 15319b217bf3f..4bd7cbab4c241 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -104,6 +104,7 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 static int blk_validate_limits(struct queue_limits *lim)
 {
 	unsigned int max_hw_sectors;
+	unsigned int logical_block_sectors;
 
 	/*
 	 * Unless otherwise specified, default to 512 byte logical blocks and a
@@ -134,8 +135,11 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	if (WARN_ON_ONCE(lim->max_hw_sectors < PAGE_SECTORS))
 		return -EINVAL;
+	logical_block_sectors = lim->logical_block_size >> SECTOR_SHIFT;
+	if (WARN_ON_ONCE(logical_block_sectors > lim->max_hw_sectors))
+		return -EINVAL;
 	lim->max_hw_sectors = round_down(lim->max_hw_sectors,
-			lim->logical_block_size >> SECTOR_SHIFT);
+			logical_block_sectors);
 
 	/*
 	 * The actual max_sectors value is a complex beast and also takes the
@@ -153,7 +157,7 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->max_sectors = min(max_hw_sectors, BLK_DEF_MAX_SECTORS_CAP);
 	}
 	lim->max_sectors = round_down(lim->max_sectors,
-			lim->logical_block_size >> SECTOR_SHIFT);
+			logical_block_sectors);
 
 	/*
 	 * Random default for the maximum number of segments.  Driver should not
-- 
2.43.0



