Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623347;
	b=W7y61PnOj4B1kWAq6DNQasjFP72UKggDtZm80Q9gj8IEDfLun+RkPviigGcvD52qcTyN
	 KqCUXeEvKo4kb7yxlo6nJVOiUrMGszYQT7dXYMByyavtN2EEGYCurzcCNoVgtWnw7EZY+
	 ajZ2d8LwvH1yA8zvh2v1YrbqGpLwtLGktznYthKeMWNB+cBEIO8dvkwU2KLaynjUV6mhq
	 J12+McsdkqJrmLZx/KGZvfvAcian9AhgA+DTGbbY3kmyggSL1/9prNL2dmG4wiSa9DSn4
	 bihoN5WyuO8dBL+b/zGL1+YC+YFEmJ4M+TPR5NK/EKySWBES/78pjW43slQpMr1P0Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iosMT67B386zCUmcHbNvCZWjzmdwGDCxzvurdEJhGu0=;
	b=rEQuKFYLaqiLpJkIbNkE0qPZTluay3iYt4IYAa600Z3Fq9GyXw3snuUfzinn051gle5q
	 G6c+VeqCNhyciQrpf9z1H4WVSORGpqiL1yeu8ng3uTFb6ikZUbkrYk6IQ5BVOAVYqk0+g
	 lMYWfUGy28XNHXR5eN1gBbBzxqfoUKaN/6e4v8rYr1i0racqYHuCnTUYVOuBYoJJzJuXT
	 3oErzyy90ZiyVPi5sP1nEKrh4gjLzWTC2sC1GL3uezka5jHQf1n42AwOdGkqx3XIw+Hmt
	 11PwbW/eY2HPhIyyfC8nKbHOwwQnqiAhTXZ9E3C/GY3bkvS1XWDB4Nz173JZ0WJnoCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Rbztj/mT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F04606A321;
	Wed, 25 Nov 2026 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rbztj/mT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9181F000CA;
	Wed, 25 Nov 2026 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623347;
	bh=iosMT67B386zCUmcHbNvCZWjzmdwGDCxzvurdEJhGu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rbztj/mT7WQQ2IXv6KdC43RDaA+tMos0GGcJQTlWQ4//KYrMO7aNRAnVEqslSpKN7
	 j4W9sDAI3EqOgaSEtHieegI/0NEL4hqc7TJ2GGelt79pOuIMf7tMKy6NILaKw2uj3u
	 CB8PdDganEsUP9WMS8dKAX0uzMnkYObAg8SUIxEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunhao Lu <1579567540@qq.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 827/990] gpio: rockchip: Fix debounce arithmetic for GPIO v2
Date: Wed, 25 Nov 2026 15:36:34 +0100
Message-ID: <20261125143841.407418813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cunhao Lu <1579567540@qq.com>

commit 13467fd6998f5da4f5b4f172f1af3d9c48d5de8f upstream.

The debounce interval calculations use unsigned long operands. On 32-bit
systems, the numerator used to calculate the maximum interval overflows
before division, while multiplying the requested interval by the clock
rate overflows before it is assigned to a u64. A zero debounce clock rate
also causes division by zero.

Use 64-bit arithmetic for both calculations and reject a zero clock rate
before division.

At 32768 Hz, a 1 us request rounds to zero divider periods. Subtracting
one then wraps the divider value to ULONG_MAX. Decrement only a nonzero
rounded period count so that such requests use the smallest divider
value.

Fixes: 3bcbd1a85b68 ("gpio/rockchip: support next version gpio controller")
Cc: stable@vger.kernel.org
Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/20261023-fix-rockchip-gpio-v2-debounce-v1-1-f1141bd5b58f@qq.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-rockchip.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -201,20 +201,25 @@ static int rockchip_gpio_set_debounce(st
 {
 	struct rockchip_pin_bank *bank = gpiochip_get_data(gc);
 	const struct rockchip_gpio_regs	*reg = bank->gpio_regs;
-	unsigned long flags, div_reg, freq, max_debounce;
+	unsigned long flags, div_reg, freq;
 	bool div_debounce_support;
 	unsigned int cur_div_reg;
-	u64 div;
+	u64 div, max_debounce;
 
 	if (bank->gpio_type == GPIO_TYPE_V2 && !IS_ERR(bank->db_clk)) {
 		div_debounce_support = true;
 		freq = clk_get_rate(bank->db_clk);
-		max_debounce = (GENMASK(23, 0) + 1) * 2 * 1000000 / freq;
+		if (!freq)
+			return -EINVAL;
+
+		div = (u64)(GENMASK(23, 0) + 1) * 2 * USEC_PER_SEC;
+		max_debounce = div64_u64(div, freq);
 		if (debounce > max_debounce)
 			return -EINVAL;
 
-		div = debounce * freq;
-		div_reg = DIV_ROUND_CLOSEST_ULL(div, 2 * USEC_PER_SEC) - 1;
+		div = (u64)debounce * freq;
+		div_reg = DIV_ROUND_CLOSEST_ULL(div, 2 * USEC_PER_SEC);
+		div_reg = div_reg ? div_reg - 1 : 0;
 	} else {
 		div_debounce_support = false;
 	}


