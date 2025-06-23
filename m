Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6D02505AF;
	Mon, 23 Jun 2025 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685766; cv=none; b=P/vnjVISKK8Ls/ikWOR6T5MbZye5Gp3qaL1iAArey2rLVhPbH8i4KgjAY6qTTXKQGvDdP79SJ9w4Eqdd7MLr87atKsgVGAIk9vn/LY6GAdFxHjWJLhJDKnjoeeSvjreqJsUWnJjaspVbqcM5cXnC3eYEZ2+lE7acnuyV6M01HGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685766; c=relaxed/simple;
	bh=+LBf8P+JDBBXcYLktiGnZ6DEHWVsRlwBigHEfXwSxAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB/hiaxxG3orCK48HlHfaGCX0cB8PKoNvTBp/1zRRkKkkoAIxZ8Ktpss8Dgz5BjR2lqG/DN5wJiF5d8MU11O34vtKwe/UtevSZwudO035Ih20kgGqP3eN2ekRbzWtbAyLjqC/+AK/E21aaR8VbXxJdy0EN2bukArEidJ00yieP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkypOYRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkypOYRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B5FC4CEEA;
	Mon, 23 Jun 2025 13:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685766;
	bh=+LBf8P+JDBBXcYLktiGnZ6DEHWVsRlwBigHEfXwSxAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkypOYRsXC1ouyM99Wzx+bOY5y71WadkfcC1LXcD9sOlBQg+R5RTFTfRbe/FWjfPs
	 G9LJwrn/UawHWppggSSNhKQE3KMR481h8smyJqEpXNx/RzuXBBCtBraEV6r88GVHvP
	 AAvgHK7YeM0MLpqPhVwgCal0esL7AQWULrmADYpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Wright <rwright@hpe.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 006/414] crypto: qat - add shutdown handler to qat_4xxx
Date: Mon, 23 Jun 2025 15:02:23 +0200
Message-ID: <20250623130642.182484717@linuxfoundation.org>
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
@@ -183,11 +183,19 @@ static void adf_remove(struct pci_dev *p
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


