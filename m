Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7562AE9A;
	Mon,  2 Jun 2025 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875165; cv=none; b=XIQJiUa1iOIl9GTP4TgNOzK0xk2eIr3f4vHrFw5qzY7uqkU46U2IKk1D7fVzPvt6/mymAzC/BlpWtb1+UtfDhN7WqBnIl7o1VpZkND6ut/JfclJqhststbcjfO01uYI6FQaZvkSzauT8MLXGoAUx5NIKNSsZHIpsOwM247EAaJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875165; c=relaxed/simple;
	bh=aBygZHAGW9FVj1lnBuIibZ9fu3UGVpURVaj0NXRQ1kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyLo1VcKFsY8ge9+m7tsL8K4fvJre3STXWX8T6HBhSEtsgVnQZz95TfD0pGsuECTA4c0hXFM4XO8zL2YUkDAoH6365sAAMI0MjQrpRNz+OPcPY+xEYwO/jNlR1fjcxSeP5/tjI9QcGOJzPKPo3AJIoqA0rQG8yWkRahkPjgD8e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITzzC9t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITzzC9t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A66C4CEEB;
	Mon,  2 Jun 2025 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875165;
	bh=aBygZHAGW9FVj1lnBuIibZ9fu3UGVpURVaj0NXRQ1kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITzzC9t5o3RZJWx/Qhu7i0Xj6yMMj7mTEGG0rz1I76gQXJCm9ipTBqAMvY/f/Zq88
	 M9xCWm7VmmG1m8ESc9cUnptagPUp5JK5JbuggVpkN9TWFTg6QvWBnll4HdeuWHvbLI
	 QEE31yOdU5fJgi6ffFgc50OpBP89hZUlZQJuJa+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/270] net: dsa: b53: allow leaky reserved multicast
Date: Mon,  2 Jun 2025 15:45:33 +0200
Message-ID: <20250602134309.161401917@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d3428e62bef24..e926dd47b1308 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -373,9 +373,11 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
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
@@ -393,7 +395,7 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
 
 	} else {
 		vc0 &= ~(VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID);
-		vc1 &= ~(VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN);
+		vc1 &= ~VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		vc5 &= ~VC5_DROP_VTABLE_MISS;
 
-- 
2.39.5



