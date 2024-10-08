Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081A31E485;
	Tue,  8 Oct 2024 12:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389752; cv=none; b=FmcJCDrYzd+cNrlMq4d0A4g2xPTjsAN5Q2Se9H6XdUsC9eMjTsdmHoJhVDXRv1jCtwKMFFc0xwPuO4KDCYczylvDrXx1CVXcXfIZr5euPCrkY+dF8PP2zH5WwmocJHF0OWaFgb1EmLCQ9zkrlK3kzzmMLj2NLRpmX07aAUBRVhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389752; c=relaxed/simple;
	bh=E4n2UyXKADKWp+jZWs7HL4ctdsn7mOVZreA+v70Vkqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXfWtPaIdO744bUJ4Bx91nfOWxvU9Uo1Q5Gfhl7h8urCZAx19VWpt0XCfoWWj3GRvl5xeRK3ErtKRzN11BubHICZDTHVet3eMnbJIZMceR8v2QE+8oPg5VxcA8bor6vuoo71nPxXdHkLavVc9nU6O6CRlDTAmCN5G9L/KbJpd/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvO4z/3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvO4z/3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AF3C4CEC7;
	Tue,  8 Oct 2024 12:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389751;
	bh=E4n2UyXKADKWp+jZWs7HL4ctdsn7mOVZreA+v70Vkqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvO4z/3WxnilYi/P2uG9KyHO/TpBCTXnKSKuaAUXdFMbsYBRFkj2wvysLSTWWGjcJ
	 squQNALaL5BckPYr+C7ktbGpS9ZG2OB8z+CyM8yHYaSeyiuXeFMUZntjSp9UqAKWe2
	 5AB7w7vQBY8prbTk+eTCojNMxE4sJpL4zorZS+6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 084/482] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Tue,  8 Oct 2024 14:02:27 +0200
Message-ID: <20241008115651.612735753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

[ Upstream commit e62beddc45f487b9969821fad3a0913d9bc18a2f ]

Driver is leaking OF node reference from
of_parse_phandle_with_fixed_args() in probe().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240827144421.52852-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index ed73707176c1a..8a047145f0c50 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -575,6 +575,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 						MDIO_SC_RESET_ST;
 				}
 			}
+			of_node_put(reg_args.np);
 		} else {
 			dev_warn(&pdev->dev, "find syscon ret = %#x\n", ret);
 			mdio_dev->subctrl_vbase = NULL;
-- 
2.43.0



