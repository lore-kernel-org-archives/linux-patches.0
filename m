Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30EB22AE68;
	Tue, 29 Apr 2025 17:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949096; cv=none; b=RNksxpxBJvzE6+9fcgRvIfLirHtJ3+m5E+B5T5Hp0UWONlPoH2yz0ftoRSDw9t5EddTVHZlMG2PUZ5tjuqYq653WCLtwf/jIkQxwNmC5VpPfrMPSh4BQGqBro6mWijWh6GjlX+yza2hL+KtyRBrhjOHv5DnPxlyU85sz09X2EWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949096; c=relaxed/simple;
	bh=jDU3XUbmvsU4WkVZcD9oahoOPlwxmJ2LchvHTEJdxo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhmvaLTCSMGxY9T43msN13V3ftFsjr0dRprwmpEyD/5tBHrpo+nIpdGrxAmS1fA1TAJNu7rCko2x2vU6ogNS3uDpRivj/s9TVNB/8hkGZj/aeM0akAMvNPmJvguwxhApLe5XZbxyM+R8fO1VgZIRiD9neBB0jB6qwaI7LA+cr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRVHHvck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRVHHvck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D68CC4CEE3;
	Tue, 29 Apr 2025 17:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949096;
	bh=jDU3XUbmvsU4WkVZcD9oahoOPlwxmJ2LchvHTEJdxo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRVHHvckPhCA/MQTTjiDO4VzmiO7kTg+vquS993GIUNSOyBgP+xU4btsDQhndtrsG
	 0hXvrezMdeuAX0mZR5tQEIVYP38FB1CMBzaIZ5sx9hFIbaYXeOdNbfyIkWPLJ27Jrq
	 CMUoN2VLNmpBUAKHFdLF3Tx+FtHjDLkDcB9x/s/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <quic_kangyang@quicinc.com>,
	David Ruth <druth@chromium.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 212/373] wifi: ath10k: avoid NULL pointer error during sdio remove
Date: Tue, 29 Apr 2025 18:41:29 +0200
Message-ID: <20250429161131.881864116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <quic_kangyang@quicinc.com>

commit 95c38953cb1ecf40399a676a1f85dfe2b5780a9a upstream.

When running 'rmmod ath10k', ath10k_sdio_remove() will free sdio
workqueue by destroy_workqueue(). But if CONFIG_INIT_ON_FREE_DEFAULT_ON
is set to yes, kernel panic will happen:
Call trace:
 destroy_workqueue+0x1c/0x258
 ath10k_sdio_remove+0x84/0x94
 sdio_bus_remove+0x50/0x16c
 device_release_driver_internal+0x188/0x25c
 device_driver_detach+0x20/0x2c

This is because during 'rmmod ath10k', ath10k_sdio_remove() will call
ath10k_core_destroy() before destroy_workqueue(). wiphy_dev_release()
will finally be called in ath10k_core_destroy(). This function will free
struct cfg80211_registered_device *rdev and all its members, including
wiphy, dev and the pointer of sdio workqueue. Then the pointer of sdio
workqueue will be set to NULL due to CONFIG_INIT_ON_FREE_DEFAULT_ON.

After device release, destroy_workqueue() will use NULL pointer then the
kernel panic happen.

Call trace:
ath10k_sdio_remove
  ->ath10k_core_unregister
    ……
    ->ath10k_core_stop
      ->ath10k_hif_stop
        ->ath10k_sdio_irq_disable
    ->ath10k_hif_power_down
      ->del_timer_sync(&ar_sdio->sleep_timer)
  ->ath10k_core_destroy
    ->ath10k_mac_destroy
      ->ieee80211_free_hw
        ->wiphy_free
    ……
          ->wiphy_dev_release
  ->destroy_workqueue

Need to call destroy_workqueue() before ath10k_core_destroy(), free
the work queue buffer first and then free pointer of work queue by
ath10k_core_destroy(). This order matches the error path order in
ath10k_sdio_probe().

No work will be queued on sdio workqueue between it is destroyed and
ath10k_core_destroy() is called. Based on the call_stack above, the
reason is:
Only ath10k_sdio_sleep_timer_handler(), ath10k_sdio_hif_tx_sg() and
ath10k_sdio_irq_disable() will queue work on sdio workqueue.
Sleep timer will be deleted before ath10k_core_destroy() in
ath10k_hif_power_down().
ath10k_sdio_irq_disable() only be called in ath10k_hif_stop().
ath10k_core_unregister() will call ath10k_hif_power_down() to stop hif
bus, so ath10k_sdio_hif_tx_sg() won't be called anymore.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Tested-by: David Ruth <druth@chromium.org>
Reviewed-by: David Ruth <druth@chromium.org>
Link: https://patch.msgid.link/20241008022246.1010-1-quic_kangyang@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2004-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2012,2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2016-2017 Erik Stromdahl <erik.stromdahl@gmail.com>
+ * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -2648,9 +2649,9 @@ static void ath10k_sdio_remove(struct sd
 
 	netif_napi_del(&ar->napi);
 
-	ath10k_core_destroy(ar);
-
 	destroy_workqueue(ar_sdio->workqueue);
+
+	ath10k_core_destroy(ar);
 }
 
 static const struct sdio_device_id ath10k_sdio_devices[] = {


