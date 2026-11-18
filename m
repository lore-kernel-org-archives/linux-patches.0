Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046331;
	b=a43j6autVLEFC/XBzXQSkJe/EALy9GDmy7xqy0TYuD3FM6vxdmOPFKE7RE33xrLkxzIn
	 1NIsobnl4TQK6R3ffpVKaJ4jRDd7PzwHHmwubKSt6qZaxmU4hBlTjmp7QPWZxpdIwC7Pi
	 DlxGQUiVV2a5R1YWEjUnMkHwRzBnheJDw5YApgELpDL5UGxGmLlOtJ0+ezTp8+PJXa8jd
	 UU5JgkG6N38AwhfWJBduUyAqcN4+OZVhJyv5vjljdHUFGRqn0Lamnkn/l7r9+TON3mu28
	 WOoUs3tOCps6ZPOBtBeS3Y8/WuUrWw6yQpcT4U66MesPfuFhkItXvRTKU88Sl7MRphA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DwGhWB3pg9waRAfTBnvSNzlAW6OscIXLzzCPYoHj/Ic=;
	b=TqYFasyDcBtcwXCZcuUJer7P+CtrXrHuNYo70lvgOi/YR88BteZz13cLXJ7c2O642Mvl
	 KGIPuLS3m7Wt72Q+EWVq67IHQsE4FfE4zoag1a5OGQlCoeUfRxIsV2bRheYyA1cTKmHEV
	 FkNumLOunA0ys83T2jEDJNIiZA21DZ2bIVKyljrYBGcojUnt50XjYksxPFGoNYmSBuhll
	 qU7koV/N6IdwCEyyWkrx4WOvqNPWThinTcts/jr9Dd61N9lXTGyVBF1/j8dgQ+iBeCtcV
	 chBkz+zVvdbP7mMtBuEG/dtjZYr6eExAuw0wKMdh/mz5UfbbDrFWspN/RIgMv+dwxdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVrG46I7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5347F606A31C;
	Wed, 18 Nov 2026 23:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVrG46I7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96CE1F000C4;
	Wed, 18 Nov 2026 23:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046331;
	bh=DwGhWB3pg9waRAfTBnvSNzlAW6OscIXLzzCPYoHj/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVrG46I7Qff0jsPl4vgInq64NBQjFtVE+ViKJZn6ayMw/akPhVD3WZ8uD031Qlja8
	 EH2WGTl+Q7XWtCHMESbboGgKt9Z/yfsNVOrj2OgOef4xDf5btKWACow/YEPnRzpFw2
	 MIFnwbF14wjsxQrmGr9haarnCAKgo77Y5fzZZ44w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franck Baur <franck.baur.67@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1206/2857] net: jme: keep RX MAC clock enabled for WoL
Date: Wed, 18 Nov 2026 15:37:20 +0100
Message-ID: <20261118150245.022954512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Franck Baur <franck.baur.67@gmail.com>

[ Upstream commit ed9179fc7228315fb745dc3b111bae446e6894d2 ]

On the JMicron JMC250 revision 03, the MAC reset performed during
suspend leaves GPREG1_RXCLKOFF set. Although the driver enables Magic
Packet detection, the gated RX MAC clock prevents wake-up from ACPI S3.

Keep the RX MAC clock enabled while WoL is armed. Restore the gated
clock state immediately after disabling WoL during resume, preserving
the RX engine initialization ordering.

Prevent concurrent link-change work from gating the clock again after
WoL has been armed. Quiesce interrupt-driven link-change scheduling,
synchronize pending interrupts, and cancel outstanding link-change
work before programming WoL in suspend and shutdown paths.

Restore the deferred processing state before requesting link
reinitialization on resume.

Tested on an ASUS K42JE with JMC250 [197b:0250] rev 03 using a
Debian 6.12.111 kernel and an externally built module. ACPI S3 wake
with a Magic Packet completed in 19 seconds, while a control without
a Magic Packet resumed through the RTC alarm after 123 seconds.
Ethernet and SSH recovered after resume.

S4 and S5 wake behaviour has not been validated with this revision.

