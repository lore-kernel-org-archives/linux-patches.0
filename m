Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214BB19259E;
	Tue, 10 Sep 2024 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963245; cv=none; b=Oi8GsbhmDQIHTNnjZy5MMAWLakMGkbHNyx/7ih+t9yVm9GPz8ehdtfZbLBMv96IlZlI/u6Hfx3ybONYNrhpGxd9+iUIX1sIQLgs7F6Xc0OCfo+onW8LwmP5va1U3197+pvWjYMex6xsnRmSlKUdNT+pWFKCAetmkZjInHkDEuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963245; c=relaxed/simple;
	bh=vSppGmhXof0c/cLMX9NKF5BO1/pny2oQH7AC7V27k5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqeG0P4L8eNaTDCV8v4Ee0plQaOR++cIysyVUmkzkGdDm7rQBSq6qYx3dE0VILmC/slFHFYEvAoAaAdkWOtNn03OrBgvHZxP7bAzm4W9eSY7ZDIUVx+nWkeMtiBeqglsRpkwnkex8Q5Lp21srtsYGo98CCkO6mykI5NW+Z6lrss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaQQx47l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaQQx47l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE66C4CEC3;
	Tue, 10 Sep 2024 10:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963245;
	bh=vSppGmhXof0c/cLMX9NKF5BO1/pny2oQH7AC7V27k5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaQQx47lVbvmneB6PL1wua4fj61iOckd75OAOItA64qKv6GgeXHSXp+n90X05mkZL
	 I7/+hlodVPg3FjvMWO3AbkPD5T5nXJ+V8CThuZDC7FGfgyRlUWTTcTDe/zPgUkwFP9
	 gWctse5poFrl5BT5dcH0kSX8JKYKBW/uDUm0w2Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/192] gpio: rockchip: fix OF node leak in probe()
Date: Tue, 10 Sep 2024 11:33:28 +0200
Message-ID: <20240910092605.391382813@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 200e43a6f4b4..3c1e303aaca8 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -713,6 +713,7 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pctldev = of_pinctrl_get(pctlnp);
+	of_node_put(pctlnp);
 	if (!pctldev)
 		return -EPROBE_DEFER;
 
-- 
2.43.0



