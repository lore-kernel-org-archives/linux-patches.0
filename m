Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6601E21CC5A;
	Thu, 15 Jan 2026 17:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497861; cv=none; b=BXRbTrZYLM1+bnEu7Mx9CTFdA7IYKqJ1yb0v1tjtFEihCl/DMsuaa9EgpLNhTbtOxvalbI9d6HmJcATSb5PWXi+i1RKOMeWRJcfyfWB2fngUIov9gwUqNMtMTTgYxCOXBVhBt3VgP96Jcsx90GtwSkPO3/DwfrNqitzoqn8cD6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497861; c=relaxed/simple;
	bh=ACKYjJbdk3r08RXr4A93bRVInzLWdonXVymRcimWYgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWZ1KB/nFMeOhQnobLu3oPrucnB34Wh5iGAwrxejeMcrqPfrhlurLagd2waE6aNRyR9uV1GM9M/wBVVGqh/SM8Vrb8t00ZgeWzejYM/T4nZiJd4aIT/Jck5l8YbLRVrXNX3SXgrkRVK0IzecDLe5eMXqtAc+dL9yejAUc+nroKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJMSUvTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJMSUvTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FF3C116D0;
	Thu, 15 Jan 2026 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497861;
	bh=ACKYjJbdk3r08RXr4A93bRVInzLWdonXVymRcimWYgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJMSUvTm1KfnAymNkJWjF1E2ornJSXJcuUdRip1K+tr47PGQvQJrcIxUtVV8uNZq7
	 RFZqEaK3uEpgMXYQ6krLMaj2HmHSJFh7sSKY8jcoSCriXlV6LpV06ZtEo1vo+FbPD7
	 7C4rBWHrKP4kfBhEGLL/88dLmqVe48VnMvBQnf+E=
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
Subject: [PATCH 5.15 229/554] broadcom: b44: prevent uninitialized value usage
Date: Thu, 15 Jan 2026 17:44:55 +0100
Message-ID: <20260115164254.534772691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ce370ef641f01..3c4e0a78b8a03 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1811,6 +1811,9 @@ static int b44_nway_reset(struct net_device *dev)
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



