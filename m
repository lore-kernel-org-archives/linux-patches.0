Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026454;
	b=tkz2ChOeFZXR6R/oKmaBl4HiRC4KDNVPj1OrEgwN0xScrh8VAIjFyA27vwfyUU84/tsP
	 QjvcyNCPP8aPaOTJ5G5pTjSXm+KxZEPpbQ446hwnaY3jeOH44f/fevnilMOwjfVB/bf2w
	 hNXk0PnMaPTuyLVa2bn1rIxe9KN8v2kCtA2L4bQXjK3RPGrZDfXe6uDwRrvcibeUJUe3/
	 l0l/gAGcACvbtvRDTs5kL8n9YYDaEpSVSOATHWt+u8j4hjxYWZjGAQ4BH7WSTlqszQ9K0
	 iCInqtVmD5mToI+XxOsneqsbzwi5AE3wzGwPo870dMPUFT88wvnOmaROfebYyGRCuPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INPmbHPrXL1JN79hNFrIqXDhOjNWsM/bBBkOfTAwzRY=;
	b=XEtZlgZqFSc0fFKJu1h23aJAqkcT8jwZv07OHgPERLAQJx6l5koKCpT/nBQEt8X1kWFY
	 T9EZe0Z/PrEfUzU7WakByc9quSq2M3QO1in1UUHrEtGBtYw1XiDW/z55ytvMaOLFeFth+
	 yQTFcxcHQZZ80cx06h3bveT8rc6mLIiu3iIvhabA/KQHtcZOoe2SVVZVIjPotAclsK5ce
	 OdScZ37DYLnW4l8ZBiJquTQPJUMnwL85J3zTkWTNiQxyzGAtUXcXBLKMRy7BmcKd/q79I
	 W2J14r30v+oo0qlWGry3HFKKYSq0eE/CA+uVYQAyygNjQ/uP3qZwC91yGNRHzHd4A5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKxdTZSt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123E60A2604;
	Wed, 18 Nov 2026 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKxdTZSt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92861F000C4;
	Wed, 18 Nov 2026 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026454;
	bh=INPmbHPrXL1JN79hNFrIqXDhOjNWsM/bBBkOfTAwzRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKxdTZSt6Quq6lTouoNgRi6wVray2dxFmb9TqF9aPJmgoXdO3oNhhMYRgTrlM6DX6
	 4VSb+G6k+yHt37VhalBQdLrActVvsbxOQRSZWjMV4h6+onWqEr0D6VU2nEeNY0p5IQ
	 oISjTRboacatQcegmMQALvhUgzDQdKq7sax1APdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1441/2151] hisi_acc_vfio_pci: fix NULL dereference in reset_prepare on PF passthrough
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150214.428381588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit e1d2d60b1f50296828d3f7ff26c45d1a90f142ef ]

When a PF is bound to the driver via driver_override and passed
through to a VM, its pf_qm stays NULL. The PCI error handler
reset_prepare() runs during open_device through
pci_try_reset_function(), before the mig_ops gate, and dereferences
the NULL pf_qm for the timeout log, crashing the kernel.

Move the mig_ops check to the entry of reset_prepare() and
aer_reset_done() so non-migration devices skip the QM_RESETTING
coordination. The dev local resolved &qm->pdev->dev before the
gate, so open code it at the dev_err() call where qm is known
valid. Also clear set_reset_flag together with QM_RESETTING in
aer_reset_done(); the flag was never cleared before, so a later
timed-out reset could release a foreign lock.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Fixes: a22099ed7936f ("hisi_acc_vfio_pci: fix VF reset timeout issue")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20261013071929.3988687-2-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index f141f21566c52..e2ef4e872124b 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1173,14 +1173,16 @@ static void hisi_acc_vf_pci_reset_prepare(struct pci_dev *pdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
-	struct device *dev = &qm->pdev->dev;
 	u32 delay = 0;
 
+	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
+		return;
+
 	/* All reset requests need to be queued for processing */
 	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
 		msleep(1);
 		if (++delay > QM_RESET_WAIT_TIMEOUT) {
-			dev_err(dev, "reset prepare failed\n");
+			dev_err(&qm->pdev->dev, "reset prepare failed\n");
 			return;
 		}
 	}
@@ -1193,12 +1195,14 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
 
-	if (hisi_acc_vdev->set_reset_flag)
-		clear_bit(QM_RESETTING, &qm->misc_ctl);
-
 	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
 		return;
 
+	if (hisi_acc_vdev->set_reset_flag) {
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
+		hisi_acc_vdev->set_reset_flag = false;
+	}
+
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	hisi_acc_vf_reset(hisi_acc_vdev);
 	mutex_unlock(&hisi_acc_vdev->state_mutex);
-- 
2.53.0



