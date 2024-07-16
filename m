Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E186F19AD51;
	Tue, 16 Jul 2024 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146168; cv=none; b=sCQ6ljGAmfWjKxhXYhQXMa1O09VXHIZrRoZpPYO9xMb93KAGPBOGpCG0gs0Gox4AeGoHAqWfpnw/bn/BfuL70XcFUCF4EqeHxejvRU++VAmgJV6IFLiIVyl9Br8kKefetrkFBkHfzy8GOrFrn5/Cf8MLLNBIOii9HLkkYB1cRRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146168; c=relaxed/simple;
	bh=6sdLtPCNeqYX2ZSzLtEZ8A/i7HDU371WdR1siaGFqgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoWFENqiyjjeIqzv8KkeADriGdMnbntZBnFIM5DTAmX95dR+/OeLfV9Umznuigy8+oSOkINK0CIga5KKl+RsmljdfLcbwHGZyvcII/zTmovWTLBVae/90HJ7wwrXs7hYRD9EiAYHW426n4Krik59tPOmAefqSVroVn30K14GVf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhHFFur3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhHFFur3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B590C116B1;
	Tue, 16 Jul 2024 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146167;
	bh=6sdLtPCNeqYX2ZSzLtEZ8A/i7HDU371WdR1siaGFqgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhHFFur3JdZR0+33iKPIKcboZkx+9DR9iT4C6D65aLY/vRGJATAH1YW4ea38nP6Jb
	 yYg0PawzUg7xDwimp9qYAwLEiuqBlqRyRnwRATU+wHI0XEPC/KOaqmFNKCJbW9oLKm
	 i9u5o34C0Jor5ELo8brRdPhjcLyMA556/p0UFtVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/144] null_blk: Do not allow runt zone with zone capacity smaller then zone size
Date: Tue, 16 Jul 2024 17:32:26 +0200
Message-ID: <20240716152755.504967827@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit b164316808ec5de391c3e7b0148ec937d32d280d ]

A zoned device with a smaller last zone together with a zone capacity
smaller than the zone size does make any sense as that does not
correspond to any possible setup for a real device:
1) For ZNS and zoned UFS devices, all zones are always the same size.
2) For SMR HDDs, all zones always have the same capacity.
In other words, if we have a smaller last runt zone, then this zone
capacity should always be equal to the zone size.

Add a check in null_init_zoned_dev() to prevent a configuration to have
both a smaller zone size and a zone capacity smaller than the zone size.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240530054035.491497-2-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 0cdeafd9defcf..174d93a84137b 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -80,6 +80,17 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 		return -EINVAL;
 	}
 
+	/*
+	 * If a smaller zone capacity was requested, do not allow a smaller last
+	 * zone at the same time as such zone configuration does not correspond
+	 * to any real zoned device.
+	 */
+	if (dev->zone_capacity != dev->zone_size &&
+	    dev->size & (dev->zone_size - 1)) {
+		pr_err("A smaller last zone is not allowed with zone capacity smaller than zone size.\n");
+		return -EINVAL;
+	}
+
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-- 
2.43.0



