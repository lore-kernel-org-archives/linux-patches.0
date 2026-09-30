Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127FF3EA957;
	Wed, 30 Sep 2026 19:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795340; cv=none; b=ZzpY3WlqQuB+IrbjmjlrykYlwcscYFj8RWiwkVq4XbBnt4w+8N64z6STC7Hk3o2i7xqrOG5/qP9cqNSqwW9zSE/47X1J6YeJfXhIpmGemBdSTtP8sF80qFAugTSvGVgBLaJ2xdpxIS1K0n4lcqhkwU9NBegFZNgbnAW3g59mVTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795340; c=relaxed/simple;
	bh=PHhyXhMreSWWVe7zrl7EaeTxg0GBMwgPG2iKHKqHrUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUOnhpGn20rHbJEjAo8AD0zUhPFHh0M5pC7L82Mk02dFdtO3mW0jB/ohGQsC/rrAGVrMhQR+o/x/k8jVWOq/JuXKbxF+mNVAWvljXAmiX6ivKklT/Dnq+w2WWCUsg0oDivk+FF+gwL0pF0jNsbDldTtASvnxkmzuHFwjz7c3hXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VudIzg2L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VudIzg2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8281F000FF;
	Wed, 30 Sep 2026 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795339;
	bh=B2s0t5QnVQa+zN74w+gK6fqFoFXI5Y+XPBnWAjg4ctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VudIzg2Lip1WIBBISzUYMVvxzHQY0eC1F7T74xqFJm5bJ+DQ+S14AUB8F3EXifJ4Q
	 /h3b6Y5e4r1/GiRTqBVCyVAB8OFSc2JtgxpNOK1NrQyi8aDwVrRBhwj+36rd75N1g2
	 6G1IwTbNN/JqAeXwL8T67ZWcsz+XMvPY0bT4lfdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0528/1193] vdpa: introduce .compat_reset operation callback
Date: Wed, 30 Sep 2026 17:20:12 +0200
Message-ID: <20260930152445.931029565@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit a26f2e4e68ee3130e5d5acb4f58807041aaea905 ]

Some device specific IOMMU parent drivers have long standing bogus
behaviour that mistakenly clean up the maps during .reset. By
definition, this is violation to the on-chip IOMMU ops (i.e. .set_map,
or .dma_map & .dma_unmap) in those offending drivers, as the removal of
internal maps is completely agnostic to the upper layer, causing
inconsistent view between the userspace and the kernel. Some userspace
app like QEMU gets around of this brokenness by proactively removing and
adding back all the maps around vdpa device reset, but such workaround
actually penaltize other well-behaved driver setup, where vdpa reset
always comes with the associated mapping cost, especially for kernel
vDPA devices (use_va=false) that have high cost on pinning. It's
imperative to rectify this behaviour and remove the problematic code
from all those non-compliant parent drivers.

However, we cannot unconditionally remove the bogus map-cleaning code
from the buggy .reset implementation, as there might exist userspace
apps that already rely on the behaviour on some setup. Introduce a
.compat_reset driver op to keep compatibility with older userspace. New
and well behaved parent driver should not bother to implement such op,
but only those drivers that are doing or used to do non-compliant
map-cleaning reset will have to.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Message-Id: <1697880319-4937-5-git-send-email-si-wei.liu@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Stable-dep-of: ccb1dc7c527f ("vhost/vdpa: reject VRING_NUM larger than device max")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vdpa.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 26ae6ae1eac38..6b8cbf75712df 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -252,6 +252,17 @@ struct vdpa_map_file {
  * @reset:			Reset device
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
+ * @compat_reset:		Reset device with compatibility quirks to
+ *				accommodate older userspace. Only needed by
+ *				parent driver which used to have bogus reset
+ *				behaviour, and has to maintain such behaviour
+ *				for compatibility with older userspace.
+ *				Historically compliant driver only has to
+ *				implement .reset, Historically non-compliant
+ *				driver should implement both.
+ *				@vdev: vdpa device
+ *				@flags: compatibility quirks for reset
+ *				Returns integer: success (0) or error (< 0)
  * @suspend:			Suspend the device (optional)
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
@@ -393,6 +404,8 @@ struct vdpa_config_ops {
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
 	int (*reset)(struct vdpa_device *vdev);
+	int (*compat_reset)(struct vdpa_device *vdev, u32 flags);
+#define VDPA_RESET_F_CLEAN_MAP 1
 	int (*suspend)(struct vdpa_device *vdev);
 	int (*resume)(struct vdpa_device *vdev);
 	size_t (*get_config_size)(struct vdpa_device *vdev);
-- 
2.53.0



