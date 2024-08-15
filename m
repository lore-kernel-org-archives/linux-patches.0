Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F491A08DD;
	Thu, 15 Aug 2024 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731379; cv=none; b=dbe991rADfT6BbwgZz9xluMQSyQ1ly6RHZ3cELepToKzp5dorOEwjCQNNRdO3QYJE68TCXgHyEwZE2OItQpwbhnhMtTrcBEgcr7wTIrkU0Vnyp7JJp7cEn9TqsoCQ02R0RvOVnnaKvskW1rWpZnZCoqFE0y5XJ8B/3FY6NrE3l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731379; c=relaxed/simple;
	bh=33b78M2euvg2BWsMDvIimuPd0ZSHF3oX+gRI/mhmEJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHWOLfwWQbVs8fQwXSZdu+qSbe1INT5MdyRfwck11D+FF7EEIQTmcJ6GGmecpSUAHx8IgQortQUHjh8er8bg7Y02JS9waRFxVdBos9mFuZYPgBOUbBmTqga85QLmdOXp35bP9MS9QSjmWvU2jlnU/0DmhoyyHKJnK8p55gj+mRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHJmvA7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHJmvA7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C6DC32786;
	Thu, 15 Aug 2024 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731379;
	bh=33b78M2euvg2BWsMDvIimuPd0ZSHF3oX+gRI/mhmEJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHJmvA7Dg1r8OijLUxOtgSX6jKKAhFk8e0OpTTW8dQ6A0j0YBNzm0cP2pKa4fYKw7
	 k38gP5IpLjQIpOaaq+pq5zUwKhfwmmEYVrWaXn8vQ1uQ0SsBkvch9kRAqE/c30XZ3D
	 ZS6RmdW4nMJ1mluwb8YnnGBsxnEaEHFvr1HmPE9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 111/259] clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use
Date: Thu, 15 Aug 2024 15:24:04 +0200
Message-ID: <20240815131907.088615623@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -579,7 +579,7 @@ da8xx_cfgchip_register_usb1_clk48(struct
 {
 	const char * const parent_names[] = { "usb0_clk48", "usb_refclkin" };
 	struct da8xx_usb1_clk48 *usb1;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	usb1 = devm_kzalloc(dev, sizeof(*usb1), GFP_KERNEL);


