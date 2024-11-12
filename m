Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D12214423;
	Tue, 12 Nov 2024 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408275; cv=none; b=I1bogEueowoqiahYDl1tfaPDI7IrIwh7kVDUUlbwiWl0IIUFsGa/RTNEDikcKrf+VINnomWTJRFZxd3SQYQT+Tj1BUI1IBapk7W3hAh188jGRt5wzjdm17uD03j0Qa3MRLtSZFmsNJ1/HEFcO+bGZgFQrbIm9tX2JK8anKm6Q/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408275; c=relaxed/simple;
	bh=ws6bboMGDtDYvN50V5NW26lI7MAoDfjVBxlG4V9qHIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+9FwuAM1vG63G6QWzZeaqdhgv5uCh03G43SA6+7aYPbgGKfOmsUHNg6bpae3gCkryYilpGRhW1ypD2yPIpWOf9TL39+WAHm8hzI2ss6QQcB6qZkNOen17K7nf9KGCj6uQtIuI4bFKWhLO6GLeWNk11a6C7iPztLk/KUE/wwyis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjLa/3aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjLa/3aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BACC4CECD;
	Tue, 12 Nov 2024 10:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408275;
	bh=ws6bboMGDtDYvN50V5NW26lI7MAoDfjVBxlG4V9qHIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjLa/3aOWHFNMVFlynFlgu4zhXwLpMPkwZCIJzjdHaK9QA0Fe8bz7taNiGgmb8tzA
	 VFGjDWyj45sz7ty/XO2xFJioZ9a+yXCHH5SVV0rl42jN5RJny7go0JPF8/z+113DB0
	 Vh0QN1tWCE28ZRuL/rWxoqAV7VtcSwWpxWdpDWxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.11 096/184] pwm: imx-tpm: Use correct MODULO value for EPWM mode
Date: Tue, 12 Nov 2024 11:20:54 +0100
Message-ID: <20241112101904.544918361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


