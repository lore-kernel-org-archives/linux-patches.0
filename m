Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E366039EF01;
	Sat, 17 Oct 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258037; cv=none; b=W+qjmJv1z7iDgjBGIbgnpZ3d3eelvo4lcWkrWO9JpW52XWQoCGnz2g+ntEXYhVJ6WQ7xebk2N0pZIl/td58sejfznsBBeoyG979Un25IeQ+rPjuIMVITSZHyAm6JjErO6auuCrMmGmrtqI+0rcq3jjCiHsbYEuXI/cD1mN2cio4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258037; c=relaxed/simple;
	bh=hvCP401wxpjpPGeKuKbUInv30FhSAooicbDHv61xlnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1YAPXLX0llaQ7SjjUJCwLG0ZQSI5VppIPCoQdxL/IUA30H+XbMOIieYgJudaFSeAFcXz55Kyl+0XRqunueAnLN2Pxbr9neCPp1Wi9AmR0g1RDYoZRusxY8UNQjdVlyDVzKhSFMcIU6cTEf28gfvik/ljXJOcSOug3FSkKaqN94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1raaxzTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1raaxzTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4324D1F000C4;
	Sat, 17 Oct 2026 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258036;
	bh=iUD50ZGbDiC3GS5n8uZMHl6sn3FXsgbAAYhoW9ds8xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1raaxzTQoKWEW7B/0RvlK6q+THGUp01ZnV+OLLr/IWw9qBzXujbPVKPBZzBzfRYwt
	 DhZzvYfhs3TvxYSdPmszKOQuzdNMRk0d7R2edbQn4uObvARG9IMoF0eEww7MREW6ci
	 umgle2waPi2rLlwF6pXRI3Q+kqWwaBVZjCKcz8dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eauger@redhat.com>,
	Hongyu Ning <hongyu.ning@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0749/1674] virtio: break and reset virtio devices on device_shutdown()
Date: Sat, 17 Oct 2026 17:50:21 +0200
Message-ID: <20261017160450.329936771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 8bd2fa086a04886798b505f28db4002525895203 ]

Hongyu reported a hang on kexec in a VM. QEMU reported invalid memory
accesses during the hang.

	Invalid read at addr 0x102877002, size 2, region '(null)', reason: rejected
	Invalid write at addr 0x102877A44, size 2, region '(null)', reason: rejected
	...

It was traced down to virtio-console. Kexec works fine if virtio-console
is not in use.

The issue is that virtio-console continues to write to the MMIO even after
underlying virtio-pci device is reset.

Additionally, Eric noticed that IOMMUs are reset before devices, if
devices are not reset on shutdown they continue to poke at guest memory
and get errors from the IOMMU. Some devices get wedged then.

The problem can be solved by breaking all virtio devices on virtio
bus shutdown, then resetting them.

Reported-by: Eric Auger <eauger@redhat.com>
Reported-by: Hongyu Ning <hongyu.ning@linux.intel.com>
Message-ID: <c1dbc7dbad9b445245d3348f19e6742b0be07347.1740094946.git.mst@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index eb8b17b3caec3..d09ab0ee74d6b 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -358,6 +358,34 @@ static const struct cpumask *virtio_irq_get_affinity(struct device *_d,
 	return dev->config->get_vq_affinity(dev, irq_vec);
 }
 
+static void virtio_dev_shutdown(struct device *_d)
+{
+	struct virtio_device *dev = dev_to_virtio(_d);
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+
+	/*
+	 * Stop accesses to or from the device.
+	 * We only need to do it if there's a driver - no accesses otherwise.
+	 */
+	if (!drv)
+		return;
+
+	/*
+	 * Some devices get wedged if you kick them after they are
+	 * reset. Mark all vqs as broken to make sure we don't.
+	 */
+	virtio_break_device(dev);
+	/*
+	 * Guarantee that any callback will see vq->broken as true.
+	 */
+	virtio_synchronize_cbs(dev);
+	/*
+	 * As IOMMUs are reset on shutdown, this will block device access to memory.
+	 * Some devices get wedged if this happens, so reset to make sure it does not.
+	 */
+	dev->config->reset(dev);
+}
+
 static const struct bus_type virtio_bus = {
 	.name  = "virtio",
 	.match = virtio_dev_match,
@@ -366,6 +394,7 @@ static const struct bus_type virtio_bus = {
 	.probe = virtio_dev_probe,
 	.remove = virtio_dev_remove,
 	.irq_get_affinity = virtio_irq_get_affinity,
+	.shutdown = virtio_dev_shutdown,
 };
 
 int register_virtio_driver(struct virtio_driver *driver)
-- 
2.53.0



