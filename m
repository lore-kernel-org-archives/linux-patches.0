Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C5142CAE7;
	Wed, 30 Sep 2026 19:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797163; cv=none; b=NdneEjw/MRdw+v+e/jwWy6aLqAUwVME3zxMrTRCjPuPEd62476E8S8tFo4wijNJPWuwlxHzmMmzZyCXPlrA7RPhwC5gMk0ZynKm62eaWNeDxHiYIgMGhN9eWBfOlBdCwMtP6JNZAxA3FvinaUUt5gYAIRhSMM4G2FP3zcrsm1GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797163; c=relaxed/simple;
	bh=B9JpUJrwOxFreiCpYm7uhThiq1c9eKJWEt6NXZKIBew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKGz7ZpXTPlvEvAlVmJyTtn3Kva5nIIdLiJbf/NU3E2PZa70sPlCllkaXO0nBmoM1Et5K7Ft4MwGOMoCZLIEDkbJKjtMjQl/MglNpkaWOElWs6NWtDyUd8oO1X0NP90rnKAu6iWiMNateBAUuswlkjBB/2B4uj4uHmzjOwXYnpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMiLvJKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMiLvJKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DD71F00898;
	Wed, 30 Sep 2026 19:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797162;
	bh=PC5eFHxl63PHjXnO8qbv7hCFD2dgmcMI6Ru765Fh7uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMiLvJKGHVh9N2XQ/41hXYLQbfOI8TrqWGOMjmse9JR+fxUFrn4um7dOsxiF+ZN3r
	 06f2932zOMeMQl2KEKp6AFChJ8keioqAI5KJZMdUX3E0SpR3Aevq+r4yXtft3zjhLC
	 DN54m3an8gKUHSPE633h3lgq1o12ovzbtKGoiU7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 6.6 1169/1193] lan78xx: Enable 125 MHz CLK configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:30:53 +0200
Message-ID: <20260930152500.215217792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2979,6 +2979,8 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	buf |= HW_CFG_MEF_;
+	buf |= HW_CFG_CLK125_EN_;
+	buf |= HW_CFG_REFCLK25_EN_;
 
 	ret = lan78xx_write_reg(dev, HW_CFG, buf);
 	if (ret < 0)


