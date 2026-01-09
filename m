Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B735A923;
	Fri,  9 Jan 2026 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960254; cv=none; b=FENHKbGpY5YYz2eYsHQCrn48ASYimJIvL7jae1kCMsegg9HgXRZA1zD/e2gPlizTglurEV7bBN3gUiY/I642qbKzdnEgeC5REz/LMvSNEp3wCglENtu3lWcoD60zUD1DHxRWEhaH15dZxSytGt/fT+uEOL3NhbWt3ONDTIALrUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960254; c=relaxed/simple;
	bh=RapC4nHjmoyqOCrEgyWULpx5qp7G1P/ZnHlehpljzAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZygolFMd8zmBwDiIJprpKFPsFoPRYZ73+xL/jZyEicFT5d8v7QIrhXA7m4f8Y3ZXhvk+NQQWw6ZhnKRRf2vfKd6omYLFtp7ToqsmtZgM9AS/6iRAUIqypi4brPA5wa1YRQ+JjA+yxZUmzmvvrWBYQ8m/LIH3gSilixicg9uJfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvXAuNtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvXAuNtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090A9C4CEF1;
	Fri,  9 Jan 2026 12:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960254;
	bh=RapC4nHjmoyqOCrEgyWULpx5qp7G1P/ZnHlehpljzAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvXAuNtHQj4eCjP/fZ8O8hNYU5+qs0RTM4oYoFSV0k6559yvxyylMoC06bcGILRRM
	 dZzZzsXuiGyWYCyIsRaqO730HODC6y5KpXVIN8oZP2U8DNwabDUyiogxtbMn3d6Hxq
	 TOv/yU6Nl5sgxOHgbIWNv0sP9wlVN3NU8nBCYMio=
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
Subject: [PATCH 6.6 339/737] broadcom: b44: prevent uninitialized value usage
Date: Fri,  9 Jan 2026 12:37:58 +0100
Message-ID: <20260109112146.742430421@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1be6d14030bcf..ba40549536e46 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1789,6 +1789,9 @@ static int b44_nway_reset(struct net_device *dev)
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



