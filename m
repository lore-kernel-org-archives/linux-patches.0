Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288E8149C53;
	Wed,  5 Feb 2025 14:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764816; cv=none; b=QqIf6T6SftRTgcd+iog3I81qmWPFGHxiIPDoeiFWe6l5xbUrCvsTZ5xTftYqvXzUW3rHeGswl0LB39cpxDA4QVKIltC2PWvdN8TdFT1WFFror7o2d3JISx9TWYAxylhHMY8Eqj3yvtfbZsneEAtcE/bB3L9bbGd4Ie4xBeoA/rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764816; c=relaxed/simple;
	bh=tc8GA8gVw2kh5cGVKDP+61qi/SkszBLsi2MQx/jXMzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D26/RojmCV5F4uazYBmWORt2cMWaeKKPh0wZN0ewX14/1eoBAdJC0UAVQxRPgV4G9qjEdfxf1CfTgpCL5H3YdNiaNRTL5CJCn8peoVMHZ9fLt9Qk+j7MO43pHUBGvEutW/o8z8Ctx1NUbjZITYU5U8Z5POwNDdoBHR2zvTr85ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoIhFVpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoIhFVpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5C4C4CED6;
	Wed,  5 Feb 2025 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764816;
	bh=tc8GA8gVw2kh5cGVKDP+61qi/SkszBLsi2MQx/jXMzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoIhFVpueQ/GmGvO18hT/n+AprApy1uGSCYkJ6Tv1gXa44SSvE+zm2uq92gDgCzWq
	 VAUcUZzVqBo/5D6Za0u8ZuMjT+LtjM5bQhX5M3Wnh7ekea8mIh4l9cXNj5xCocClC2
	 nqV7lUsb8S4M5+KzEyCYKA5y94CRJyPWXsPz0gws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 116/623] leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()
Date: Wed,  5 Feb 2025 14:37:38 +0100
Message-ID: <20250205134500.657343839@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 0508316be63bb735f59bdc8fe4527cadb62210ca ]

netxbig_leds_get_of_pdata() does not release the OF node obtained by
of_parse_phandle() when of_find_device_by_node() fails. Add an
of_node_put() call to fix the leak.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 9af512e81964 ("leds: netxbig: Convert to use GPIO descriptors")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241216074923.628509-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-netxbig.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index af5a908b8d9ed..e95287416ef87 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -439,6 +439,7 @@ static int netxbig_leds_get_of_pdata(struct device *dev,
 	}
 	gpio_ext_pdev = of_find_device_by_node(gpio_ext_np);
 	if (!gpio_ext_pdev) {
+		of_node_put(gpio_ext_np);
 		dev_err(dev, "Failed to find platform device for gpio-ext\n");
 		return -ENODEV;
 	}
-- 
2.39.5



