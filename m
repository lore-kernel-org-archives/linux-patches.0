Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4EF2C235C;
	Mon, 18 Aug 2025 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524657; cv=none; b=muDdhUfUpme/UqaWT8OWtztr2LQ3gwYmITDkS49PFmm/Sj1983Lk6Pcw6AR0MiLP0iudVmM1A7NCx2f6G5wCAnXG2SsUlvWbHHWH/ItoEiRhFl6z5Ob+jP1zEF5Ht44zZlnSUSeAI92yxRnCF/8qMgtAIzrIMM74cUIztNLeUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524657; c=relaxed/simple;
	bh=lqRuHQOnuEj9Ip7LQkR0W0tCxzD0XpAtyYzDeGqAnFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fla8BUBLC9jNSFR0QKubFd3jfUN58G7oiLgvGiYvJI/6LY2W1J6oZ6DK7r/lI1MRULOOhZlwHThwjtWWEUT6zV/NWs+ikKaEyGiWwBopePx9IMvabPknyCTfqm0NUhwqTBarzewAf8hYw2Kl3Kc/GfcijmJoEd5w6OGlPb+VKHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJAYbzeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJAYbzeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DDCC4CEEB;
	Mon, 18 Aug 2025 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524657;
	bh=lqRuHQOnuEj9Ip7LQkR0W0tCxzD0XpAtyYzDeGqAnFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJAYbzeEt98573jdqCA/SPz7MCensiFACz0lx20XcN+n8Hu3ZD4MqWAJU+NoIUL/v
	 nn80XlKO02Sab9ZXR6M0ylz6B1rAIrOqqYTCty6myq9krVs6k409D+p0Z+7T7/vB3S
	 TsaROFPpmpoBm0UqcoAYmwhmNb1s6LBVb4zKWntc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Larysch <fl@n621.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 022/570] net: phy: micrel: fix KSZ8081/KSZ8091 cable test
Date: Mon, 18 Aug 2025 14:40:09 +0200
Message-ID: <20250818124506.650232958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Larysch <fl@n621.de>

commit 49db61c27c4bbd24364086dc0892bd3e14c1502e upstream.

Commit 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814
phy") introduced cable_test support for the LAN8814 that reuses parts of
the KSZ886x logic and introduced the cable_diag_reg and pair_mask
parameters to account for differences between those chips.

However, it did not update the ksz8081_type struct, so those members are
now 0, causing no pairs to be tested in ksz886x_cable_test_get_status
and ksz886x_cable_test_wait_for_completion to poll the wrong register
for the affected PHYs (Basic Control/Reset, which is 0 in normal
operation) and exit immediately.

Fix this by setting both struct members accordingly.

Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Larysch <fl@n621.de>
Link: https://patch.msgid.link/20250723222250.13960-1-fl@n621.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -472,6 +472,8 @@ static const struct kszphy_type ksz8051_
 
 static const struct kszphy_type ksz8081_type = {
 	.led_mode_reg		= MII_KSZPHY_CTRL_2,
+	.cable_diag_reg		= KSZ8081_LMD,
+	.pair_mask		= KSZPHY_WIRE_PAIR_MASK,
 	.has_broadcast_disable	= true,
 	.has_nand_tree_disable	= true,
 	.has_rmii_ref_clk_sel	= true,


