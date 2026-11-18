Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023584;
	b=kEIDDMgpMlyIy9BlldjtXeEaHJSyd16G4h/SrnBBRBi3U1dM11/rP2bxNfkKnkElDu5M
	 lguxerw6teCaqm0evf/dftCnkT6i3xN1Sts4vkJ+uMx67YuBcxJPQaDjMsQUFll5bnDCS
	 j7da3NL3exiErnlG18oVi5sHkop8vnB73n2mHCGyO8rXrej+ArNnqtluen9ev1HIZPAiN
	 yVOLkTT3BH+xweTbJMKOObny0m/ExfCCEfnru2PHg5goJiN3MhQDt3aWlEniivCqHglnZ
	 CBpXL/+aNM5MoDQ3ZCw7BccLH19rARwXHeogbfoSa6JrtDUO4STBHEjpLrYL2oKFs+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jeAdgHvHNNUzpA/3oZDiI5YPhZ41HLkm5sHTIG5/QLo=;
	b=rhR/pO/WoRNRVeqwWu8khtNlz9TQPiKXaCwSyOJok0tWmLBgr003lMF5rys7Eg2rKdcm
	 THYateuMCffgpfYnYQbhSswxqz26xzR5d4gMe6wHOxRkw5uXT5T25W8Ul1yMYrBYb8w3l
	 /Sy7xzCA5W1c4ga0dU6BL3q20HwQaqpEqstGlgzUjVxHY8vRk5ofnWy+Wi5P9PZ+qo+sF
	 ADkfz8DvYU3U/XongMJdakociwxprrJnd08CSYS4k8wBr1wHiZb6gTb0aiFQjEXl0YUkG
	 ASCzsMwJasYtC83r7vpeeVcCe9KEiklXS8jN5IWcXfSWguWL4rxUhpupM/uMd5Udp+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wS+2PqqH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5BA606A32F;
	Wed, 18 Nov 2026 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wS+2PqqH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F661F000C4;
	Wed, 18 Nov 2026 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023584;
	bh=jeAdgHvHNNUzpA/3oZDiI5YPhZ41HLkm5sHTIG5/QLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wS+2PqqH+QpOvLwDuckDWQ13bRXwuaqgrJu97FEAoGGLxG73ttFco6H3EoYsV8sen
	 WAHzaanD53bdQJOmq3FKRqKikXgHHa/m6YhkaNjTVSZmzU+aOLZEFUOb2w/xeTaduT
	 9Vg1UsVWKireKYZ+IPJEvf1T6goLHx2p+3mXdGmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0420/2151] virtio_pci_modern: move avq cleanup from reset to del_vqs
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118150137.352286316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 2a12d96dd863cb23eadf07d8845e961580b5fcdf ]

vp_modern_avq_cleanup() detaches unused buffers from the admin
virtqueue. Calling it from vp_reset() is incorrect:
virtqueue_get_buf in the avq interrupt handler can race with
virtqueue_detach_unused_buf in cleanup, and get_buf after
detach is not documented as valid.

The root cause is that detaching buffers does not belong in
reset at all - reset quiesces the device, while cleanup belongs
where the virtqueue is about to be destroyed, from del_vqs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/virtualization/20260911125745.E0A2F1F00899@smtp.kernel.org/
Fixes: 4c3b54af907e ("virtio_pci_modern: use completion instead of busy loop to wait on admin cmd result")
Cc: Jiri Pirko <jiri@resnulli.us>
Assisted-by: LLM
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <21fe35ad7b66e2c30dbdba6fe4df4824d1c0db66.1789204858.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_modern.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index dd0e65f71d413..ff714cf0128e3 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -364,6 +364,12 @@ static void vp_modern_avq_cleanup(struct virtio_device *vdev)
 	}
 }
 
+static void vp_modern_del_vqs(struct virtio_device *vdev)
+{
+	vp_modern_avq_cleanup(vdev);
+	vp_del_vqs(vdev);
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -558,8 +564,6 @@ static void vp_reset(struct virtio_device *vdev)
 	while (vp_modern_get_status(mdev))
 		msleep(1);
 
-	vp_modern_avq_cleanup(vdev);
-
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 }
@@ -1232,7 +1236,7 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_status	= vp_set_status,
 	.reset		= vp_reset,
 	.find_vqs	= vp_modern_find_vqs,
-	.del_vqs	= vp_del_vqs,
+	.del_vqs	= vp_modern_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
 	.get_extended_features = vp_get_features,
 	.finalize_features = vp_finalize_features,
@@ -1252,7 +1256,7 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_status	= vp_set_status,
 	.reset		= vp_reset,
 	.find_vqs	= vp_modern_find_vqs,
-	.del_vqs	= vp_del_vqs,
+	.del_vqs	= vp_modern_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
 	.get_extended_features = vp_get_features,
 	.finalize_features = vp_finalize_features,
-- 
2.53.0



