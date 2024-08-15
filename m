Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B3C63D5;
	Thu, 15 Aug 2024 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732366; cv=none; b=LTe4++uCfhs+zy5lpcvLTW8+ByJ/IdI9IW9+J30sBKilAWpUMLrpO3JxEOTebpC6+ermPZi2WOfPFIe8ZPUbwWUtsBRAv/YvM/vI8446qZ6XKkEnUg7Om/KKWBC96jK0oB9AMR94lrFz7EWmwcPrT7CwqI31Opvnt893X1cFwAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732366; c=relaxed/simple;
	bh=yL0pPvth8NFzNjv4foUlcMtHfzMphMXC/bQq0WMGCWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6jMxnitYS2LWSVG/CaLGBoSF9GX2mVOwDYqq+5mJbCmnHWqD5W0A435V/2Eky8mTzrANcdwACI8GkUb6hiR1fql4VUCdW/qTqDKl88eIMaLkE9eHXNt+eMlabjnNP0KKvaAnXF8llGQ965TgvLzbHR86OE/xfqg13xlI+v3TAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwxFuYY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwxFuYY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E17C32786;
	Thu, 15 Aug 2024 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732366;
	bh=yL0pPvth8NFzNjv4foUlcMtHfzMphMXC/bQq0WMGCWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwxFuYY705GcZZLfGS1Da7CXuJ++d8elEWjo+59j+S7sX+brjXJPHCTHUjTTEelMY
	 w1mwF4MBAsb8eFh5r+nfABLMWPW47ly9VHj0i1YLd9Um/QSxjYb1jX3J7QWIIcLACv
	 bOaai3T/+4nDcswxdJkG2bJK1xVSzqUkLkAqCAk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 158/352] clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use
Date: Thu, 15 Aug 2024 15:23:44 +0200
Message-ID: <20240815131925.376714932@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
@@ -505,7 +505,7 @@ da8xx_cfgchip_register_usb0_clk48(struct
 	const char * const parent_names[] = { "usb_refclkin", "pll0_auxclk" };
 	struct clk *fck_clk;
 	struct da8xx_usb0_clk48 *usb0;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	fck_clk = devm_clk_get(dev, "fck");
@@ -580,7 +580,7 @@ da8xx_cfgchip_register_usb1_clk48(struct
 {
 	const char * const parent_names[] = { "usb0_clk48", "usb_refclkin" };
 	struct da8xx_usb1_clk48 *usb1;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	usb1 = devm_kzalloc(dev, sizeof(*usb1), GFP_KERNEL);


