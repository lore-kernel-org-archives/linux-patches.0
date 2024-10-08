Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBF41DF272;
	Tue,  8 Oct 2024 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393153; cv=none; b=NEvbKLVGq4FlDGqb3YqdSbgDkH9X1OyI4WIrOkRl9vCTCzEc34ytTn3uk8LiPYPC3QNuSal2jnPmMadYFJJid01GwFbJGbshRvWi1MIs2cTafuAZ4QAnYPDBmCsnjsSnKjuKQvOb3v/68jsb3HoGS2s/bIci2Hyu5nyngDL88Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393153; c=relaxed/simple;
	bh=joQ0NjvxM463EaCyh9/J0JO1I3FuIVS7iMyzKrbpheU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcZxkDBWP5ekO/WlieEGX3MxVReaNeDPuiMnjbRmoqpOfunkgQXiV+xtvuaUeYx3i21jrFAndI4BXsHx6pO08zMXCxkcMEwGDi4NV1k6Mqw1l50uXP/fXWlT+7xEzJqTBOGNk6vfiOnjYPq6W9lionPOQ+W5thj7GAtmjuNsTck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYpaVmpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYpaVmpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70807C4CECC;
	Tue,  8 Oct 2024 13:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393152;
	bh=joQ0NjvxM463EaCyh9/J0JO1I3FuIVS7iMyzKrbpheU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYpaVmpWVQ1ATwxvyHZ3s4GetYIk5Ygj7hoJ5rlozgG7EenwXiQTHTbMQCLbOlwVD
	 VxYjNXpKX99KRMh6Xr3gJXO2CjDqZff+RijyJyHNJqVnQN1F+J72rLsacQjgA7gyEy
	 3yAlQjYgObMvWc1q2oRhaOunJe2zKomPn9Cg7cZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/386] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Tue,  8 Oct 2024 14:05:14 +0200
Message-ID: <20241008115632.178591124@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 409a89d802208..9ffd479c75088 100644
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



