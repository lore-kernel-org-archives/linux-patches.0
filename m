Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDF424728E;
	Mon, 23 Jun 2025 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686086; cv=none; b=TirFTxsFfKXzhYFZ0KT/32AOty2v7c7sHNPj2NYKHoo4iZGfluhR+4zXI5UWK9kJQlTAYceMImGp/YjgyJQphXjYwXa0FVCvQoQ8rQoNDyV9z2gPc1ZCSK6C5ZWaRn7WELpaZR6bM8TKJOc8sEKgPFaiP0nBJRUm5s3g6rFCOtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686086; c=relaxed/simple;
	bh=BMk99MlMjTrvBkk/Yv9RxOYHvhadQOQHD3htWtCr6oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=duxs1ZsXTWkHVTWp9GmqDyFIqi0Uh0wuk1rUHNHMeNpzEf/WfXz4edqiJpaR347kPK65BsSu27jw6YXjNVn4YfuDxrQni9/BaxRNJHEmH271CPh5RoMoSdvFBn5ugTU0Zk3DVHGXSyqgr1y6ayp5PU8Po77PDZfkXedJkI2o0JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AxKxfYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AxKxfYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512FAC4CEEA;
	Mon, 23 Jun 2025 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686086;
	bh=BMk99MlMjTrvBkk/Yv9RxOYHvhadQOQHD3htWtCr6oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AxKxfYcxpKLvme5bA+v9j1dVrmjD/GwX3W7Y6egKfawTD8u2XS+tC9BZIKZdmJFj
	 nSIXNnlIMLA/76mGxKcddUuaSUxjM0KtBbt6rH6RJ1CW7gUaAFAXxSV76dX3x3pIC1
	 R2FR/JeTqlgOS2C45IY1zimutg4wET2Nc7nsDzjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/355] rtc: Fix offset calculation for .start_secs < 0
Date: Mon, 23 Jun 2025 15:04:50 +0200
Message-ID: <20250623130629.478467508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Mergnat <amergnat@baylibre.com>

[ Upstream commit fe9f5f96cfe8b82d0f24cbfa93718925560f4f8d ]

The comparison

        rtc->start_secs > rtc->range_max

has a signed left-hand side and an unsigned right-hand side.
So the comparison might become true for negative start_secs which is
interpreted as a (possibly very large) positive value.

As a negative value can never be bigger than an unsigned value
the correct representation of the (mathematical) comparison

        rtc->start_secs > rtc->range_max

in C is:

        rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max

Use that to fix the offset calculation currently used in the
rtc-mt6397 driver.

Fixes: 989515647e783 ("rtc: Add one offset seconds to expand RTC range")
Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250428-enable-rtc-v4-2-2b2f7e3f9349@baylibre.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 625effe6cb65f..b1ce3bd724b2c 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -314,7 +314,7 @@ static void rtc_device_get_offset(struct rtc_device *rtc)
 	 *
 	 * Otherwise the offset seconds should be 0.
 	 */
-	if (rtc->start_secs > rtc->range_max ||
+	if ((rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max) ||
 	    rtc->start_secs + range_secs - 1 < rtc->range_min)
 		rtc->offset_secs = rtc->start_secs - rtc->range_min;
 	else if (rtc->start_secs > rtc->range_min)
-- 
2.39.5



