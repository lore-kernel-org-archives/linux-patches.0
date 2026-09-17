Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3530552188E;
	Thu, 17 Sep 2026 17:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665888; cv=none; b=JqdkgC80R2Ej3fxbpjrGjY7rZ3wBPRvHqo9voZH4eZyHeB0hOW8q1yOJ2fEWwNofFGZ6pCVPV26Q8wInbKSXgJsyU+sWZiucQ2jmBXJrsOrWdUDwJVKRk6EbTmi8jIYu6olVCEkhFtMF5+kV4chnJeNu75BeBnPyqjm53cN4IfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665888; c=relaxed/simple;
	bh=e2qhVDDiJIT9VBhcm5klTtZP9YQ90RPkN9nh98c7138=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew1eXf6qHMVnsddvz/oN2LTH2NFZJrTgXhS+pk/fGRmSesSguJxFp4g0eWGFVv+VpOOm2wWnQfpwyP3igzkw47Drbjjlu6stsRXSFtXDrA4sG0SON/laz0SV/oBh5JDVUdHmiT8Yb3znB2NeLesY9F7HqTko/n0m+xgmz+uD3lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv11jQo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv11jQo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB841F00893;
	Thu, 17 Sep 2026 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665887;
	bh=94AkGUfmyeIutZQIOHl/KbjazpzlcqoDWY8ofQ0p0/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kv11jQo+Ws9hks2OfYrNTojJzi0V7BFu/apVrxvqX7WeWsiVHP7PRtYZjqi35BrY3
	 2drwboWpSjZ7CXBHiqFE/pZ2yC7G7J27epadaCAtK4eRrLiFnVLg5ATeE28MX3BFti
	 siUKvukba1IbDLPrJGCKO6Fm8znXpqc0ItuFAfA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0852/1250] virtio: fix use-after-free in unregister_virtio_device()
Date: Thu, 17 Sep 2026 16:10:47 +0100
Message-ID: <20260917151615.059478328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3f9a0fceb730f5107d52421ead5568eae25a0049 ]

device_unregister() is device_del() plus put_device(). When the caller
holds no extra reference, that drops the last one and runs the release
callback, which for several transports frees the memory the embedded
struct virtio_device sits in. unregister_virtio_device() then calls
virtio_debug_device_exit(), which reads dev->debugfs_dir out of the freed
object.

Affected transports are the ones whose release callback frees and whose
remove path takes no reference: virtio_mmio, virtio_vdpa, virtio_uml,
mlxbf-tmfifo and virtio_ccw. virtio_pci is unaffected because
virtio_pci_remove() brackets the call with get_device() and put_device().

Remove the debugfs entries before the device can go away. They are only
accessed through the protected debugfs interface, so
debugfs_remove_recursive() waits for in-progress file operations before
returning. Tearing them down while the device is still alive is therefore
safe.

Reproduced on User-Mode Linux with CONFIG_KASAN and CONFIG_VIRTIO_DEBUG
by unbinding a virtio-uml device:

  BUG: KASAN: slab-use-after-free in virtio_debug_device_exit+0x36/0x4d
  Read of size 8 at addr 00000000616e0b10 by task init/1
   __asan_report_load8_noabort
   virtio_debug_device_exit+0x36/0x4d
   unregister_virtio_device+0x48/0x75
   virtio_uml_remove
   platform_remove
   device_release_driver_internal
   unbind_store

  Freed by task 1:
   kfree
   virtio_uml_release_dev
   device_release
   kobject_put
   put_device
   device_unregister

With this applied, the report is gone and unbind is clean.

Fixes: 96a8326d69ff ("virtio: add debugfs infrastructure to allow to debug virtio features")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260821213953.76906-1-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 3b7bab73d8950..4ced08886d0b8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -595,8 +595,8 @@ void unregister_virtio_device(struct virtio_device *dev)
 {
 	int index = dev->index; /* save for after device release */
 
-	device_unregister(&dev->dev);
 	virtio_debug_device_exit(dev);
+	device_unregister(&dev->dev);
 	ida_free(&virtio_index_ida, index);
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
-- 
2.53.0



