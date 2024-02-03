Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2F51CD04;
	Sat,  3 Feb 2024 04:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933878; cv=none; b=p6szujuKD1tx3+qNaoxgwIhvFBPO4qdtK2w8Ssz8iDlVF+nS/FWw94Ubuw4x4sTWIR3aIJk50WVJ8wcTfJCz+aLep4v0XX4rN57NfTWtY6KMYdKvTreVg6ctpRZuZyZZ3ky1wzyEH3M8MHxaAegWxDZaFH6CDMgDaWDMToFbOyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933878; c=relaxed/simple;
	bh=34p1I2heCsWUkXlcKnlNUFndg2d9uZtcacYWRltqyMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PB59SGYnhJVRZQanC50L3Arv6f1HI5beDzsaB0MjhhQe1IZFiAjcePIzG3q8HaVWexotx4I1b+fWo9UN3OijRSqeumjk3gdlcW+8JOM2A1drrkXQrvBxfAN/yeCxhtU0kOVW+33iss/bDYh8bA/fiA7uXWLTyYnyY3BbPWkcYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6rJcK9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6rJcK9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5902C433C7;
	Sat,  3 Feb 2024 04:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933877;
	bh=34p1I2heCsWUkXlcKnlNUFndg2d9uZtcacYWRltqyMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6rJcK9HI8vgwFO+2zI/m8JW6lTAJhOs/+wBhg7Xy/xiHcnb9JLtrvLcMO85RYa4w
	 eiaD/yLEkeORFc8PQ/pviMB5LYH381uJVJT3Wms5WX2DSEceuLnl+Wo6fPP/Xijywk
	 8ltjB+VjLpqUQI1PDzUVfZZSSdSA4AaZn1bXCrVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 217/353] accel/habanalabs: add support for Gaudi2C device
Date: Fri,  2 Feb 2024 20:05:35 -0800
Message-ID: <20240203035410.548345387@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 42422993cf28d456778ee9168d73758ec037cd51 ]

Gaudi2 with PCI revision ID with the value of '3' represents Gaudi2C
device and should be detected and initialized as Gaudi2.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/device.c                 | 3 +++
 drivers/accel/habanalabs/common/habanalabs.h             | 2 ++
 drivers/accel/habanalabs/common/habanalabs_drv.c         | 3 +++
 drivers/accel/habanalabs/common/mmu/mmu.c                | 1 +
 drivers/accel/habanalabs/common/sysfs.c                  | 3 +++
 drivers/accel/habanalabs/include/hw_ip/pci/pci_general.h | 1 +
 6 files changed, 13 insertions(+)

diff --git a/drivers/accel/habanalabs/common/device.c b/drivers/accel/habanalabs/common/device.c
index 9711e8fc979d..9e461c03e705 100644
--- a/drivers/accel/habanalabs/common/device.c
+++ b/drivers/accel/habanalabs/common/device.c
@@ -853,6 +853,9 @@ static int device_early_init(struct hl_device *hdev)
 		gaudi2_set_asic_funcs(hdev);
 		strscpy(hdev->asic_name, "GAUDI2B", sizeof(hdev->asic_name));
 		break;
+	case ASIC_GAUDI2C:
+		gaudi2_set_asic_funcs(hdev);
+		strscpy(hdev->asic_name, "GAUDI2C", sizeof(hdev->asic_name));
 		break;
 	default:
 		dev_err(hdev->dev, "Unrecognized ASIC type %d\n",
diff --git a/drivers/accel/habanalabs/common/habanalabs.h b/drivers/accel/habanalabs/common/habanalabs.h
index 1655c101c705..d0fd77bb6a74 100644
--- a/drivers/accel/habanalabs/common/habanalabs.h
+++ b/drivers/accel/habanalabs/common/habanalabs.h
@@ -1262,6 +1262,7 @@ struct hl_dec {
  * @ASIC_GAUDI_SEC: Gaudi secured device (HL-2000).
  * @ASIC_GAUDI2: Gaudi2 device.
  * @ASIC_GAUDI2B: Gaudi2B device.
+ * @ASIC_GAUDI2C: Gaudi2C device.
  */
 enum hl_asic_type {
 	ASIC_INVALID,
@@ -1270,6 +1271,7 @@ enum hl_asic_type {
 	ASIC_GAUDI_SEC,
 	ASIC_GAUDI2,
 	ASIC_GAUDI2B,
+	ASIC_GAUDI2C,
 };
 
 struct hl_cs_parser;
diff --git a/drivers/accel/habanalabs/common/habanalabs_drv.c b/drivers/accel/habanalabs/common/habanalabs_drv.c
index 306a5bc9bf89..51fb04bbe376 100644
--- a/drivers/accel/habanalabs/common/habanalabs_drv.c
+++ b/drivers/accel/habanalabs/common/habanalabs_drv.c
@@ -141,6 +141,9 @@ static enum hl_asic_type get_asic_type(struct hl_device *hdev)
 		case REV_ID_B:
 			asic_type = ASIC_GAUDI2B;
 			break;
+		case REV_ID_C:
+			asic_type = ASIC_GAUDI2C;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/accel/habanalabs/common/mmu/mmu.c b/drivers/accel/habanalabs/common/mmu/mmu.c
index b2145716c605..b654302a68fc 100644
--- a/drivers/accel/habanalabs/common/mmu/mmu.c
+++ b/drivers/accel/habanalabs/common/mmu/mmu.c
@@ -596,6 +596,7 @@ int hl_mmu_if_set_funcs(struct hl_device *hdev)
 		break;
 	case ASIC_GAUDI2:
 	case ASIC_GAUDI2B:
+	case ASIC_GAUDI2C:
 		/* MMUs in Gaudi2 are always host resident */
 		hl_mmu_v2_hr_set_funcs(hdev, &hdev->mmu_func[MMU_HR_PGT]);
 		break;
diff --git a/drivers/accel/habanalabs/common/sysfs.c b/drivers/accel/habanalabs/common/sysfs.c
index 01f89f029355..278606373055 100644
--- a/drivers/accel/habanalabs/common/sysfs.c
+++ b/drivers/accel/habanalabs/common/sysfs.c
@@ -251,6 +251,9 @@ static ssize_t device_type_show(struct device *dev,
 	case ASIC_GAUDI2B:
 		str = "GAUDI2B";
 		break;
+	case ASIC_GAUDI2C:
+		str = "GAUDI2C";
+		break;
 	default:
 		dev_err(hdev->dev, "Unrecognized ASIC type %d\n",
 				hdev->asic_type);
diff --git a/drivers/accel/habanalabs/include/hw_ip/pci/pci_general.h b/drivers/accel/habanalabs/include/hw_ip/pci/pci_general.h
index f5d497dc9bdc..4f951cada077 100644
--- a/drivers/accel/habanalabs/include/hw_ip/pci/pci_general.h
+++ b/drivers/accel/habanalabs/include/hw_ip/pci/pci_general.h
@@ -25,6 +25,7 @@ enum hl_revision_id {
 	REV_ID_INVALID				= 0x00,
 	REV_ID_A				= 0x01,
 	REV_ID_B				= 0x02,
+	REV_ID_C				= 0x03
 };
 
 #endif /* INCLUDE_PCI_GENERAL_H_ */
-- 
2.43.0



