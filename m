Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E433A43B483;
	Tue, 21 Jul 2026 21:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671130; cv=none; b=dvTIxxAIIycsz0MiL4u5gOrWXKRlDJeJ3TmJovUf1aHcaZMgs9C3urGiTyRAzEf/xVL7ODgwhehuA/DmD35YTMCViT+DQRRgD285oBKHPCr9NziuCda4RicqKAq57dz5SdQOXM6LzMx3UdjZMR5ho5JW1Lty2EirzYSiD5IDSCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671130; c=relaxed/simple;
	bh=Huc5/8T8q4xidP+l33q/fJQQR8i/PiZbXKzZ0Uq3J04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF7yevjneEXQfZXhCJrkP7nuLnObXV5DFhX4LSo9e3NeLQHdOwiY9EBSUXBIuKHspiFI3brwgK+l44QC+Wof48C1xeDxAJ1uW1Tk3FZRgxn6Ci3ARaqAbMfpqNx/0VvAP8+Vxo6P8z15HUhzdwr4hSBfc0YaecqBCUGZe0C3j8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sk0kXYRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sk0kXYRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB76B1F000E9;
	Tue, 21 Jul 2026 21:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671127;
	bh=u1pGnfj5kgAY0N07K9e8ynS8kwMSGlRb8JRYwa1YpKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sk0kXYRQJL38jxQULusWo5wXwJEy3XmK2ur2pB31fQw/6Lul5jMIlHo4ZtTMYFhHo
	 jBc43KRsMPM5IcHtoqeGHyuSH/ZeOJdK8zmd1bQGKxRjPUx05cl8gX69mDAYGPfbx7
	 dskUr1WQzBH2iKnBqsntpeqD6qLY3mMWsnQbZcDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Moll <pawel.moll@arm.com>,
	Johan Hovold <johan@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 085/843] virtio-mmio: fix device release warning on module unload
Date: Tue, 21 Jul 2026 17:15:20 +0200
Message-ID: <20260721152407.911115592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit c687bc35694698ec4c7f92bf929c3d659f0cecb8 upstream.

Driver core expects devices to be allocated dynamically and complains
loudly when a device that lacks a release function is freed.

Use __root_device_register() to allocate and register the root device
instead of open coding using a static device.

Note that root_device_register(), which also creates a link to the
module, cannot be used as the device is registered when parsing the
module parameters which happens before the module kobject has been set
up.

Fixes: 81a054ce0b46 ("virtio-mmio: Devices parameter parsing")
Cc: stable@vger.kernel.org	# 3.5
Cc: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260427143710.14702-1-johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_mmio.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -675,9 +675,7 @@ static int virtio_mmio_remove(struct pla
 
 #if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)
 
-static struct device vm_cmdline_parent = {
-	.init_name = "virtio-mmio-cmdline",
-};
+static struct device *vm_cmdline_parent;
 
 static int vm_cmdline_parent_registered;
 static int vm_cmdline_id;
@@ -685,7 +683,6 @@ static int vm_cmdline_id;
 static int vm_cmdline_set(const char *device,
 		const struct kernel_param *kp)
 {
-	int err;
 	struct resource resources[2] = {};
 	char *str;
 	long long int base, size;
@@ -717,11 +714,10 @@ static int vm_cmdline_set(const char *de
 	resources[1].start = resources[1].end = irq;
 
 	if (!vm_cmdline_parent_registered) {
-		err = device_register(&vm_cmdline_parent);
-		if (err) {
-			put_device(&vm_cmdline_parent);
+		vm_cmdline_parent = __root_device_register("virtio-mmio-cmdline", NULL);
+		if (IS_ERR(vm_cmdline_parent)) {
 			pr_err("Failed to register parent device!\n");
-			return err;
+			return PTR_ERR(vm_cmdline_parent);
 		}
 		vm_cmdline_parent_registered = 1;
 	}
@@ -732,7 +728,7 @@ static int vm_cmdline_set(const char *de
 		       (unsigned long long)resources[0].end,
 		       (int)resources[1].start);
 
-	pdev = platform_device_register_resndata(&vm_cmdline_parent,
+	pdev = platform_device_register_resndata(vm_cmdline_parent,
 			"virtio-mmio", vm_cmdline_id++,
 			resources, ARRAY_SIZE(resources), NULL, 0);
 
@@ -756,8 +752,12 @@ static int vm_cmdline_get_device(struct
 static int vm_cmdline_get(char *buffer, const struct kernel_param *kp)
 {
 	buffer[0] = '\0';
-	device_for_each_child(&vm_cmdline_parent, buffer,
-			vm_cmdline_get_device);
+
+	if (vm_cmdline_parent_registered) {
+		device_for_each_child(vm_cmdline_parent, buffer,
+				vm_cmdline_get_device);
+	}
+
 	return strlen(buffer) + 1;
 }
 
@@ -779,9 +779,9 @@ static int vm_unregister_cmdline_device(
 static void vm_unregister_cmdline_devices(void)
 {
 	if (vm_cmdline_parent_registered) {
-		device_for_each_child(&vm_cmdline_parent, NULL,
+		device_for_each_child(vm_cmdline_parent, NULL,
 				vm_unregister_cmdline_device);
-		device_unregister(&vm_cmdline_parent);
+		root_device_unregister(vm_cmdline_parent);
 		vm_cmdline_parent_registered = 0;
 	}
 }


