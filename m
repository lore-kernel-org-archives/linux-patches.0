Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D83136988;
	Mon, 23 Jun 2025 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684330; cv=none; b=JK69HcZOCTzXOM3153wEd9YsiIs1QpTnU+fCQAWCvUtL93JO/bDSS8hETIl4C5TxRICxsZt05lDswQjqyapZn7kNbkUBoA8zwaDknTu5Hyhbzp6XN59zN4zfP9v9hIu6C0S3wxYdsXa4UiII9i+Bp5dgMOC0Bm10nw1QAy+Q+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684330; c=relaxed/simple;
	bh=FNbvcUhcnLLExQECjQd8H/1fEGiEGQU4M18UTQLx1Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbBqdkgLV+8Q+/oFHVM0980XFqwr2LDoJI9Xf57U7O0YddogFWxOJNqPJfhJuG6oIUzXmOYYHtsgbHMZ3x7ZguWRn6O21hZkqcm97A96TzOGcty8OQ8x2Zl8K1v49B8HZ6lbDQVWfpv06SaA0c/sqFJEhglDgTuNWB4r+REKy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIVD5q8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIVD5q8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7D9C4CEEA;
	Mon, 23 Jun 2025 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684330;
	bh=FNbvcUhcnLLExQECjQd8H/1fEGiEGQU4M18UTQLx1Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIVD5q8/cEdYxcSEq9gmHCCqW3XiLDsW60U0jDu4/1rEslaR8+jpE8TRazObPgTCn
	 rF0+n9dtHcw/10yvxbt6eJ11PYHxUcrcikcEuH/VEEZj8G6zFCGSbz5kyjSN4agCmV
	 rkmh44jbK26OqrS0nI8YYiSzN0FD8MVdinez1wY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Wright <rwright@hpe.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.15 009/592] crypto: qat - add shutdown handler to qat_4xxx
Date: Mon, 23 Jun 2025 14:59:27 +0200
Message-ID: <20250623130700.445043425@linuxfoundation.org>
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

commit 845bc952024dbf482c7434daeac66f764642d52d upstream.

During a warm reset via kexec, the system bypasses the driver removal
sequence, meaning that the remove() callback is not invoked.
If a QAT device is not shutdown properly, the device driver will fail to
load in a newly rebooted kernel.

This might result in output like the following after the kexec reboot:

    4xxx 0000:01:00.0: Failed to power up the device
    4xxx 0000:01:00.0: Failed to initialize device
    4xxx 0000:01:00.0: Resetting device qat_dev0
    4xxx 0000:01:00.0: probe with driver 4xxx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: 8c8268166e83 ("crypto: qat - add qat_4xxx driver")
Link: https://lore.kernel.org/all/Z-DGQrhRj9niR9iZ@gondor.apana.org.au/
Reported-by: Randy Wright <rwright@hpe.com>
Closes: https://issues.redhat.com/browse/RHEL-84366
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -188,11 +188,19 @@ static void adf_remove(struct pci_dev *p
 	adf_cleanup_accel(accel_dev);
 }
 
+static void adf_shutdown(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	adf_dev_down(accel_dev);
+}
+
 static struct pci_driver adf_driver = {
 	.id_table = adf_pci_tbl,
 	.name = ADF_4XXX_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };


