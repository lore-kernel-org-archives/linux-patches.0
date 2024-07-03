Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B3F194A6F;
	Wed,  3 Jul 2024 10:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004363; cv=none; b=Rk5ePIjaYrjKa7kKb3/e8TaYSZpLHQTnqRLa0fpY2rjRPOrplVIKvyBEsPxpUKeBClkFtdDe52I+BJRn3ZSTXD3q7mshu3cUnTv5iAWBsC+SMm4lp2Jp+tjrXRgXHAtc+HP4ZRWIqUu+/YRpBGObWJcIpH6F9NQjp4i6VlcJyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004363; c=relaxed/simple;
	bh=V+GCiI3ruv5jDLpgP1KU6n6l8Zp37ki/bDmzhaXmqf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfMIb+2KInZyU33VDJniMN374eaqsHbIGyJnN3CFJ3oRvlYVaaAJ9cYgjp0z9mQwq2C9PoC2p5wylGcNwxS9wo8eYbz02IJqWDsz5NpFAYdAvWJp3LK7ejeq63WLL7NiuNDyGDxi0VQu0RaIyUUHEyfUYswWd+a0y0a/TSQDcno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2oobXQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2oobXQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F79C32781;
	Wed,  3 Jul 2024 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004363;
	bh=V+GCiI3ruv5jDLpgP1KU6n6l8Zp37ki/bDmzhaXmqf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2oobXQRab2I2i9fXrlc9EJ4fUb4cMJmH2mQN6xmVlRw8JVZrnAMi6c8oDJfl3mv7
	 wcc93qv1+Tw/AV9qVLurBbhGOpROr2OlRL88zB8aPXv6YFYzr2zaOjibtnlqj7VpJN
	 Y+q1e3+yqbxfhxJDsGkhc56Q0VJYKY2ES8BfOjq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 002/290] null_blk: Print correct max open zones limit in null_init_zoned_dev()
Date: Wed,  3 Jul 2024 12:36:23 +0200
Message-ID: <20240703102904.268750625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 233e27b4d21c3e44eb863f03e566d3a22e81a7ae upstream.

When changing the maximum number of open zones, print that number
instead of the total number of zones.

Fixes: dc4d137ee3b7 ("null_blk: add support for max open/active zone limit for zoned devices")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20240528062852.437599-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -81,7 +81,7 @@ int null_init_zoned_dev(struct nullb_dev
 	if (dev->zone_max_active && dev->zone_max_open > dev->zone_max_active) {
 		dev->zone_max_open = dev->zone_max_active;
 		pr_info("changed the maximum number of open zones to %u\n",
-			dev->nr_zones);
+			dev->zone_max_open);
 	} else if (dev->zone_max_open >= dev->nr_zones - dev->zone_nr_conv) {
 		dev->zone_max_open = 0;
 		pr_info("zone_max_open limit disabled, limit >= zone count\n");


