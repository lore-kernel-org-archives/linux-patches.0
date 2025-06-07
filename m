Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735D015D1;
	Sat,  7 Jun 2025 10:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290950; cv=none; b=hpPcw1+ftRq4g9EaF7rRPmO0TbN2fnvXV07ekiH2nCk/cWTGBEuUNrHl2O3dgMkTHboeELjo7LCpsVQQcjY5lKhgYn/w+kkyC/jcnP3xfmp1HMn6vPWlwVvf5WOOAkmaP2tQEOQ6GC7gGbwK8yPKNlzu4BCLGirx0zBIm6sS3/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290950; c=relaxed/simple;
	bh=42utxIOhrAf9sVJ0GJMVOyfXo1ZJbwjsdvSLSAZxvPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/2aTHeKPkHgOMzaHAQLYIiBoZvtIOc4eellT17UWX7k824g+VKh/hz7MZvZZp3+ryN0M1Rd7+ifqm+7mbp62Spv52e1oN1jdsxqScXrafJYL7bp5KAAQMEHLpgNgdPUBwDPxU01j13KH9QwYQvsTpwj+Lmkyag1bVKd/KUrmzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k7h3aIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k7h3aIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00369C4CEE4;
	Sat,  7 Jun 2025 10:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290950;
	bh=42utxIOhrAf9sVJ0GJMVOyfXo1ZJbwjsdvSLSAZxvPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2k7h3aIgFglOsKbcT2FDIfQ4cohc8UbUwACySUz+cusY8Ik1Sa8kvZ4DUULTai/vT
	 q0kQCmydIPqL+Rto9AtnEytFAnwmKGuwStIqNi/HZAhYN9qs55AakFIOhxQ85R4T6W
	 cUS0+V8cT4U0cwk25so7FhepbVTSqAJabyxFKcfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 09/24] accel/ivpu: Add initial Panther Lake support
Date: Sat,  7 Jun 2025 12:07:40 +0200
Message-ID: <20250607100718.275751852@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maciej Falkowski <maciej.falkowski@linux.intel.com>

commit c140244f0cfb9601dbc35e7ab90914954a76b3d1 upstream.

Add support for the 5th generation of Intel NPU that
is going to be present in PTL_P (Panther Lake) CPUs.
NPU5 code reuses almost all of previous driver code.

Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004162505.1695605-2-maciej.falkowski@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    1 +
 drivers/accel/ivpu/ivpu_drv.h |   10 +++++++---
 drivers/accel/ivpu/ivpu_fw.c  |    3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -709,6 +709,7 @@ static struct pci_device_id ivpu_pci_ids
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_MTL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_ARL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_LNL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PTL_P) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ivpu_pci_ids);
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -23,9 +23,10 @@
 #define DRIVER_DESC "Driver for Intel NPU (Neural Processing Unit)"
 #define DRIVER_DATE "20230117"
 
-#define PCI_DEVICE_ID_MTL   0x7d1d
-#define PCI_DEVICE_ID_ARL   0xad1d
-#define PCI_DEVICE_ID_LNL   0x643e
+#define PCI_DEVICE_ID_MTL	0x7d1d
+#define PCI_DEVICE_ID_ARL	0xad1d
+#define PCI_DEVICE_ID_LNL	0x643e
+#define PCI_DEVICE_ID_PTL_P	0xb03e
 
 #define IVPU_HW_IP_37XX 37
 #define IVPU_HW_IP_40XX 40
@@ -227,6 +228,8 @@ static inline int ivpu_hw_ip_gen(struct
 		return IVPU_HW_IP_37XX;
 	case PCI_DEVICE_ID_LNL:
 		return IVPU_HW_IP_40XX;
+	case PCI_DEVICE_ID_PTL_P:
+		return IVPU_HW_IP_50XX;
 	default:
 		dump_stack();
 		ivpu_err(vdev, "Unknown NPU IP generation\n");
@@ -241,6 +244,7 @@ static inline int ivpu_hw_btrs_gen(struc
 	case PCI_DEVICE_ID_ARL:
 		return IVPU_HW_BTRS_MTL;
 	case PCI_DEVICE_ID_LNL:
+	case PCI_DEVICE_ID_PTL_P:
 		return IVPU_HW_BTRS_LNL;
 	default:
 		dump_stack();
--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -57,11 +57,14 @@ static struct {
 	{ IVPU_HW_IP_37XX, "intel/vpu/vpu_37xx_v0.0.bin" },
 	{ IVPU_HW_IP_40XX, "vpu_40xx.bin" },
 	{ IVPU_HW_IP_40XX, "intel/vpu/vpu_40xx_v0.0.bin" },
+	{ IVPU_HW_IP_50XX, "vpu_50xx.bin" },
+	{ IVPU_HW_IP_50XX, "intel/vpu/vpu_50xx_v0.0.bin" },
 };
 
 /* Production fw_names from the table above */
 MODULE_FIRMWARE("intel/vpu/vpu_37xx_v0.0.bin");
 MODULE_FIRMWARE("intel/vpu/vpu_40xx_v0.0.bin");
+MODULE_FIRMWARE("intel/vpu/vpu_50xx_v0.0.bin");
 
 static int ivpu_fw_request(struct ivpu_device *vdev)
 {


