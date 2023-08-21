Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F3E1170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB12C433C7;
	Mon, 21 Aug 2023 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647479;
	bh=V5htXI/isMDTyngJmE2r17CXwwBM32OzxOtzxDclOsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVmhF0QarrKrgsbkoZIRAMOVff+zljRDl5A1Z66VGmjnycKhzHMDgTVvuJ5eA+nEt
	 BWPfVFmj+1haG9Nd7tvPmhKASQHOYRo26I/Btjk40FCXGRFl+cGx7t7er7mZFODWzi
	 n7qVzCv8jhSIptpzH7+/0B9zge73L0espikOlN+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ofir Bitton <obitton@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/194] accel/habanalabs: add pci health check during heartbeat
Date: Mon, 21 Aug 2023 21:40:07 +0200
Message-ID: <20230821194124.028595855@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit d8b9cea584661b30305cf341bf9f675dc0a25471 ]

Currently upon a heartbeat failure, we don't know if the failure
is due to firmware hang or due to a bad PCI link. Hence, we
are reading a PCI config space register with a known value (vendor ID)
so we will know which of the two possibilities caused the heartbeat
failure.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c         | 15 ++++++++++++++-
 drivers/misc/habanalabs/common/habanalabs.h     |  2 ++
 drivers/misc/habanalabs/common/habanalabs_drv.c |  2 --
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index e0dca445abf14..9ee1b6abd8a05 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -870,6 +870,18 @@ static void device_early_fini(struct hl_device *hdev)
 		hdev->asic_funcs->early_fini(hdev);
 }
 
+static bool is_pci_link_healthy(struct hl_device *hdev)
+{
+	u16 vendor_id;
+
+	if (!hdev->pdev)
+		return false;
+
+	pci_read_config_word(hdev->pdev, PCI_VENDOR_ID, &vendor_id);
+
+	return (vendor_id == PCI_VENDOR_ID_HABANALABS);
+}
+
 static void hl_device_heartbeat(struct work_struct *work)
 {
 	struct hl_device *hdev = container_of(work, struct hl_device,
@@ -882,7 +894,8 @@ static void hl_device_heartbeat(struct work_struct *work)
 		goto reschedule;
 
 	if (hl_device_operational(hdev, NULL))
-		dev_err(hdev->dev, "Device heartbeat failed!\n");
+		dev_err(hdev->dev, "Device heartbeat failed! PCI link is %s\n",
+			is_pci_link_healthy(hdev) ? "healthy" : "broken");
 
 	hl_device_reset(hdev, HL_DRV_RESET_HARD | HL_DRV_RESET_HEARTBEAT);
 
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 58c95b13be69a..257b94cec6248 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -34,6 +34,8 @@
 struct hl_device;
 struct hl_fpriv;
 
+#define PCI_VENDOR_ID_HABANALABS	0x1da3
+
 /* Use upper bits of mmap offset to store habana driver specific information.
  * bits[63:59] - Encode mmap type
  * bits[45:0]  - mmap offset value
diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index 112632afe7d53..ae3cab3f4aa55 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -54,8 +54,6 @@ module_param(boot_error_status_mask, ulong, 0444);
 MODULE_PARM_DESC(boot_error_status_mask,
 	"Mask of the error status during device CPU boot (If bitX is cleared then error X is masked. Default all 1's)");
 
-#define PCI_VENDOR_ID_HABANALABS	0x1da3
-
 #define PCI_IDS_GOYA			0x0001
 #define PCI_IDS_GAUDI			0x1000
 #define PCI_IDS_GAUDI_SEC		0x1010
-- 
2.40.1



