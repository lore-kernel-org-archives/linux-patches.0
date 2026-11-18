Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045536;
	b=e/KsCga00TLwR+QidVcsOONm4vHMYJXjZ+gawrHwnSeFMHxHgVU1na/c8zyrsC1rDOHS
	 ASzRpZ/tSearnr8OucxfaA1v/FAfeDbdaOUtURkcO3to4pvrGfGO5t0XmkZo2IhlIFJW9
	 fdU/e4xgukrwvT3m9H9/GMA7jf4KR2XiA49NPEZVPAUGMScx1/yzQSbGubQovQG5SHYHZ
	 YCbfY8S7ioTmy07iLPT7CyQOj3c6oOOVDNPQ4rQ8U8g5Pw3I0nAjXwHNF0JPWdr8ymBCC
	 k7Dy0pVmCFQhYkGkobj+bnCgQi+ubn7WfVS7ulRxtsKCtkKSvd6g+puM+lWA+vIrQhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XUsOfW3bjpP9eIccY9Ix+XlEk2FfEZXZz7fxvXZrN0g=;
	b=BWzIA5bN6AZvtExzYOmucMia6gMJXzSXoQLRmouO8RYBSVqAy407NhhKeoUMTdY+v/WK
	 CtH4ezHfuatfeBpfvjqcet5ePv9zAnxfT2peFyDYS0oHkWTsTCDPlfIHxcse+2YjuOgCf
	 slXMlCoqCS6U+jBHwsgmG0epPTZblLMc9evKy3x/8br3OewauOe1guR3PNp9scT6lSNi+
	 L6frQwHVGpIWzmBzVmSC5Q9MMxc8iOil+HLqKluX0rvJGrnDnwES1+2TstBM3skrS+/CC
	 i68SrtOFcBUmeN3OGUT/Fmh+QyNDyx3LNeH4qfqrkcw48N8i9TzOuGqUnydQWzJZWBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1kRDENm6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB09606A32A;
	Wed, 18 Nov 2026 23:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1kRDENm6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8A91F000C4;
	Wed, 18 Nov 2026 23:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045536;
	bh=XUsOfW3bjpP9eIccY9Ix+XlEk2FfEZXZz7fxvXZrN0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kRDENm6m9fIG+aqxuUlqEGbdVTUYdlIitWvsEYrBwsz8MPMjxKzwEFjwETYvJ/X3
	 oyDUJBVRi6zl7jsUVqTtV55QwcxhsIoo8xlzozgRBpvkRTOvBo1sfpCMGs0f9honQ/
	 VY0WZ3Gco24VqTaC9edtSbq414nDTgduaRT2Nnz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0959/2857] irqchip/mchp-eic: Fix clock reference leak in mchp_eic_probe()
Date: Wed, 18 Nov 2026 15:33:13 +0100
Message-ID: <20261118150236.130762582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit af9c707eb065a7d48eb92dc15acdb4346acf5db0 ]

of_clk_get_by_name() returns the clock with an elevated reference count
that mchp_eic_probe() keeps for the lifetime of the driver, but none of
the probe error paths drops it, so the reference is leaked whenever
probe fails after the clock has been obtained.

Put the reference in the error cleanup.  The clk_prepare_enable()
failure path must jump there directly as it cannot call
clk_disable_unprepare() on a clock that was never enabled.

Fixes: 00fa3461c86d ("irqchip/mchp-eic: Add support for the Microchip EIC")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916190349.2094401-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mchp-eic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mchp-eic.c b/drivers/irqchip/irq-mchp-eic.c
index 7f84c736d2827..77f44d4cf30eb 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -228,7 +228,7 @@ static int mchp_eic_init(struct device_node *node, struct device_node *parent)
 
 	ret = clk_prepare_enable(eic->clk);
 	if (ret)
-		goto unmap;
+		goto clk_put;
 
 	for (i = 0; i < MCHP_EIC_NIRQ; i++) {
 		struct of_phandle_args irq;
@@ -264,6 +264,8 @@ static int mchp_eic_init(struct device_node *node, struct device_node *parent)
 
 clk_unprepare:
 	clk_disable_unprepare(eic->clk);
+clk_put:
+	clk_put(eic->clk);
 unmap:
 	iounmap(eic->base);
 free:
-- 
2.53.0



