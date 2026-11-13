Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585571;
	b=PDBiP7Zpb7ukdONu4+VOXcCY7J3aLqfoCvldOQ+2opFLnk8lyrEVjBhN7HzkOykc1rwe
	 UnikAaZi+JJme1HjmPSAPxvmlPStl0e3K7VG3qRa1cpw628aHrKRHL+r6LcJo04rITM2X
	 la1bfO+OPx15yt9f2QkAnn83xNy5vVrwWHt4M2Zc7oIQJoqRDgGy7AYhxPDaU27q78OlT
	 g8tEZ77KKmFj+7qoudfyGqOv4E4xJ/dC2TBcJr4U1sUWG6mPeubaqd/2NBxnO/r35r+pJ
	 P3+po6XK+oMVKcvxIPJmPdtgLOC+cBQK25hJ/TUf8SJe4AGXCWyZyq1c4UvfeG/RZVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CxxBV/q0BR1xwn4UBQQaTB3wUp79b2VW4H7hWlpXmmI=;
	b=gzJIjQ3Z6KtEqkOQjYPOi/NOn/v+FD9Rgo/FKunjA40lFj5dspNV6R68hAkBi0qoIYPE
	 Z+KgxgLiEzZaydmcKT09OoBfTCAvDYwCCLBDv/vTcn8artXKw6MuFkJaiHQb4Bb+8Swlu
	 XUFzyrIMDsP/4u2sQ3x1yk5F63CowXSR7N+vpr+Qf3h2e90uBuhPcQiSLH97nZ/aozKbB
	 gntLQ7uO/b7kYRwejI5h/C3lNDwXH53Nat1XaSWQnt+vnZT2s7d23aiBAvedXOOjnRGKe
	 mtP5ASJwPPUU2l2LbsOHVufQKg3IdAyPb7GukVvHEoSeHpmGzwVBPpnPD57Nmtnttww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+30oCAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908D606BABC;
	Fri, 13 Nov 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+30oCAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842FD1F000C4;
	Fri, 13 Nov 2026 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585571;
	bh=CxxBV/q0BR1xwn4UBQQaTB3wUp79b2VW4H7hWlpXmmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+30oCAG0SmEW1krOUY8RMVIw+1v//C1P3qR31hclVYaBgS6lKOOKMKIB2GkVor7R
	 UmJZtZbiLECX2jUpF/TXloCZegMTFrax9C7qZzKSNE5hLEdj6ghOETovcuoSMIVWcf
	 aMJ5RoacMqXxKgP64yOKu+BdhRtIll5VfPm4uST4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@linux.dev>,
	Yuqiang Sun <izaiahsun@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 205/507] nvme: Do not drop the cdev reference twice when cdev_device_add() fails
Date: Fri, 13 Nov 2026 10:48:29 -0500
Message-ID: <20261113153801.427466560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqiang Sun <izaiahsun@gmail.com>

[ Upstream commit 7dfe79db5615df8d37ae7de6d3ec099b71bf3e03 ]

Since commit 9952f3882ecb ("nvme: fix cdev lifetime"),
nvme_add_ns_cdev() and nvme_add_ns_head_cdev() take a reference to the
namespace (or namespace head) before calling nvme_cdev_add(), to be
dropped by the char device's release, nvme_cdev_rel(), and drop it
themselves when nvme_cdev_add() fails. But when cdev_device_add()
fails, nvme_cdev_add() has already put the device, and nvme_cdev_rel()
has already dropped that reference: the caller drops it a second time.

With one allocation failure injected into cdev_device_add() for a
namespace on an NVMe over loop controller, deleting the controller
gives, with native multipath:

  BUG: KASAN: slab-use-after-free in nvme_put_ns_head+0x21/0x140
  Write of size 4 at addr ff1100000a4ea078 by task init/1
   nvme_put_ns_head
   nvme_put_ns
   nvme_remove_namespaces
   nvme_do_delete_ctrl
   nvme_delete_ctrl_sync
   nvme_sysfs_delete
  Freed by task 1:
   kfree
   nvme_ns_remove
   nvme_remove_namespaces
  refcount_t: underflow; use-after-free.

Take the reference in nvme_cdev_add() instead, right before
cdev_device_add(), and let the callers neither take nor drop it. Add
nvme_is_ns_cdev() for the check that nvme_cdev_rel() and nvme_cdev_add()
now share.

Fixes: 9952f3882ecb ("nvme: fix cdev lifetime")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 18 +++++++++++++++---
 drivers/nvme/host/multipath.c |  2 --
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af71d02b84765..9ea9db0271c2d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3941,10 +3941,16 @@ static int nvme_subsys_check_duplicate_ids(struct nvme_subsystem *subsys,
 	return 0;
 }
 
+/* The char device of a namespace rather than of a namespace head */
+static bool nvme_is_ns_cdev(struct device *dev)
+{
+	return dev->parent->class == &nvme_class;
+}
+
 static void nvme_cdev_rel(struct device *dev)
 {
 	ida_free(&nvme_ns_chr_minor_ida, MINOR(dev->devt));
-	if (dev->parent->class == &nvme_class)
+	if (nvme_is_ns_cdev(dev))
 		nvme_put_ns(container_of(dev, struct nvme_ns, cdev_device));
 	else
 		nvme_put_ns_head(container_of(dev, struct nvme_ns_head,
@@ -3978,6 +3984,14 @@ int nvme_cdev_add(struct cdev *cdev, struct device *cdev_device,
 	device_initialize(cdev_device);
 	cdev_init(cdev, fops);
 	cdev->owner = owner;
+	/* Undone in nvme_cdev_rel() */
+	if (nvme_is_ns_cdev(cdev_device))
+		nvme_get_ns(container_of(cdev_device, struct nvme_ns,
+					 cdev_device));
+	else
+		nvme_get_ns_head(container_of(cdev_device,
+					      struct nvme_ns_head,
+					      cdev_device));
 	ret = cdev_device_add(cdev, cdev_device);
 	if (ret)
 		put_device(cdev_device);
@@ -4010,13 +4024,11 @@ static void nvme_add_ns_cdev(struct nvme_ns *ns)
 {
 	ns->cdev_device.parent = ns->ctrl->device;
 
-	nvme_get_ns(ns); /* Undone in nvme_cdev_rel() */
 	if (nvme_cdev_add(&ns->cdev, &ns->cdev_device,
 			&nvme_ns_chr_fops, ns->ctrl->ops->module,
 			ns->ctrl->instance, ns->head->instance)) {
 		dev_err(ns->ctrl->device, "Unable to create the ng%dn%d device\n",
 			ns->ctrl->instance, ns->head->instance);
-		nvme_put_ns(ns);
 		return;
 	}
 	set_bit(NVME_NS_CDEV_LIVE, &ns->flags);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 99ecc73393e58..0920fa9616de0 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -648,14 +648,12 @@ static void nvme_add_ns_head_cdev(struct nvme_ns_head *head)
 {
 	head->cdev_device.parent = &head->subsys->dev;
 
-	nvme_get_ns_head(head); /* Undone in nvme_cdev_rel() */
 	if (nvme_cdev_add(&head->cdev, &head->cdev_device,
 			&nvme_ns_head_chr_fops, THIS_MODULE,
 			head->subsys->instance, head->instance)) {
 		dev_err(disk_to_dev(head->disk),
 			"Unable to create the ng%dn%d device\n",
 			head->subsys->instance, head->instance);
-		nvme_put_ns_head(head);
 		return;
 	}
 	set_bit(NVME_NSHEAD_CDEV_LIVE, &head->flags);
-- 
2.53.0



