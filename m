Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15F520FAB3;
	Tue, 12 Nov 2024 10:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407757; cv=none; b=dNcFMbehMtOtTG5IO4sfbTVp2ECVLwB/SAJoasRodh+WS+Ul9T+OXeHv0t9Lh8kwEdENVPjuehaxVXtiLxCaZ0ON+xmMp7d/KhAQ7BWSLYFdI6NHQG0GTrBVGi+9itGTMlO4tXWXHRLsXaRaTh9tmxEKKZZS1G/x5r0dwpZJt9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407757; c=relaxed/simple;
	bh=wV8O+ziYWyh/Cvo9FbAl5HVELAoqgRhCTCWsEIu6beY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bt2kKDl4moIOkzG+dwWWs2SzDWUA07Z0Ea1MtvdIIDZHKsoMFZxGE/vrO3xQeansEQU14ChJFEVvKK2qqGq+/BEtOGP7FCOwRDhhNFDqY2fL4V5+h4q2IT0uzEARBrVyNd304NBInabJs4XHFrQ0/851yq5lxuHXdZHBMXxTd80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reMGOJCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reMGOJCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341B6C4CECD;
	Tue, 12 Nov 2024 10:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407757;
	bh=wV8O+ziYWyh/Cvo9FbAl5HVELAoqgRhCTCWsEIu6beY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reMGOJCrKfpnI5pWJ48oWJ+UnHDxhnaRggxhDDC/5C+m5ZIVl42sJ0H73zW57NQSI
	 psiKJJmLyFcfM3YB301p0lfedxBqtZmIaqtgb3y+PEZ5TZJmCECekDCXiOvAoEsxTR
	 +yR3MDmKVQF6VQtqCDM5ttetdN8ePaDRwT5ZtTIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.6 074/119] pwm: imx-tpm: Use correct MODULO value for EPWM mode
Date: Tue, 12 Nov 2024 11:21:22 +0100
Message-ID: <20241112101851.550823894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


