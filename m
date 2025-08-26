Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7391FECAB;
	Tue, 26 Aug 2025 11:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208317; cv=none; b=qrRbAwiMrssrZRCCaef1Ip5/k1HcmMdfF2Pg7F+Zz0CGiP4c1axjhUGVoTtHEFBDrgtcGh1zqYBXy2Gi0065iLF4HfwNGJ7CMwvpBdbKw72bRNFcstAc42cnNewzPunrGeFzBr5wx4S7vJwyIuryexLWhPQEY7j7TmTmbDrh2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208317; c=relaxed/simple;
	bh=IfmfE0HeYANYQht3G8N6RPLN6rX2aYW2NZfnvvUFNZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6w15eJCh1esfWVj7jVSWYUyS2oyxO9ZCRWkxmKyvRgGHuP1xVP6utYKVv0u88BoXUZnPS3smIycaSHowS2wQGLfwah3zHIHU2cw71kX+EtEjPTBr6h1uauk7eBk4EPovdu+AEkGVn02qxoWOBwi0Z9LXieOtTyKb/dUwNXFpcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWAoqx1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWAoqx1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A48C4CEF1;
	Tue, 26 Aug 2025 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208317;
	bh=IfmfE0HeYANYQht3G8N6RPLN6rX2aYW2NZfnvvUFNZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWAoqx1UNWUD8aWSwP4hDG/MrRvhqSclJlrpHLjBtigb4oJ9Bs45N/HntE63RrvfY
	 MCatOjNHFZv7XLofc7GnGbPiwgpiUP65SsFZbUsizkkFR9iGklvyjih31gSP6+akSp
	 qwbzv7hHJZYnkGzkHUhE+WBY7O/rZ+TMUGbJfqMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.12 065/322] pwm: imx-tpm: Reset counter if CMOD is 0
Date: Tue, 26 Aug 2025 13:08:00 +0200
Message-ID: <20250826110917.167063785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>

commit 65c6f742ab14ab1a2679fba72b82dcc0289d96f1 upstream.

As per the i.MX93 TRM, section 67.3.2.1 "MOD register update", the value
of the TPM counter does NOT get updated when writing MOD.MOD unless
SC.CMOD != 0. Therefore, with the current code, assuming the following
sequence:

	1) pwm_disable()
	2) pwm_apply_might_sleep() /* period is changed here */
	3) pwm_enable()

and assuming only one channel is active, if CNT.COUNT is higher than the
MOD.MOD value written during the pwm_apply_might_sleep() call then, when
re-enabling the PWM during pwm_enable(), the counter will end up resetting
after UINT32_MAX - CNT.COUNT + MOD.MOD cycles instead of MOD.MOD cycles as
normally expected.

Fix this problem by forcing a reset of the TPM counter before MOD.MOD is
written.

Fixes: 738a1cfec2ed ("pwm: Add i.MX TPM PWM driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
Link: https://lore.kernel.org/r/20250728194144.22884-1-laurentiumihalcea111@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-imx-tpm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pwm/pwm-imx-tpm.c
+++ b/drivers/pwm/pwm-imx-tpm.c
@@ -205,6 +205,15 @@ static int pwm_imx_tpm_apply_hw(struct p
 		writel(val, tpm->base + PWM_IMX_TPM_SC);
 
 		/*
+		 * if the counter is disabled (CMOD == 0), programming the new
+		 * period length (MOD) will not reset the counter (CNT). If
+		 * CNT.COUNT happens to be bigger than the new MOD value then
+		 * the counter will end up being reset way too late. Therefore,
+		 * manually reset it to 0.
+		 */
+		if (!cmod)
+			writel(0x0, tpm->base + PWM_IMX_TPM_CNT);
+		/*
 		 * set period count:
 		 * if the PWM is disabled (CMOD[1:0] = 2b00), then MOD register
 		 * is updated when MOD register is written.


