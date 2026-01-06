Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D0A33858A;
	Tue,  6 Jan 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719834; cv=none; b=MHgK8uLJn/Gv/oUpMHik9Oru3jWgNPKoK8t++VIzlZtAyl48ty8pi/NDKaZvEn9VYVHhl4H/V/N8Qyz732stdWHJPeC0dt7d80F3n6Xl/Jdw4vUBgxHHx/nXRHvApJuVzbZbDxFGKZjdNwYX0GNgPQJfEUztONE/QPFjwT3me7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719834; c=relaxed/simple;
	bh=PhoI40tkAbBjqQBv9rQQJJuZO/JXGL/oRpgyAEMqJAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7SwCrNUQlgsHFV/abz7/6aitMtY6L0Go3ghKEdi4xwD8mfh677oEaXOFomO1+kTwtXkOPLiIVf38kLmDcp05pnMUlxlR2H0Qs/zuyGB3auJ70rzPcEL03vXHYruaQlm1taDEGrmdEPsczJZW7GPfjj8YRxQXwT6fsNtJGBQkIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVAX4KIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVAX4KIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458DFC116C6;
	Tue,  6 Jan 2026 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719834;
	bh=PhoI40tkAbBjqQBv9rQQJJuZO/JXGL/oRpgyAEMqJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVAX4KIwZb7PFsLK3sIivRmSeAl5IxcfA1fBgxd46Nb/ggZcVHsT8NdU1yXTm55Zu
	 +7SY9gXD8habwUe9vEPRAh5JV5gSYgucqd18tSOFxXRdt0fSGL8h2LJCr1ewPtZIL8
	 Ne8q1IPOXbssPtLivCNJfG0k1G7SVb7Dn3oMys8A=
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
Subject: [PATCH 6.12 054/567] broadcom: b44: prevent uninitialized value usage
Date: Tue,  6 Jan 2026 17:57:16 +0100
Message-ID: <20260106170453.338679476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5809ad5eb827..29f0de9e31545 100644
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