Fixes: 854a2e7c331a ("jme: Safer MAC processor reset sequence")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Franck Baur <franck.baur.67@gmail.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/jme.c | 37 ++++++++++++++++++++++++++++++++-----
 drivers/net/ethernet/jme.h |  1 +
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index a718207988f2c..2fd74ae243add 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1502,7 +1502,8 @@ jme_intr_msi(struct jme_adapter *jme, u32 intrstat)
 		 * all other events are ignored
 		 */
 		jwrite32(jme, JME_IEVE, intrstat);
-		schedule_work(&jme->linkch_task);
+		if (!test_bit(JME_FLAG_WOL_QUIESCE, &jme->flags))
+			schedule_work(&jme->linkch_task);
 		goto out_reenable;
 	}
 
@@ -1546,7 +1547,8 @@ jme_intr_msi(struct jme_adapter *jme, u32 intrstat)
 	/*
 	 * Re-enable interrupt
 	 */
-	jwrite32f(jme, JME_IENS, INTR_ENABLE);
+	if (!test_bit(JME_FLAG_WOL_QUIESCE, &jme->flags))
+		jwrite32f(jme, JME_IENS, INTR_ENABLE);
 }
 
 static irqreturn_t
@@ -1892,6 +1894,7 @@ jme_powersave_phy(struct jme_adapter *jme)
 		jme_set_100m_half(jme);
 		if (jme->reg_pmcs & (PMCS_LFEN | PMCS_LREN))
 			jme_wait_link(jme);
+		jme_mac_rxclk_on(jme);
 		jme_clear_pm_enable_wol(jme);
 	} else {
 		jme_phy_off(jme);
@@ -3158,6 +3161,21 @@ jme_shutdown(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct jme_adapter *jme = netdev_priv(netdev);
 
+	if (netif_running(netdev)) {
+		set_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
+		netif_device_detach(netdev);
+		netif_stop_queue(netdev);
+		jme_stop_irq(jme);
+		synchronize_irq(pdev->irq);
+		jme_stop_irq(jme);
+		cancel_work_sync(&jme->linkch_task);
+		tasklet_disable(&jme->pcc_task);
+		napi_disable(&jme->napi);
+		tasklet_disable(&jme->txclean_task);
+		tasklet_disable(&jme->rxclean_task);
+		tasklet_disable(&jme->rxempty_task);
+	}
+
 	jme_powersave_phy(jme);
 	pci_pme_active(pdev, true);
 }
@@ -3172,11 +3190,16 @@ jme_suspend(struct device *dev)
 	if (!netif_running(netdev))
 		return 0;
 
-	atomic_dec(&jme->link_changing);
-
+	set_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
 	netif_device_detach(netdev);
 	netif_stop_queue(netdev);
 	jme_stop_irq(jme);
+	synchronize_irq(jme->pdev->irq);
+	jme_stop_irq(jme);
+	cancel_work_sync(&jme->linkch_task);
+	tasklet_disable(&jme->pcc_task);
+	napi_disable(&jme->napi);
+	atomic_dec(&jme->link_changing);
 
 	tasklet_disable(&jme->txclean_task);
 	tasklet_disable(&jme->rxclean_task);
@@ -3215,6 +3238,7 @@ jme_resume(struct device *dev)
 		return 0;
 
 	jme_clear_pm_disable_wol(jme);
+	jme_mac_rxclk_off(jme);
 	jme_phy_on(jme);
 	if (test_bit(JME_FLAG_SSET, &jme->flags))
 		jme_set_link_ksettings(netdev, &jme->old_cmd);
@@ -3226,8 +3250,11 @@ jme_resume(struct device *dev)
 
 	atomic_inc(&jme->link_changing);
 
-	jme_reset_link(jme);
+	napi_enable(&jme->napi);
+	tasklet_enable(&jme->pcc_task);
+	clear_bit(JME_FLAG_WOL_QUIESCE, &jme->flags);
 
+	jme_reset_link(jme);
 	jme_start_irq(jme);
 
 	return 0;
diff --git a/drivers/net/ethernet/jme.h b/drivers/net/ethernet/jme.h
index 860494ff37144..ec5dfddf73227 100644
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -450,6 +450,7 @@ enum jme_flags_bits {
 	JME_FLAG_SSET		= 2,
 	JME_FLAG_POLL		= 5,
 	JME_FLAG_SHUTDOWN	= 6,
+	JME_FLAG_WOL_QUIESCE	= 7,
 };
 
 #define TX_TIMEOUT		(5 * HZ)
-- 
2.53.0



