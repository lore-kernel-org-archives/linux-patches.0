Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2904A3C9EE5;
	Wed, 30 Sep 2026 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795498; cv=none; b=SfaFYSY2r2gUHqu9vfwJGgDz6E92izGY2nSksLMoXcnBwjnvN75eV9KyC0sVaYrX+3f3frxh99/Un8dy06vuz6Yw/QI/TzgT68I07zhNRo0dvvP5vzoRs9dQc6odZ2hmCc5gFu7zaztMTkz3r8LQKqCPQeITtQa3nREtwR1210s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795498; c=relaxed/simple;
	bh=hCx35gaDQDB8HEx3JANh6Mtln9ZvaNnRt0lA5ShtlQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dy+5L7gI5nOvx38mXi0qbn0LzOLVs+Lzx/g+FkfbR9n67vzzGeEa/7hBnP929sGWmhVMECrdc2Z6/QaX+/XQaZzc/bQyrAzRewtDcap7t3280xsQ0XV31mFgLQc595XZ4nrKbZm4MN9gSj1I+v1cBGZJLcv0zkfpt60hRuCr3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjLn8/Um; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjLn8/Um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BED1F000FF;
	Wed, 30 Sep 2026 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795496;
	bh=VORB7YFGSBpPpOYY0oPYbSmxrJOtW0VLwmhcmoH5YNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjLn8/UmT40ql/TON+S/10/Mme1vFxR5n3wCtBpAr1vZjWnIQ6VJfsuJAGLmsNkFT
	 yr4u9ZXH7HFqym9TY7uZ1IPlnlGcZZ76rSaqJwoFU5V0CDDBlxMqaw2D6Avd1lvSHT
	 ZwVUKhVlbK4CW9LtIzkzM8saJ5B4DGoY72RMYxIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0565/1193] net: ks8851: Fix receiver error in 100BASE-TX mode following software power-down
Date: Wed, 30 Sep 2026 17:20:49 +0200
Message-ID: <20260930152446.793914583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



