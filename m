Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CE454706B;
	Thu, 17 Sep 2026 18:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670754; cv=none; b=ABBUaXHjG5G1zAvcOqyfYgJTw7rr2OarhFqSy5/BLsdAN1X0GvZwlzS5QhYljmyZVjYgE4wXDzbxHqpOFWls5rxY/RYxROmWdbF1Mwofd996ZX7MxMLtQ8Xg08sjy9Pro2RQYLRyt7G0ZZPRjHmxD/njWNrRZQBoXGmo3tRHW48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670754; c=relaxed/simple;
	bh=2tpcjhgT01sGB/vqq1gInpVwpzgq0BjzPc+F5pZ2eRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sI+fIBW7fqAVSazzACYkkTg7qUU9SbHkCYzbyivaSJsMC2uEkczixNjT6iDwQjyHCePRqBGMG/45o8FiohimWwpZsAv23FJNNs9hFF0wNgIJGqiL5fpMVTucdedH3ts0F8/DEK3ccyu+jQcV0H2QDtMTeBcfrybNoFY2Cu/wVrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxaudHPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxaudHPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C015C1F00893;
	Thu, 17 Sep 2026 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670753;
	bh=+doVaL1lR8R8335qRf5Xhn6q8HygmsB4NM3Ik0KfoPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxaudHPIhmsv1M2gFCA6nT1/n9nIpWuGUtZofIQZl2ZwT0GYmBWYNcJbLvmP+60kV
	 nNZYD6C/CvobX3nHMSwjzY6LHQ5xNxZOT9eJJ93fkz4m1yHsmB1tYarowHWnETx9nw
	 dgnCIUWAEtLQDhgJrS6VVMX00vvP0EBHamrdBXhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jan Havran (Advantech Czech)" <havran.jan@email.cz>,
	Daniel Golle <daniel@makrotopia.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0757/1102] net: dsa: lantiq_gswip: fix GSWIP_MDIO_PHY_FCONTX_EN value
Date: Thu, 17 Sep 2026 16:11:40 +0100
Message-ID: <20260917151559.432707582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jan Havran (Advantech Czech) <havran.jan@email.cz>

[ Upstream commit 59fb389ad6bf50916189e56dafcd225ab977f874 ]

Per the GSW145 data sheet, the FCONTX (bits 8:7) and FCONRX (bits 6:5)
flow-control fields of the PHY_ADDR_n register both encode 00 = AUTO,
01 = EN, 10 = reserved, 11 = DIS. GSWIP_MDIO_PHY_FCONTX_EN was 0x0100,
i.e. field value 10 (the reserved encoding), instead of 0x0080 (01 = EN);
FCONRX_EN is already 0x0020 (01). Enabling tx flow control therefore wrote
the reserved value.

Set FCONTX_EN to 0x0080. The register is shared by all supported parts.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Jan Havran (Advantech Czech) <havran.jan@email.cz>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260907134818.16670-4-havran.jan@email.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.h b/drivers/net/dsa/lantiq_gswip.h
index 8703c947028a6..7a17f8cbfb1e1 100644
--- a/drivers/net/dsa/lantiq_gswip.h
+++ b/drivers/net/dsa/lantiq_gswip.h
@@ -39,7 +39,7 @@
 #define  GSWIP_MDIO_PHY_FDUP_DIS	0x0600
 #define  GSWIP_MDIO_PHY_FCONTX_MASK	0x0180
 #define  GSWIP_MDIO_PHY_FCONTX_AUTO	0x0000
-#define  GSWIP_MDIO_PHY_FCONTX_EN	0x0100
+#define  GSWIP_MDIO_PHY_FCONTX_EN	0x0080
 #define  GSWIP_MDIO_PHY_FCONTX_DIS	0x0180
 #define  GSWIP_MDIO_PHY_FCONRX_MASK	0x0060
 #define  GSWIP_MDIO_PHY_FCONRX_AUTO	0x0000
-- 
2.53.0



