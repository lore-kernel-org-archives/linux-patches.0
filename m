Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3826022A81D;
	Tue, 29 Apr 2025 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946721; cv=none; b=AsmHHRJvFnIFJGXAwGlzgmMxMjxVvaOU29S6T2X1pnk46WbO4PGZW6dE46KyJHlRkxnK8JPZa9h34H01KhdfYU4e+Y4hjuxitzn8rVKQhR8cfQ6dmjjN1tYaRjPCMzrvICVP0TZn/VDC+2UGYS0lMdeUhX4wQTj9DeEOpmnIb6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946721; c=relaxed/simple;
	bh=6iaZK6PKhuIME2g7IbnTRrvVobiA9KpXmfWCPEUpzuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvnySq9aiB7HjD9480ESa1dTwT0WozHPfdbEpKFYQuQ+024Y+Kyz2exDuAtuRxP++cgpLX9RLYYxPTlMtnnyuTTy+SAmHC3xBsbwblg9XAsaxRhmYQg6mlvl14MPJKkj+fHB/tNyzmB6puOp5RtLOEdijrgUX7cfhtDQ/aK/jbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HK8xVbHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HK8xVbHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4A9C4CEE9;
	Tue, 29 Apr 2025 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946721;
	bh=6iaZK6PKhuIME2g7IbnTRrvVobiA9KpXmfWCPEUpzuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HK8xVbHG8d01jIzYTqn1CfsIP4LiDceEFBo93WuupXvzkWlrgVklrerhEIi+nXDNa
	 o5PrT7EmWSHxDvOMpL6FyAEQie0hjNASnlaJIBYlQ8DsBmbtJm06x2qqu9aYa58pJ6
	 iDnwnj5w0DAXXouxiwGxFE44fnyr+zAVUIJYBuAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/286] pwm: fsl-ftm: Handle clk_get_rate() returning 0
Date: Tue, 29 Apr 2025 18:39:12 +0200
Message-ID: <20250429161109.834829475@linuxfoundation.org>
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
index 59272a9204793..8221f286f5828 100644
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



