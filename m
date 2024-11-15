Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213B1891A8;
	Fri, 15 Nov 2024 06:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653892; cv=none; b=D4lluMyAB9YKvNVhrIK9M1hWgh4zl9l5ReD6xkWk4SSU8wrkRD9o0bILhoVteWhLdxmFfi3pvh9CAtk0qCBzvuOEZiAfJYW/v02gWTjDMJrpV5Wcr8axF0zamgNdKFkHGESaS3YNrwmFf3Gepc/cbqHVPJiaB0RhZGJOnASlxow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653892; c=relaxed/simple;
	bh=UEigPPN3yfWJ1xcutWJWcVZu3QZpHlB+nbT+hunoedA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjWy+9G0kSRUy5kkaXp3fwWZ+D57JS+9AVlOCdC/0Z56DU1gd+qgg49vBUjqNyp/TdReiPDZxT5Khvo7ky61Ql8Tfz/3TMnnU4xTVOHDqQS+Uo8N63WRAy/w3pMj9vgGk1lWb+zbU6R0ceMoEszVRHPaoltqD+QIE1VdaN2+dWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jKWNXeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jKWNXeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F7BC4CED2;
	Fri, 15 Nov 2024 06:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653892;
	bh=UEigPPN3yfWJ1xcutWJWcVZu3QZpHlB+nbT+hunoedA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jKWNXeJi6JhDGuyyaayCM1TRpjLQ/KMSPt5SPPUUF3MpLpdWHRRMpixdJKFaCaeh
	 MFZm5JuY6eKfXpaYTiVnj+mRs8u73SLOko2xqRCrz/e3RYhx+VScFkKHhjLF893FFO
	 ektJD4JSJj4jcAoxYMh/aZSs+k+1Ty72NVc3wMC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.10 33/82] pwm: imx-tpm: Use correct MODULO value for EPWM mode
Date: Fri, 15 Nov 2024 07:38:10 +0100
Message-ID: <20241115063726.757780152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


