Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62E516F8FA;
	Wed,  3 Jul 2024 11:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005550; cv=none; b=NiVV1h9tTUQR8IrsP7RU9uRTaLDHJZep1PpbRSZHAUso7OjhpV0wVGG//nkAmCIUp03GQNkJVhnB2f3J7zsEWnWLn+TpTg2jcChHY90zz+DiKKplR1vdAGYtp10hNTI4qzQykA9ZrL0rwAeO5e/bh+8XyHYWXM47pbjuNN+IFw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005550; c=relaxed/simple;
	bh=ti97h0r82jkfQbkCd7FMju780F/kaUEXNnco1kejixE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3CZHYo5w98XWJUagTA0qxwycOSoLhAzFCDvljNBDOvYYKWbxhg8IFJ0krva9tY+JmAqk4VEEoIlGKZhI83qiUM94M22rA0WbcwJkRVRtVcyMJRmR6REBkSzSGjkpHo9h832BDLkoU9/GayReYwy53omXVwx7EnYxS4RTXHI6bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNiKWQiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNiKWQiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDB4C2BD10;
	Wed,  3 Jul 2024 11:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005550;
	bh=ti97h0r82jkfQbkCd7FMju780F/kaUEXNnco1kejixE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNiKWQiEqSAtB2gYYQyswxhY8iYmHjmStHm3wL8W79Kdle1BYGOyTwDOvmaTeY4Fw
	 S1W5XFq6eW2vnWkBKG90P6pY7Xa2OfJ3NlFwOAjUFynGeJJDORUnNuAQxYW91WMaFk
	 YOpwiIF9TaKNrgVJ2ieBhQgca8jv+lFr2SiDHk04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 119/356] null_blk: Print correct max open zones limit in null_init_zoned_dev()
Date: Wed,  3 Jul 2024 12:37:35 +0200
Message-ID: <20240703102917.597374143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
@@ -109,7 +109,7 @@ int null_init_zoned_dev(struct nullb_dev
 	if (dev->zone_max_active && dev->zone_max_open > dev->zone_max_active) {
 		dev->zone_max_open = dev->zone_max_active;
 		pr_info("changed the maximum number of open zones to %u\n",
-			dev->nr_zones);
+			dev->zone_max_open);
 	} else if (dev->zone_max_open >= dev->nr_zones - dev->zone_nr_conv) {
 		dev->zone_max_open = 0;
 		pr_info("zone_max_open limit disabled, limit >= zone count\n");


