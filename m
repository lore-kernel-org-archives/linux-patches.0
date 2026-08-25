Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C799D42902A;
	Tue, 25 Aug 2026 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666123; cv=none; b=JQpe16gBav95tnBVvH6bmi9W1/Vd63vutdG3oO6PVDMRNFI/Bz8KkmdvvIVfUYNBNmhTRwv3wwfaaGjW8OYgtObm+llEk1Vd13E134spSgcaR2gnEq2dD++2YQ7czAcZ5wpdXm3cH6Zlh0qYykFJVgCjdDnW+YkSORReCKBRFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666123; c=relaxed/simple;
	bh=Fhux2HOvUmw1ddpzLJcbUZ3q/QovNZsXNo5ONuV+WIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGbKlhSDM53000pm1r+yXSbXFvqdwny4C0OlMoNk1Vy5XGgvd6L49YoS9kkIIKHLi99r4TlN5KMTYGziX6lj8eo5vPxau9yvY2JvissufHbTXZKjwuQD9vBKcr0Z1gnqNj63vP3YDUrcuUmKXjWUphD/MfgMzM2DjVk0cIw1/Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCpb9vk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCpb9vk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59B31F000E9;
	Tue, 25 Aug 2026 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666121;
	bh=unC3gmvombhBCrxoOQPzHunN/b+kxxyhHuj9V2rsTz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZCpb9vk4Ai8pUO3OAJH+roGavh3NXTBkZALSDQE7+ipuAlMdwp483O0ZPc8664YuP
	 vOKk9I+VZl4sgnvm84SkGWjn8tRzstg/xX1/CGbp/y/Q8408Og4oVHYGIj7SUTCEci
	 /F1cnihdMn1d6ZUyQ1zfSb5JdpKC5w1yvD3m6Tvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/76] misc: fastrpc: separate fastrpc device from channel context
Date: Tue, 25 Aug 2026 15:26:05 +0200
Message-ID: <20260825132542.017083081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 965602eabb57d086466ad749e81941e3dd66b595 ]

Currently fastrpc misc device instance is within channel context struct
with a kref. So we have 2 structs with refcount, both of them managing the
same channel context structure.

Separate fastrpc device from channel context and by adding a dedicated
fastrpc_device structure, this should clean the structures a bit and also help
when adding secure device node support.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220214161002.6831-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6102ceb4eab8 ("misc: fastrpc: Remove buffer from list prior to unmap operation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -78,7 +78,7 @@
 #define USER_PD		(1)
 #define SENSORS_PD	(2)
 
-#define miscdev_to_cctx(d) container_of(d, struct fastrpc_channel_ctx, miscdev)
+#define miscdev_to_fdevice(d) container_of(d, struct fastrpc_device, miscdev)
 
 static const char *domains[FASTRPC_DEV_MAX] = { "adsp", "mdsp",
 						"sdsp", "cdsp"};
@@ -212,9 +212,14 @@ struct fastrpc_channel_ctx {
 	spinlock_t lock;
 	struct idr ctx_idr;
 	struct list_head users;
-	struct miscdevice miscdev;
 	struct kref refcount;
 	u64 dma_mask;
+	struct fastrpc_device *fdevice;
+};
+
+struct fastrpc_device {
+	struct fastrpc_channel_ctx *cctx;
+	struct miscdevice miscdev;
 };
 
 struct fastrpc_user {
@@ -1250,10 +1255,14 @@ static int fastrpc_device_release(struct
 
 static int fastrpc_device_open(struct inode *inode, struct file *filp)
 {
-	struct fastrpc_channel_ctx *cctx = miscdev_to_cctx(filp->private_data);
+	struct fastrpc_channel_ctx *cctx;
+	struct fastrpc_device *fdevice;
 	struct fastrpc_user *fl = NULL;
 	unsigned long flags;
 
+	fdevice = miscdev_to_fdevice(filp->private_data);
+	cctx = fdevice->cctx;
+
 	fl = kzalloc(sizeof(*fl), GFP_KERNEL);
 	if (!fl)
 		return -ENOMEM;
@@ -1651,6 +1660,27 @@ static struct platform_driver fastrpc_cb
 	},
 };
 
+static int fastrpc_device_register(struct device *dev, struct fastrpc_channel_ctx *cctx,
+				   const char *domain)
+{
+	struct fastrpc_device *fdev;
+	int err;
+
+	fdev = devm_kzalloc(dev, sizeof(*fdev), GFP_KERNEL);
+	if (!fdev)
+		return -ENOMEM;
+
+	fdev->cctx = cctx;
+	fdev->miscdev.minor = MISC_DYNAMIC_MINOR;
+	fdev->miscdev.fops = &fastrpc_fops;
+	fdev->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "fastrpc-%s", domain);
+	err = misc_register(&fdev->miscdev);
+	if (!err)
+		cctx->fdevice = fdev;
+
+	return err;
+}
+
 static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 {
 	struct device *rdev = &rpdev->dev;
@@ -1680,11 +1710,7 @@ static int fastrpc_rpmsg_probe(struct rp
 	if (!data)
 		return -ENOMEM;
 
-	data->miscdev.minor = MISC_DYNAMIC_MINOR;
-	data->miscdev.name = devm_kasprintf(rdev, GFP_KERNEL, "fastrpc-%s",
-					    domains[domain_id]);
-	data->miscdev.fops = &fastrpc_fops;
-	err = misc_register(&data->miscdev);
+	err = fastrpc_device_register(rdev, data, domains[domain_id]);
 	if (err) {
 		kfree(data);
 		return err;
@@ -1729,7 +1755,9 @@ static void fastrpc_rpmsg_remove(struct
 		fastrpc_notify_users(user);
 	spin_unlock_irqrestore(&cctx->lock, flags);
 
-	misc_deregister(&cctx->miscdev);
+	if (cctx->fdevice)
+		misc_deregister(&cctx->fdevice->miscdev);
+
 	of_platform_depopulate(&rpdev->dev);
 
 	fastrpc_channel_ctx_put(cctx);


