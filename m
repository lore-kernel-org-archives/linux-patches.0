Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1A39A7FD;
	Tue, 21 Jul 2026 18:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658233; cv=none; b=C3pxu4g2wVrUFPt3DAaojAUqygYkt9LIs2rPCmdDTMFLn1cpNslIFb7RthFafiS25Hb/S1oNhpqb0/P6ewHrK3iQu9BFh7cW3RttJGxEx7yGVYAG+lg2L1XZznWi1UakaisDE8qq1P1EXw1j7GNa2c3JYn6S06eeV1slXCu0fps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658233; c=relaxed/simple;
	bh=00j8gdVhAaiWwNqPzKkNjz11CjZgDdf5ycv4blSNoWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN23m/v+PZoF6I5mTKD4Z4zsd0x2hAPuxh5edIwdJuHhHHfYJT8fMFWVccFUq2Y8fq90Ph6dh3YIqmEk+2f8+l2R+t6DrsZmmfR8J19TfY5ObbMjwOqMYHSolygef94FYZgbSwBhyHFhqDzTmg0YNEL+ff2vqITJ+LRR1Wf5RUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Twtrdegx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Twtrdegx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F691F000E9;
	Tue, 21 Jul 2026 18:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658232;
	bh=rHaSKu9fb/TQLsxLSMCGNQxbnwRhrVbuth9XpG4Ui1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Twtrdegx11YMjFjVga2GubDa4mss/92l3EzWo4gmhOSr/z6nNVa4KErncEoLjlLTL
	 Dh1AGgX+WmWKRLifZ1BJeNdlhtouUPxgfVaBSAD7Neci9yEtFzt29Y/inrO44/xHbh
	 VwcheqwggR4WWsBUKHIuhtHjGYm+5j6zKUekdv2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1064/1611] gpio: dwapb: reduce allocation to single kzalloc
Date: Tue, 21 Jul 2026 17:19:40 +0200
Message-ID: <20260721152539.337227026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9a5bf2f53b76b1619c602f9e751fe4c0e64713ca ]

Instead of kzalloc + kcalloc, Combine the two using a flexible array
member.

Allows using __counted_by for extra runtime analysis. Move counting
variable to right after allocation as required by __counted_by.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260320005338.30355-1-rosenp@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Stable-dep-of: d775b9451eb8 ("gpio: dwapb: Defer clock gating until noirq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-dwapb.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 4986c465c9a866..15cebc8b5d6635 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -75,8 +75,8 @@ struct dwapb_port_property {
 };
 
 struct dwapb_platform_data {
-	struct dwapb_port_property *properties;
 	unsigned int nports;
+	struct dwapb_port_property properties[] __counted_by(nports);
 };
 
 /* Store GPIO context across system-wide suspend/resume transitions */
@@ -114,11 +114,11 @@ static inline struct dwapb_gpio *to_dwapb_gpio(struct gpio_chip *gc)
 struct dwapb_gpio {
 	struct	device		*dev;
 	void __iomem		*regs;
-	struct dwapb_gpio_port	*ports;
 	unsigned int		nr_ports;
 	unsigned int		flags;
 	struct reset_control	*rst;
 	struct clk_bulk_data	clks[DWAPB_NR_CLOCKS];
+	struct dwapb_gpio_port	ports[] __counted_by(nr_ports);
 };
 
 static inline u32 gpio_reg_v2_convert(unsigned int offset)
@@ -585,14 +585,10 @@ static struct dwapb_platform_data *dwapb_gpio_get_pdata(struct device *dev)
 	if (nports == 0)
 		return ERR_PTR(-ENODEV);
 
-	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(dev, struct_size(pdata, properties, nports), GFP_KERNEL);
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
-	pdata->properties = devm_kcalloc(dev, nports, sizeof(*pp), GFP_KERNEL);
-	if (!pdata->properties)
-		return ERR_PTR(-ENOMEM);
-
 	pdata->nports = nports;
 
 	i = 0;
@@ -714,22 +710,17 @@ static int dwapb_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(pdata))
 		return PTR_ERR(pdata);
 
-	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
+	gpio = devm_kzalloc(&pdev->dev, struct_size(gpio, ports, pdata->nports), GFP_KERNEL);
 	if (!gpio)
 		return -ENOMEM;
 
-	gpio->dev = &pdev->dev;
 	gpio->nr_ports = pdata->nports;
+	gpio->dev = &pdev->dev;
 
 	err = dwapb_get_reset(gpio);
 	if (err)
 		return err;
 
-	gpio->ports = devm_kcalloc(&pdev->dev, gpio->nr_ports,
-				   sizeof(*gpio->ports), GFP_KERNEL);
-	if (!gpio->ports)
-		return -ENOMEM;
-
 	gpio->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(gpio->regs))
 		return PTR_ERR(gpio->regs);
-- 
2.53.0



