Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2134251A148;
	Wed, 30 Sep 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789827; cv=none; b=ULev8/PUtVmoF7557dHoAv1LORHIfBQNZCWI5sN1teZ068LfHpVVdDD2uBpofKwxr/m5W9N/EZdkHwYBVDfrAO8woNIydN9o3Y7/1OLn2uk2YevELUtIDQ2g1wDkL74UTpwIf+LodKnWeIBbxnPtcWwQmC4pyKsxQZ0YcCy4JW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789827; c=relaxed/simple;
	bh=yuXSFfPIhbuo3hxrrDW1fTu/+Dd5bi+S+mSnQtCzKBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJDFZnMxoW+WLygkRv7FSUEvdsQhzBSHqHsx8JAlEU0mgt6H2sm84K25fw8N9dAinmUZ60NCfFpmS2q1kBPQX11YVjdToiLuEGV5ti+5j98+FhMWtCyh90kc1Ozngvw1Z/7onvl6rB6Y7HUti5mBh2QN3YERViYpTP5ouyfbRhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5unxs+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5unxs+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B99A1F000FF;
	Wed, 30 Sep 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789826;
	bh=4Db4edSlIi4QGzkZTe6HsotURLiEd2F5zKGtolllgDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5unxs+8ncken31FVpDJWCKb0hoezo1aOidxH4n3u0//fVt00sukaxDv6lFJCetkH
	 A7N1AZT33d462fs/iRYvW9sQhIRh5poV6IBhrLjNuSqPOeXs6Qhb2iKHNy6lTVlAVp
	 RguAyWLynsi7YzGLE729YDpViZ9t2cl+vd2ayFME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	"Yuhang.chen" <yhchen312@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 614/877] wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot
Date: Wed, 30 Sep 2026 17:25:25 +0200
Message-ID: <20260930152427.903237092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: "Yuhang.chen" <yhchen312@gmail.com>

[ Upstream commit 667c12782aaf8dd3cb2213e528fe63a73cb63345 ]

Since the hardware rfkill polling was introduced, arm64 platforms can
panic with an asynchronous SError during warm reboot:

  SError Interrupt on CPU8, code 0x00000000be000011 -- SError
  Workqueue: events_power_efficient rfkill_poll [rfkill]
    rtw89_pci_ops_read8+0x94/0x160 [rtw89_pci]
    rtw89_core_rfkill_poll+0x50/0x1e0 [rtw89_core]
    rtw89_ops_rfkill_poll+0x40/0x68 [rtw89_core]
    ieee80211_rfkill_poll+0x3c/0x70 [mac80211]
    cfg80211_rfkill_poll+0x40/0x2a0 [cfg80211]
    rfkill_poll+0x30/0x88 [rfkill]
  Kernel panic - not syncing: Asynchronous SError Interrupt

On the reboot path the kernel only runs device_shutdown(), which calls
each driver's .shutdown callback; .remove is not invoked.  The rtw89 PCI
driver had no .shutdown callback, so nothing stopped the rfkill polling
work while the platform was tearing the PCIe link down.  Once the link
is gone, the next MMIO read from the poll handler targets a
non-responding device and is reported as a fatal asynchronous SError on
arm64.

Add rtw89_pci_shutdown(), wired to all rtw89 PCI device drivers, which
sets a new RTW89_FLAG_SHUTDOWN flag (mirroring the USB
RTW89_FLAG_UNPLUGGED pattern).  When the flag is set,
rtw89_ops_rfkill_poll() returns early, so no MMIO read is issued to the
chip after shutdown begins and the SError no longer occurs.

This does not call the full .remove path from .shutdown, to keep the
shutdown handler minimal and avoid running the non-idempotent teardown
twice.

Fixes: 0b38e6277aed ("wifi: rtw89: add support for hardware rfkill")
Cc: stable@vger.kernel.org
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yuhang.chen <yhchen312@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260729014142.2746777-1-yhchen312@gmail.com
[ Adapted the shutdown check to use the existing goto out path for mutex unlocking. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/core.h       |    1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c   |    3 ++-
 drivers/net/wireless/realtek/rtw89/pci.c        |   13 +++++++++++++
 drivers/net/wireless/realtek/rtw89/pci.h        |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8851be.c  |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c  |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c  |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852bte.c |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c  |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c  |    1 +
 10 files changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4725,6 +4725,7 @@ enum rtw89_flags {
 	RTW89_FLAG_CHANGING_INTERFACE,
 	RTW89_FLAG_HW_RFKILL_STATE,
 	RTW89_FLAG_UNPLUGGED,
+	RTW89_FLAG_SHUTDOWN,
 
 	NUM_OF_RTW89_FLAGS,
 };
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -1550,7 +1550,8 @@ static void rtw89_ops_rfkill_poll(struct
 	mutex_lock(&rtwdev->mutex);
 
 	/* wl_disable GPIO get floating when entering LPS */
-	if (test_bit(RTW89_FLAG_RUNNING, rtwdev->flags))
+	if (test_bit(RTW89_FLAG_RUNNING, rtwdev->flags) ||
+	    test_bit(RTW89_FLAG_SHUTDOWN, rtwdev->flags))
 		goto out;
 
 	rtw89_core_rfkill_poll(rtwdev, false);
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4465,6 +4465,19 @@ void rtw89_pci_remove(struct pci_dev *pd
 }
 EXPORT_SYMBOL(rtw89_pci_remove);
 
+void rtw89_pci_shutdown(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtw89_dev *rtwdev;
+
+	if (!hw)
+		return;
+
+	rtwdev = hw->priv;
+	set_bit(RTW89_FLAG_SHUTDOWN, rtwdev->flags);
+}
+EXPORT_SYMBOL(rtw89_pci_shutdown);
+
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek PCI 802.11ax wireless driver");
 MODULE_LICENSE("Dual BSD/GPL");
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1602,6 +1602,7 @@ struct pci_device_id;
 
 int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 void rtw89_pci_remove(struct pci_dev *pdev);
+void rtw89_pci_shutdown(struct pci_dev *pdev);
 void rtw89_pci_ops_reset(struct rtw89_dev *rtwdev);
 int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en);
 int rtw89_pci_ltr_set_v1(struct rtw89_dev *rtwdev, bool en);
--- a/drivers/net/wireless/realtek/rtw89/rtw8851be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851be.c
@@ -84,6 +84,7 @@ static struct pci_driver rtw89_8851be_dr
 	.id_table	= rtw89_8851be_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 };
 module_pci_driver(rtw89_8851be_driver);
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
@@ -86,6 +86,7 @@ static struct pci_driver rtw89_8852ae_dr
 	.id_table	= rtw89_8852ae_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 };
 module_pci_driver(rtw89_8852ae_driver);
--- a/drivers/net/wireless/realtek/rtw89/rtw8852be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
@@ -88,6 +88,7 @@ static struct pci_driver rtw89_8852be_dr
 	.id_table	= rtw89_8852be_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 };
 module_pci_driver(rtw89_8852be_driver);
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
@@ -84,6 +84,7 @@ static struct pci_driver rtw89_8852bte_d
 	.id_table	= rtw89_8852bte_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 };
 module_pci_driver(rtw89_8852bte_driver);
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
@@ -113,6 +113,7 @@ static struct pci_driver rtw89_8852ce_dr
 	.id_table	= rtw89_8852ce_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 };
 module_pci_driver(rtw89_8852ce_driver);
--- a/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
@@ -82,6 +82,7 @@ static struct pci_driver rtw89_8922ae_dr
 	.id_table	= rtw89_8922ae_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops_be,
 };
 module_pci_driver(rtw89_8922ae_driver);


