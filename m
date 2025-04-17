Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C89E1EB1BF;
	Thu, 17 Apr 2025 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912986; cv=none; b=n3iU4hIOVjg5pJeoYzArPXIhvAMfSUHAWKCNgrF2p6NPGYd+yKbDweYebitxh+huPrOTblMl/MKV0uSpUXwPYZK+TWFOAO/GjQZDTwWdKUu9y9/+tZlFL4W2uCGX48bVhUAyd9KzNO83G6htMc4miAwS0BEEdZk2o0eyBDjCm2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912986; c=relaxed/simple;
	bh=/TMRHWQ+1BzJyqMY6iVmyUsmo805aBY97RErLlZC/Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbDfCddO52s2P9YwxhWjW+kDqoWtj22z17f8CZ3WI94WvUTkwi11FJbjt7FMMrF4Ro2KnXsCRCTck/vyo/xurtnRp4T6/SfZghaqpMV9WVBkfNbbWIk8mqWCYWKvxFRNPihuc696bVZTQw7qYmUEFn6an+20rmXhIDvSSmuw38E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC6ffOQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC6ffOQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69F2C4CEE4;
	Thu, 17 Apr 2025 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912986;
	bh=/TMRHWQ+1BzJyqMY6iVmyUsmo805aBY97RErLlZC/Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DC6ffOQswRKGkuWsepiM2nHFMlvdPZ5OGJUNSZCprk4wBehRHTUSgUEMjYfy2ERby
	 dYIYHFAxZM8LlQNXJW70HF5fQUCX1YY3IlArztCbboXFv6KeHK7/XFTwgMyS9Wt3FF
	 i1B1o33YUfoydgIglIbA2QOEf+q+7RtF2DGPCe9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 189/449] pwm: rcar: Improve register calculation
Date: Thu, 17 Apr 2025 19:47:57 +0200
Message-ID: <20250417175125.580206828@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit e7327c193014a4d8666e9c1cda09cf2c060518e8 ]

There were several issues in the function rcar_pwm_set_counter():

 - The u64 values period_ns and duty_ns were cast to int on function
   call which might loose bits on 32 bit architectures.
   Fix: Make parameters to rcar_pwm_set_counter() u64
 - The algorithm divided by the result of a division which looses
   precision.
   Fix: Make use of mul_u64_u64_div_u64()
 - The calculated values were just masked to fit the respective register
   fields which again might loose bits.
   Fix: Explicitly check for overlow

Implement the respective fixes.

A side effect of fixing the 2nd issue is that there is no division by 0
if clk_get_rate() returns 0.

Fixes: ed6c1476bf7f ("pwm: Add support for R-Car PWM Timer")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/ab3dac794b2216cc1cc56d65c93dd164f8bd461b.1743501688.git.u.kleine-koenig@baylibre.com
[ukleinek: Added an explicit #include <linux/bitfield.h> to please the
0day build bot]
Link: https://lore.kernel.org/oe-kbuild-all/202504031354.VJtxScP5-lkp@intel.com/
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-rcar.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-rcar.c b/drivers/pwm/pwm-rcar.c
index 2261789cc27da..578dbdd2d5a72 100644
--- a/drivers/pwm/pwm-rcar.c
+++ b/drivers/pwm/pwm-rcar.c
@@ -8,6 +8,7 @@
  * - The hardware cannot generate a 0% duty cycle.
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -102,23 +103,24 @@ static void rcar_pwm_set_clock_control(struct rcar_pwm_chip *rp,
 	rcar_pwm_write(rp, value, RCAR_PWMCR);
 }
 
-static int rcar_pwm_set_counter(struct rcar_pwm_chip *rp, int div, int duty_ns,
-				int period_ns)
+static int rcar_pwm_set_counter(struct rcar_pwm_chip *rp, int div, u64 duty_ns,
+				u64 period_ns)
 {
-	unsigned long long one_cycle, tmp;	/* 0.01 nanoseconds */
+	unsigned long long tmp;
 	unsigned long clk_rate = clk_get_rate(rp->clk);
 	u32 cyc, ph;
 
-	one_cycle = NSEC_PER_SEC * 100ULL << div;
-	do_div(one_cycle, clk_rate);
+	/* div <= 24 == RCAR_PWM_MAX_DIVISION, so the shift doesn't overflow. */
+	tmp = mul_u64_u64_div_u64(period_ns, clk_rate, (u64)NSEC_PER_SEC << div);
+	if (tmp > FIELD_MAX(RCAR_PWMCNT_CYC0_MASK))
+		tmp = FIELD_MAX(RCAR_PWMCNT_CYC0_MASK);
 
-	tmp = period_ns * 100ULL;
-	do_div(tmp, one_cycle);
-	cyc = (tmp << RCAR_PWMCNT_CYC0_SHIFT) & RCAR_PWMCNT_CYC0_MASK;
+	cyc = FIELD_PREP(RCAR_PWMCNT_CYC0_MASK, tmp);
 
-	tmp = duty_ns * 100ULL;
-	do_div(tmp, one_cycle);
-	ph = tmp & RCAR_PWMCNT_PH0_MASK;
+	tmp = mul_u64_u64_div_u64(duty_ns, clk_rate, (u64)NSEC_PER_SEC << div);
+	if (tmp > FIELD_MAX(RCAR_PWMCNT_PH0_MASK))
+		tmp = FIELD_MAX(RCAR_PWMCNT_PH0_MASK);
+	ph = FIELD_PREP(RCAR_PWMCNT_PH0_MASK, tmp);
 
 	/* Avoid prohibited setting */
 	if (cyc == 0 || ph == 0)
-- 
2.39.5



