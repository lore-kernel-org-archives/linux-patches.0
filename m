Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353F63B3BF2;
	Wed, 30 Sep 2026 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795460; cv=none; b=HynuwvSj3HqGFig11wV906pqAkvCbQdy+kpHOs/GcQYAfebPpVOJZKM5V/Pg//uWOacewmYPWH9KQKtllCNEZ56DmjU0MVELg/lMwIdbl1CZMP2OipfN5S8FaHAMnhzT6u0T4AY31ez3XKl8G/HwdNnrrAPckco/jmhJ+f8TCJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795460; c=relaxed/simple;
	bh=hegRr+RjDSOUc+cOWigAuhBYVjSx/musdkhNYtn90MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SI1VGsXLy4iHsoByXPShlo5x6opXBRWLegfAEpgqwy7RPrcug+fwxhEtU1S6jUHI8NlQvfX0GgB+ZfpuNzMZRLvkt2YkTrx4vVhPbKUHeVoy431Jwm32MLmhfOf9JCp7t/nfcA9Mo+Ma4JroodHxvgHJzwXSOP9sHzEyaP4pOzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p57EAaJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p57EAaJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791B91F000FF;
	Wed, 30 Sep 2026 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795459;
	bh=YRW74XtO3I0u3MdAe/IUwsbEQPg+R0LZZ0CzDYYBzrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p57EAaJmOaVwS30pQq5SqtlX2H0+MLIVI1VOuHB/hkfAYHQqUfO6LhRlv+ISB5IqQ
	 CW27+MB6Fh73ITOSwIDcUSbZSoTc0tM9oOQVmhVuyuo6JF5yEQtTyyvowgcisLNq/4
	 XIw6c42Zo548Z+XAoAhaS0Y441PSJ7GYEh8Fpw5U=
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
Subject: [PATCH 6.6 0524/1193] vdpa: introduce dedicated descriptor group for virtqueue
Date: Wed, 30 Sep 2026 17:20:08 +0200
Message-ID: <20260930152445.831995310@linuxfoundation.org>
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

[ Upstream commit a72cac6067fdfde280ece0ec5c055659a8de6508 ]

In some cases, the access to the virtqueue's descriptor area, device
and driver areas (precluding indirect descriptor table in guest memory)
may have to be confined to a different address space than where its
buffers reside. Without loss of simplicity and generality with already
established terminology, let's fold up these 3 areas and call them
as a whole as descriptor table group, or descriptor group for short.
Specifically, in case of split virtqueues, descriptor group consists of
regions for Descriptor Table, Available Ring and Used Ring; for packed
virtqueues layout, descriptor group contains Descriptor Ring, Driver
and Device Event Suppression structures.

The group ID for a dedicated descriptor group can be obtained through a
new .get_vq_desc_group() op. If driver implements this op, it means that
the descriptor, device and driver areas of the virtqueue may reside
in a dedicated group than where its buffers reside, a.k.a the default
virtqueue group through the .get_vq_group() op.

In principle, the descriptor group may or may not have same group ID
as the default group. Even if the descriptor group has a different ID,
meaning the vq's descriptor group areas can optionally move to a
separate address space than where guest memory resides, the descriptor
group may still start from a default address space, same as where its
buffers reside. To move the descriptor group to a different address
space, .set_group_asid() has to be called to change the ASID binding
for the group, which is no different than what needs to be done on any
other virtqueue group. On the other hand, the .reset() semantics also
applies on descriptor table group, meaning the device reset will clear
all ASID bindings and move all virtqueue groups including descriptor
group back to the default address space, i.e. in ASID 0.

QEMU's shadow virtqueue is going to utilize dedicated descriptor group
to speed up map and unmap operations, yielding tremendous downtime
reduction by avoiding the full and slow remap cycle in SVQ switching.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20231018171456.1624030-4-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Tested-by: Si-Wei Liu <si-wei.liu@oracle.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Stable-dep-of: ccb1dc7c527f ("vhost/vdpa: reject VRING_NUM larger than device max")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vdpa.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 0e652026b776f..d376309b99cf4 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -204,6 +204,16 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns u32: group id for this virtqueue
+ * @get_vq_desc_group:		Get the group id for the descriptor table of
+ *				a specific virtqueue (optional)
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns u32: group id for the descriptor table
+ *				portion of this virtqueue. Could be different
+ *				than the one from @get_vq_group, in which case
+ *				the access to the descriptor table can be
+ *				confined to a separate asid, isolating from
+ *				the virtqueue's buffer address access.
  * @get_device_features:	Get virtio features supported by the device
  *				@vdev: vdpa device
  *				Returns the virtio features support by the
@@ -360,6 +370,7 @@ struct vdpa_config_ops {
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
 	u32 (*get_vq_group)(struct vdpa_device *vdev, u16 idx);
+	u32 (*get_vq_desc_group)(struct vdpa_device *vdev, u16 idx);
 	u64 (*get_device_features)(struct vdpa_device *vdev);
 	u64 (*get_backend_features)(const struct vdpa_device *vdev);
 	int (*set_driver_features)(struct vdpa_device *vdev, u64 features);
-- 
2.53.0



