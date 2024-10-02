Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9E71CF7D4;
	Wed,  2 Oct 2024 14:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878773; cv=none; b=WPdk/v5K3/VGaT4mUHJwDIIdMSgRMLIkDXUxPmUVglZTQUsNuWceSpta5PMRLI3ljuS9MpOscaXd2A/Ilh2BcHlh978rm3aoAKK1oaHoXrNRmQNAqJ/STO3sWz31UmzjeGOxClFhRUbU2MtUv+zepASFDmHkTc5KE1o6FFZ133U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878773; c=relaxed/simple;
	bh=+5ZZY0wdMz337c4GlwtEU2keYkQUzoobx3/mm6d08VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkmUgO5pmL5vrBQATwcFpkD6dOnYDkK4OPFOZVD/PgzjuSeo6icX6vMPrWeO8z9rmkjcSMT5TtFmE1/chSVXpiQAOfJPlxdQCf/OVk7b16i4jaMSh8SW34OPhNkG8ntEaz75kuQt2X8efSGcH0UBMdgtNfzcH0DcuAsdYvnO7YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mauF73+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mauF73+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0FEC4CEC2;
	Wed,  2 Oct 2024 14:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878772;
	bh=+5ZZY0wdMz337c4GlwtEU2keYkQUzoobx3/mm6d08VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mauF73+EdXcNycFDj0x22MyasgoVF5ARxtYQsUj570LkH99Uasi0RyoHyoUWLBDf3
	 6O8OpLMTgCoq/76mjsGOurSxrfGAyi+Obiz315/7q/5e61wmV7ymDrwFKyanALMUJD
	 aEqsM14KMJTGwb0QtVhOfgpstQhCmDIaX2XiUVVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.10 527/634] bus: integrator-lm: fix OF node leak in probe()
Date: Wed,  2 Oct 2024 15:00:27 +0200
Message-ID: <20241002125831.906420827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 15a62b81175885b5adfcaf49870466e3603f06c7 upstream.

Driver code is leaking OF node reference from of_find_matching_node() in
probe().

Fixes: ccea5e8a5918 ("bus: Add driver for Integrator/AP logic modules")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/20240826054934.10724-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/arm-integrator-lm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/arm-integrator-lm.c
+++ b/drivers/bus/arm-integrator-lm.c
@@ -85,6 +85,7 @@ static int integrator_ap_lm_probe(struct
 		return -ENODEV;
 	}
 	map = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(map)) {
 		dev_err(dev,
 			"could not find Integrator/AP system controller\n");


