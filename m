Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F90B2E2F00;
	Tue, 22 Jul 2025 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192594; cv=none; b=U2ioI1lCbnWE9VcBRdnOhhKkZeOVseSOVwSIGbFlHHnLPxay63BspWs9DTKySZq2HK7gaubNNv0LlomM+eCYHRWFslftq9CmVDxyCxWUvC6lN50ysW+F+YHpjhrujMUGzgimcaU8k/hYTKqYk1hHoSzfXMjnwaJfS4lR8Gv+gpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192594; c=relaxed/simple;
	bh=fl0YJ2rYi5P7BWmxzlDYQ/4VuTzG9BQNjCX2Q9BBkTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHf058YtgDOfFvVJQ650SlSH6SAZk7pLESXo8ZEc0Mz1YKmVTMkXjL6pfnXN/3ZPJ177WaDBzCUyckVe6nyWtYfM9GcmO4ZNqjnWEPRkfxcBxP/L1vEdMFvK9ufZHNg1uwyk/81J9+IBqAwLmJkpgJQtRJeudulLMgAT0Z2tdIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq2VzE9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq2VzE9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846BAC4CEEB;
	Tue, 22 Jul 2025 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192594;
	bh=fl0YJ2rYi5P7BWmxzlDYQ/4VuTzG9BQNjCX2Q9BBkTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wq2VzE9BfQGYyOo1/5BXmOw9dvXCErqSVHWbd4rj+qL+bAPuHISXggbdBKRCJGWdp
	 0g1rJ+E2ilyTAyXNkFaNo3eghABo1Nbi5vtfl7SivWngbx7wLrsNb8ZJz+oFx4v7wj
	 8AFe8Fxl8YejOW+Yux54J/JDcH5FOrDzOmMM1avo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Chukun Pan <amadeus@jmu.edu.cn>
Subject: [PATCH 6.6 105/111] regulator: pwm-regulator: Calculate the output voltage for disabled PWMs
Date: Tue, 22 Jul 2025 15:45:20 +0200
Message-ID: <20250722134337.334549123@linuxfoundation.org>
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

commit 6a7d11efd6915d80a025f2a0be4ae09d797b91ec upstream.

If a PWM output is disabled then it's voltage has to be calculated
based on a zero duty cycle (for normal polarity) or duty cycle being
equal to the PWM period (for inverted polarity). Add support for this
to pwm_regulator_get_voltage().

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://msgid.link/r/20240113224628.377993-3-martin.blumenstingl@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/pwm-regulator.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -157,6 +157,13 @@ static int pwm_regulator_get_voltage(str
 
 	pwm_get_state(drvdata->pwm, &pstate);
 
+	if (!pstate.enabled) {
+		if (pstate.polarity == PWM_POLARITY_INVERSED)
+			pstate.duty_cycle = pstate.period;
+		else
+			pstate.duty_cycle = 0;
+	}
+
 	voltage = pwm_get_relative_duty_cycle(&pstate, duty_unit);
 	if (voltage < min(max_uV_duty, min_uV_duty) ||
 	    voltage > max(max_uV_duty, min_uV_duty))


