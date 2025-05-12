Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68761519B8;
	Mon, 12 May 2025 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072812; cv=none; b=G8bTJlX0ubH0B2SAF5mMSLhyGrZVU/K4vpJCQopmNGIRcCz0voxjoyI20IGmH5JxyU3E6msWHK6cY2eyhc7O8GEMWAjVlLwn9m0yr3dAeY0ip4p//UQGmYoONBMgDY38bXRvhYA21BwTE9Wz1TJx3YnY901GlhaALe0L4ICbqaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072812; c=relaxed/simple;
	bh=A7Pu36E0p8KH35miq2LLKphPOBkD2N6Tt6EZymANUak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qODeEqGZLAoywALf/wK1WnFG/Wm3O2+EcNCvdLzNMf8ki3CFmy5cX3nTi5SsEkO2BA+BOIOLDiyasTWKPs07YxWOnjcXfZBhNwy8zZP3nJCOWMy2gSqSwHz+rbrglFN/RquGdnbZHPEXejHlLowDx0COIg2c8r+x7oaH5NQeZMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYv8EbUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYv8EbUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E51FC4CEE7;
	Mon, 12 May 2025 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072812;
	bh=A7Pu36E0p8KH35miq2LLKphPOBkD2N6Tt6EZymANUak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYv8EbUjbGU970ubB+J6JDAx/SREpIQ45FpSgIFHtEFKVqQFrcw2t7DcoUUn4SmkB
	 n4R8uDFjm9RODrnwdl9Pta/xM0YXSgvLJd94XKmH6SJijgJxclA636bm/hbZvbYY/i
	 GzgyiMYp2W0HDEQ1l9THjKAQrv28/jMuNRbQgbwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/184] net: dsa: b53: allow leaky reserved multicast
Date: Mon, 12 May 2025 19:43:56 +0200
Message-ID: <20250512172043.154741005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 5f93185a757ff38b36f849c659aeef368db15a68 ]

Allow reserved multicast to ignore VLAN membership so STP and other
management protocols work without a PVID VLAN configured when using a
vlan aware bridge.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d4600ab0b70b3..f327fdeb81850 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -373,9 +373,11 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 		b53_read8(dev, B53_VLAN_PAGE, B53_VLAN_CTRL5, &vc5);
 	}
 
+	vc1 &= ~VC1_RX_MCST_FWD_EN;
+
 	if (enable) {
 		vc0 |= VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID;
-		vc1 |= VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN;
+		vc1 |= VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		if (enable_filtering) {
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
@@ -393,7 +395,7 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 
 	} else {
 		vc0 &= ~(VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID);
-		vc1 &= ~(VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN);
+		vc1 &= ~VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		vc5 &= ~VC5_DROP_VTABLE_MISS;
 
-- 
2.39.5



