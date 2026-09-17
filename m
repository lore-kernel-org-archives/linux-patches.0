Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86093A6B66;
	Thu, 17 Sep 2026 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658714; cv=none; b=krmagV/QRGy/P/H8blTd5rD6zg17r8zCe7DmSEpoWXVgP2dkGd+j9zgPU7yN+RQexo4F+l8kKlLFaR2iFGHLuwwmhodzx3yoTLrtvhSjYf6MLOlQpGZuHn5nUEPyEBwb9uMyNKfTqJKCmnt5yqo1Fi89/fYrkXAegFhJl3NBYHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658714; c=relaxed/simple;
	bh=bIINg8THVd426YSZi5FAgHULUkOANLIG1EOjwoR3T60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZcrYpNJwh8+H8TI1xjIECzHvtpzeFsUXN5fpNpQqJDqwnWpL6YWIrSwkEiQS9jqHs1q3oS/OFtqIjwmKfeabXFIhjCfMiuHnPJAADzRNMYHf0phUde7UuBCJ/hHEtShMftXhbKgBmzsxdXtzcnv7YEWhRxaX0wOzu6wmkX8pf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trnBf4t2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trnBf4t2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DE21F000FF;
	Thu, 17 Sep 2026 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658704;
	bh=aT+nWSZHoVfRu+kFQCmEv3J9ZUx/o/yiagrawl3KCTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trnBf4t2yAN3mGOb4kpRdevP8O1IiDHs05I/CzKell9s6/GbAfdFD+n+lDCuv75Je
	 eyZwMNpo0xk1/J13+4nPcnjehKA/+raLjx9ntcDrnjOzq/AP6lsDXgXyS1JbzMqGZX
	 msQE11YQtnbny0kWaIMxCyz0phhniE+WTX2HAyrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 004/733] leds: st1202: Validate pattern input before stopping the sequence
Date: Thu, 17 Sep 2026 16:05:12 +0100
Message-ID: <20260917151350.730727438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit fd2529ba8fb44cd4b56f1069363b949644b42cec ]

Input validation for pattern duration is performed inside the write
loop, after the pattern sequence has already been stopped. If
validation fails mid-loop the chip is left with the sequence stopped
and partially written pattern data, with no recovery.

Move all input validation before the mutex and before any hardware
interaction, so an invalid input leaves the chip state unchanged.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB84975929B6ED7CDFBCEB7D76C5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 2593ff39f22a6..168df5ecf27b7 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -237,6 +237,12 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (len > ST1202_MAX_PATTERNS)
 		return -EINVAL;
 
+	for (int patt = 0; patt < len; patt++) {
+		if (pattern[patt].delta_t < ST1202_MILLIS_PATTERN_DUR_MIN ||
+				pattern[patt].delta_t > ST1202_MILLIS_PATTERN_DUR_MAX)
+			return -EINVAL;
+	}
+
 	guard(mutex)(&chip->lock);
 
 	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
@@ -244,10 +250,6 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 		return ret;
 
 	for (int patt = 0; patt < len; patt++) {
-		if (pattern[patt].delta_t < ST1202_MILLIS_PATTERN_DUR_MIN ||
-				pattern[patt].delta_t > ST1202_MILLIS_PATTERN_DUR_MAX)
-			return -EINVAL;
-
 		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, pattern[patt].brightness);
 		if (ret != 0)
 			return ret;
-- 
2.53.0



