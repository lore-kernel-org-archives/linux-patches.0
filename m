Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35F618D65E;
	Thu,  5 Sep 2024 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530331; cv=none; b=qJISIMEbNQ+01FUXb0ZQ+zvFdR2elOZhXs7bmBs8MQ2RKy2jc1lS/Eo5nJ0wHKvP4Re0unR9RazGcQa4GOT9O6VXqTwo1RlQqkCLkkjp16cGMxFfLQnYHqP+XlTyQPaeAay/n/5M2KN9op8ZTcsbqk7I4xQYyVe82LUUBbyujO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530331; c=relaxed/simple;
	bh=PgrxyXO/kKYVvfwtWgr+tZ74L+aa8aRKNfi5R6KAxO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=botWjqZiD6iRmQiXykLsuCgTbb5zEvX+zYzpXBQ3zu1WzgOBkWY6iYIYGEPM144MiuLAlZpOS7BG2k7ebOMbxBXJXCDAyBnoBl64ORzh93xX50U5WoLKTqoDwjkQbpPupKbGgJOtO1xJgvfF03BdmXJb3/mdNAdfvyOag5KP6dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Auq/lgW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Auq/lgW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B35C4CEC3;
	Thu,  5 Sep 2024 09:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530330;
	bh=PgrxyXO/kKYVvfwtWgr+tZ74L+aa8aRKNfi5R6KAxO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Auq/lgW3RW4u8D1w1nw43p1Yxt/87fXSL2b5IQcdMjxija451nibW+I4Lm2opDUvM
	 2ze0Y2NNgzorMniIZovYKokDwGNLDpq9qxR8GOEDkAbGFYa1Q/Dlov/aD1tDYpUhvL
	 oSJHTEEooQCClS/yjWvGp+YMgWv697b5SMvy8i2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Sloat <ksloat@designlinxhs.com>,
	Michal Simek <michal.simek@amd.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/132] pwm: xilinx: Fix u32 overflow issue in 32-bit width PWM mode.
Date: Thu,  5 Sep 2024 11:41:24 +0200
Message-ID: <20240905093726.016144304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



