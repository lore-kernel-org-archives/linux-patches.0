Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A354E3248;
	Thu, 17 Sep 2026 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659704; cv=none; b=HARNM6u2z/uo05fCvKRwNa5lxBN1TUcaIMQqHu4pDcIUaS3z7Idk8XijoZ9/32BBxtEQLp72D1weImdnlqSOIJiHdqNuxpZ98B0yZk8V1IHlJMljEchevYsUM0SrScfBk4400NG1aa38a/2WXw7aOeijCE5jMVOJJnLi3RU6dpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659704; c=relaxed/simple;
	bh=svsb+9hDIQaU9ah2hycbspTp1AkWNKdiieMf8GSgt8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXbjqtF2MFMQx/m3rupTWm5KgiQkTzuGGelRuTK3Ol42HRBz73Y5sQRAlmVY3fmUhfBWqTZDfSfLl60HsscPs7U+spvE7Tj3LosujD12k/o51Tt0fKMgSydZqcbskKiZrSCpX+21qP0H7KFzqiz8JqkHKqAtMNaT+m9iNMt+phQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mB6Nhh58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mB6Nhh58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4356E1F00898;
	Thu, 17 Sep 2026 15:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659690;
	bh=YT2GrYArb4PFldIvQBkDZ3Ych7cUzATfbfJqPXDz7Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mB6Nhh58LEEPRXdteXbJ96Dxr+UdynW8esnY61v0d73U4rOSzrnqJYBj+LUwSxN9g
	 ssLTPfr/xj3/9Ado4+/AuybWSZi9FVzDZ06Z5EamFu1wK8eta6MGoYHaOCwR034Z+t
	 +a4qDsJr25eDV8itDeIgkwqRUY1q3zZHUVXQuIOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 342/733] virtio: fix use-after-free in unregister_virtio_device()
Date: Thu, 17 Sep 2026 16:10:50 +0100
Message-ID: <20260917151400.073787405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 75bb4ffe3b877..b6c9e927bef57 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -604,8 +604,8 @@ void unregister_virtio_device(struct virtio_device *dev)
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



