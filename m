Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271A313546;
	Wed,  3 Dec 2025 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778051; cv=none; b=Xef+qjDBmJSMoptt7ophpe57vI725hpbGk2gOgXHNEqjZbRlR8EEpcq92xjcfoFjOBFOl6NonAPPkBsvdG32SocTNhxWkd/0uOgQb5YxgdCJC7qg+4wp8RSSiewwsRz1OGhbFWJsDqSg+FiiRbT3Wt3C4RPWnC7Jhos39jpnCiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778051; c=relaxed/simple;
	bh=L32Dfthnso2ZJ3EXurLjHI4yB5whjjsGUn9B2LngGXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAy7MMaHUfzufbHiXrCfkzPD4Zddj/TorjdAMbY7tbfGu5dHWS6PFmkGjeI7RcX1fRTq+iWgXQPC8n+fQKJj5diScAfWTLJXYz63woIisJKcn/yBMn4JS6/lHpdyxtLTD+GbxssLprYwGe11T3UTzK9TllSXzf6NbzHcE2nh4tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unNeLCuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unNeLCuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2715CC4CEF5;
	Wed,  3 Dec 2025 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778051;
	bh=L32Dfthnso2ZJ3EXurLjHI4yB5whjjsGUn9B2LngGXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unNeLCuybJukVBwfOrexjrFeFF6cyLqrTlERxWhAT6S8yfmtoc6WpWnpEASgdOUaS
	 +GYbglG3P1dne1dAQaqfJBBzX9kcEE19eq+aesYM1vhIKOLF40VcVTvnXbbeRNuOAv
	 GtsjZKgFw++iULtIU3R8l19OR8eExYMw6nF3F47E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.15 228/392] extcon: adc-jack: Cleanup wakeup source only if it was enabled
Date: Wed,  3 Dec 2025 16:26:18 +0100
Message-ID: <20251203152422.573433041@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 92bac7d4de9c07933f6b76d8f1c7f8240f911f4f upstream.

Driver in the probe enables wakeup source conditionally, so the cleanup
path should do the same - do not release the wakeup source memory if it
was not allocated.

Link: https://lore.kernel.org/lkml/20250509071703.39442-2-krzysztof.kozlowski@linaro.org/
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Closes: https://lore.kernel.org/r/22aaebb7-553b-4571-8a43-58a523241082@wanadoo.fr/
Fixes: 78b6a991eb6c ("extcon: adc-jack: Fix wakeup source leaks on device unbind")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-adc-jack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -162,7 +162,8 @@ static int adc_jack_remove(struct platfo
 {
 	struct adc_jack_data *data = platform_get_drvdata(pdev);
 
-	device_init_wakeup(&pdev->dev, false);
+	if (data->wakeup_source)
+		device_init_wakeup(&pdev->dev, false);
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
 


