Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779204D5A0;
	Wed, 15 May 2024 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715761619; cv=none; b=jQ/jJNwkJRYjkB/tVGsH74tjVDQ7KaLzICmjPqzhv0CULtwHtyjKJrcHAVzAPgO1GT8IwhnEncOjUIXgWzRMh46RNdxcG0B8yzzudU4aUuTUb6+SNQQhFrf4bWi0RQip6aiuJAd3TOELlihhihTERuSb6s/BbOCMcrL9CJXhvSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715761619; c=relaxed/simple;
	bh=NbfYz+M+nd2Zm85vBrGf+jufbpIFDJAZ9r9aHUz08ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBSWdrSnvKLkRaIZrc1G7spUedF3tabuDFNwc5z0EniSyY1E/uIBNyc06ev/t1HTyw/oWghytOeBvlofz4m/smyRCZW/OPWyVLIL4DRCT1Z+pxVO3EmGgdK8PwpGfzaItS5xyYLAqQDxqfIahQyeYBeZxKwIRYQvtnAGttcrMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePMxZpxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePMxZpxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A493FC116B1;
	Wed, 15 May 2024 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715761619;
	bh=NbfYz+M+nd2Zm85vBrGf+jufbpIFDJAZ9r9aHUz08ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePMxZpxWmuKIT0NNFbb8S0IiETq09IyYzAhaD3tXi1Z6GwIG7mcRgmiLa2e1b23jX
	 7ai4S5DUyfeof0T1GGEZl3KHZWC0+6UTBlJ7PtMhC0uJLByObj/WVPdT0fwLWD2PS1
	 XtjYZzOrfMMaeqvY+qY+IfhvORbdSrbrvCujfBqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Rao <nikhil.rao@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 6.9 3/5] dmaengine: idxd: add a write() method for applications to submit work
Date: Wed, 15 May 2024 10:26:40 +0200
Message-ID: <20240515082345.856306840@linuxfoundation.org>
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

From: Nikhil Rao <nikhil.rao@intel.com>

commit 6827738dc684a87ad54ebba3ae7f3d7c977698eb upstream.

After the patch to restrict the use of mmap() to CAP_SYS_RAWIO for
the currently existing devices, most applications can no longer make
use of the accelerators as in production "you don't run things as root".

To keep the DSA and IAA accelerators usable, hook up a write() method
so that applications can still submit work. In the write method,
sufficient input validation is performed to avoid the security issue
that required the mmap CAP_SYS_RAWIO check.

One complication is that the DSA device allows for indirect ("batched")
descriptors. There is no reasonable way to do the input validation
on these indirect descriptors so the write() method will not allow these
to be submitted to the hardware on affected hardware, and the sysfs
enumeration of support for the opcode is also removed.

Early performance data shows that the performance delta for most common
cases is within the noise.

Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/cdev.c  |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/sysfs.c |   27 ++++++++++++++++++-
 2 files changed, 90 insertions(+), 2 deletions(-)

--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -426,6 +426,70 @@ static int idxd_cdev_mmap(struct file *f
 			vma->vm_page_prot);
 }
 
+static int idxd_submit_user_descriptor(struct idxd_user_context *ctx,
+				       struct dsa_hw_desc __user *udesc)
+{
+	struct idxd_wq *wq = ctx->wq;
+	struct idxd_dev *idxd_dev = &wq->idxd->idxd_dev;
+	const uint64_t comp_addr_align = is_dsa_dev(idxd_dev) ? 0x20 : 0x40;
+	void __iomem *portal = idxd_wq_portal_addr(wq);
+	struct dsa_hw_desc descriptor __aligned(64);
+	int rc;
+
+	rc = copy_from_user(&descriptor, udesc, sizeof(descriptor));
+	if (rc)
+		return -EFAULT;
+
+	/*
+	 * DSA devices are capable of indirect ("batch") command submission.
+	 * On devices where direct user submissions are not safe, we cannot
+	 * allow this since there is no good way for us to verify these
+	 * indirect commands.
+	 */
+	if (is_dsa_dev(idxd_dev) && descriptor.opcode == DSA_OPCODE_BATCH &&
+		!wq->idxd->user_submission_safe)
+		return -EINVAL;
+	/*
+	 * As per the programming specification, the completion address must be
+	 * aligned to 32 or 64 bytes. If this is violated the hardware
+	 * engine can get very confused (security issue).
+	 */
+	if (!IS_ALIGNED(descriptor.completion_addr, comp_addr_align))
+		return -EINVAL;
+
+	if (wq_dedicated(wq))
+		iosubmit_cmds512(portal, &descriptor, 1);
+	else {
+		descriptor.priv = 0;
+		descriptor.pasid = ctx->pasid;
+		rc = idxd_enqcmds(wq, portal, &descriptor);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+static ssize_t idxd_cdev_write(struct file *filp, const char __user *buf, size_t len,
+			       loff_t *unused)
+{
+	struct dsa_hw_desc __user *udesc = (struct dsa_hw_desc __user *)buf;
+	struct idxd_user_context *ctx = filp->private_data;
+	ssize_t written = 0;
+	int i;
+
+	for (i = 0; i < len/sizeof(struct dsa_hw_desc); i++) {
+		int rc = idxd_submit_user_descriptor(ctx, udesc + i);
+
+		if (rc)
+			return written ? written : rc;
+
+		written += sizeof(struct dsa_hw_desc);
+	}
+
+	return written;
+}
+
 static __poll_t idxd_cdev_poll(struct file *filp,
 			       struct poll_table_struct *wait)
 {
@@ -448,6 +512,7 @@ static const struct file_operations idxd
 	.open = idxd_cdev_open,
 	.release = idxd_cdev_release,
 	.mmap = idxd_cdev_mmap,
+	.write = idxd_cdev_write,
 	.poll = idxd_cdev_poll,
 };
 
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1197,12 +1197,35 @@ static ssize_t wq_enqcmds_retries_store(
 static struct device_attribute dev_attr_wq_enqcmds_retries =
 		__ATTR(enqcmds_retries, 0644, wq_enqcmds_retries_show, wq_enqcmds_retries_store);
 
+static ssize_t op_cap_show_common(struct device *dev, char *buf, unsigned long *opcap_bmap)
+{
+	ssize_t pos;
+	int i;
+
+	pos = 0;
+	for (i = IDXD_MAX_OPCAP_BITS/64 - 1; i >= 0; i--) {
+		unsigned long val = opcap_bmap[i];
+
+		/* On systems where direct user submissions are not safe, we need to clear out
+		 * the BATCH capability from the capability mask in sysfs since we cannot support
+		 * that command on such systems.
+		 */
+		if (i == DSA_OPCODE_BATCH/64 && !confdev_to_idxd(dev)->user_submission_safe)
+			clear_bit(DSA_OPCODE_BATCH % 64, &val);
+
+		pos += sysfs_emit_at(buf, pos, "%*pb", 64, &val);
+		pos += sysfs_emit_at(buf, pos, "%c", i == 0 ? '\n' : ',');
+	}
+
+	return pos;
+}
+
 static ssize_t wq_op_config_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
 	struct idxd_wq *wq = confdev_to_wq(dev);
 
-	return sysfs_emit(buf, "%*pb\n", IDXD_MAX_OPCAP_BITS, wq->opcap_bmap);
+	return op_cap_show_common(dev, buf, wq->opcap_bmap);
 }
 
 static int idxd_verify_supported_opcap(struct idxd_device *idxd, unsigned long *opmask)
@@ -1455,7 +1478,7 @@ static ssize_t op_cap_show(struct device
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
-	return sysfs_emit(buf, "%*pb\n", IDXD_MAX_OPCAP_BITS, idxd->opcap_bmap);
+	return op_cap_show_common(dev, buf, idxd->opcap_bmap);
 }
 static DEVICE_ATTR_RO(op_cap);
 


