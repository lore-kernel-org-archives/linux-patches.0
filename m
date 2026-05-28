Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1143F282F17;
	Thu, 28 May 2026 20:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999651; cv=none; b=DsPWnSR7QNeOXKyS7kOnIobI9uOuC6Eym+jqe0GSADuZGyIptNMoiD+ocayW6VtOhPhts87fDmGRIdxrkEv4gLxpcr+7qz1XyByhwwahnfXPhvZtvzHSZYH/y9ixns8ffV3XPRPhYxVhqWF6mrjewVZuVGC/wdcjMLNVocLsheM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999651; c=relaxed/simple;
	bh=bEKBiQ5NCrUvQ5aOxDoaNVbppZk3b5idv6pnHyLJZKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPlbkdueVQa+ws4rTQVtvH5pgXHDmAKHwl3tVwC1KlKccT+vlM+cntSJdZZvaGtA8f77GH4kKqbKqsh+tyc6SZELLpEYGBz8356FLUz8eNAR7uNGwylLqMfLs+XASXbGQ7MtYwGKJVC8YE9/YIY9SVFjbsnd6HYwxSlg1TG5Bwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv9Inp1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv9Inp1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E46B1F000E9;
	Thu, 28 May 2026 20:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999650;
	bh=UR3j1OyF3gLhmeDu7L39ht/VST/zfJlqf0odHPCdL/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wv9Inp1UPhFVg3P5lqpafxY8XLSdHKeC9WzMiJ6DU9bddG9dr0OMPFtxokb24H0jQ
	 90hCSq1izwUCiQoAYeivytQWDOMAcQ6rJTkGrp30oAJAawKnnvhsefHrjpzRZ77OEz
	 pmr48poUe8xpBL2oNvtJcpyPeGs5ynkCwJh5UzH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	=?UTF-8?q?=C5=81ukasz=20Lebiedzi=C5=84ski?= <kernel@lvkasz.us>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 115/377] phy: exynos5-usbdrd: fix USB 2.0 HS PHY tuning values for Exynos7870
Date: Thu, 28 May 2026 21:45:53 +0200
Message-ID: <20260528194641.665769264@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Lebiedziński <kernel@lvkasz.us>

commit 5a759b120e31aa3ed914d98b51eb1755235250f2 upstream.

The existing PHYPARAM0 tuning values for Exynos7870 are incorrect,
causing the USB 2.0 PHY to fail high-speed negotiation and fall back
to full-speed (12Mbps) operation.

Fix TXVREFTUNE (transmitter voltage reference) from 14 to 3,
TXRESTUNE (transmitter impedance) from 3 to 2, and SQRXTUNE
(squelch threshold) from 6 to 5. Also explicitly set
TXPREEMPPULSETUNE to 0, which was previously missing from the
tuning table despite being included in the register mask.

All values are derived from the vendor kernel for the Samsung
Galaxy A6 (SM-A600FN), as no public hardware documentation is
available for the Exynos7870 USB DRD PHY. With these corrections,
the PHY successfully negotiates high-speed (480Mbps) operation.

Fixes: 588d5d20ca8d ("phy: exynos5-usbdrd: add exynos7870 USBDRD support")
Cc: stable@vger.kernel.org
Tested-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Łukasz Lebiedziński <kernel@lvkasz.us>
Link: https://patch.msgid.link/20260406135627.234835-1-kernel@lvkasz.us
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/samsung/phy-exynos5-usbdrd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/phy/samsung/phy-exynos5-usbdrd.c
+++ b/drivers/phy/samsung/phy-exynos5-usbdrd.c
@@ -1905,13 +1905,14 @@ const struct exynos5_usbdrd_phy_tuning e
 			      PHYPARAM0_TXPREEMPAMPTUNE | PHYPARAM0_TXHSXVTUNE |
 			      PHYPARAM0_TXFSLSTUNE | PHYPARAM0_SQRXTUNE |
 			      PHYPARAM0_OTGTUNE | PHYPARAM0_COMPDISTUNE),
-			     (FIELD_PREP_CONST(PHYPARAM0_TXVREFTUNE, 14) |
+			     (FIELD_PREP_CONST(PHYPARAM0_TXVREFTUNE, 3) |
 			      FIELD_PREP_CONST(PHYPARAM0_TXRISETUNE, 1) |
-			      FIELD_PREP_CONST(PHYPARAM0_TXRESTUNE, 3) |
+			      FIELD_PREP_CONST(PHYPARAM0_TXRESTUNE, 2) |
+			      FIELD_PREP_CONST(PHYPARAM0_TXPREEMPPULSETUNE, 0) |
 			      FIELD_PREP_CONST(PHYPARAM0_TXPREEMPAMPTUNE, 0) |
 			      FIELD_PREP_CONST(PHYPARAM0_TXHSXVTUNE, 0) |
 			      FIELD_PREP_CONST(PHYPARAM0_TXFSLSTUNE, 3) |
-			      FIELD_PREP_CONST(PHYPARAM0_SQRXTUNE, 6) |
+			      FIELD_PREP_CONST(PHYPARAM0_SQRXTUNE, 5) |
 			      FIELD_PREP_CONST(PHYPARAM0_OTGTUNE, 2) |
 			      FIELD_PREP_CONST(PHYPARAM0_COMPDISTUNE, 3))),
 	PHY_TUNING_ENTRY_LAST


