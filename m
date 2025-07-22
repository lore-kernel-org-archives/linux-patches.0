Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1042E2F02;
	Tue, 22 Jul 2025 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192601; cv=none; b=EaYPoppNULV53J4e+kmlP6rY8UFjxidpevBydvep8AiISxudJS8ExrPfCpQU2vPTQ6gbthIgDhOHJx2fmHDVvyHk/Ok95Bsvm7n2oJcXecIxuYEL2+sObuN3KUWrSFyJQAxzFrMHpqrCoOFMbDlD9pL6Xzu+Ik5UcKeWceRbVZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192601; c=relaxed/simple;
	bh=T59haaTNjZkiPgxqcbsUadrlLRflzK64zJFbdPkDLvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6fiXFYlt4UpBfo0BcnJrp4eSFwDrm+UJKLwA1nhYgGetuKfFvcivzzjvuwJMOEZREmtJMqtbrszLWT4FF9L2+ktda7vzgBFwJdgn8oxNFHRw8DsAK+ecHZOEA+2j+W99X/TcYUz9BshGe8MXMGarqLR0HPgW1HOVL2fsXQ2CUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBXYDjoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBXYDjoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C623BC4CEF1;
	Tue, 22 Jul 2025 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192597;
	bh=T59haaTNjZkiPgxqcbsUadrlLRflzK64zJFbdPkDLvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBXYDjoc6ix9M4LRdT88JWuaYeINMej06WGOoH3is69+t4P20/hIiCXEuR43ftK68
	 cYvAvZRmgIpCE0Mv52fnGVDZbCW/EqDnQ6EfT1MPtKZAUTTptvxNfxjh+3hLlzLbS8
	 tYRbmmf7rOG0O+9I/KZvnBaCHpN27VK/S6D9T3oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Chukun Pan <amadeus@jmu.edu.cn>
Subject: [PATCH 6.6 106/111] regulator: pwm-regulator: Manage boot-on with disabled PWM channels
Date: Tue, 22 Jul 2025 15:45:21 +0200
Message-ID: <20250722134337.372761548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit b3cbdcc191819b75c04178142e2d0d4c668f68c0 upstream.

Odroid-C1 uses a Monolithic Power Systems MP2161 controlled via PWM for
the VDDEE voltage supply of the Meson8b SoC. Commit 6b9352f3f8a1 ("pwm:
meson: modify and simplify calculation in meson_pwm_get_state") results
in my Odroid-C1 crashing with memory corruption in many different places
(seemingly at random). It turns out that this is due to a currently not
supported corner case.

The VDDEE regulator can generate between 860mV (duty cycle of ~91%) and
1140mV (duty cycle of 0%). We consider it to be enabled by the bootloader
(which is why it has the regulator-boot-on flag in .dts) as well as
being always-on (which is why it has the regulator-always-on flag in
.dts) because the VDDEE voltage is generally required for the Meson8b
SoC to work. The public S805 datasheet [0] states on page 17 (where "A5"
refers to the Cortex-A5 CPU cores):
  [...] So if EE domains is shut off, A5 memory is also shut off. That
  does not matter. Before EE power domain is shut off, A5 should be shut
  off at first.

It turns out that at least some bootloader versions are keeping the PWM
output disabled. This is not a problem due to the specific design of the
regulator: when the PWM output is disabled the output pin is pulled LOW,
effectively achieving a 0% duty cycle (which in return means that VDDEE
voltage is at 1140mV).

The problem comes when the pwm-regulator driver tries to initialize the
PWM output. To do so it reads the current state from the hardware, which
is:
  period: 3666ns
  duty cycle: 3333ns (= ~91%)
  enabled: false
Then those values are translated using the continuous voltage range to
860mV.
Later, when the regulator is being enabled (either by the regulator core
due to the always-on flag or first consumer - in this case the lima
driver for the Mali-450 GPU) the pwm-regulator driver tries to keep the
voltage (at 860mV) and just enable the PWM output. This is when things
start to go wrong as the typical voltage used for VDDEE is 1100mV.

Commit 6b9352f3f8a1 ("pwm: meson: modify and simplify calculation in
meson_pwm_get_state") triggers above condition as before that change
period and duty cycle were both at 0. Since the change to the pwm-meson
driver is considered correct the solution is to be found in the
pwm-regulator driver. Update the duty cycle during driver probe if the
regulator is flagged as boot-on so that a call to pwm_regulator_enable()
(by the regulator core during initialization of a regulator flagged with
boot-on) without any preceding call to pwm_regulator_set_voltage() does
not change the output voltage.

[0] https://dn.odroid.com/S805/Datasheet/S805_Datasheet%20V0.8%2020150126.pdf

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://msgid.link/r/20240113224628.377993-4-martin.blumenstingl@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/pwm-regulator.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -323,6 +323,32 @@ static int pwm_regulator_init_continuous
 	return 0;
 }
 
+static int pwm_regulator_init_boot_on(struct platform_device *pdev,
+				      struct pwm_regulator_data *drvdata,
+				      const struct regulator_init_data *init_data)
+{
+	struct pwm_state pstate;
+
+	if (!init_data->constraints.boot_on || drvdata->enb_gpio)
+		return 0;
+
+	pwm_get_state(drvdata->pwm, &pstate);
+	if (pstate.enabled)
+		return 0;
+
+	/*
+	 * Update the duty cycle so the output does not change
+	 * when the regulator core enables the regulator (and
+	 * thus the PWM channel).
+	 */
+	if (pstate.polarity == PWM_POLARITY_INVERSED)
+		pstate.duty_cycle = pstate.period;
+	else
+		pstate.duty_cycle = 0;
+
+	return pwm_apply_might_sleep(drvdata->pwm, &pstate);
+}
+
 static int pwm_regulator_probe(struct platform_device *pdev)
 {
 	const struct regulator_init_data *init_data;
@@ -382,6 +408,13 @@ static int pwm_regulator_probe(struct pl
 	if (ret)
 		return ret;
 
+	ret = pwm_regulator_init_boot_on(pdev, drvdata, init_data);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to apply boot_on settings: %d\n",
+			ret);
+		return ret;
+	}
+
 	regulator = devm_regulator_register(&pdev->dev,
 					    &drvdata->desc, &config);
 	if (IS_ERR(regulator)) {


