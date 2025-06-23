Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EDA1F1522;
	Mon, 23 Jun 2025 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684328; cv=none; b=N/P/8yeH0TuPyCGd7mCmrepUKnC8CRqqWeJoSF6C5jXzc6V8Bp7scDmBEsZp3k4t/ZSrFkZURlxJAhTU94PoqvdjzjKrZXgrfK7upN5z/O+tYHmsBriPLW72tH6U7oAlReLpHHM6fa8KOkUoZnoRPdKAiryXe6bJVqzHsdwqHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684328; c=relaxed/simple;
	bh=IWB9o5OnmDac25mYInM6kVpzwa/L7amrYPPteBFDhso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+NbzcUWNQyAvLPuohRNZ+zD+aBNuo4FgnyUgUl8paulJkPwnmbgEDVm4YugD4fZM6SAWwBqzKdM+bD9lk8G6o9D6pz+mhEUckM+3VCGmFCsUceahIMKk9uHkcMXNCnb+spbCwKVl4wP6KBht8Re3kQgYAOxSccsp4cXkLwMUTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zao9qen8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zao9qen8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E63C4CEEA;
	Mon, 23 Jun 2025 13:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684327;
	bh=IWB9o5OnmDac25mYInM6kVpzwa/L7amrYPPteBFDhso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zao9qen8HWeIxKSbacxZXL0Pm+QW9O93sCig3kiqthvycIHnhSEZSZiIDdftfAsub
	 rPU1TJ6HVhhEOVxRzrEY5PuQAR6BAniWxhNZguMVz8URiYS8p2sRO0Xtz4QLkQhce8
	 ouKQ2NcY8QopIatdMjUZPTlx32CBmZ9zY2F1k5uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.15 008/592] crypto: qat - add shutdown handler to qat_420xx
Date: Mon, 23 Jun 2025 14:59:26 +0200
Message-ID: <20250623130700.422724306@linuxfoundation.org>
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

commit 097143f23a1164bfd1b6f70279d229be44da2e30 upstream.

During a warm reset via kexec, the system bypasses the driver removal
sequence, meaning that the remove() callback is not invoked.
If a QAT device is not shutdown properly, the device driver will fail to
load in a newly rebooted kernel.

This might result in output like the following after the kexec reboot:

    420xx 0000:01:00.0: Failed to power up the device
    420xx 0000:01:00.0: Failed to initialize device
    420xx 0000:01:00.0: Resetting device qat_dev0
    420xx 0000:01:00.0: probe with driver 420xx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -186,11 +186,19 @@ static void adf_remove(struct pci_dev *p
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
 	.name = ADF_420XX_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };


