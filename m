Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD903AEF28;
	Thu, 17 Sep 2026 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670596; cv=none; b=S1V5suViYx5OR9g7H7733i7n3SmydhGrebp1bjR2Oz9GmJjycQly7y51Hz1mMdUdW5pxy2zDpZWe812kkS3NsNFNUyIvdvyXRpKAh7LuvGWUU3aeGCkrUiCS4EEbaHVryAVB+yyyNzIDqZieddVHdeEhTNGuprnWZWNfoWjBaWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670596; c=relaxed/simple;
	bh=w9LhUrLJo328IFSv2zaAvdPgPjDDMpU28hxARgUNyvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVpc29xvBaQHfu44ACingNDMwCy3fRXH6/xcsBnAaf+tzS4GFHoYM1egvCRyH7wRRqmKiceIFl3EPrMxbsAg4buvTmUmJfR9Eb/lpgar1wklPqAmXoZopB/GaUuNCi08dT2ne7yCwXpWTxy2P0dKe9QuEnHe+ArnLohBiXbuPtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyaxGWzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyaxGWzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A071F000FF;
	Thu, 17 Sep 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670595;
	bh=A393V3164r7JakIJu+JNfo9OkQVhPhPYAYDPuZ0v0oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyaxGWzXaHb+Q/5PNayQFs7J/sMem/N231Dyu4o8bTKbZdVPl9OCeK7kT7U2f6WFg
	 RyvzAE0P+SPe8iO4WliYC0US9BwIJoRrR4iFLnMFDVcxAOmvGNAYVJtr5BbFjy1q2a
	 ZsH1Pfb7dsrknEtaUFKAUg352gBsN75nqF25HoAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0711/1102] virtio: fix use-after-free in unregister_virtio_device()
Date: Thu, 17 Sep 2026 16:10:54 +0100
Message-ID: <20260917151558.178836085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b9095751e43bb..1b193d08a6ba8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -521,8 +521,8 @@ void unregister_virtio_device(struct virtio_device *dev)
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



