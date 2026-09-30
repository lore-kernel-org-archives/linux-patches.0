Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2B651CF51;
	Wed, 30 Sep 2026 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792730; cv=none; b=YHHRLen+D35/+1wHfMCZQeMXrDrkIpPD58CuJph0d9aoDWi7bbNzfg81tgOmZgaopdqKWg6k1sG1ctYK0audoQMWLBo5TBj9yrLxo7pbAYa0OUg6XW61+QF7d5YnTe469WjLHoR7yHJtavmoXaoOx5pVecRrqozHdGvd7j1nFDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792730; c=relaxed/simple;
	bh=xPFtBG29Td4gl6VqQeoDlxakxJ7SDF4y6CeoQfFUwrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiSinPmF6Y1hA7FBDuzRw8TJbAUvXD8wdWVy1mSINeUbb28kUwcVrlXvew+T4eAM0XdBxVtb4NwEI84wu87PFG/FPOUolYqKT8o64jopV9MenkYghCkY51v5t/KIuNn1hL1o6Z3nzfRCfaR2U6fVVVfPUJb1D6oPXd8riZnVlOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtQDmJfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtQDmJfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32081F000FF;
	Wed, 30 Sep 2026 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792729;
	bh=FevpGgi6nbCXHikTk7i3syCK64GPaT1TsOvvri5OXLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtQDmJfLePDKH/Jx/9r97M/2ewwtTPhYEJQ6fb/226DgcER7Vqk7ICg4WanyoVDa4
	 WPTFjcajrEJIn/uXtD9RgxPghAo+6d+2174P1N+bsZixXfunnJz1OvWratGfdBzlJr
	 f2AqBNuGVAA/83dD9ThL0qhWmlS+jseBPkf2Qa4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 5.15 751/752] lan78xx: Enable Auto Speed and Auto Duplex configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:30:21 +0200
Message-ID: <20260930152414.466566724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 799f532de13601f91ecb9cc6169d45d6e6933b0f upstream.

Enabled ASD/ADD configuration for LAN7801 in the absence of EEPROM.
After the lite reset these contents go back to defaults where ASD/
ADD is disabled. The check is already available for LAN7800.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20240529140256.1849764-3-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Minh Tiến Nguyễn <zizuzacker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2894,8 +2894,11 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	/* LAN7801 only has RGMII mode */
-	if (dev->chipid == ID_REV_CHIP_ID_7801_)
+	if (dev->chipid == ID_REV_CHIP_ID_7801_) {
 		buf &= ~MAC_CR_GMII_EN_;
+		/* Enable Auto Duplex and Auto speed */
+		buf |= MAC_CR_AUTO_DUPLEX_ | MAC_CR_AUTO_SPEED_;
+	}
 
 	if (dev->chipid == ID_REV_CHIP_ID_7800_ ||
 	    dev->chipid == ID_REV_CHIP_ID_7850_) {


