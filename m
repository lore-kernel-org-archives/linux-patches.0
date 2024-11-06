Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193A31DE8A2;
	Wed,  6 Nov 2024 12:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895238; cv=none; b=d3cGT3pEYELkJL7J0lJ9kx43qXyvSXqBsTwc1ZdwqTSIHEJQij4RFW4WVSJVdhNEeyGGpC4FaZhsP0Dy6Nbu9+0+cDLNobyogdyTAEtP3ec4cnwX0j15mkRIXEmsu+uRvC02saUhzguN0nJ60svKm6REyMFYrV1Cl98V8EAkITo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895238; c=relaxed/simple;
	bh=98JvPYSHw2AqdwgNn51CPxC4x+4u/8iSgwABGPfspC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6P17ODwqYwY5G1uWHe8Fiv/x+63KFICFCPX3yWi7EVv7tw4oh8UOM57tyNhmwZn2SDKvhyAQN0LsGiw8RaS3615fKseoltDCVZAxDDncIfgFpXGCx0v32hNMszH0u3HWuoFhoZ0xYIubaSALwPaENlhY1kblyOBcehanbVbjYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eOMCzds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eOMCzds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DD5C4CECD;
	Wed,  6 Nov 2024 12:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895238;
	bh=98JvPYSHw2AqdwgNn51CPxC4x+4u/8iSgwABGPfspC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eOMCzdspfYvuRs5/12DFP4N5C+FB2Ppo9clUHIPioNKn21klUcwpw/52Erk7b/zu
	 X9FDRbYZ0lQAPnXsn9+5AwVufHyKCNeDhGGgUpSt6UM0xi2Hv3hLwG8959m8yuN077
	 R9OZsmfmNY8y8blz94GfCQRBEs1SnTk+M0FGyshI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/350] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Wed,  6 Nov 2024 13:01:18 +0100
Message-ID: <20241106120324.621520940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9a3bc0994a1db..b0f798042e411 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -508,6 +508,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 						MDIO_SC_RESET_ST;
 				}
 			}
+			of_node_put(reg_args.np);
 		} else {
 			dev_warn(&pdev->dev, "find syscon ret = %#x\n", ret);
 			mdio_dev->subctrl_vbase = NULL;
-- 
2.43.0



