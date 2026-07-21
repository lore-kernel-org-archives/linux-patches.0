Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D9924A078;
	Tue, 21 Jul 2026 21:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668838; cv=none; b=pX3NFqvK9F9yJmK+Ghso+sE0WM7hP2sOev9GDrvTIBFtx9VJ8U4goSmDKp7eVUY3Ebgo9IBlFD3zZ3fbQLsfShF3eSSKt8sh0g42ik24guGULOOpTuQ+zQGKkSDuPuRLFYIIzdqntcg4UDiqUm2FuxOx/ufJlFSt10jlIIcIaHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668838; c=relaxed/simple;
	bh=2uqwCMLqj230L0m37I/JRYSd+4EUBNKxtKS+5EfKYAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NlaBcLTF9UM5SQ53nVzXbF/l+n6M0oK3bkjlwBwenPjUhYgIYaUsb7PbTcZOKJvzdRuR4OGazAsA9tTAqBBYZ+hbLUf5ZuJz93Cy4ZbuHh3nFPQjl4/QVCGVFxgM0e5W0K9AjeWSuWJFJPCdczmfn97pFVIqbTc+nPoNq8jCd/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUQ+jiuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUQ+jiuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C9E1F00A3A;
	Tue, 21 Jul 2026 21:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668837;
	bh=DhBGX/8Kf4ezsj8+xm9P9ixdbFImaUuaqwtCjspKlOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUQ+jiujM9dT4asAdJ4Q11Cih1h9f70dW40rnNeC/hODsgV57/4n8ieoMVicWDG+T
	 J7rAsgoKJKI5b9e8I7YdHWmlncRF4B30RoTJBbjrcnH0Aq35aFw5O3tqyKaU/SzSkJ
	 C6l/TkHR4IHTsL/miANtyb3MWiRgDyybPiFN4XHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronaldo Nunez <rnunez@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0325/1067] pwm: imx27: Fix variable truncation in .apply()
Date: Tue, 21 Jul 2026 17:15:26 +0200
Message-ID: <20260721152431.861747178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronaldo Nunez <rnunez@baylibre.com>

[ Upstream commit dc9e08fdbcc3eb08a1d2b868b535081c44425e27 ]

Fix a variable truncation when calculating period in microseconds as
part of the solution for the ERR051198 in .apply() callback.

Example scenario:
 - Period of 3us (PWMPR = 196 and prescaler = 1)
 - Expected value in tmp: 198000000000 (NSEC_PER_SEC * (196 + 2) * 1)
 - Actual value is 431504384 (truncation to u32)

Signed-off-by: Ronaldo Nunez <rnunez@baylibre.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260522191348.6227-1-rnunez@baylibre.com
Fixes: a25351e4c774 ("pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx27.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-imx27.c b/drivers/pwm/pwm-imx27.c
index 0cd42ae5c0a4c9..dfbc99227e8970 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -218,7 +218,7 @@ static void pwm_imx27_wait_fifo_slot(struct pwm_chip *chip,
 static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			   const struct pwm_state *state)
 {
-	unsigned long period_cycles, duty_cycles, prescale, period_us, tmp;
+	unsigned long period_cycles, duty_cycles, prescale, period_us;
 	struct pwm_imx27_chip *imx = to_pwm_imx27_chip(chip);
 	struct pwm_state cstate;
 	unsigned long long c;
@@ -227,6 +227,7 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	int val;
 	int ret;
 	u32 cr;
+	u64 tmp;
 
 	pwm_get_state(pwm, &cstate);
 
@@ -270,6 +271,11 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	val = readl(imx->mmio_base + MX3_PWMPR);
 	val = val >= MX3_PWMPR_MAX ? MX3_PWMPR_MAX : val;
 	cr = readl(imx->mmio_base + MX3_PWMCR);
+
+	/*
+	 * tmp stores period in nanoseconds. Result fits in u64 since
+	 * val <= 0xfffe and prescaler in [1, 0x1000].
+	 */
 	tmp = NSEC_PER_SEC * (u64)(val + 2) * MX3_PWMCR_PRESCALER_GET(cr);
 	tmp = DIV_ROUND_UP_ULL(tmp, clkrate);
 	period_us = DIV_ROUND_UP_ULL(tmp, 1000);
-- 
2.53.0



