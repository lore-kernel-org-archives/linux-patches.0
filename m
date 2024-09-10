Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3971974EA;
	Tue, 10 Sep 2024 10:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963905; cv=none; b=Zazb7KwRTh/lOb4Skhf5pAqlwnXv3rKds3dUSDdB8mHOp22lcUN5YwvhkWzB8MKpBX2mwS8TnZXbbXoEBq/ywf7WOulnTsS0gAKRsiodNMDQf/xGuxDT2mdTj2SiFQwmC/ICUTbE+FjcNVOrNDPFsy9dyKKLTZL3nP5cwqTYCXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963905; c=relaxed/simple;
	bh=Ul+WbT7PT7iwHGLXWLBWXuUl6lm2pwWXaXCmQRhGKyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fer82/Km9amjErS5AMLmccx/3emypPo8laSUJ3Z7T+TSb19zca/jrxkqfjgkHNQJGSiAZLfZQm4EOG8arNca0bIPdy8fPNGsEY4Kl4/M8QLbbF4aIdh9ATD4ILIn2JhnJBpNDCq7eE5v2mvycD0nzSQpcVWxpMIiKq0tPkAzZ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e85O0FN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e85O0FN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F60C4CEC3;
	Tue, 10 Sep 2024 10:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963905;
	bh=Ul+WbT7PT7iwHGLXWLBWXuUl6lm2pwWXaXCmQRhGKyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e85O0FN66jkaKpVdicJjtsHG7D3J5Y4kIIMJShApr9lBBaIxANWBGDv6lQb2lUD+2
	 FZGkzeXfMyrG3VNV4/zhYXi7K9oxWTHv8xbz0rQcHD7SgtWshE7jKloxkEHO6UsHYJ
	 47RzqK51K5K2LIop5xK39Ag17hFloQ8PZe7zVcv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/214] gpio: rockchip: fix OF node leak in probe()
Date: Tue, 10 Sep 2024 11:33:47 +0200
Message-ID: <20240910092606.901491010@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

[ Upstream commit adad2e460e505a556f5ea6f0dc16fe95e62d5d76 ]

Driver code is leaking OF node reference from of_get_parent() in
probe().

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20240826150832.65657-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index a197f698efeb..d331745da1a3 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -708,6 +708,7 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pctldev = of_pinctrl_get(pctlnp);
+	of_node_put(pctlnp);
 	if (!pctldev)
 		return -EPROBE_DEFER;
 
-- 
2.43.0



