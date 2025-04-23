Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A8281522;
	Wed, 23 Apr 2025 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420832; cv=none; b=Zzf2QhgHX2ybg0c/fQ0ik0j/+citI2eCtUJTtHP0KdjwyDEJSbmcyhnKHFEDim2cbr7BOnq9r6U8oT0YCM1jr7HCAnjzAaoNeL5t+nAMKpwFqRS97rwthC+6Y3TcfCe9WxfRlhEPeAA0sdozsmA//IiPRot+/gCx9in9uhEnM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420832; c=relaxed/simple;
	bh=LDJSTXnTAYB8LOsWyEzYLZJcd8+aMBjq9YoMp4GuQow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7KoV/RrsGPs/r4aVBG5Bcp0WOCnjCu1U2tyc7kpNnyQTreDPzqJhoONSDttMVDEsWivyLV0badMuYae0zI4gni44TJcQHTGoy8EZtTqzC7rpV+5wN/O7JRr5HF3y00q81l+ksVG9sx4Wov7cS7nuYDddK8bUqnIr8aTRcOdWhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpl2aluB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpl2aluB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F86C4CEE3;
	Wed, 23 Apr 2025 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420832;
	bh=LDJSTXnTAYB8LOsWyEzYLZJcd8+aMBjq9YoMp4GuQow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpl2aluBuoZQs9QdwO80Mn7ryUitHRCZPF1fuhv4kubnoPHPMrDKrnvQI5O7lBznk
	 g4aGQ30Gif3e/KsIHZuqfcr3px9CtfltAbz1IHkdVmCBzTxyzAmDFhcZDw3J27TMqL
	 ljaI84M+IfyRJilNPQAOODUEtxjo8pdrh2ykOLV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/393] pwm: fsl-ftm: Handle clk_get_rate() returning 0
Date: Wed, 23 Apr 2025 16:40:12 +0200
Message-ID: <20250423142648.151917932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7c6045c5d089..2c60d67e9a4a4 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -119,6 +119,9 @@ static unsigned int fsl_pwm_ticks_to_ns(struct fsl_pwm_chip *fpc,
 	unsigned long long exval;
 
 	rate = clk_get_rate(fpc->clk[fpc->period.clk_select]);
+	if (rate >> fpc->period.clk_ps == 0)
+		return 0;
+
 	exval = ticks;
 	exval *= 1000000000UL;
 	do_div(exval, rate >> fpc->period.clk_ps);
@@ -191,6 +194,9 @@ static unsigned int fsl_pwm_calculate_duty(struct fsl_pwm_chip *fpc,
 	unsigned int period = fpc->period.mod_period + 1;
 	unsigned int period_ns = fsl_pwm_ticks_to_ns(fpc, period);
 
+	if (!period_ns)
+		return 0;
+
 	duty = (unsigned long long)duty_ns * period;
 	do_div(duty, period_ns);
 
-- 
2.39.5



