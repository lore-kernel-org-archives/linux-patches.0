Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE9331A045;
	Fri,  9 Oct 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556007; cv=none; b=fdZ6ZCZrbuGg5q1W6vBBarEiNsyov3bxB7Tk+0Snv6CHYgCIju1qTOPsYvCnhGyYqd1DS9MWs9jb6qMErof7+LALoZeHL+nTewyuN8UJ+mjgay5Fr7n+GfXBsAZG/cYgD3K4SZKgbah7Wp4k1oXjog28y3hd+FEHoCBCe6x/YEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556007; c=relaxed/simple;
	bh=4/eXPc9unSf+IJv3JEieWoR/zK5QzirtUR3JkwpHe1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0hqT1Zuf1N61yfHeIbHYkg7CL/kE43QvmUrigOmmqXXx5jmGv3fcuFxkqzX3prI28RTAswQAlChz/OM6g2VR1laVIrBayefKzPWOyiKhD20kd+P/SjGPw03sUHFl4d7LqqgiN9mpI2k9WKkg2CRwqDV13jg3WeXxmids4w+MSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2o0ehqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2o0ehqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A1D1F000FF;
	Fri,  9 Oct 2026 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556005;
	bh=IMBvI3VVn4Ly52P48C6ajU9mFrIzeEVbEvUSo37g0L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2o0ehqKITlvq63bQmkRl2BQTX5fY4Mn4EpFX6OO9Gubbs8u2/3amkK1ucM2otwMR
	 IbClq2KzPfrzMqlOpulh4Z/h+u+d2uDY8HTynZeNAikeq09BHmYroIcJ++Oxxj/gGL
	 jKXc9vl9OSPnbY4frcnKP486ehW9TJQLl4kIBAog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	John Garry <john.garry@linux.dev>,
	Damien Le Moal <dlemoal@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 106/428] nvme: work around -Wformat-security warning
Date: Fri,  9 Oct 2026 16:07:23 +0200
Message-ID: <20261009140948.538510463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6b8a5367e9e73a17561b8ce584ae77a43f712007 ]

Passing a string variable into dev_set_name() causes a warning
when building with -Wformat-security enabled:

drivers/nvme/host/core.c: In function 'nvme_cdev_add':
drivers/nvme/host/core.c:3911:9: error: format not a string literal and no format arguments [-Werror=format-security]
 3911 |         ret = dev_set_name(cdev_device, name);

Remove the temporary strings and let dev_set_name() do the
same thing internally.

Fixes: 26acdaa357cd ("nvme: fix crash and memory leak during invalid cdev teardown")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: John Garry <john.garry@linux.dev>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      |   21 +++++++++------------
 drivers/nvme/host/multipath.c |   12 +++++-------
 drivers/nvme/host/nvme.h      |    6 +++---
 3 files changed, 17 insertions(+), 22 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3913,9 +3913,9 @@ void nvme_cdev_del(struct cdev *cdev, st
 	put_device(cdev_device);
 }
 
-int nvme_cdev_add(const char *name, struct cdev *cdev,
-		struct device *cdev_device,
-		const struct file_operations *fops, struct module *owner)
+int nvme_cdev_add(struct cdev *cdev, struct device *cdev_device,
+		const struct file_operations *fops, struct module *owner,
+		int ctrl, int head)
 {
 	int minor, ret;
 
@@ -3923,7 +3923,7 @@ int nvme_cdev_add(const char *name, stru
 	if (minor < 0)
 		return minor;
 
-	ret = dev_set_name(cdev_device, name);
+	ret = dev_set_name(cdev_device, "ng%dn%d", ctrl, head);
 	if (ret) {
 		ida_free(&nvme_ns_chr_minor_ida, minor);
 		return ret;
@@ -3964,17 +3964,14 @@ static const struct file_operations nvme
 
 static void nvme_add_ns_cdev(struct nvme_ns *ns)
 {
-	char name[32];
-
 	ns->cdev_device.parent = ns->ctrl->device;
-	snprintf(name, sizeof(name), "ng%dn%d", ns->ctrl->instance,
-		 ns->head->instance);
 
 	nvme_get_ns(ns); /* Undone in nvme_cdev_rel() */
-	if (nvme_cdev_add(name, &ns->cdev, &ns->cdev_device,
-			&nvme_ns_chr_fops, ns->ctrl->ops->module)) {
-		dev_err(ns->ctrl->device, "Unable to create the %s device\n",
-			name);
+	if (nvme_cdev_add(&ns->cdev, &ns->cdev_device,
+			&nvme_ns_chr_fops, ns->ctrl->ops->module,
+			ns->ctrl->instance, ns->head->instance)) {
+		dev_err(ns->ctrl->device, "Unable to create the ng%dn%d device\n",
+			ns->ctrl->instance, ns->head->instance);
 		nvme_put_ns(ns);
 		return;
 	}
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -621,17 +621,15 @@ static const struct file_operations nvme
 
 static void nvme_add_ns_head_cdev(struct nvme_ns_head *head)
 {
-	char name[32];
-
 	head->cdev_device.parent = &head->subsys->dev;
-	snprintf(name, sizeof(name), "ng%dn%d", head->subsys->instance,
-		 head->instance);
 
 	nvme_get_ns_head(head); /* Undone in nvme_cdev_rel() */
-	if (nvme_cdev_add(name, &head->cdev, &head->cdev_device,
-			&nvme_ns_head_chr_fops, THIS_MODULE)) {
+	if (nvme_cdev_add(&head->cdev, &head->cdev_device,
+			&nvme_ns_head_chr_fops, THIS_MODULE,
+			head->subsys->instance, head->instance)) {
 		dev_err(disk_to_dev(head->disk),
-			"Unable to create the %s device\n", name);
+			"Unable to create the ng%dn%d device\n",
+			head->subsys->instance, head->instance);
 		nvme_put_ns_head(head);
 		return;
 	}
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1008,9 +1008,9 @@ int nvme_get_log(struct nvme_ctrl *ctrl,
 void nvme_get_ns_head(struct nvme_ns_head *head);
 bool nvme_tryget_ns_head(struct nvme_ns_head *head);
 void nvme_put_ns_head(struct nvme_ns_head *head);
-int nvme_cdev_add(const char *name, struct cdev *cdev,
-		struct device *cdev_device,
-		const struct file_operations *fops, struct module *owner);
+int nvme_cdev_add(struct cdev *cdev, struct device *cdev_device,
+		const struct file_operations *fops, struct module *owner,
+		int ctrl, int head);
 void nvme_cdev_del(struct cdev *cdev, struct device *cdev_device);
 int nvme_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);


