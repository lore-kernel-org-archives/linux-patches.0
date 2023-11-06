Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F832208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0e2e509q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EC6C433C8;
	Mon,  6 Nov 2023 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276720;
	bh=f8N8EXvota+AP8vYYgsjIJGfN4j2MArr88ST27ERHi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0e2e509q32Nfn+NYvj49O4vwZU9tyAocK2l6+ZTAYGZKI23USoIWqJ5cq2HooREWP
	 r7XcOOnwthEAxU6uFZHLEfabzXYmEO5QlrSCKjB2JrdcAbULoUZqXGD7XfZ9sE+xAa
	 75jKZowmjcO3sq+kLr1hdvZcUoU9vRuzLep4ejdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Eric Curtin <ecurtin@redhat.com>,
	Neal Gompa <neal@gompa.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.5 73/88] Bluetooth: hci_bcm4377: Mark bcm4378/bcm4387 as BROKEN_LE_CODED
Date: Mon,  6 Nov 2023 14:04:07 +0100
Message-ID: <20231106130308.434179636@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit 41e9cdea9c4ab6606ca462ff4ec901a82d022c05 upstream.

bcm4378 and bcm4387 claim to support LE Coded PHY but fail to pair
(reliably) with BLE devices if it is enabled.
On bcm4378 pairing usually succeeds after 2-3 tries. On bcm4387
pairing appears to be completely broken.

Cc: stable@vger.kernel.org # 6.4.y+
Link: https://discussion.fedoraproject.org/t/mx-master-3-bluetooth-mouse-doesnt-connect/87072/33
Link: https://github.com/AsahiLinux/linux/issues/177
Fixes: 288c90224eec ("Bluetooth: Enable all supported LE PHY by default")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm4377.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/hci_bcm4377.c b/drivers/bluetooth/hci_bcm4377.c
index 19ad0e788646..a61757835695 100644
--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -512,6 +512,7 @@ struct bcm4377_hw {
 	unsigned long disable_aspm : 1;
 	unsigned long broken_ext_scan : 1;
 	unsigned long broken_mws_transport_config : 1;
+	unsigned long broken_le_coded : 1;
 
 	int (*send_calibration)(struct bcm4377_data *bcm4377);
 	int (*send_ptb)(struct bcm4377_data *bcm4377,
@@ -2372,6 +2373,8 @@ static int bcm4377_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		set_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &hdev->quirks);
 	if (bcm4377->hw->broken_ext_scan)
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
+	if (bcm4377->hw->broken_le_coded)
+		set_bit(HCI_QUIRK_BROKEN_LE_CODED, &hdev->quirks);
 
 	pci_set_drvdata(pdev, bcm4377);
 	hci_set_drvdata(hdev, bcm4377);
@@ -2461,6 +2464,7 @@ static const struct bcm4377_hw bcm4377_hw_variants[] = {
 		.bar0_core2_window2 = 0x18107000,
 		.has_bar0_core2_window2 = true,
 		.broken_mws_transport_config = true,
+		.broken_le_coded = true,
 		.send_calibration = bcm4378_send_calibration,
 		.send_ptb = bcm4378_send_ptb,
 	},
@@ -2474,6 +2478,7 @@ static const struct bcm4377_hw bcm4377_hw_variants[] = {
 		.has_bar0_core2_window2 = true,
 		.clear_pciecfg_subsystem_ctrl_bit19 = true,
 		.broken_mws_transport_config = true,
+		.broken_le_coded = true,
 		.send_calibration = bcm4387_send_calibration,
 		.send_ptb = bcm4378_send_ptb,
 	},
-- 
2.42.0



