Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8F437C0F6;
	Wed, 30 Sep 2026 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784011; cv=none; b=ZXq5FcAPGtuRU1whqlR6KNNeiSMbne05vJgQykrK6MvtxLXlKFsiTVwkLziNTivFduLDTLrWON2D6htVnYlG3wTWe1BBIKpp7hxUZdFOxCD5gvFOzhK7NClJAFYewe0yD9RYBn5SvFdHdwUiWsoPpMuCRrx/JvxPS++WuLLb7Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784011; c=relaxed/simple;
	bh=HeoD4dL6oMmypTFDKnauwQ9tc3SSU0dyfCfYK9JQDZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCZz90TOyoOdx9MvJJnahiI9cR9ntFpV/Iv0Xc5ib8Z1Y856fSuqhl4DJUDUb5RrhoBr2sQ4kI6onGlRqvIA8jfCUCRMjKwGJHHBDXv6nR6L2ATdZTpu9QZpOAzXAoXej82TAiJnxTlYUUvqlvFrYFqbxUN8S6FXWErGXan7fF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6jKy6HZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6jKy6HZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992551F00893;
	Wed, 30 Sep 2026 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784006;
	bh=JwyeYM69LyCAbBe/ulVYE4DTGNrFCOnw/f/7Vxwvjq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6jKy6HZO9Ybk5Y51SOLrAJjrp46YfDTHYPiOxIIeLhuQjJttsdrxfw+m+Nkt93tQ
	 /YLLMZ9XCKiamL5cs5q9X08hzqAzXtJy1tmFI7sLLymKwAue9Fi5inPQqu2pxQBQ58
	 G72d9UYgWRKOLr2dxgz59XtO3mI21XnBYiAqYKKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 5.10 592/595] lan78xx: Enable 125 MHz CLK configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:28:05 +0200
Message-ID: <20260930152400.472495691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 5160b129f65fc6e1a4aa282d44f824e12aa800ee upstream.

The 125MHz and 25MHz clock configurations are enabled in the initialization
regardless of EEPROM (125MHz is needed for RGMII 1000Mbps operation). After
a lite reset (lan78xx_reset), these contents go back to defaults(all 0, so
no 125MHz or 25MHz clock).

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20240529140256.1849764-2-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Minh Tiến Nguyễn <zizuzacker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2749,6 +2749,8 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	buf |= HW_CFG_MEF_;
+	buf |= HW_CFG_CLK125_EN_;
+	buf |= HW_CFG_REFCLK25_EN_;
 
 	ret = lan78xx_write_reg(dev, HW_CFG, buf);
 	if (ret < 0)


