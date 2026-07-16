Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77950424651;
	Thu, 16 Jul 2026 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209330; cv=none; b=GvN7Ffwh6RuM5UGl1F3I00oImfraCHHKmkPxr5UVBoa/u6wA3kcqJAwzrbqklGaLqXzryBaU++k0RyGJcmVu9Nuzl4HjjkjIOR0IW/O7dAGjSYSgrWUVXZPjUrjsNS659NyvevI3NdfSaYq0RxxsJk8TkQcTCe0vHPuPaUqjfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209330; c=relaxed/simple;
	bh=oSKnVg3eXnVM146Cd2Fp0hIvZcX9BRw87Zi0PR8hXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MooIQjesWom6hHohjTq5uTKzQrdLwSEHSHiCpSfLqg6c1LHY7gp7Nqt4qs+qMPchnuCtqYKP4bG4+or5fS8TTXsuCyVn973VOyFE1gezGLQXT5P1HRfsMnO1sCz4j0kwYE9YkKLGJw7FCToweXth3zVXVztfgS20NVwn0HVpWKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bi6PXrv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bi6PXrv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA6B1F000E9;
	Thu, 16 Jul 2026 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209329;
	bh=dY5Kxo9R64bMDkilFgRNTJTNivX+6ne66er7xzNe3b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bi6PXrv2Qc6Q42s0Cz8c6wjeRtwkSTxKsuZCfpmcFuy26u45VqfOx/PjwRFcDKq/Z
	 OLFelBK1o1JDGyJ9bvdq8axuMv0kdyWInX9Taowtgw8g7oGocp7409hNRnSTQjnWlw
	 2g4gpoiBW5C3l4XFh2Kmp4cvrXBwDVP0YBKlnugY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Moll <pawel.moll@arm.com>,
	Johan Hovold <johan@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.1 144/518] virtio-mmio: fix device release warning on module unload
Date: Thu, 16 Jul 2026 15:26:52 +0200
Message-ID: <20260716133051.003375929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -662,9 +662,7 @@ static void virtio_mmio_remove(struct pl
 
 #if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)
 
-static struct device vm_cmdline_parent = {
-	.init_name = "virtio-mmio-cmdline",
-};
+static struct device *vm_cmdline_parent;
 
 static int vm_cmdline_parent_registered;
 static int vm_cmdline_id;
@@ -672,7 +670,6 @@ static int vm_cmdline_id;
 static int vm_cmdline_set(const char *device,
 		const struct kernel_param *kp)
 {
-	int err;
 	struct resource resources[2] = {};
 	char *str;
 	long long base, size;
@@ -704,11 +701,10 @@ static int vm_cmdline_set(const char *de
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
@@ -719,7 +715,7 @@ static int vm_cmdline_set(const char *de
 		       (unsigned long long)resources[0].end,
 		       (int)resources[1].start);
 
-	pdev = platform_device_register_resndata(&vm_cmdline_parent,
+	pdev = platform_device_register_resndata(vm_cmdline_parent,
 			"virtio-mmio", vm_cmdline_id++,
 			resources, ARRAY_SIZE(resources), NULL, 0);
 
@@ -743,8 +739,12 @@ static int vm_cmdline_get_device(struct
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
 
@@ -766,9 +766,9 @@ static int vm_unregister_cmdline_device(
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


