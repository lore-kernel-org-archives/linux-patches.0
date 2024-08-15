Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FD819EECD;
	Thu, 15 Aug 2024 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728799; cv=none; b=K6ncMTPij3cZ4Mqqr9S4tIsvvmpB0rf1i5o1QRpl4mKxvq/cyUzxWrrSpSgiShcIv5POpth9dZw80VmlFUos1zVc1qnBD8Ijg5LuvJM2rLCYfuV0u7gietEIbXgHNcXNU2CVeFpFbEBO+wI5xDdz5qLNhbpoCpzr+cE1+svvBiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728799; c=relaxed/simple;
	bh=GAb1zf4JoX8VtkKKTfkRG4Fk+9YVxDUmxq/+iQW1YJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTbqUHelBHZ/ci2LkN/ExG0cbkuNnOwXmybaJOxTYhHcCQ+lrpFl2U3qA6PjamXFHztbHpAE4XIeJHdfmUljZzGq8W/C0jw66iS7LVMofvuRiIZEZk7W2Mw575fde7LXMqgGMUDNdYpY+XlZATt7CqO5iJx/S1KcqKbBmqg/t1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0WH+Oye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0WH+Oye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B441FC32786;
	Thu, 15 Aug 2024 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728799;
	bh=GAb1zf4JoX8VtkKKTfkRG4Fk+9YVxDUmxq/+iQW1YJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0WH+Oye4qFcX8PLDLzrHZlVJiLn9SLEvTgkO+a3l4znySwKrlOfxJJ680FDQ5ARF
	 81XuBhAGEFzC0AaR3ffjE+VJqosGCTuuP1vShNBWOlGZfdFQfBcSX+tr9XNb4uYPay
	 oFlrNTYM00g9Lv4ZRIgkrkz9hekgkkoNd8oZa2M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 082/196] clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use
Date: Thu, 15 Aug 2024 15:23:19 +0200
Message-ID: <20240815131855.217466637@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

commit a83b22754e351f13fb46596c85f667dc33da71ec upstream.

The flag attribute of the struct clk_init_data isn't initialized before
the devm_clk_hw_register() call. This can lead to unexpected behavior
during registration.

Initialize the entire clk_init_data to zero at declaration.

Cc: stable@vger.kernel.org
Fixes: 58e1e2d2cd89 ("clk: davinci: cfgchip: Add TI DA8XX USB PHY clocks")
Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Reviewed-by: David Lechner <david@lechnology.com>
Link: https://lore.kernel.org/r/20240718115534.41513-1-bastien.curutchet@bootlin.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/davinci/da8xx-cfgchip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/davinci/da8xx-cfgchip.c
+++ b/drivers/clk/davinci/da8xx-cfgchip.c
@@ -507,7 +507,7 @@ da8xx_cfgchip_register_usb0_clk48(struct
 	const char * const parent_names[] = { "usb_refclkin", "pll0_auxclk" };
 	struct clk *fck_clk;
 	struct da8xx_usb0_clk48 *usb0;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	fck_clk = devm_clk_get(dev, "fck");
@@ -581,7 +581,7 @@ da8xx_cfgchip_register_usb1_clk48(struct
 {
 	const char * const parent_names[] = { "usb0_clk48", "usb_refclkin" };
 	struct da8xx_usb1_clk48 *usb1;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	usb1 = devm_kzalloc(dev, sizeof(*usb1), GFP_KERNEL);


