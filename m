Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020375;
	b=3RShpIzXfuCEcetseKGojHPNPVdxGa9WMhqncotg+n6bYcarvD4LapAbar5pvGCPBWe2
	 2YcAMqtdQAyN7j4EKCduTDtmEk9dIGb4yaIQL80JMupry6ObR25ik4/626hmCWctP3Xzm
	 nX0kxsANzu0hIYvEvUomuKAwV85tgXnf8WRxa5Ihpeo7PSkbtvgEBN9JRS5oZfdEpP4Qc
	 sMNBcKYgs/4PNMjlLFAAr6rYYUkKQxGLBB9wGj6oBi6Uzgd3tvAxBu8OKUYPcibpfVuaN
	 1nXVxAIN1rbOk8VggLUQs39NzoOKUDN+Rby6kLXgiV9lryG+A5MHYZgHpI/kWLumCmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZhOEOGlp+nhak6/04VWktvRDLPukN6cdBqkDWW2gQMk=;
	b=s+cwvIZpEJ5O4CiokcBnh47+dUd08NTwlG0n/BZT+CLO4zhW8n8pi9mdzHwTyOJPd4by
	 YJFB0M6GnHx49nE/kUNsjNkKKPPOps0oTAQcHJIQTr+aXYiYlASwM02NLUrEOLTbsoaaS
	 FlGiATlEY43kbvK0j6bYNkIykTLwa3clkWOoy6DpSaT26rjCM7IHBfPmJio2KQtqzBKqY
	 hhcu2/2aLyjioAp/Aj6wo0swSFLSSs1EnU8vX9oDhu+aAbuzmVVOpD8X5xQU7xfOpkgGK
	 r1yl9McRLMrRyTomXIYk3nI+fRw1Le/6O9RD9yPF0nMMSZZgZjRR8+o2XBZ6ESHEv+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR7OuZxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC2E606A31C;
	Wed, 18 Nov 2026 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR7OuZxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA381F000C4;
	Wed, 18 Nov 2026 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020375;
	bh=ZhOEOGlp+nhak6/04VWktvRDLPukN6cdBqkDWW2gQMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lR7OuZxoukf8MDh9iA5wWLheWt5EtPj6HewTXiItKXXGcPwbbEN45u5g8cC3A7j7B
	 jN5GTgtf77enuMUjBlwHcSnVAsqewAzF8P7a44b80tIzDrmyRmdbj3C/xdq9ik0Cu9
	 uVJLqZK0IvTnlzcxlJQ08wcis4e+JIewXe7/tBgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1922/2651] spmi: mtk-pmif: Fix clock reference leak in mtk_spmi_bus_probe()
Date: Wed, 18 Nov 2026 15:52:42 +0100
Message-ID: <20261118150355.932499425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 636c4c026f47f0a7a009b1e39e310afca640a047 ]

of_clk_get_by_name() returns a reference that must be released with
clk_put(). If the lookup of a later clock fails, the function returns
without releasing the clocks that were already obtained. Put those
clocks before returning.

Fixes: 078117963b2c ("spmi: mtk-pmif: Add multi-bus support for SPMI 2.0")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index 61c916edaec4c..833c2b30d09f0 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -746,9 +746,11 @@ static int mtk_spmi_bus_probe(struct platform_device *pdev,
 	for (i = 0; i < pbus->nclks; i++) {
 		pbus->clks[i].id = pmif_clock_names[i];
 		pbus->clks[i].clk = of_clk_get_by_name(node, pbus->clks[i].id);
-		if (IS_ERR(pbus->clks[i].clk))
+		if (IS_ERR(pbus->clks[i].clk)) {
+			clk_bulk_put(i, pbus->clks);
 			return dev_err_probe(&pdev->dev, PTR_ERR(pbus->clks[i].clk),
 					     "Failed to get clocks\n");
+		}
 	}
 
 	err = clk_bulk_prepare_enable(pbus->nclks, pbus->clks);
-- 
2.53.0



