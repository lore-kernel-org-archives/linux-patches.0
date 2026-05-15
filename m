Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D35C305671;
	Fri, 15 May 2026 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860650; cv=none; b=pmt2/P+QkfUv9vOrohXLrWv/k4SpZgyHbf4/jg+m8s+YWgRCSeBaLoYS43oIiy2tRA2KCLcVUrPsGR7doAGghDMVV+n8p1+rPTuna0JvhGlxWOWuBbQe6K6LmBUD5D7ZkuXuZLCysSabwv97O16QacQgEjJQJpehmFykfJ+C1ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860650; c=relaxed/simple;
	bh=BMiSeJFv5VB4OxbfJjHDWfAfWbU5NeB1iIy4W7hj5pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFaw+wMeD569E5QGXKXbpaYxHJDQf0YalfE2Nz5UsS2riQ5YvULgtjhoSsK18KLOwZNqKF8RwcvXwH+DAZBuooqCrZDYG29dauT+vNpCTG/DO1cLlDD1fA2P9zcAJbxlqm6QcFjU0h2N0RArMqcT/Ja0dqnhHIwSYcqhADNc7Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmaYwPvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmaYwPvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7535C2BCB0;
	Fri, 15 May 2026 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860650;
	bh=BMiSeJFv5VB4OxbfJjHDWfAfWbU5NeB1iIy4W7hj5pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmaYwPvxGyolIoZ3c2RoxoGjv+YiqcwlHXoeWKN5tqzjvoOrTRBBeIJ6ti7pLhhtq
	 gSGadgkP8ps5z9TYcsu96jSAUVdmEI6IzfkTg8WWEcaKf4UWIM+MfgcK2J8DDeuN17
	 OiIvlJRXvowcNdW+VF8T83kfvQYf4tJIodl5MIq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 009/474] leds: qcom-lpg: Check for array overflow when selecting the high resolution
Date: Fri, 15 May 2026 17:41:58 +0200
Message-ID: <20260515154715.257223194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1043,7 +1043,12 @@ static int lpg_pwm_get_state(struct pwm_
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


