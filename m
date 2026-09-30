Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603583E7BAD;
	Wed, 30 Sep 2026 19:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795334; cv=none; b=LfepYaGUTlf8ggUiOUKzd7vlivV5j4qGAog8oE/unVsZ+Bemc251w6DjewazmO6/c9Hyrsn4bdRtvnQ90vRPY8cW36UPye6uPEQNKKLJ3ECGSIeo9VfO/3HRQ8S6ieX64BCW07SNJiPrXPlXM6QGzbUYT0yjTfEd0mv3bzXb+KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795334; c=relaxed/simple;
	bh=feTiGW6QLPjgLvvvbtkR9YXvRzDgnygrWXBBsKq/Vqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FKwsUQMrnamGzHxaTxREvjnWBIjkfEwVMQvAAfXAn7SnGvtTE8/ANKWgrK3ak3tcTtLkIxrCejisTdiWTwZXEKxqmy58ZhJZxB08IWXl7hkJeI4A6QI3MUbj+xLaXGZVHChiup1I9ybyYQyE5DUzO4yIKeKfKlF2eEIq4QK6lRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lkir9ICB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lkir9ICB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB60C1F000FF;
	Wed, 30 Sep 2026 19:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795333;
	bh=iJZrXh9NdezjIWPtn+0razi/IUP1cnH1mfyS1YdHogY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lkir9ICBkJRzih7bGbpCP9UlfujWBeNGmjUwdSsIy2c6Nf4TmwecHOlQT4sVWJf6Z
	 eaYerDFDNf1XSFUpijyBNQudwBJMJZDJIVfLEHTA5H7Ah8G3WHyOGChhxCaetfpugL
	 qijHyuioa8MJ/HGUho1TkiOMkLKzNC8BixFauKLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0526/1193] vdpa: introduce .reset_map operation callback
Date: Wed, 30 Sep 2026 17:20:10 +0200
Message-ID: <20260930152445.879006582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit d2cf1b6e3b85dcb2bb3e8cd7924beede34fbbf0e ]

Some device specific IOMMU parent drivers have long standing bogus
behavior that mistakenly clean up the maps during .reset. By definition,
this is violation to the on-chip IOMMU ops (i.e. .set_map, or .dma_map &
.dma_unmap) in those offending drivers, as the removal of internal maps
is completely agnostic to the upper layer, causing inconsistent view
between the userspace and the kernel. Some userspace app like QEMU gets
around of this brokenness by proactively removing and adding back all
the maps around vdpa device reset, but such workaround actually penalize
other well-behaved driver setup, where vdpa reset always comes with the
associated mapping cost, especially for kernel vDPA devices
(use_va=false) that have high cost on pinning. It's imperative to
rectify this behavior and remove the problematic code from all those
non-compliant parent drivers.

The reason why a separate .reset_map op is introduced is because this
allows a simple on-chip IOMMU model without exposing too much device
implementation detail to the upper vdpa layer. The .dma_map/unmap or
.set_map driver API is meant to be used to manipulate the IOTLB
mappings, and has been abstracted in a way similar to how a real IOMMU
device maps or unmaps pages for certain memory ranges. However, apart
from this there also exists other mapping needs, in which case 1:1
passthrough mapping has to be used by other users (read virtio-vdpa). To
ease parent/vendor driver implementation and to avoid abusing DMA ops in
an unexpacted way, these on-chip IOMMU devices can start with 1:1
passthrough mapping mode initially at the time of creation. Then the
.reset_map op can be used to switch iotlb back to this initial state
without having to expose a complex two-dimensional IOMMU device model.

The .reset_map is not a MUST for every parent that implements the
.dma_map or .set_map API, because device may work with DMA ops directly
by implement their own to manipulate system memory mappings, so don't
have to use .reset_map to achieve a simple IOMMU device model for 1:1
passthrough mapping.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <1697880319-4937-2-git-send-email-si-wei.liu@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Stable-dep-of: ccb1dc7c527f ("vhost/vdpa: reject VRING_NUM larger than device max")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vdpa.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index d376309b99cf4..26ae6ae1eac38 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -327,6 +327,15 @@ struct vdpa_map_file {
  *				@iova: iova to be unmapped
  *				@size: size of the area
  *				Returns integer: success (0) or error (< 0)
+ * @reset_map:			Reset device memory mapping to the default
+ *				state (optional)
+ *				Needed for devices that are using device
+ *				specific DMA translation and prefer mapping
+ *				to be decoupled from the virtio life cycle,
+ *				i.e. device .reset op does not reset mapping
+ *				@vdev: vdpa device
+ *				@asid: address space identifier
+ *				Returns integer: success (0) or error (< 0)
  * @get_vq_dma_dev:		Get the dma device for a specific
  *				virtqueue (optional)
  *				@vdev: vdpa device
@@ -405,6 +414,7 @@ struct vdpa_config_ops {
 		       u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
 			 u64 iova, u64 size);
+	int (*reset_map)(struct vdpa_device *vdev, unsigned int asid);
 	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
 			      unsigned int asid);
 	struct device *(*get_vq_dma_dev)(struct vdpa_device *vdev, u16 idx);
-- 
2.53.0



