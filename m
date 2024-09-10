Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910C814D280;
	Tue, 10 Sep 2024 10:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964659; cv=none; b=Fgw9j03+VriI1ZqBwdUjru9n8tZLh/ck5zpBVI+/yBE2wxmm6u/m/GfRiBK01UgHsijgdLuUOzACw/McUksJD8aXDjJ03wmbzwcxR3YVxrYMQuxbLdtft0ZOOXExTc6HtC7mTW3Ic+NYVFN2/GHeVLTBdoGtFHXyly5zqtJY+S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964659; c=relaxed/simple;
	bh=OfcXLmEYlSEtyRgXFc2bsjCU+Mtg/PkuKYtVK51C4yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9OpDzbhdStdloLdYm83U6ap6lh0nQsJIOu7V/xTF/x3+j+BHbqfA20szn/xGXZf2Li3qXGemkHW/h2Z/+fafdm7a9WhcQ8fxXonR72+KK+FKOQM0LTKsVjW1qnnBRTAPLH9PcCz8Vv6AXTTkwttxo4JHIXEYcupnNd/Tw1dhXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP4OhEcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP4OhEcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D94BC4CEC3;
	Tue, 10 Sep 2024 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964659;
	bh=OfcXLmEYlSEtyRgXFc2bsjCU+Mtg/PkuKYtVK51C4yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP4OhEcdx4Qubao3JU6lqEoJ8bhxwbkLbNlpPkmbh4pVW0aKAdm1YUG0kNwaiRbeK
	 J+jWF0ArVpMMTjP3Sk/AknnFuGVaTPrd/0igK3jCGylyst0+YTZw7KzNm6Q5RVWQ0f
	 Rul2yjTOErEeaoL5B63OP97/4Tdt6heBt/Oyiw5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/269] gpio: rockchip: fix OF node leak in probe()
Date: Tue, 10 Sep 2024 11:34:04 +0200
Message-ID: <20240910092616.940354469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index b35b9604413f..caeb3bdc78f8 100644
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



