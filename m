Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62D3A5449;
	Tue, 21 Jul 2026 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649595; cv=none; b=aTs14/ufysEloe8+ecE4Or41IFkpT/437DhF7807/YghTjMgAGYpk7CLrN384RgWzHW+no7qYDI8hnwFfjBfHsqjgoij7VgV/hxHdaTIy4uHlgOmymwRJ4pa+4D6jVskmydyIBIfkmumrjP3cbPbCLPTTU8b6u4RPWpshUBoSp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649595; c=relaxed/simple;
	bh=fEZJ4ZZuu8nNPkvkq6DOSd+SS8aZjcW2MQb04C99RG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hZXnin0gwuDISwywmLWXHb+O2E+Mnb5KmyGb+Vfx0EgM+SWTYdB2RQpSGD1sXmhl2vvtfa1w/0m9SbqidN4v4pSaHYIxoH+/eBt25PCp/CWnjs4WpQEi8zxJjjOv656DPZLrWNe9v2p1LH4kVYuHuhQBsXaBLEIJWiRq+0HqihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQDegt3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQDegt3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177BF1F000E9;
	Tue, 21 Jul 2026 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649593;
	bh=0GfFed5oZeZQNdD/1VsQrZWW3/+bXb21VCLqvcqvMs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQDegt3Z9oNTBKR+7Dcodt3O0kx0iP71hl9OzvHtegXbU6kX84Sehk9CjZpFoCtk8
	 5MvYXpjYsPD1bYTq/1UwPJqRDxhZvheQqqvnxYaGDcEjP25riBZFEjbP+1QqMjqnFF
	 mx5mipf+2wKzrLScNdSeOUa3N8fufBR/R6bDwIpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0635/2077] vduse: fix compat handling for VDUSE_IOTLB_GET_FD/VDUSE_VQ_GET_INFO
Date: Tue, 21 Jul 2026 17:05:08 +0200
Message-ID: <20260721152607.786353770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 455a2a1af92651764e9eb42cec0d95ac142afc28 ]

These two ioctls are incompatible on 32-bit x86 userspace, because
the data structures are shorter than they are on 64-bit.

Add a proper .compat_ioctl handler for x86 that reads the structures
with the smaller padding before calling the internal handlers. On
all other architectures, CONFIG_COMPAT_FOR_U64_ALIGNMENT is disabled
and no special handling is required.

Fixes: ad146355bfad ("vduse: Support querying information of IOVA regions")
Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260213154051.4172275-1-arnd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 123 ++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index a479fef535ac61..1367d14e5105e6 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1624,6 +1624,127 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT_FOR_U64_ALIGNMENT
+/*
+ * i386 has different alignment constraints than x86_64,
+ * so there are only 3 bytes of padding instead of 7.
+ */
+struct compat_vduse_iotlb_entry {
+	compat_u64 offset;
+	compat_u64 start;
+	compat_u64 last;
+	__u8 perm;
+	__u8 padding[3];
+};
+#define COMPAT_VDUSE_IOTLB_GET_FD	_IOWR(VDUSE_BASE, 0x10, struct compat_vduse_iotlb_entry)
+
+struct compat_vduse_vq_info {
+	__u32 index;
+	__u32 num;
+	compat_u64 desc_addr;
+	compat_u64 driver_addr;
+	compat_u64 device_addr;
+	union {
+		struct vduse_vq_state_split split;
+		struct vduse_vq_state_packed packed;
+	};
+	__u8 ready;
+	__u8 padding[3];
+};
+#define COMPAT_VDUSE_VQ_GET_INFO	_IOWR(VDUSE_BASE, 0x15, struct compat_vduse_vq_info)
+
+static long vduse_dev_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	struct vduse_dev *dev = file->private_data;
+	void __user *argp = (void __user *)arg;
+	int ret;
+
+	if (unlikely(dev->broken))
+		return -EPERM;
+
+	switch (cmd) {
+	case COMPAT_VDUSE_IOTLB_GET_FD: {
+		struct vduse_iotlb_entry_v2 entry = {0};
+		struct file *f = NULL;
+
+		ret = -EFAULT;
+		if (copy_from_user(&entry, argp, _IOC_SIZE(cmd)))
+			break;
+
+		ret = vduse_dev_iotlb_entry(dev, &entry, &f, NULL);
+		if (ret)
+			break;
+
+		ret = -EINVAL;
+		if (!f)
+			break;
+
+		ret = copy_to_user(argp, &entry, _IOC_SIZE(cmd));
+		if (ret) {
+			ret = -EFAULT;
+			fput(f);
+			break;
+		}
+		ret = receive_fd(f, NULL, perm_to_file_flags(entry.perm));
+		fput(f);
+		break;
+	}
+	case COMPAT_VDUSE_VQ_GET_INFO: {
+		struct vduse_vq_info vq_info = {};
+		struct vduse_virtqueue *vq;
+		u32 index;
+
+		ret = -EFAULT;
+		if (copy_from_user(&vq_info, argp,
+				   sizeof(struct compat_vduse_vq_info)))
+			break;
+
+		ret = -EINVAL;
+		if (vq_info.index >= dev->vq_num)
+			break;
+
+		index = array_index_nospec(vq_info.index, dev->vq_num);
+		vq = dev->vqs[index];
+		vq_info.desc_addr = vq->desc_addr;
+		vq_info.driver_addr = vq->driver_addr;
+		vq_info.device_addr = vq->device_addr;
+		vq_info.num = vq->num;
+
+		if (dev->driver_features & BIT_ULL(VIRTIO_F_RING_PACKED)) {
+			vq_info.packed.last_avail_counter =
+				vq->state.packed.last_avail_counter;
+			vq_info.packed.last_avail_idx =
+				vq->state.packed.last_avail_idx;
+			vq_info.packed.last_used_counter =
+				vq->state.packed.last_used_counter;
+			vq_info.packed.last_used_idx =
+				vq->state.packed.last_used_idx;
+		} else
+			vq_info.split.avail_index =
+				vq->state.split.avail_index;
+
+		vq_info.ready = vq->ready;
+
+		ret = -EFAULT;
+		if (copy_to_user(argp, &vq_info,
+		    sizeof(struct compat_vduse_vq_info)))
+			break;
+
+		ret = 0;
+		break;
+	}
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return vduse_dev_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#else
+#define vduse_dev_compat_ioctl compat_ptr_ioctl
+#endif
+
 static int vduse_dev_release(struct inode *inode, struct file *file)
 {
 	struct vduse_dev *dev = file->private_data;
@@ -1677,7 +1798,7 @@ static const struct file_operations vduse_dev_fops = {
 	.write_iter	= vduse_dev_write_iter,
 	.poll		= vduse_dev_poll,
 	.unlocked_ioctl	= vduse_dev_ioctl,
-	.compat_ioctl	= compat_ptr_ioctl,
+	.compat_ioctl	= vduse_dev_compat_ioctl,
 	.llseek		= noop_llseek,
 };
 
-- 
2.53.0



