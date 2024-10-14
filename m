Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739361BDC3;
	Mon, 14 Oct 2024 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918403; cv=none; b=uKjoxSZ0iacrQGf8XqPeAftOlnYqJLWSMGQaI9CQWqbhx2mUynFRRv7+WKZa3P5TldXAVq/2ZYxz5lXR6Piq9lvbttFBELGva8jyEx288ooCXBUP5Bs3h5diNmazZMxL9Rgir4A7WKYmDr9ZloGra+ERKDsxnWxj2J5/x6QH8pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918403; c=relaxed/simple;
	bh=64NIHbyhGDDxvNM9jb9xEbuqeEJVfHIPoUCZ8S5HA0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej+otFup2YslisDJjEkghcnD6WIlI1AxarUVnukZk7u6LyKMhOzbcBjnT1/STNKqCiWSiK5sLhmtQ6O2wizZvCbHhZHANB1PCYjWlR8/fyjq2QS1qOKm8ipsn41erNUYbwofEvfqq2yzbP5gn69K2waQk1tMGe7uoS24s59GZxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQ1MiXV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQ1MiXV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D754BC4CEC7;
	Mon, 14 Oct 2024 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918403;
	bh=64NIHbyhGDDxvNM9jb9xEbuqeEJVfHIPoUCZ8S5HA0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQ1MiXV+PV8xKkwFKiI53jQmTG10cQFHvG9roAhlZe5pA9Ptcoj47/MUsLyzc5avp
	 RI0ULncOWF8YgxALs1vY5FRaV3W0AfWvQhSMUq7xk92KDE3e9OITRG8wLJXSm5E/dw
	 23N/9PKIRV4/fXuNY4rOHRwuLpDcEyWj65ZvEGlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 312/798] bus: integrator-lm: fix OF node leak in probe()
Date: Mon, 14 Oct 2024 16:14:26 +0200
Message-ID: <20241014141230.206042250@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


