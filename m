Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B71F332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301228; cv=none; b=imPp3yc/XivOdhLgUHiB7dh4DDUjC/iMutPYpiZCD5/U+j8K/qBEItM0eb4QJdj3oL4/DdwENmcaJKfBnnxPlIQHaH6CLIU1upCXq+POOV3eyYOTd9ZyPj1GF7Gi6PU2uEAdf/gT/8Uiqc+OtWlxCxvXjJTZOKuDOiI3ciZ9Lqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301228; c=relaxed/simple;
	bh=zaLi0pMp0bWbvEXHJsbhu3SFVHOuKzj/+3rDcft9+5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=synrXOs6yXEqqMmoOc56w/jnOL50vh862ORZ6bFZottu1Xoa4JGwP8vIIKzLwj/n/EO9oc06bVjpPiOHovRX/f5C7yXUe7GxYc+T2lC3Y0O+N46EmkB4d3rwY7P+XjLqojHBl4dDBem9kb4wqQP6Y4H2iRzB5g9++yQhk9+RXUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmTMy7Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmTMy7Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F114FC19425;
	Sat, 28 Feb 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301228;
	bh=zaLi0pMp0bWbvEXHJsbhu3SFVHOuKzj/+3rDcft9+5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmTMy7KwSIZKCmVzCjBwqmcQjH8pi0UU6SVKzaVcz4dIX3poSzgJ6Ud/hW6si5ozI
	 8nMrxzVQt6RdNgzOS2zVLVhcSSb3bt67BcXPdmBtrIblMYQ5eA4Ml7zhbAFaQWBDog
	 P2grQVAeHgIaWCtwsmn+lB6Rm3sop6wqMwCX2URA5UMYy54aG+uXQm7FqGKQQcLAMX
	 J3OVgMYakqgeUgA7gR+Z/9bAGX5zIfdxL43cOQXnQ9bUA1Xr9NCTHXlVHHbq+92YH2
	 TRG+jYnzAH/l98/E1/BYcxcvTujBJR5d9jrYCvnNlJYSTeZRqIFJJQ41qe0l4hjAql
	 KYHXPvTCS9WqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Martin=20P=C3=A5lsson?= <martin@poleshift.se>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 406/752] net: usb: lan78xx: scan all MDIO addresses on LAN7801
Date: Sat, 28 Feb 2026 12:41:57 -0500
Message-ID: <20260228174750.1542406-406-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Martin Pålsson <martin@poleshift.se>

[ Upstream commit f1e2f0ce704e4a14e3f367d3b97d3dd2d8e183b7 ]

The LAN7801 is designed exclusively for external PHYs (unlike the
LAN7800/LAN7850 which have internal PHYs), but lan78xx_mdio_init()
restricts PHY scanning to MDIO addresses 0-7 by setting phy_mask to
~(0xFF). This prevents discovery of external PHYs wired to addresses
outside that range.

One such case is the DP83TC814 100BASE-T1 PHY, which is typically
configured at MDIO address 10 via PHYAD bootstrap pins and goes
undetected with the current mask.

Remove the restrictive phy_mask assignment for the LAN7801 so that the
default mask of 0 applies, allowing all 32 MDIO addresses to be
scanned during bus registration.

Fixes: 02dc1f3d613d ("lan78xx: add LAN7801 MAC only support")
Signed-off-by: Martin Pålsson <martin@poleshift.se>
Link: https://patch.msgid.link/0110019c6f388aff-98d99cf0-4425-4fff-b16b-dea5ad8fafe0-000000@eu-north-1.amazonses.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 00397a8073934..065588c9cfa65 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2094,8 +2094,6 @@ static int lan78xx_mdio_init(struct lan78xx_net *dev)
 		dev->mdiobus->phy_mask = ~(1 << 1);
 		break;
 	case ID_REV_CHIP_ID_7801_:
-		/* scan thru PHYAD[2..0] */
-		dev->mdiobus->phy_mask = ~(0xFF);
 		break;
 	}
 
-- 
2.51.0

