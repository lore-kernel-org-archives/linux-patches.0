Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4072258ED7;
	Mon, 18 Aug 2025 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521418; cv=none; b=NCCfEmm35o59k/T07IBJRRfitexIkk62X43invLi+HM85mFvsRSigQd7YS+rEVS+a/1nEHTT+l1O6cf1dCD4Np8YyD4p/NyqkV5640dTLb0Sbhohyjn0/buaIdbNcUbPv1aOse/6nRTNupw2tTD5RuXSvW8g1SYvYEISho1AdTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521418; c=relaxed/simple;
	bh=QmNlPg6yYCzN+85V7MbH3tWRyB/Jk+TW0odXRZ7miIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC0OPTLPq4HBJV3ldwzNs8rwQpfsGFTm5jzyVelirFuwOxiXbD92tm52y4TopQBWPiQa+pEJuhRedXUcr01Rt5zN1q4fzRMlXRJVA2P+5pELge+G8rG61UP1WGKI/bRtY60ZYsIQE7FqQRBd6vzgnELrXA9P+//aIPbNYd9qMn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMDkcKzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMDkcKzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC186C4CEF1;
	Mon, 18 Aug 2025 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521418;
	bh=QmNlPg6yYCzN+85V7MbH3tWRyB/Jk+TW0odXRZ7miIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMDkcKzn/c1noiaMSgF04RK1Fv03UCtNOcc4hKGCUJeoyvuprwyLGtSBjcFgNCjjF
	 11m4r7A98tOSckqyPXWM6+D3AcjFWWhccj9/AH8FCM/72IZr2nmbzauP7PmVFv+KkD
	 nwLvLiFm/bUl2IHw3MiANwK+Oh8bg3FwWQwzJP8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Larysch <fl@n621.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 015/444] net: phy: micrel: fix KSZ8081/KSZ8091 cable test
Date: Mon, 18 Aug 2025 14:40:41 +0200
Message-ID: <20250818124449.475074909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -470,6 +470,8 @@ static const struct kszphy_type ksz8051_
 
 static const struct kszphy_type ksz8081_type = {
 	.led_mode_reg		= MII_KSZPHY_CTRL_2,
+	.cable_diag_reg		= KSZ8081_LMD,
+	.pair_mask		= KSZPHY_WIRE_PAIR_MASK,
 	.has_broadcast_disable	= true,
 	.has_nand_tree_disable	= true,
 	.has_rmii_ref_clk_sel	= true,


