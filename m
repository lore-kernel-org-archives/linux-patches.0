Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2462F20899D;
	Tue, 12 Nov 2024 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407367; cv=none; b=ooIUJBL6T34aUKX3mJ+r+zFEfrvyvfZqoqA6WN210B2CFgzwEv7ixBxL0BBhrqWRfBxOypz773GBdkxjxVzmyngA1lk0a+dcRFO1sQCFoOq2+TYxJrvSbG4rq8hF5Z++THdsI4IZwkCdp76Vg8qGfGFEuRPAqXVVHjsJjVOeU2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407367; c=relaxed/simple;
	bh=NrYjOwQnfOSPhu7hHTfOhvic3TfnfrsyAU1Y65SgTcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAyYFZrFOLID5rVLqpwEJPH2csdoNTXNTDlKfxpzS9qfB9rcKokLcEuchWl/pPbf2G9vitmne5rc4L9GffSOpW64Pn3sj/4QUSlTTAB6TjzernhQH2Q4G6bLefHQR+5wG5j3A4P00/5zqHIPdXGIxbHjWqw6dnTYRQouS6cEARs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkCPRr8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkCPRr8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CC1C4CECD;
	Tue, 12 Nov 2024 10:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407367;
	bh=NrYjOwQnfOSPhu7hHTfOhvic3TfnfrsyAU1Y65SgTcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkCPRr8nGvpmYl/SVlTOeMvckylU6tzaG/RrM1yR+NrAhgFgWk8I4RuEbciJak8ig
	 WY3OrB2aNuSg/GDDa40ix0Kc6dManW84TfpIAADL79S9g/xe/Snv4AAXpmJrq46MPv
	 /wK15vsB+PVNT5JEc9d4fw/ZCuqyYgXaSa4qk0a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.1 55/98] pwm: imx-tpm: Use correct MODULO value for EPWM mode
Date: Tue, 12 Nov 2024 11:21:10 +0100
Message-ID: <20241112101846.364058895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Erik Schumacher <erik.schumacher@iris-sensing.com>

commit cc6a931d1f3b412263d515fd93b21fc0ca5147fe upstream.

The modulo register defines the period of the edge-aligned PWM mode
(which is the only mode implemented). The reference manual states:
"The EPWM period is determined by (MOD + 0001h) ..." So the value that
is written to the MOD register must therefore be one less than the
calculated period length. Return -EINVAL if the calculated length is
already zero.
A correct MODULO value is particularly relevant if the PWM has to output
a high frequency due to a low period value.

Fixes: 738a1cfec2ed ("pwm: Add i.MX TPM PWM driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Erik Schumacher <erik.schumacher@iris-sensing.com>
Link: https://lore.kernel.org/r/1a3890966d68b9f800d457cbf095746627495e18.camel@iris-sensing.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-imx-tpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -106,7 +106,9 @@ static int pwm_imx_tpm_round_state(struc
 	p->prescale = prescale;
 
 	period_count = (clock_unit + ((1 << prescale) >> 1)) >> prescale;
-	p->mod = period_count;
+	if (period_count == 0)
+		return -EINVAL;
+	p->mod = period_count - 1;
 
 	/* calculate real period HW can support */
 	tmp = (u64)period_count << prescale;


