Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835002459FF;
	Mon, 23 Jun 2025 13:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684325; cv=none; b=V1XPMIkip0hngPOxjnhO76s/ZWms3ciI1lY3x4WbrmuZbkEuEJS/Z2os7l1X6uJcYyTbv0t0eELV1fL4VfQsQhM5Z6BAaFZ94RxUrjbVxbVB/C8EaOKRlJO48rj7LanMhGDNn3YWmBPqs4PcuWzpdRaB749c9t3rxcB5H705FS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684325; c=relaxed/simple;
	bh=M4+ShqjlleNtSnngmwnPxzglkHGdmclHLemuxwnFYT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf4a02iurTkjeoJPlXiRmcG8lJ8fS7ycvyUgsgadM3qAzb39xeXyRRnNSRohF8bUtbdTLWZRaeBskOIt2suVA/8JFb8uopMe12g3fmMWyOVqPFxWlr5n8omZbirIGmqB9zpQg3oa8+t4lYU24B3c8q0OMX7j8CTu8D7pEU6P7e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpaleJs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpaleJs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BD0C4CEEA;
	Mon, 23 Jun 2025 13:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684325;
	bh=M4+ShqjlleNtSnngmwnPxzglkHGdmclHLemuxwnFYT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpaleJs/KFXRjT2s6NBUaGHL1hmQMZk28VrPpnaDKEBo7BiLdzOsPbMlFHQCUVMqY
	 yXyaREhTtynKX8E0eu0xSExRPz4o4fe95upHDb959RTYU6TG/1DhZGxY8z7/PGuNeq
	 FBM1LVnkDzBPMbYjPYUFedskXI94cxEeCwR1LS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.15 007/592] crypto: qat - add shutdown handler to qat_c3xxx
Date: Mon, 23 Jun 2025 14:59:25 +0200
Message-ID: <20250623130700.396990386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit 71e0cc1eab584d6f95526a5e8c69ec666ca33e1b upstream.

During a warm reset via kexec, the system bypasses the driver removal
sequence, meaning that the remove() callback is not invoked.
If a QAT device is not shutdown properly, the device driver will fail to
load in a newly rebooted kernel.

This might result in output like the following after the kexec reboot:

    QAT: AE0 is inactive!!
    QAT: failed to get device out of reset
    c3xxx 0000:3f:00.0: qat_hal_clr_reset error
    c3xxx 0000:3f:00.0: Failed to init the AEs
    c3xxx 0000:3f:00.0: Failed to initialise Acceleration Engine
    c3xxx 0000:3f:00.0: Resetting device qat_dev0
    c3xxx 0000:3f:00.0: probe with driver c3xxx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: 890c55f4dc0e ("crypto: qat - add support for c3xxx accel type")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -19,6 +19,13 @@
 #include <adf_dbgfs.h>
 #include "adf_c3xxx_hw_data.h"
 
+static void adf_shutdown(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	adf_dev_down(accel_dev);
+}
+
 static const struct pci_device_id adf_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX), },
 	{ }
@@ -33,6 +40,7 @@ static struct pci_driver adf_driver = {
 	.name = ADF_C3XXX_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };


