Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2318B257AEC;
	Mon, 23 Jun 2025 13:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685787; cv=none; b=FsaTAoYcsssMqEK2NxtxvmT6b7TJ//DfA85R8M9DxeBNPza+1ovvMqwtTuB4Hzk+QBKWX5ARPfsEwY335RKHdw02r1YFDZmcriWGsWZnYbbumdsNoqRNr7EoAgR97DGErKJE2OTuYzg1wECugl2o3USoagvdNbXCtjKF+l1Kfqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685787; c=relaxed/simple;
	bh=GXdFq3XMg8Sr1Nm8ECJScJY3+BWzc34Yy6qT0iPzh94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Knzz8tBGjkuSodhrzjdrktgejNr9UkJnwDH2rVXSheHlZtKyTTrW4g190HtSinHFfx+077vEuv36VzAMh4nlRmTzcX2P5KhKdF4pIcy0goE5x5uX9MMZJzUmNvD6vodXIBdQvXNvCOkCkVQnFMv3GnwlgO6ek2nmTL6N4OoSzTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmyMI76Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmyMI76Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4C0C4CEF0;
	Mon, 23 Jun 2025 13:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685787;
	bh=GXdFq3XMg8Sr1Nm8ECJScJY3+BWzc34Yy6qT0iPzh94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmyMI76Z2vQWLk8N/nzGmhURGPL2HhWHm240+yCthTUnSiBIUvu9WfQSm160+3au/
	 hy/kPy9DyDWSSHBqMQteNNoEcwtx1nAJmgQK1uFa/2gvNOwoHqBP9VLtexQgeono3q
	 ytAMNJP/ikQWurWM/czEGYw9o5rY6WIOvqv8dDKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 007/414] crypto: qat - add shutdown handler to qat_c62x
Date: Mon, 23 Jun 2025 15:02:24 +0200
Message-ID: <20250623130642.211610086@linuxfoundation.org>
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

commit a9a6e9279b2998e2610c70b0dfc80a234f97c76c upstream.

During a warm reset via kexec, the system bypasses the driver removal
sequence, meaning that the remove() callback is not invoked.
If a QAT device is not shutdown properly, the device driver will fail to
load in a newly rebooted kernel.

This might result in output like the following after the kexec reboot:

    QAT: AE0 is inactive!!
    QAT: failed to get device out of reset
    c6xx 0000:3f:00.0: qat_hal_clr_reset error
    c6xx 0000:3f:00.0: Failed to init the AEs
    c6xx 0000:3f:00.0: Failed to initialise Acceleration Engine
    c6xx 0000:3f:00.0: Resetting device qat_dev0
    c6xx 0000:3f:00.0: probe with driver c6xx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: a6dabee6c8ba ("crypto: qat - add support for c62x accel type")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -19,6 +19,13 @@
 #include <adf_dbgfs.h>
 #include "adf_c62x_hw_data.h"
 
+static void adf_shutdown(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	adf_dev_down(accel_dev);
+}
+
 static const struct pci_device_id adf_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X), },
 	{ }
@@ -33,6 +40,7 @@ static struct pci_driver adf_driver = {
 	.name = ADF_C62X_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };


