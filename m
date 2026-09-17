Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54787374A0E;
	Thu, 17 Sep 2026 18:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670776; cv=none; b=do3CuK631NTNqY6OVFQgJzCZ44tBSXhFkAh6v+NgicJFGOD6Al+dvXW2E7EUTSITkmNENKHdUMsOmg9O+8LbXz3pY7w3c6QVPe+75cumFnLTzE3cVOMLyIriUmXsy1vQ6pnDgU4G8Y+TJCt2Pe7G1fo572RKpUQDUXqJH6CU3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670776; c=relaxed/simple;
	bh=MeQL0koj55G2GKjSc1/q3Irs/PfEcEaeVDCBZh1SH8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0Xs1HJbC81a570BzJRE4p8Vm1SNIb9jh9OsObiQw67q1RdzOHlNzPcTtwAlOvUR0LJbjyrd++ZktdSuwBnPsLD6OcbRmNXpj0Qfx3hW6xs3QMh4EHbZQ/7aItEngRoPJEfISnYcCkp2Sk/QPZCa3yU5q5+202r8xNkBar13S98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsOXQih5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsOXQih5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372C01F000FF;
	Thu, 17 Sep 2026 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670774;
	bh=5Pl1JlUyDdMuPj1ih9FbfqZI/9iieaPx3TvI7SYdN5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsOXQih59TczsV8YEAm0Fsh49zo/uP4RgmwAspcpt2GHsOLzldGWQh53mJ5lnH9Sc
	 LU9JunrWthABi+gXUCdAcC8BfyUXXZxjpivtGu9WnMsZb1mOs8c5urRdHFddNbQhGX
	 845Ge/iYgNaQX1LT6XCtrF4RXuMgPXm/FF5AM1Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0759/1102] net: ks8851: Fix receiver error in 100BASE-TX mode following software power-down
Date: Thu, 17 Sep 2026 16:11:42 +0100
Message-ID: <20260917151559.484738712@linuxfoundation.org>
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

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 66ef5adb75446627f8b6c26cd04f2adc86d4de56 ]

KSZ8851 errata sheet DS80000716D-page 4 Module 3 [1] states that,
when issuing a software power-down (PMECR[1:0] = 10) followed by a
power-on (PMECR[1:0] = 00), the receiver circuit can fail to start
properly preventing communication. The Transmitter will still send
data, but no data will be received.

The errata sheet also includes a workaround, which states that,
it is recommended that the software power-down feature not be used.

Implement that workaround and drop the entry into software power-down
mode. The ks8851_write_mac_addr() calls entry into normal power-on
mode at the very beginning of the function, therefore dropping the
second call to enter software power-down mode is sufficient here.
The ks8851_net_stop() can only be called after ks8851_net_start()
was already called, and ks8851_net_start() also makes the MAC enter
normal power-on mode, therefore it is also fine to drop the call to
enter software power-down mode from ks8851_net_stop().

This will lead to a slight increase in power consumption, but it also
fixes a sporadic reliability problem on at least KSZ8851-16MLL, which
is where the problem was reported and this fix was tested.

[1] https://ww1.microchip.com/downloads/en/DeviceDoc/80000716D.pdf

Fixes: 3ba81f3ece3c ("net: Micrel KS8851 SPI network driver")
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260905130327.203851-1-marex@nabladev.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 7c336e0a4b8ae..4267c4cb1acdc 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -143,9 +143,6 @@ static int ks8851_write_mac_addr(struct net_device *dev)
 		ks8851_wrreg16(ks, KS_MAR(i), val);
 	}
 
-	if (!netif_running(dev))
-		ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
-
 	ks8851_unlock(ks);
 
 	return 0;
@@ -494,8 +491,7 @@ static int ks8851_net_open(struct net_device *dev)
  * @dev: The device being closed.
  *
  * Called to close down a network device which has been active. Cancel any
- * work, shutdown the RX and TX process and then place the chip into a low
- * power state whilst it is not being used.
+ * work and shutdown the RX and TX process.
  */
 static int ks8851_net_stop(struct net_device *dev)
 {
@@ -522,8 +518,6 @@ static int ks8851_net_stop(struct net_device *dev)
 	/* shutdown TX process */
 	ks8851_wrreg16(ks, KS_TXCR, 0x0000);
 
-	/* set powermode to soft power down to save power */
-	ks8851_set_powermode(ks, PMECR_PM_SOFTDOWN);
 	ks8851_unlock(ks);
 
 	/* ensure any queued tx buffers are dumped */
-- 
2.53.0



