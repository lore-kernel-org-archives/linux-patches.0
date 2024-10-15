Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2B71C07ED;
	Tue, 15 Oct 2024 13:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997836; cv=none; b=uVWvWul4Y+P3Zo36VQUQxOBgCJhjsR/M22MUK6E8k8i9/IxpDQZDcRAWp3JCyfXMjVwRBYywqjZCeNUV4tRAD7k8Q5f/wuoBH39M/Vi9LhNVzsiDmXauzSkVCKG1vhGIMbNprR8oCVDu4mkgDYl0N+gDZjrQY4j/6rIuUXSWhI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997836; c=relaxed/simple;
	bh=Ns+YqqLVHfeMkFdymRyjKUP4XnbtlktdeRf7w/O/W6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmZAeyQSXyLqXt8SwBu8PcwuQZuY4VSp3CPCAmBFMoYjL/dA804CUyyrMOz5+KlsCBihKfREw3r75vZWhTC4IWLl8+j7Sl75iYJRbbUnozO/+/HsuZHUSqeHSlvxblH2aynnA3weZAgHLZx7aqSOzBPo6lXFWI/cJcrYzU0jh/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJDEpAa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJDEpAa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F97C4CEC6;
	Tue, 15 Oct 2024 13:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997836;
	bh=Ns+YqqLVHfeMkFdymRyjKUP4XnbtlktdeRf7w/O/W6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJDEpAa0DLdB5EINcoeUgfnE04GXYqc/OIfxxuUgzJIPG40HE6QCDgb3ZbL+aM/8i
	 KZ7XsW9BVKoZE0jVAYk5SV1WykYcv7CMb0uXjkCA+WzzEExfehYBzzGpkhszDDw75j
	 0dDO8iGJ2RID7m2Zbt8MvNvEbRlOvwXP8jT3Tsdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/518] net: hisilicon: hns_mdio: fix OF node leak in probe()
Date: Tue, 15 Oct 2024 14:43:24 +0200
Message-ID: <20241015123928.567850752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 883d0d7c6858b..229288dbe708d 100644
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



