Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8024036826E;
	Wed, 30 Sep 2026 19:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796602; cv=none; b=VEuWSaFcb6uLHWY0bWNSa+CDh8g0zgG5nNujdCUuyALBtvKkKfOFbSxCkHlBYKQWG7bNiAUqZG2REJmxDmyhA6yl1oGqJb7QO8tiY4R+KyixtBQzhi3016NpMabOwf0inBpXF3zvzVEpnCTHgn6APdqJuau+2WKwmZ+noa7R3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796602; c=relaxed/simple;
	bh=KUxCZPIB3+mkhaj50uECw4JlDfdjBLiHUZ7AG3C+18o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQuDUaKtZ+lP6Y3YU0jLjHjwKj7dJsxmNY8DtEIFoOha79INEexfeiwLI6ikqfmgZHfZNvq8AeYqlAEjfDFHfeZDG3/TFy9IbR1yqp5o0SPi1HnYA7aQ4+Ci53ezYAxSuHfQQABMkbSJbx82yrtzN7AEavxMJO5lcfzUxYCe1UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyzRM1gl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyzRM1gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C7F1F000FF;
	Wed, 30 Sep 2026 19:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796601;
	bh=yZxTxlH3WMF6e5vAYeBTzgRIONRiW4dAcBl+eXcHCdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyzRM1gl5W5r7H+c2L0TQMIP3OGR9rOBc7iur47ePgQ61eWpqHEa8oPnUVX1i6sAs
	 BCvM8eIIdtmDH8UTy7CQHtitonUFZtOWYOQQ9aqWwoH4V9nJL5tMtvO5y00t84TSQ4
	 gLSYdRwvKAp6DrHvoLadG5aZsQSHe8PtG43jMf6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com,
	Slawomir Stepien <sst@poczta.fm>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0971/1193] HID: amd_sfh: Validate PCI BAR size before mapping
Date: Wed, 30 Sep 2026 17:27:35 +0200
Message-ID: <20260930152455.819070465@linuxfoundation.org>
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

From: Slawomir Stepien <sst@poczta.fm>

[ Upstream commit 65bcc5f89704efe5b9d69d4ea2c1002d90c31382 ]

The amd_sfh driver maps PCI BAR 2 using pcim_iomap_regions() and
subsequently accesses MMIO registers at offsets up to 0x10958 (e.g.,
AMD_P2C_MSG3 at 0x1068C). However, the driver never validates that the BAR
size is large enough to cover these accesses. If the driver is bound to a
device with a smaller BAR 2, this leads to an out-of-bounds memory access
and a page fault during the probe function.

For example, a page fault can occur when reading from privdata->mmio +
AMD_P2C_MSG3 in mp2_select_ops():

  BUG: unable to handle page fault for address: ffffc9000390368c
  PGD 100000067 P4D 100000067 PUD 1012c1067 PMD 105b64067 PTE 0
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:readl arch/x86/include/asm/io.h:59 [inline]
  RIP: 0010:mp2_select_ops drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:282
  [inline]
  RIP: 0010:amd_mp2_pci_probe+0x337/0x5f0
  drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:487
  Call Trace:
   <TASK>
   local_pci_probe drivers/pci/pci-driver.c:332 [inline]
   pci_call_probe drivers/pci/pci-driver.c:394 [inline]
   __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
   pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489

Fix this by verifying that the length of BAR 2 is at least 128KB before
attempting to map it. Since the maximum accessed offset is 0x10958, and PCI
BAR sizes are powers of 2, any legitimate hardware will have a BAR size of
at least 128KB.

Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
Link: https://syzkaller.appspot.com/ai_job?id=3bc1c45c-548f-4ab5-8243-d2c8ec321d6c
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_common.h |  4 ++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c   | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
index 2643bb14fee27..0aeb670ae1a4f 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
@@ -11,11 +11,15 @@
 #define AMD_SFH_COMMON_H
 
 #include <linux/pci.h>
+#include <linux/sizes.h>
 #include "amd_sfh_hid.h"
 
 #define PCI_DEVICE_ID_AMD_MP2		0x15E4
 #define PCI_DEVICE_ID_AMD_MP2_1_1	0x164A
 
+/* The BAR 2 size must cover the highest register offset (0x10958) */
+#define AMD_SFH_MIN_BAR_SIZE		SZ_128K
+
 #define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
 #define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index ce449da08e9ba..ca4dc771e0bff 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -349,6 +349,16 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (rc)
 		return rc;
 
+	if (!(pci_resource_flags(pdev, 2) & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "BAR 2 is not IORESOURCE_MEM\n");
+		return -ENODEV;
+	}
+
+	if (pci_resource_len(pdev, 2) < AMD_SFH_MIN_BAR_SIZE) {
+		dev_err(&pdev->dev, "BAR 2 is too small\n");
+		return -EINVAL;
+	}
+
 	rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
 	if (rc)
 		return rc;
-- 
2.53.0



