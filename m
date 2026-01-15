Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A523BF2EA;
	Thu, 15 Jan 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499285; cv=none; b=A+bpl1gGb8T8TLHF/aP2CJQRJ6DArmvlmEpz/dn8OLH0atSRjO6GUg8GNZcIg8F32coL0Ni05+m+DzJWgjhxmAS5Uz/7tYMrkzmlaKblhmZJi3G9CBM52o1Kn+SgwBH4FJCMbtruGGDh9cq3rqcys0wN882C2AN1CXvEMI5kllY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499285; c=relaxed/simple;
	bh=8VKBXgaVr/ouGQOoXAZV/8jdntauq6TeTgfccc+WA5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRbXoxwORrdZih5QNUwL018RMw7HGqqC2wWt55hroHx7s5hQArX3rt2eS9S3Ym1EA/+gCEPdY1H82mWe8jpcBKIps7Y7yDKjYGfJynrI4Ls+s+IDh+U3tv+l6AQzSHk1KxuaWBBXaBLjyE1mQm9LepCSMSDxq93P2fNIjp+ztL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLOnbkDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLOnbkDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528A3C16AAE;
	Thu, 15 Jan 2026 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499285;
	bh=8VKBXgaVr/ouGQOoXAZV/8jdntauq6TeTgfccc+WA5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLOnbkDV+0q861v9NEriHce0WeUW5CJPcb2pCcj3DAtrALWtbbQnd1QZTACmryLl3
	 IFRzWLoHOF2pmPkp+C7X0O48o1h6ucmD/oPk7OfOiNDFFY7oPJ0tuOh7HjRcL5wy93
	 dXM2Af6uhSBxs25GkIOzr5o47ADxTMgwiLcH5FWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexey Simakov <bigalex934@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/451] broadcom: b44: prevent uninitialized value usage
Date: Thu, 15 Jan 2026 17:46:15 +0100
Message-ID: <20260115164237.201215170@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 50b3db3e11864cb4e18ff099cfb38e11e7f87a68 ]

On execution path with raised B44_FLAG_EXTERNAL_PHY, b44_readphy()
leaves bmcr value uninitialized and it is used later in the code.

Add check of this flag at the beginning of the b44_nway_reset() and
exit early of the function with restarting autonegotiation if an
external PHY is used.

Fixes: 753f492093da ("[B44]: port to native ssb support")
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251205155815.4348-1-bigalex934@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/b44.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 7ad9a47156912..f29a38675afb6 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1809,6 +1809,9 @@ static int b44_nway_reset(struct net_device *dev)
 	u32 bmcr;
 	int r;
 
+	if (bp->flags & B44_FLAG_EXTERNAL_PHY)
+		return phy_ethtool_nway_reset(dev);
+
 	spin_lock_irq(&bp->lock);
 	b44_readphy(bp, MII_BMCR, &bmcr);
 	b44_readphy(bp, MII_BMCR, &bmcr);
-- 
2.51.0



