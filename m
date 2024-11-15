Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF7A17E015;
	Fri, 15 Nov 2024 06:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652997; cv=none; b=b6WazzbPNugYNPe84YDgAo24HEIIAzt0r+ShEN2Ytmz5f3QB7oa8RsVwI90uH29PM0Mmfh8ZYvCtYDNKAyWQQLFIXn8bgcc+c21DZsyUkpKmiQGy+RjcwyVVz9UTRt5KYUGtVQct7x+d+qLIvww0jNSnqI+cX2S7ADScJl2T2BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652997; c=relaxed/simple;
	bh=uWgYDsMG3ZjXxcov9F9hXnswd/4YrXwp3h4zwCGN8io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLEyqGzxTMxqQiAU4bc7t2GMHfF9pfqtZBONSDKzgeSSJPOvGoNiv7LwZYPlC6eWVT+jFWGIKHBRL39fFlOEtRD64I/6N+Ykhhpmu2u07VdWn9ftFcbIXWJB6bN3jQidaZzqddkljOfQ9bXqsIUI1UM07TxjmCtXqbJfE5vXPGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mg+6ofMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mg+6ofMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609D4C4CECF;
	Fri, 15 Nov 2024 06:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652996;
	bh=uWgYDsMG3ZjXxcov9F9hXnswd/4YrXwp3h4zwCGN8io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mg+6ofMNnoxxsNWVi+oXOYBusPisLvpcFtccC8ED4SiOnJ7EFXeTNAPqqOVNWnBWj
	 pJ2DbM+EN/FTJsuYDm4D/9PaVQwah/4901iR5sDReGzUgGt/YOVJbphcBEVSF8YiVN
	 xrVr11S9uymjTIniCYjFeTw4Bs9c+8w3sQbAKxvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.4 24/66] pwm: imx-tpm: Use correct MODULO value for EPWM mode
Date: Fri, 15 Nov 2024 07:37:33 +0100
Message-ID: <20241115063723.716287258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -108,7 +108,9 @@ static int pwm_imx_tpm_round_state(struc
 	p->prescale = prescale;
 
 	period_count = (clock_unit + ((1 << prescale) >> 1)) >> prescale;
-	p->mod = period_count;
+	if (period_count == 0)
+		return -EINVAL;
+	p->mod = period_count - 1;
 
 	/* calculate real period HW can support */
 	tmp = (u64)period_count << prescale;


