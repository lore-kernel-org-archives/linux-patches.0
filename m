Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB622D7806;
	Mon, 27 Oct 2025 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590388; cv=none; b=kQYYYCY61JDT1jtogkd4t4hgVco6h3dmv0ruGCg8Xdy5g9qYDDbq6mpx27b3BOQK1IbY/eCtIVlyos61VQa1cDtU7kjDq0K1mbfQWcKpPK3j+L/rX+CYjk82ZPt+weuggaHS6d3AGfy4D4uD7l7vxTJkxwuYQiNV4dhEfiSYVYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590388; c=relaxed/simple;
	bh=CDA1rKfSYCB48hFufW9nizl+UMU2DOuIZkvESUD3nto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omipyOSgIVAbaWH9mKVW5u/QoHJNBT+1iioDpWDxG4aExCItqpf/1j0eC30HZlrvgRGQQKIuP/5lkrzdps1nMI4g9IPk6bzsgoxFy2l6hrXbh3yts/8Vz7JfLZmhj13C2iJt5DwSxA9E3Mf9xbBmsH/XkkeNeuUO6prnL6sbeKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0S/O/e5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0S/O/e5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2AC4CEF1;
	Mon, 27 Oct 2025 18:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590388;
	bh=CDA1rKfSYCB48hFufW9nizl+UMU2DOuIZkvESUD3nto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0S/O/e5yfBNSaPb/qZMPE6+pDLRoMtEse1PQ87w5cflGZBzl6ilMJLFV6erGchKH7
	 oi4kgN52dbbSJxLpcuTCFyHeKEMIEIlNmxP/wRaaYJ3z7HnivXD31SO7vfXRZOK0jM
	 IfGU3fATjdvDbAPFnmeTumajxRoD42lUgiRKTJxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/224] pwm: tiehrpwm: Fix corner case in clock divisor calculation
Date: Mon, 27 Oct 2025 19:32:52 +0100
Message-ID: <20251027183509.706820008@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 00f83f0e07e44e2f1fb94b223e77ab7b18ee2d7d ]

The function set_prescale_div() is responsible for calculating the clock
divisor settings such that the input clock rate is divided down such that
the required period length is at most 0x10000 clock ticks. If period_cycles
is an integer multiple of 0x10000, the divisor period_cycles / 0x10000 is
good enough. So round up in the calculation of the required divisor and
compare it using >= instead of >.

Fixes: 19891b20e7c2 ("pwm: pwm-tiehrpwm: PWM driver support for EHRPWM")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/85488616d7bfcd9c32717651d0be7e330e761b9c.1754927682.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 7b4c770ce9d67..7414daef81a35 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -167,7 +167,7 @@ static int set_prescale_div(unsigned long rqst_prescaler, u16 *prescale_div,
 
 			*prescale_div = (1 << clkdiv) *
 					(hspclkdiv ? (hspclkdiv * 2) : 1);
-			if (*prescale_div > rqst_prescaler) {
+			if (*prescale_div >= rqst_prescaler) {
 				*tb_clk_div = (clkdiv << TBCTL_CLKDIV_SHIFT) |
 					(hspclkdiv << TBCTL_HSPCLKDIV_SHIFT);
 				return 0;
@@ -266,7 +266,7 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	pc->period_cycles[pwm->hwpwm] = period_cycles;
 
 	/* Configure clock prescaler to support Low frequency PWM wave */
-	if (set_prescale_div(period_cycles/PERIOD_MAX, &ps_divval,
+	if (set_prescale_div(DIV_ROUND_UP(period_cycles, PERIOD_MAX), &ps_divval,
 			     &tb_divval)) {
 		dev_err(chip->dev, "Unsupported values\n");
 		return -EINVAL;
-- 
2.51.0



