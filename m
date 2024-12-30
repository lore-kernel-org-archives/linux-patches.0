Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7974D15E8B;
	Mon, 30 Dec 2024 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573741; cv=none; b=Y48EdtcIV/yP2PX4vFkJoVha+6UzMgqUjLwBndmLifi7jxRUgA9Zicu6kdvrJ9uFkkOmvQTth+DvBrH+/VPIiotDWsfhW1eEpf/WA2AHPXtR8kXLZYDFrI7qY6dLO6Ex8kEg6xqS5GOS4yNSXmKEKsGravmuc6uhBbDK01M3YiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573741; c=relaxed/simple;
	bh=SIfhCKKXNrV2MQ1WoqLvTrXXdidF5k1PB5Gbqf4OQbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBvauW0BXbtNdEm0JA2mGRO/Obe2WWefobMNEGQSDUVZJNkJAW7xTgwKu8J43hGEdMWpSzQqG5Fy/er2rRLu2LNOv8TFYtFW7vcGyGyWNAjBx7Vzu8XSZyWgD4kwGRPhCZhQWvnWO+iDYxnmL+uS7E5oW4QeqtvB7CyPaM6igJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyVu4hUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyVu4hUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93261C4CED0;
	Mon, 30 Dec 2024 15:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573740;
	bh=SIfhCKKXNrV2MQ1WoqLvTrXXdidF5k1PB5Gbqf4OQbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyVu4hUzUvI1wFfg7TudcU4QlmDjd4NTJJ3RWbbPOJqjvu+TbOb9HONk97SOmL56z
	 5cY1DvoOsES537p8YxbHnuWSp1eJHwxCKTADalvNeveRWzNBUjvS/yzhvLINU8UOXq
	 fA2y+5Ut63TD4VukCUZ+21Zzk9wQFD87BlWJJQ5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 21/86] phy: rockchip: naneng-combphy: fix phy reset
Date: Mon, 30 Dec 2024 16:42:29 +0100
Message-ID: <20241230154212.527901746@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

commit fbcbffbac994aca1264e3c14da96ac9bfd90466e upstream.

Currently, the USB port via combophy on the RK3528/RK3588 SoC is broken.

  usb usb8-port1: Cannot enable. Maybe the USB cable is bad?

This is due to the combphy of RK3528/RK3588 SoC has multiple resets, but
only "phy resets" need assert and deassert, "apb resets" don't need.
So change the driver to only match the phy resets, which is also what
the vendor kernel does.

Fixes: 7160820d742a ("phy: rockchip: add naneng combo phy for RK3568")
Cc: FUKAUMI Naoki <naoki@radxa.com>
Cc: Michael Zimmermann <sigmaepsilon92@gmail.com>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20241122073006.99309-2-amadeus@jmu.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -309,7 +309,7 @@ static int rockchip_combphy_parse_dt(str
 
 	priv->ext_refclk = device_property_present(dev, "rockchip,ext-refclk");
 
-	priv->phy_rst = devm_reset_control_array_get_exclusive(dev);
+	priv->phy_rst = devm_reset_control_get(dev, "phy");
 	if (IS_ERR(priv->phy_rst))
 		return dev_err_probe(dev, PTR_ERR(priv->phy_rst), "failed to get phy reset\n");
 


