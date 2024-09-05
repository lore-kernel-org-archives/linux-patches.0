Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10B619884A;
	Thu,  5 Sep 2024 09:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529847; cv=none; b=fhKqn99npA1121RFmXLTBg5I77Ov5in+SOwNBw3eoJHK+0jMOkwSHxUpFuKbfL6DQ3BgcZxwf2VfnYw8yYk5QZGAtJWoAZtiyFuqwp4B2Ii6VoalLdA5a9VwY+Y7d13VowgzTL8my5gud+6sBoGjRksMkvviFy24eENgy2rWcYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529847; c=relaxed/simple;
	bh=R0IQkmkCVvFvoR9LupYLtcopnM/VzfkMdirfnVSHYzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdNqDfKe4I+AwLBA5z0Nj/G0lBWHIPCgnKYtZrrIkrAsklKkx1reP7Lr8inWLDAXr25kBEkSu1cKbGonC2vDuAEsegmP/l6TB3Y8I2rjl75QH9TSSMTbnwGgU4sMxbCEc44sRMQlrAaw7GufoegIZD/Q743UH2TXJDyOqOX13s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2F/KkGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2F/KkGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8FFC4CEC3;
	Thu,  5 Sep 2024 09:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529847;
	bh=R0IQkmkCVvFvoR9LupYLtcopnM/VzfkMdirfnVSHYzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2F/KkGiTwZqwWxQnwBMkn3wEZv+yKihNVYehC1sBKSh7bUXY7yMkS1upS7UUjQon
	 eVs9lNZ0tvsU9HI7UVt0FiiEog2Mp9nnNhkSWyLxc9z/yhRboAtpGgKxDUz2254JJ2
	 HwSxHs1Sm7bTByfg3q23tkjT5oRGSfkUpMVGtCpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Sloat <ksloat@designlinxhs.com>,
	Michal Simek <michal.simek@amd.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 130/184] pwm: xilinx: Fix u32 overflow issue in 32-bit width PWM mode.
Date: Thu,  5 Sep 2024 11:40:43 +0200
Message-ID: <20240905093737.301186949@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



