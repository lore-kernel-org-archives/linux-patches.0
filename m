Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA4119D065;
	Wed, 30 Jul 2025 09:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868482; cv=none; b=el9kGX+6Zitn7EfKZhfTgN8xkh0idAUfKnN+IVBC6gSfPyZ8krG8LSs2M5vUG9lHNIsAJOg+jlPkz77pnyof65Yr87oIOh9dmvomwfHtwW9q9OMHky4Xqg/NRJhStMjtVk+H1Wj30QwpRZI4AFih+Zbta589+ApSvuqtBOSYgkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868482; c=relaxed/simple;
	bh=A10ubhc9TdoYOlZ5qfkBUhKDwQF+ZjSAfpUwX2JLxnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb9Fsf7hr6TBqBV7pXKu58Sq/I2sPJN1hU25ff0fEGViPGnlmKFJF1IUL7X17KXUmU9WUPHe4i4tPB8eikgwT1sHrSKQkHIhy/Q6UkLN1MHVBH0y94woCDNng3sjWhwcNGrnsbc4HY7k23IaQwnQuuyfdEgdgexi0rI6j5NyqHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff6fJTlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff6fJTlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A49C4CEE7;
	Wed, 30 Jul 2025 09:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868481;
	bh=A10ubhc9TdoYOlZ5qfkBUhKDwQF+ZjSAfpUwX2JLxnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ff6fJTlC68wwjntK4KJQNKWZcn9F0+AKyreaB7ncH+EXhaKw9D58Optbh+Ta6tBDV
	 ztuvGpCGaYWMmf+E35XCleDtesrt50IFnBrqPMpg6GS4JkjLipIgT1iLccx65Ng0S3
	 da/3sdr3jJG7KEdW+E4H+xWrUJ3ZPyVZs3vNEGak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 61/76] crypto: qat - add shutdown handler to qat_dh895xcc
Date: Wed, 30 Jul 2025 11:35:54 +0200
Message-ID: <20250730093229.232849105@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 2c4e8b228733bfbcaf49408fdf94d220f6eb78fc ]

During a warm reset via kexec, the system bypasses the driver removal
sequence, meaning that the remove() callback is not invoked.
If a QAT device is not shutdown properly, the device driver will fail to
load in a newly rebooted kernel.

This might result in output like the following after the kexec reboot:

    QAT: AE0 is inactive!!
    QAT: failed to get device out of reset
    dh895xcc 0000:3f:00.0: qat_hal_clr_reset error
    dh895xcc 0000:3f:00.0: Failed to init the AEs
    dh895xcc 0000:3f:00.0: Failed to initialise Acceleration Engine
    dh895xcc 0000:3f:00.0: Resetting device qat_dev0
    dh895xcc 0000:3f:00.0: probe with driver dh895xcc failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ added false parameter to adf_dev_down() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -27,12 +27,14 @@ MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
 static int adf_probe(struct pci_dev *dev, const struct pci_device_id *ent);
 static void adf_remove(struct pci_dev *dev);
+static void adf_shutdown(struct pci_dev *dev);
 
 static struct pci_driver adf_driver = {
 	.id_table = adf_pci_tbl,
 	.name = ADF_DH895XCC_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };
@@ -227,6 +229,13 @@ static void adf_remove(struct pci_dev *p
 	kfree(accel_dev);
 }
 
+static void adf_shutdown(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	adf_dev_down(accel_dev, false);
+}
+
 static int __init adfdrv_init(void)
 {
 	request_module("intel_qat");


