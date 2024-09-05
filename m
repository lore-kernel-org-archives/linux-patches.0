Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCBC1494DB;
	Thu,  5 Sep 2024 10:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530596; cv=none; b=KDmFItjp98lqd4pGNUx517oJlA/RDWMkgYDrmMTs5cQzBzDow2YlBjENsUo+fCllyLCy+u0BalCX+z/0tPtJPDx68e0qaOd10eA9WX+GLaInG69U75QoBXRQLGhgwxNvNEw3Z8Zn5HQh3Gy2XWla/rS45BvlBMtiOL34dlpLwV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530596; c=relaxed/simple;
	bh=TTW8Y7GOcMkg20RXwovJhN6v0CqKlDOYYVTSan7hxyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=be5FOJXwI2AUtBsXL/nZpuVSN9cPOO1Ycbs1Z8tk1GPxmpMpLrn86mWp4xuvJ4B4Vi3T75VSLHLemrlEy3mm2DgtqGhM5dneefoaEh5T8ckooQTh6oi3L3K8bp+ZQHW/vcMkpSmnJN8MmyfHeHKgYQAgqfzMfnkS8Iul2UGoz+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV6eVjFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV6eVjFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C70C4CEC3;
	Thu,  5 Sep 2024 10:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530596;
	bh=TTW8Y7GOcMkg20RXwovJhN6v0CqKlDOYYVTSan7hxyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV6eVjFT6TuOxUFC5kwK1y7cPzcUIyG0HATOOjjl1N9wUCoPNB8uc+DiZH/3ic/7y
	 SHH26fFk+ZbOTUvg+RbON8PNULJ4qIFVX/nApI6FMHniPZcoFH4LiEhYQvUFGmPmxJ
	 j3LfWbfIX059DTaHJ64bLvV+rThru9BySpChdFl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Sloat <ksloat@designlinxhs.com>,
	Michal Simek <michal.simek@amd.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/101] pwm: xilinx: Fix u32 overflow issue in 32-bit width PWM mode.
Date: Thu,  5 Sep 2024 11:41:46 +0200
Message-ID: <20240905093719.027782921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Sloat <ksloat@designlinxhs.com>

[ Upstream commit 56f45266df67aa0f5b2a6881c8c4d16dbfff6b7d ]

This timer HW supports 8, 16 and 32-bit timer widths. This
driver currently uses a u32 to store the max possible value
of the timer. However, statements perform addition of 2 in
xilinx_pwm_apply() when calculating the period_cycles and
duty_cycles values. Since priv->max is a u32, this will
result in an overflow to 1 which will not only be incorrect
but fail on range comparison. This results in making it
impossible to set the PWM in this timer mode.

There are two obvious solutions to the current problem:
1. Cast each instance where overflow occurs to u64.
2. Change priv->max from a u32 to a u64.

Solution #1 requires more code modifications, and leaves
opportunity to introduce similar overflows if other math
statements are added in the future. These may also go
undetected if running in non 32-bit timer modes.

Solution #2 is the much smaller and cleaner approach and
thus the chosen method in this patch.

This was tested on a Zynq UltraScale+ with multiple
instances of the PWM IP.

Signed-off-by: Ken Sloat <ksloat@designlinxhs.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/SJ0P222MB0107490C5371B848EF04351CA1E19@SJ0P222MB0107.NAMP222.PROD.OUTLOOK.COM
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/clocksource/timer-xilinx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/clocksource/timer-xilinx.h b/include/clocksource/timer-xilinx.h
index c0f56fe6d22a..d116f18de899 100644
--- a/include/clocksource/timer-xilinx.h
+++ b/include/clocksource/timer-xilinx.h
@@ -41,7 +41,7 @@ struct regmap;
 struct xilinx_timer_priv {
 	struct regmap *map;
 	struct clk *clk;
-	u32 max;
+	u64 max;
 };
 
 /**
-- 
2.43.0



