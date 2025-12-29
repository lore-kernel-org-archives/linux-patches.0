Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8BC222560;
	Mon, 29 Dec 2025 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025036; cv=none; b=GnyVJbVz+oSJ6FUMvZvO2Su64WPrkcNm9mJzvmQnzsa/CTdpu3c7rIF9cfxLuwnMaGLxk9G9WBVv2Wh0YfVwaAL3yKWUkK4cW1hfOsnUlySgxcdAHWJJ/a3WgufjRS67zHzgrT4st0Evxn+QjOG9RcxaZ6dfbEgZ5i+xfIasxsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025036; c=relaxed/simple;
	bh=GCzrzRXwkRMXImIuEe6InbYfWYH2G46hFQsrofo/ywY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpqS3aBBz5wQECRhaNTMCndtv0/t5ut3A60AiPS4kP/bXDrcTZNg71GFOjq1YCCeDDYixDx9ljboQCdnfWyC5Fr4qty1sv8zVcrQVDAAXfZXtcxflYOMynQlqB6J8N2Tx7zyo+xm7TgCULWPlLTGD+ezBsWsuSRurJYDCHJZ0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0sq/S7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0sq/S7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B6DC4CEF7;
	Mon, 29 Dec 2025 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025036;
	bh=GCzrzRXwkRMXImIuEe6InbYfWYH2G46hFQsrofo/ywY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0sq/S7U4v8hfFkJN8hiV2KBO/JYlagNbMM3oMYqlLtow6mKQyXa3T+K8wIUdVnAj
	 FhPlzMPRWfbEZLx4gwpJRm3l/zbTfQ0kwaRd4wUKndDVy981X3GDU8s7W5aTOSXbnA
	 zD/Y3sYqB6Ic7zJI2OAsgZ6+eAshtiEBfMPu3Ca0=
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
Subject: [PATCH 6.18 072/430] broadcom: b44: prevent uninitialized value usage
Date: Mon, 29 Dec 2025 17:07:54 +0100
Message-ID: <20251229160727.016088419@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0353359c3fe96..073d7d490d4b6 100644
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



