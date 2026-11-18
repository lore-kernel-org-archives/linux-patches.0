Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040480;
	b=pGEphqzoyDcwER1QvieUNYycnelIc6jlHJikK17ObPF7tZCMRCO2LVXijZFdWK1aNYBI
	 ifqP4WkcijObXOV0DpSvqeQwxjKEmTMRzjPtFgV1PK8u3ZeQomV3tP3xY+cm96zV9GKzS
	 mHDUWPCpthNicvYT+xiHXmYK6WRr4Ca+8sXj+1AXbm5PtzxtsRrkPYu5rz+QAcLvDLasN
	 1qt5wak4WJRo8MkWqQIkLdiL2VkYYJ8PJG/uSJowbES80uK8GgiJmTUgON+gIkdwhv3ak
	 xspS/BE/KPviFdNOwYXp9A0o2saKwO4g10s2iy8nXO/RRBQExqQszvEsnKBevI8FC1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DZVdcqStcwA5HTb3kWmZXnqP/Zl6qPlALiaz6t1YJNs=;
	b=5UvL24s5sBuZMttEFUInY1wQABCrOgoBaEMY/6fG+nn2UPrvwikKsLcyOFhQwpK1dCZM
	 jSqCDdxhITW8RCAebl2XxyV2MelyPKdS7XJjgz9hqcoY4srfHqpD0pi0Hn4GotnQde5fC
	 Of3dpLI+UXZT7Lepple6azpg6s8VnoH5qrxGLLpzRL/9IwXyPxHueinbRciwLBJAqL0xQ
	 i5cHzsweCAxjCxOP3hrWvpT9EOlKxjLAc9M+VnFVmsQTTSvEpz2Ghpae62jntC9bdjace
	 IVJktvLlt6axZCIm3CgkdII67/oeXUEJTRwdYPsGbX2X50J7+CteihNATXCNGxqmYNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sv8P0OPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC84606A320;
	Wed, 18 Nov 2026 22:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sv8P0OPu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AC01F000C4;
	Wed, 18 Nov 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040480;
	bh=DZVdcqStcwA5HTb3kWmZXnqP/Zl6qPlALiaz6t1YJNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sv8P0OPudiakhUYanJnGxJqFRdrsm/Q8WTkcPl/h68amcuhaLDd4KqemNdMmtGvQ8
	 Cgh2JBz6KOmb9wiXRBOawaReIXtBB4Ckk6AHC1l9xv2u//eoHFYqC0Cu0gTxX6H+MY
	 yQNpFcAf9ENGSdC/6rpD9S9Ib2uoPYOfyey9uVn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2472/3318] pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150435.574034201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit dfd8259507c53a3c7eb0dd11c1152c88e12aa316 ]

stm32_pctl_probe() obtains one clock per bank with
of_clk_get_by_name(), but none of the error paths drop those
references: the loop returns directly when a later clock lookup fails,
and both the clk_bulk_prepare_enable() failure and the err_register
path return without calling clk_bulk_put().  clk_bulk_disable_unprepare()
only disables the clocks, it does not release them.

Release the references on these paths; the success path keeps them as
the driver needs them for suspend/resume.

Fixes: 451bc9aea9a1 ("pinctrl: stm32: Add check for clk_enable()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index a8fbdcf640f69..170f0aa0d5381 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1644,6 +1644,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		pctl->clks[i].clk = of_clk_get_by_name(np, NULL);
 		if (IS_ERR(pctl->clks[i].clk)) {
 			fwnode_handle_put(child);
+			clk_bulk_put(i, pctl->clks);
 			return dev_err_probe(dev, PTR_ERR(pctl->clks[i].clk),
 					     "failed to get clk\n");
 		}
@@ -1654,6 +1655,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare_enable(banks, pctl->clks);
 	if (ret) {
 		dev_err(dev, "failed to prepare_enable clk (%d)\n", ret);
+		clk_bulk_put(banks, pctl->clks);
 		return ret;
 	}
 
@@ -1678,6 +1680,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	}
 
 	clk_bulk_disable_unprepare(banks, pctl->clks);
+	clk_bulk_put(banks, pctl->clks);
 	return ret;
 }
 EXPORT_SYMBOL(stm32_pctl_probe);
-- 
2.53.0



