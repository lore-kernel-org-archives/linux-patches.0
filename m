Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F144C50254F;
	Wed, 30 Sep 2026 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786794; cv=none; b=GeYgHT6Z04o71RAhRt7ctW58jirKB/5MjHzmotBbLyLd4oWM9x5HPKnluIQ1b8KE8Zci2dmOiuERFKiiiiSL6uCWA8bvQ+F3l8fPtgudfNCNOTUqvzJfJvootDenrnc6CORwR3O14QzFK4C/kWz2szAmIJz6Jws5DZSMqJ+Ho8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786794; c=relaxed/simple;
	bh=qTizyX5tTsGSdSQu02J0EgppfX8Km4RJKjBfzL4XSYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2BE6AZLnbhh6bBUfvjNNdS91ufc8dUrSNfcj36G9fVfoDRxvNC68y0UAZencYhvy0iuIE9TOcRedyZ+hsH2O1JoWtSoPZdLOKCg2HqpJMJyWRAsBw9SOg10BKr+HJcIvkUFmDQAeRTSVGz2XQU0BddgK7kGoBuB9gegr1P9ecY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC9av96C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC9av96C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD61F00893;
	Wed, 30 Sep 2026 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786792;
	bh=FwbcKXKZVZhyaK7AvoO/K3U55EqppQSswgJliTPkii4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC9av96C8xyf72fbSixHeu6jGKVDPdE6PoRaz49LVW0qyw66uvncm3oYg6sESIkaP
	 TouvBn8MIBftS3YlcW5jo1Z6z+YJN+95aoFC/lDQuTa5on8XbC0moOZx9RJA/3wU5J
	 NNXpB8niWbjf6knQhy2Mt8RtscjhVWVCjOSIO5K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 6.1 980/982] lan78xx: Enable Auto Speed and Auto Duplex configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:28:36 +0200
Message-ID: <20260930152437.794143331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3069,8 +3069,11 @@ static int lan78xx_reset(struct lan78xx_
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


