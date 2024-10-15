Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3C81E766C;
	Tue, 15 Oct 2024 11:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993447; cv=none; b=ZQlDFGEfMLPwaOBrpVepC9m6rZt9/UkifhFpbTgljdSQz3zpGjqzmosg4idC3MtjFCsFj2ntoiCkZOSJ4iXsTitDEGr+wkwbCxCNtx1yX6YP8dbhc8mNHRawtcsk8YSeMLQeMH/jYZGOir1x2mqDmSmuggVgJZJOjHbzQWtEU1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993447; c=relaxed/simple;
	bh=gvhx86S7Fwc3v3O9KF25RCSH0WyjZ3nBgN0+d1n/vLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCBy1hRmcWpNwJL/MKAzoI/ktxhz5vLrzcskKXk3SH2v7nVvMAIGPivP3aKkkh8w9m/kg3ozzchnWmY00WYnX73S/lpIdm4zk1BXb8vfJ1A16Ucak3JpygYA3NTBXZaGIRtB+5vyoFcpZdX1pS3VRynzA9B99kp0R7NKlIhFJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJ0Q7ttn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJ0Q7ttn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F070DC4CEC6;
	Tue, 15 Oct 2024 11:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993447;
	bh=gvhx86S7Fwc3v3O9KF25RCSH0WyjZ3nBgN0+d1n/vLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJ0Q7ttnGCmOt2rqvYJGKBaTNtW/Mk5gg5J+2b5M9VS3hEcAlZD45/EZ4v91aOcTd
	 oFFkDF3nsTUc3P4SwJQJFZdhVoHMQRhdiQKRiXNTklMUeISXyOsFobw2fD7nIq0ZCV
	 TGw8BkqN2AtxFna/7+irxteGYP2hMfMIxjnhRUY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/691] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Tue, 15 Oct 2024 13:26:01 +0200
Message-ID: <20241015112456.734573741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 07fdab58001d9..dd5fe71279f04 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -497,6 +497,7 @@ static int hns_mdio_probe(struct platform_device *pdev)
 						MDIO_SC_RESET_ST;
 				}
 			}
+			of_node_put(reg_args.np);
 		} else {
 			dev_warn(&pdev->dev, "find syscon ret = %#x\n", ret);
 			mdio_dev->subctrl_vbase = NULL;
-- 
2.43.0



