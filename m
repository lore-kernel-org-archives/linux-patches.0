Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A4C28CF4C;
	Wed, 23 Apr 2025 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420722; cv=none; b=rXn9ImzA2Tm5RSFzSeucryyolcWjSSuV9oSBUTZJ/Nkk5B+i2IgZXudIQm7171cz57A8Iq/Duo0IXC+hWzYG3D7sxmR6/JwfE1K0dvJzPE5JCzSE4jdiZnQx/j5sMgx27gkxAeikt1BTyXYepqsCxhcdn8gLepitYyDXBGN/Kxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420722; c=relaxed/simple;
	bh=mRxSEh+YJxUg52YMJPJoq4TDkM8IPJ1CoAWUQ8UwLFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvxKjkRulzUBCaFWmWUGz8KYD8B9+Qpz93y2UtrS2WksQBHhZCOB+Cn72PhIE+bdPYa8+dv0GCxKSNQKRWR6p3SSiGo23IOItrgCrwoXxYqm7FOzBLEiiy+NkbW2rmA2phOanb82aU2Mb7ut6JzoEKLDe38Yu0VqRFyHhY64omA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv4hVs+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv4hVs+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7658EC4CEE2;
	Wed, 23 Apr 2025 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420721;
	bh=mRxSEh+YJxUg52YMJPJoq4TDkM8IPJ1CoAWUQ8UwLFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv4hVs+TzmNPUPk+vH3gpHMeJbaKaGrqRk89LBqyDQhpGnxJG1aJ5we5XKV0DnLWD
	 K6OVrKITNYqll2MAznIh86KCSZUs5AZ7JYqFJj9f0n8jV7MW2Axa5yxql5t83u5p5Y
	 P/yYHtdXzCJcrs2RjQKZRxGbB8bBar0KOlVBS4as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/291] pwm: fsl-ftm: Handle clk_get_rate() returning 0
Date: Wed, 23 Apr 2025 16:41:04 +0200
Message-ID: <20250423142627.437888033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 928446a5302eee30ebb32075c0db5dda5a138fb7 ]

Considering that the driver doesn't enable the used clocks (and also
that clk_get_rate() returns 0 if CONFIG_HAVE_CLK is unset) better check
the return value of clk_get_rate() for being non-zero before dividing by
it.

Fixes: 3479bbd1e1f8 ("pwm: fsl-ftm: More relaxed permissions for updating period")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b68351a51017035651bc62ad3146afcb706874f0.1743501688.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-fsl-ftm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 0247757f9a72d..6751f3d005605 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -123,6 +123,9 @@ static unsigned int fsl_pwm_ticks_to_ns(struct fsl_pwm_chip *fpc,
 	unsigned long long exval;
 
 	rate = clk_get_rate(fpc->clk[fpc->period.clk_select]);
+	if (rate >> fpc->period.clk_ps == 0)
+		return 0;
+
 	exval = ticks;
 	exval *= 1000000000UL;
 	do_div(exval, rate >> fpc->period.clk_ps);
@@ -195,6 +198,9 @@ static unsigned int fsl_pwm_calculate_duty(struct fsl_pwm_chip *fpc,
 	unsigned int period = fpc->period.mod_period + 1;
 	unsigned int period_ns = fsl_pwm_ticks_to_ns(fpc, period);
 
+	if (!period_ns)
+		return 0;
+
 	duty = (unsigned long long)duty_ns * period;
 	do_div(duty, period_ns);
 
-- 
2.39.5



