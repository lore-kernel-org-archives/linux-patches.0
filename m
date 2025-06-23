Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642724C7F;
	Mon, 23 Jun 2025 13:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685160; cv=none; b=hemSIFQQoB5pkFDtGCkRJbTQt+y3jkCSDxNJsIYqIx/ltU7/uUdeRZFCejFX/6XYRYc83/JFYL0Mud6vdXVMv79vtAv9epGR8MZsfa7x3YXBOXoJD8PEboYnEJjh6NevjFowh7SiJjECeku+u/ELUGkd/daTSCm6vdrh4KCIDlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685160; c=relaxed/simple;
	bh=YsEE0FMg8gsSt+YfiZ3uEhcLVVElAfXay1IbmE/RkbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S5Q9xvzwz1XF6g23/zygTev0juJuLEBnCD/f8GZ4AwMFCozaOm4WDQm5u+q2aPqU0StlrW6ENYpoNdnITALGPYL8yg8gJpLvitbqrcsarpzSKzT8cHQf5hKj8F67yOJVB5wYQwITSyekXi6oVeSzVqjjN7hFHrxFaSn+1fWTv7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ou7NiIwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ou7NiIwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9EBC4CEEA;
	Mon, 23 Jun 2025 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685160;
	bh=YsEE0FMg8gsSt+YfiZ3uEhcLVVElAfXay1IbmE/RkbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ou7NiIwinOm6VxT/e3peR0FNVjAvCEvEMkJ4nQeu0hMzj8KYrYMtnBL2be2Ys+m5U
	 XZYHCFj0hN/Vobp1cV3ORBJQ/bLq/6hR0jEJezsR1nv1Z9eZAmN7/rQssDc+lgtSpC
	 SKN00JtlGOCtpNA5EqE/ZRSB/D8p2ydmS9qLHU80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/222] rtc: Fix offset calculation for .start_secs < 0
Date: Mon, 23 Jun 2025 15:06:38 +0200
Message-ID: <20250623130614.006743391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8b434213bc7ad..87cb34acadde3 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -270,7 +270,7 @@ static void rtc_device_get_offset(struct rtc_device *rtc)
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



