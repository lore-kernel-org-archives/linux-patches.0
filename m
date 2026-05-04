Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A486E3DEAC2;
	Mon,  4 May 2026 14:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904362; cv=none; b=BXG6lkBwngQPTF/h4bjb9vZTj32X59dN4ho4slcWgGMGJn1ah/Q0L7bszziunD29dd/DDeICuUwmpoky+zESqlThMykO0elxQTLMGP4mL5XFrN4npyO9Rzwtj2EjcTZTAdqy7mxfmp1nI2BuWApmvRvGzlh2Aq1liJwfGZVvQ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904362; c=relaxed/simple;
	bh=gooxO4olCA/Sey7cZXxadEKRmOfnfjQ6++KE/4mbnqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAljjC4wtHEpQ0RDwNBNAU3FuQDl0KN2fIsA6+GNCtTkhBX4u2RDf/l5u5XUdnPtdcLoAV4sBkMYWJtD/ApGUJrsPK6t0MgLnS7PUEzrucHM5cVktZjn+olbcRcKSyoUk8rgIgeV2lE64hiLKeYM5SLn9mf1Ylhj99OxGHnQl/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGgomd2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGgomd2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A553C2BCB8;
	Mon,  4 May 2026 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904362;
	bh=gooxO4olCA/Sey7cZXxadEKRmOfnfjQ6++KE/4mbnqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGgomd2PKpWRlhAPqW9JOSyhlcA19DFs1XnJsALCLJHxnNGo3KStjuhTsRi/UjKGZ
	 U5iuiRGP/of5do+tv1y0Wl4BFnUEEZhDUiqvlNYEa/XKsVlX+uRtx552sL0elfxFl3
	 vNY5paR4V/IMb+xUW5zhVX4IfePmVlmR8+VrTvSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 010/215] leds: qcom-lpg: Check for array overflow when selecting the high resolution
Date: Mon,  4 May 2026 15:50:29 +0200
Message-ID: <20260504135130.551890621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d45963a93c1495e9f1338fde91d0ebba8fd22474 upstream.

When selecting the high resolution values from the array, FIELD_GET() is
used to pull from a 3 bit register, yet the array being indexed has only
5 values in it.  Odds are the hardware is sane, but just to be safe,
properly check before just overflowing and reading random data and then
setting up chip values based on that.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026021934-nearby-playroom-036b@gregkh
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -1272,7 +1272,12 @@ static int lpg_pwm_get_state(struct pwm_
 		return ret;
 
 	if (chan->subtype == LPG_SUBTYPE_HI_RES_PWM) {
-		refclk = lpg_clk_rates_hi_res[FIELD_GET(PWM_CLK_SELECT_HI_RES_MASK, val)];
+		unsigned int clk_idx = FIELD_GET(PWM_CLK_SELECT_HI_RES_MASK, val);
+
+		if (clk_idx >= ARRAY_SIZE(lpg_clk_rates_hi_res))
+			return -EINVAL;
+
+		refclk = lpg_clk_rates_hi_res[clk_idx];
 		resolution = lpg_pwm_resolution_hi_res[FIELD_GET(PWM_SIZE_HI_RES_MASK, val)];
 	} else {
 		refclk = lpg_clk_rates[FIELD_GET(PWM_CLK_SELECT_MASK, val)];


