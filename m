Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792653AA4F8;
	Mon,  4 May 2026 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903652; cv=none; b=dlpGDZ/b6KnU1dHFIi8+aGQbiZgWwV6Y4EwjqB2EA8144zeiOq56C9x1MhvLmNj79UuB+VQXD2KOVXpLyqFLkHeAQtiRrx4X3sI/tpIIVN7i8cipu0nuGYj0RxFREvJT4GYquSVT9Ndx8vRC3XDjOmWmLOfV07iEl8omMrbwMpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903652; c=relaxed/simple;
	bh=IGSlpFj4xux29AlfKgI4iykZgOPNudyWV/DlpMnj9NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bkk60wCZF8jvWDDXUd7KFENrtRKvSwMgM67tcV4uTfEdVqNCoPo3SZBlOqgoeShZmLRBklTrwrQSp/UUZzb6ipQHSyQc595ai3S4itvPFriSYSMuR8/iit+Szk3X2y00i0ZoL1Vdu2FDFIKqskgul3DOywJj962QyT7dfsgpYEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiLi5Ums; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiLi5Ums"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC88C2BCC4;
	Mon,  4 May 2026 14:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903652;
	bh=IGSlpFj4xux29AlfKgI4iykZgOPNudyWV/DlpMnj9NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiLi5Ums9rHh9k6jCS0FvyZD01hycr28AU4k3ixWcR7kQKdPOMvBqbZs4tXZWQeS2
	 lwhlqH/a9D5yuq4OBYJQJXVCKe0jSQouVeaQCfwiAuyRYJ5hjcGnkw24yp48JAvzlI
	 PpxLvZl4sM9zs/zmD7Xo9Fy+nELD/KZohZii67h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 010/275] leds: qcom-lpg: Check for array overflow when selecting the high resolution
Date: Mon,  4 May 2026 15:49:10 +0200
Message-ID: <20260504135143.322514404@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1273,7 +1273,12 @@ static int lpg_pwm_get_state(struct pwm_
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


