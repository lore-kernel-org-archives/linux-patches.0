Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61BB482E9;
	Wed, 15 May 2024 08:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715761616; cv=none; b=rtuqQUbtW5VOMYCf7oFv6QYpS1wJT6McOJJdukku80JF6zqv2oEhbmdUOVuaMd4aQ33Whz6DgsewtK86yEBPo6TPymnAILWVaNI88rrHYCUiVLJjX898LgQWt15ZA8znJ9qEsaP1FREbW6Lmqe39j3cPeVPtzFE5o+aGGm8hgN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715761616; c=relaxed/simple;
	bh=TXFbClsquKLng4Fb6Qwq7I+2xqyCg/NdGwIDyZu3PAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwLkBfwooXzmHmYbmPbaO5JT4H3VlVa/s5EJkaPwUVxoRU3KaWEG5qLQCHYh8cREDE9Aqegem0gEKlFh1/qbcaeFRW3pwbTqEEDdr+ShMxPAhSTLzmu7Kk7tpRuvrii5JPCHRglF3cWX8dYcwyYuJ5Puw9bDaCXeSHTsKNsVtDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naEyE5en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naEyE5en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4292C116B1;
	Wed, 15 May 2024 08:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715761616;
	bh=TXFbClsquKLng4Fb6Qwq7I+2xqyCg/NdGwIDyZu3PAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naEyE5enmmqUjOBLgz2E/AyKde6IkPKIXgTnmHD13NiqU+4xDW7/aCXMx+xS0jbuP
	 z6Em3AVqCerZvSZ1JLOkv/++SYtbRptcb46yJpuE0vEifujyHA74USN1nI01Rf039t
	 +mYSdJZFF5IcyxGZfv4OVxrJplF/3T75G3l7DrCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 6.9 2/5] dmaengine: idxd: add a new security check to deal with a hardware erratum
Date: Wed, 15 May 2024 10:26:39 +0200
Message-ID: <20240515082345.671446389@linuxfoundation.org>
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

commit e11452eb071b2a8e6ba52892b2e270bbdaa6640d upstream.

On Sapphire Rapids and related platforms, the DSA and IAA devices have an
erratum that causes direct access (for example, by using the ENQCMD or
MOVDIR64 instructions) from untrusted applications to be a security problem.

To solve this, add a flag to the PCI device enumeration and device structures
to indicate the presence/absence of this security exposure. In the mmap()
method of the device, this flag is then used to enforce that the user
has the CAP_SYS_RAWIO capability.

In a future patch, a write() based method will be added that allows untrusted
applications submit work to the accelerator, where the kernel can do
sanity checking on the user input to ensure secure operation of the accelerator.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/cdev.c |   12 ++++++++++++
 drivers/dma/idxd/idxd.h |    3 +++
 drivers/dma/idxd/init.c |    4 ++++
 3 files changed, 19 insertions(+)

--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -400,6 +400,18 @@ static int idxd_cdev_mmap(struct file *f
 	int rc;
 
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
+
+	/*
+	 * Due to an erratum in some of the devices supported by the driver,
+	 * direct user submission to the device can be unsafe.
+	 * (See the INTEL-SA-01084 security advisory)
+	 *
+	 * For the devices that exhibit this behavior, require that the user
+	 * has CAP_SYS_RAWIO capabilities.
+	 */
+	if (!idxd->user_submission_safe && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	rc = check_vma(wq, vma, __func__);
 	if (rc < 0)
 		return rc;
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -288,6 +288,7 @@ struct idxd_driver_data {
 	int evl_cr_off;
 	int cr_status_off;
 	int cr_result_off;
+	bool user_submission_safe;
 	load_device_defaults_fn_t load_device_defaults;
 };
 
@@ -374,6 +375,8 @@ struct idxd_device {
 
 	struct dentry *dbgfs_dir;
 	struct dentry *dbgfs_evl_file;
+
+	bool user_submission_safe;
 };
 
 static inline unsigned int evl_ent_size(struct idxd_device *idxd)
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -47,6 +47,7 @@ static struct idxd_driver_data idxd_driv
 		.align = 32,
 		.dev_type = &dsa_device_type,
 		.evl_cr_off = offsetof(struct dsa_evl_entry, cr),
+		.user_submission_safe = false, /* See INTEL-SA-01084 security advisory */
 		.cr_status_off = offsetof(struct dsa_completion_record, status),
 		.cr_result_off = offsetof(struct dsa_completion_record, result),
 	},
@@ -57,6 +58,7 @@ static struct idxd_driver_data idxd_driv
 		.align = 64,
 		.dev_type = &iax_device_type,
 		.evl_cr_off = offsetof(struct iax_evl_entry, cr),
+		.user_submission_safe = false, /* See INTEL-SA-01084 security advisory */
 		.cr_status_off = offsetof(struct iax_completion_record, status),
 		.cr_result_off = offsetof(struct iax_completion_record, error_code),
 		.load_device_defaults = idxd_load_iaa_device_defaults,
@@ -774,6 +776,8 @@ static int idxd_pci_probe(struct pci_dev
 	dev_info(&pdev->dev, "Intel(R) Accelerator Device (v%x)\n",
 		 idxd->hw.version);
 
+	idxd->user_submission_safe = data->user_submission_safe;
+
 	return 0;
 
  err_dev_register:


