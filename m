Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966A313298;
	Mon, 13 Apr 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099166; cv=none; b=n4Twjvs+c5eFstiox339sfn1vapQFUAPbM/NcaSrkMe5C3wXYRB5QNUKmWSNJ0JI1Ssm+DsXYTtpFoN5yBReLK+tQFiMV2Jfn+7OWie+Kq9U8lsUAsS3LruY8da4JmGIsFiuXsMHAX/on/8l1NYs0tDiC8zfZmUKYiqBi2cSJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099166; c=relaxed/simple;
	bh=vKyr5bdJP3xua1TuYNM4eUM64oPb97Olzt4ha/mS+fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qx/SP+LuYoCj81qrAOHdAq35H57QqiuhQD9oajSnbUJNvR8hFLEOt3G2HPb5O5YWyWgwTk+dNQED//kx4xHIu/1myXI4LmdoPu7TYX88DA8rEJX95GCetfqQHdCMZMoIkwGFqVplzy5/+XX0vTbqZZPvWmDITWQ3LuETltCcXKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocMywVma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocMywVma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AE2C2BCAF;
	Mon, 13 Apr 2026 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099165;
	bh=vKyr5bdJP3xua1TuYNM4eUM64oPb97Olzt4ha/mS+fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocMywVma/y6zbHQUKyWxnGf5tWGqEqe3Zrk5/7LeKtaK6Eg03KhxoA0CLMWXD+Tvv
	 ylSH85AjiA4wqEKNZGTbk2mFxsasiYAxwDIWuC+0J5awKFo7d4JPkcn/WTfUIKhO3t
	 E9mFvW6hsb3aANACSr1sovLlKTCWelbPnApDcgP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teddy Astie <teddy.astie@vates.tech>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 235/491] xen/privcmd: restrict usage in unprivileged domU
Date: Mon, 13 Apr 2026 17:58:00 +0200
Message-ID: <20260413155827.856258092@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 453b8fb68f3641fea970db88b7d9a153ed2a37e8 upstream.

The Xen privcmd driver allows to issue arbitrary hypercalls from
user space processes. This is normally no problem, as access is
usually limited to root and the hypervisor will deny any hypercalls
affecting other domains.

In case the guest is booted using secure boot, however, the privcmd
driver would be enabling a root user process to modify e.g. kernel
memory contents, thus breaking the secure boot feature.

The only known case where an unprivileged domU is really needing to
use the privcmd driver is the case when it is acting as the device
model for another guest. In this case all hypercalls issued via the
privcmd driver will target that other guest.

Fortunately the privcmd driver can already be locked down to allow
only hypercalls targeting a specific domain, but this mode can be
activated from user land only today.

The target domain can be obtained from Xenstore, so when not running
in dom0 restrict the privcmd driver to that target domain from the
beginning, resolving the potential problem of breaking secure boot.

This is XSA-482

Reported-by: Teddy Astie <teddy.astie@vates.tech>
Fixes: 1c5de1939c20 ("xen: add privcmd driver")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/privcmd.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) "xen:" KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -24,6 +25,8 @@
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/wait.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -37,6 +40,7 @@
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 #include <xen/balloon.h>
+#include <xen/xenbus.h>
 
 #include "privcmd.h"
 
@@ -59,6 +63,11 @@ struct privcmd_data {
 	domid_t domid;
 };
 
+/* DOMID_INVALID implies no restriction */
+static domid_t target_domain = DOMID_INVALID;
+static bool restrict_wait;
+static DECLARE_WAIT_QUEUE_HEAD(restrict_wait_wq);
+
 static int privcmd_vma_range_is_mapped(
                struct vm_area_struct *vma,
                unsigned long addr,
@@ -878,13 +887,16 @@ static long privcmd_ioctl(struct file *f
 
 static int privcmd_open(struct inode *ino, struct file *file)
 {
-	struct privcmd_data *data = kzalloc(sizeof(*data), GFP_KERNEL);
+	struct privcmd_data *data;
+
+	if (wait_event_interruptible(restrict_wait_wq, !restrict_wait) < 0)
+		return -EINTR;
 
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	/* DOMID_INVALID implies no restriction */
-	data->domid = DOMID_INVALID;
+	data->domid = target_domain;
 
 	file->private_data = data;
 	return 0;
@@ -977,6 +989,45 @@ static struct miscdevice privcmd_dev = {
 	.fops = &xen_privcmd_fops,
 };
 
+static int init_restrict(struct notifier_block *notifier,
+			 unsigned long event,
+			 void *data)
+{
+	char *target;
+	unsigned int domid;
+
+	/* Default to an guaranteed unused domain-id. */
+	target_domain = DOMID_IDLE;
+
+	target = xenbus_read(XBT_NIL, "target", "", NULL);
+	if (IS_ERR(target) || kstrtouint(target, 10, &domid)) {
+		pr_err("No target domain found, blocking all hypercalls\n");
+		goto out;
+	}
+
+	target_domain = domid;
+
+ out:
+	if (!IS_ERR(target))
+		kfree(target);
+
+	restrict_wait = false;
+	wake_up_all(&restrict_wait_wq);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xenstore_notifier = {
+	.notifier_call = init_restrict,
+};
+
+static void __init restrict_driver(void)
+{
+	restrict_wait = true;
+
+	register_xenstore_notifier(&xenstore_notifier);
+}
+
 static int __init privcmd_init(void)
 {
 	int err;
@@ -984,6 +1035,9 @@ static int __init privcmd_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (!xen_initial_domain())
+		restrict_driver();
+
 	err = misc_register(&privcmd_dev);
 	if (err != 0) {
 		pr_err("Could not register Xen privcmd device\n");


