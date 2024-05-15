Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E6A4D9E2;
	Wed, 15 May 2024 08:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715761628; cv=none; b=eSZ+u5BCF8MsR8tIRXU+0ry0w1IrxdHnPUFSd2QONt6891YegP4kuuL8IdXFR0HqnG9tpdHpFcmmyC0EUKhTQHFpUrnKXopEk7MILT25NP4D84O2NeYbHsicbeFrWLTz2iimjff2yuMw2jOyWupo9xRfkrOe+rDaYmMGqGZKXxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715761628; c=relaxed/simple;
	bh=cR4iNBhkVcRgYgdv6EjiwCPUFDwhXtLzw5rPFFOEBrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iujjRhH+WVA5mfrU+ZB3RR5BOlFHipK6OzyQL2Bm4m8aa2N7Cg3LtlWpEAuSTpUU4qR3ocP3iZldKQE+2zq+tgPk5BnsNScHZYI2q3GmuFiWFM3csPpLqpjEhp2+hW3TNxpQ+PnJ8UckwDqLzX9a+22yaFdzs+BOWwj9PZ3TzMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uppO28YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uppO28YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81098C116B1;
	Wed, 15 May 2024 08:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715761627;
	bh=cR4iNBhkVcRgYgdv6EjiwCPUFDwhXtLzw5rPFFOEBrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uppO28YYzNXTCd7/QmZDVel8MYvkicP0T39sWyHTcxoAYNgkbjh43OFBwhY9+hK7O
	 G2tq95cD+jU67gMe4XMi9RcGpcmWqdJN4KLBnL8gExChvYf69pSoR6y0gmDG3hj4b6
	 pQbkBvTFq9KQ4nHpyCljJlaRPiIo34LlEZE1IGi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 6.9 1/5] VFIO: Add the SPR_DSA and SPR_IAX devices to the denylist
Date: Wed, 15 May 2024 10:26:38 +0200
Message-ID: <20240515082345.484193693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
References: <20240515082345.213796290@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit 95feb3160eef0caa6018e175a5560b816aee8e79 upstream.

Due to an erratum with the SPR_DSA and SPR_IAX devices, it is not secure to assign
these devices to virtual machines. Add the PCI IDs of these devices to the VFIO
denylist to ensure that this is handled appropriately by the VFIO subsystem.

The SPR_DSA and SPR_IAX devices are on-SOC devices for the Sapphire Rapids
(and related) family of products that perform data movement and compression.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/registers.h |    3 ---
 drivers/vfio/pci/vfio_pci.c  |    2 ++
 include/linux/pci_ids.h      |    2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -6,9 +6,6 @@
 #include <uapi/linux/idxd.h>
 
 /* PCI Config */
-#define PCI_DEVICE_ID_INTEL_DSA_SPR0	0x0b25
-#define PCI_DEVICE_ID_INTEL_IAX_SPR0	0x0cfe
-
 #define DEVICE_VERSION_1		0x100
 #define DEVICE_VERSION_2		0x200
 
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -71,6 +71,8 @@ static bool vfio_pci_dev_in_denylist(str
 		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
 		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
+		case PCI_DEVICE_ID_INTEL_DSA_SPR0:
+		case PCI_DEVICE_ID_INTEL_IAX_SPR0:
 			return true;
 		default:
 			return false;
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2687,8 +2687,10 @@
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
 #define PCI_DEVICE_ID_INTEL_HDA_HSW_0	0x0a0c
+#define PCI_DEVICE_ID_INTEL_DSA_SPR0	0x0b25
 #define PCI_DEVICE_ID_INTEL_HDA_HSW_2	0x0c0c
 #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
+#define PCI_DEVICE_ID_INTEL_IAX_SPR0	0x0cfe
 #define PCI_DEVICE_ID_INTEL_HDA_HSW_3	0x0d0c
 #define PCI_DEVICE_ID_INTEL_HDA_BYT	0x0f04
 #define PCI_DEVICE_ID_INTEL_SST_BYT	0x0f28


