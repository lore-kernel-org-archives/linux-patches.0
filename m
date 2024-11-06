Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733541E1336;
	Wed,  6 Nov 2024 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898320; cv=none; b=NktOWTfIDdUessbmefSl+3mwMjHSFqJYS2+op+6mcQyAZxSlkqchkqEUmv99YVgeT/B40SZwpuQ5eQfQhceOz/kDzXQMOXIlfdBVL9tcAux5H/7Dy2hTWCdlfPKhqABg0x7PY3d5MD78VpAEBkWKNfMYdHVMT5A5PT6rqUnI1ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898320; c=relaxed/simple;
	bh=NAu2uzPKNArupiz5dEHLHccdBQPDTbyaWebkDMwoddY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSZVLmpPCBKgA92eHgNdVoJU4YdLIgqy5KjqpxHaCNmCUK/F5SN2amZm5LKy2VNE6bTDxaJxmtVoSNk112hhUkb37n0EDfGAZ5WbT6038NcFA24O+JbwFiFJXViAxRwCtRKTRVezYjr6g6Yrr3QZHrey5d3h56x0dwhjxVotypw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNJ1Zvgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNJ1Zvgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8EAC4CECD;
	Wed,  6 Nov 2024 13:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898319;
	bh=NAu2uzPKNArupiz5dEHLHccdBQPDTbyaWebkDMwoddY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNJ1Zvgx+0Qfho4luQIJ+5PgmgG5Ki9ebc1XNeVtUslt4KFeN0bXiTbZ7kjtYuy99
	 MnU0IErPscoZxYhCCjVrre4Ll2BQJGE4UAgTV6UDZ8Vr97L5RCqgMRYMC5K+o2ttfJ
	 RHpJEBTF31pLOr9T5l0qbuVQn5WY4CEfzRC8hTHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/462] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Wed,  6 Nov 2024 13:01:32 +0100
Message-ID: <20241106120336.433345969@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7df5d7d211d47..58af9b4ae2be8 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -498,6 +498,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 						MDIO_SC_RESET_ST;
 				}
 			}
+			of_node_put(reg_args.np);
 		} else {
 			dev_warn(&pdev->dev, "find syscon ret = %#x\n", ret);
 			mdio_dev->subctrl_vbase = NULL;
-- 
2.43.0



