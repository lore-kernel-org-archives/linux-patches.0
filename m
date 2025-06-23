Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D97024728E;
	Mon, 23 Jun 2025 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686122; cv=none; b=eJDQyinoZ/jEAW9kg3LxUKCxiOpinS9cxyxGKIzVOufsIj7gvo5WQ3XASVD5qftC4UogoNnm3oGiQUIijVRXu0eS/GrKpUuKjOZxFa1pVh4H/VKLOGzJ0JtQ5swKo6Lite12mJ1iMSVTxZq3T02Ccyc/3nT9Z0zNlHgs+fmjMuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686122; c=relaxed/simple;
	bh=CetJhIo5BjeSlZYuo43LBbI7mGUwdU3bcnMmzfrOD6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjvDamqeKRQCQSP9QRft7QSW9JXIE1SH3TSYvBIK4RfEjgsAqw00S2PbilBel8Qaj1xbjdFuHxtM4ehghtw8eqiQEmuIsjNG0wY8D16eB/pVIzfZfSUNdiZ4OJ79jNngdAvQ5G9rfjao5COFLMR5BwQ8lHgttKAShW3Byt1nd3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqDxPqEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqDxPqEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDD4C4CEEA;
	Mon, 23 Jun 2025 13:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686122;
	bh=CetJhIo5BjeSlZYuo43LBbI7mGUwdU3bcnMmzfrOD6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqDxPqEpWW0DkfEHnDqIL052BmAtqPmsZlvLDee6Gs7MQIgL6gVpoB8RfX7kpZT3g
	 XKQtJtb17s1PhfRhAW0m8/lG4WVNJZJ6GKjLz3twNXycxFpI0Beun3fkbnVwv38+ln
	 IR2npq0wbEPy/itbmYXHQwA0/JZebYq22MIC8/1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 004/414] crypto: qat - add shutdown handler to qat_c3xxx
Date: Mon, 23 Jun 2025 15:02:21 +0200
Message-ID: <20250623130642.131764390@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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


