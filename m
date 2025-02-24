Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D5155744;
	Mon, 24 Feb 2025 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409130; cv=none; b=ob89odJlWvccAVtdr+QNCubsjfzg0fyg3WnFo/JHuzgJsnCtjIaDldxGe+jBgNMV2A0h0iZXLLuHUwkdD3f6DVmO176Yt6LR7q+VmBaCyoXT6flJEWWS0L4+uf0bHrASXvYXag+mcAme8dtrRkTw02jX44wh3Sqgo+62TUySi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409130; c=relaxed/simple;
	bh=tr1PkQOOiXEVohdtf2e5b3DPNE3gmUPMNkmQvwUu4Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJMBh8AlBC32Tw63BYLN1YN24JTFmJCFCR3023fAM05jxrWSM+yx8XPKHhtq12ygj4+yDHBSyQaTi2rxVOl1YJEkMJbfjXeq0//owdqoYelQYF6npqHbgdYRCragm+pePTp/v6w5L+hLf+MBhlVSpxf8z+FT+UBAplDhaWVdR3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDi0bc61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDi0bc61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E21AC4CED6;
	Mon, 24 Feb 2025 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409129;
	bh=tr1PkQOOiXEVohdtf2e5b3DPNE3gmUPMNkmQvwUu4Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDi0bc61kiUdppvpoGffbCRwDi8VuF2qAM1gaPN0Bn1cxOESq/ZSy2YemTwmuGdGo
	 IMumWua6OmiuzMZp3a9ZhGImJO7D16xdqH7zq+G01N+IWn46bUSxPt7kWnoxZXE32d
	 5J0CO4HXF9P07jj7Ltd3TSocZAA6kC+dzLG3E9J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Korsnes <johan.korsnes@remarkable.no>,
	Linus Walleij <linus.walleij@linaro.org>,
	Haibo Chen <haibo.chen@nxp.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.13 106/138] gpio: vf610: add locking to gpio direction functions
Date: Mon, 24 Feb 2025 15:35:36 +0100
Message-ID: <20250224142608.647498992@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Korsnes <johan.korsnes@remarkable.no>

commit 4e667a1968099c6deadee2313ecd648f8f0a8956 upstream.

Add locking to `vf610_gpio_direction_input|output()` functions. Without
this locking, a race condition exists between concurrent calls to these
functions, potentially leading to incorrect GPIO direction settings.

To verify the correctness of this fix, a `trylock` patch was applied,
where after a couple of reboots the race was confirmed. I.e., one user
had to wait before acquiring the lock. With this patch the race has not
been encountered. It's worth mentioning that any type of debugging
(printing, tracing, etc.) would "resolve"/hide the issue.

Fixes: 659d8a62311f ("gpio: vf610: add imx7ulp support")
Signed-off-by: Johan Korsnes <johan.korsnes@remarkable.no>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250217091643.679644-1-johan.korsnes@remarkable.no
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-vf610.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -36,6 +36,7 @@ struct vf610_gpio_port {
 	struct clk *clk_port;
 	struct clk *clk_gpio;
 	int irq;
+	spinlock_t lock; /* protect gpio direction registers */
 };
 
 #define GPIO_PDOR		0x00
@@ -124,6 +125,7 @@ static int vf610_gpio_direction_input(st
 	u32 val;
 
 	if (port->sdata->have_paddr) {
+		guard(spinlock_irqsave)(&port->lock);
 		val = vf610_gpio_readl(port->gpio_base + GPIO_PDDR);
 		val &= ~mask;
 		vf610_gpio_writel(val, port->gpio_base + GPIO_PDDR);
@@ -142,6 +144,7 @@ static int vf610_gpio_direction_output(s
 	vf610_gpio_set(chip, gpio, value);
 
 	if (port->sdata->have_paddr) {
+		guard(spinlock_irqsave)(&port->lock);
 		val = vf610_gpio_readl(port->gpio_base + GPIO_PDDR);
 		val |= mask;
 		vf610_gpio_writel(val, port->gpio_base + GPIO_PDDR);
@@ -297,6 +300,7 @@ static int vf610_gpio_probe(struct platf
 		return -ENOMEM;
 
 	port->sdata = device_get_match_data(dev);
+	spin_lock_init(&port->lock);
 
 	dual_base = port->sdata->have_dual_base;
 


