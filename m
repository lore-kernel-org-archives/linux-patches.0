Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8820C242D6E;
	Tue, 29 Apr 2025 17:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946718; cv=none; b=u1wVIEn1viLllr2HbLDxCMqO9Uy6xJjOrVl8Y7Kb4HNrEwy+usxl3CcmMFkpHwGttylH8rPte4fVvYpyOfYZAe2gY91hmk2ze200k6N9Nckmdi/16guVnBJcMejgR7FR1kFlAfwLmFbUoHOvmy31HQvUItwR0uqYV/bKTUUwT84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946718; c=relaxed/simple;
	bh=0/qIO4o7idbmJXwGO+QsZ+Zd0qPiAdvep2OEbVfIr2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCtrEYjyGoJwcyasOBamPo21gY2o80mNTTYmY7ptYHGKpKoORaDxg2QepwdaBUXq8F9aAqkzH9nCkdkPMuGOKGT+SZiVR13v/0AoKewoiP8a8AmreHiViL0JZOKGlrluGA9CzUR/CbkglnneJmKQK2Wkj/mqWzsubGdy5uGMMLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSyRf9EP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSyRf9EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11645C4CEE3;
	Tue, 29 Apr 2025 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946718;
	bh=0/qIO4o7idbmJXwGO+QsZ+Zd0qPiAdvep2OEbVfIr2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSyRf9EPx0UAAtvEmYAZigI0jo4HprgHuYLfjvOKsypCpZu3qgdLkaDrS7gdZrQML
	 xhJ5y31zCE84PsDoeO6Mm+UR+ihCUFN5+JzpPBuMuX9reJfSnU5SmtpAb/vxrkMCbw
	 b95rfEi/AiTylg3e1a3/ySSzzC0qsknQcqsCm3Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/286] pwm: rcar: Improve register calculation
Date: Tue, 29 Apr 2025 18:39:11 +0200
Message-ID: <20250429161109.795501395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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
index efe11e4e449e1..83da738954074 100644
--- a/drivers/pwm/pwm-rcar.c
+++ b/drivers/pwm/pwm-rcar.c
@@ -8,6 +8,7 @@
  * - The hardware cannot generate a 0% duty cycle.
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -103,23 +104,24 @@ static void rcar_pwm_set_clock_control(struct rcar_pwm_chip *rp,
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



