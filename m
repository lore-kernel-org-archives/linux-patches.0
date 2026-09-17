Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2178502D4C;
	Thu, 17 Sep 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666322; cv=none; b=oMdHKmMgq0sm5vRqcmXKnsWM05oBPlX0IcKXfZK2GE091tuoiJ042mZWpWN+1TOLIO5LnCEfWI8O3tksAxxrWeP3rFmQYv6F65RmhBWG8ZTwG0PLJUoZjhcgLUQd1EM85w6ETwS1GMGo9jG2dcTyNTiJ/Qd2Kdh0Aiaa2UZ4Mzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666322; c=relaxed/simple;
	bh=xf/77fsiYRGIRORzAUUP0LSdXhDRcQNbgGlQGlTojlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzTZcu+6miH4uA0qny+ZS8oa8oAh1KkNU8Qe9xRKW1S0plF14bZ52J4GzYfqMGpveA2lG0qzrgJOmceQYM31+ggyaHC03QqjYZ9nPYrfklvoCZPspiR6U8NQBpj9TEIS5vpTBJnXU07gitGbHXViqOaSBckfaWs+LSmPKFf8NM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdaMDXNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdaMDXNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D431F000FF;
	Thu, 17 Sep 2026 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666321;
	bh=TOFzAaaUsWjT2naZdrSaimG4B25/H3Wqw4lURKHY3hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdaMDXNYmETPkbm37Gp5NCS2kacgut9x9Sg2lFkaCk/YhRQofezVZUT00Ccy9TBS6
	 ui3iY34JN7buyT0gvF5kls29qg4JCxstAW3jKiOcetzSh5IlQaXR0vwelD7DXudYSt
	 Lf3tcHfFbG1esqbRRNFf/tEPjRsWYqzNBIJ9cFnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 0981/1250] virtio_mmio: disable IRQ wake before free_irq
Date: Thu, 17 Sep 2026 16:12:56 +0100
Message-ID: <20260917151618.610540270@linuxfoundation.org>
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

From: Xiong Weimin <xiongweimin@kylinos.cn>

commit d14d693adb055e98ca705822ba6daebc18602d9a upstream.

When the DT node has "wakeup-source", vm_find_vqs() calls
enable_irq_wake() on the shared IRQ, but vm_del_vqs() freed that IRQ
without a matching disable_irq_wake(). That leaves a wake reference
behind and can warn on later free_irq()/request_irq() cycles.

Record whether enable_irq_wake() succeeded, and disable it in
vm_del_vqs() before free_irq().

Fixes: 02213273f72a ("virtio_mmio: add support to set IRQ of a virtio device as wakeup source")
Cc: stable@vger.kernel.org
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260805032937.1606737-1-xiongweimin@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_mmio.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -87,6 +87,9 @@ struct virtio_mmio_device {
 
 	void __iomem *base;
 	unsigned long version;
+
+	/* True if enable_irq_wake() succeeded for the shared IRQ. */
+	bool wake_irq_enabled;
 };
 
 /* Configuration interface */
@@ -329,11 +332,17 @@ static void vm_del_vqs(struct virtio_dev
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	struct virtqueue *vq, *n;
+	int irq = platform_get_irq(vm_dev->pdev, 0);
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
 		vm_del_vq(vq);
 
-	free_irq(platform_get_irq(vm_dev->pdev, 0), vm_dev);
+	if (vm_dev->wake_irq_enabled) {
+		disable_irq_wake(irq);
+		vm_dev->wake_irq_enabled = false;
+	}
+
+	free_irq(irq, vm_dev);
 }
 
 static void vm_synchronize_cbs(struct virtio_device *vdev)
@@ -460,8 +469,9 @@ static int vm_find_vqs(struct virtio_dev
 	if (err)
 		return err;
 
-	if (of_property_read_bool(vm_dev->pdev->dev.of_node, "wakeup-source"))
-		enable_irq_wake(irq);
+	if (of_property_read_bool(vm_dev->pdev->dev.of_node, "wakeup-source") &&
+	    !enable_irq_wake(irq))
+		vm_dev->wake_irq_enabled = true;
 
 	for (i = 0; i < nvqs; ++i) {
 		struct virtqueue_info *vqi = &vqs_info[i];


