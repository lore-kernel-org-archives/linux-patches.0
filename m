Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B42ECE87;
	Tue, 17 Jun 2025 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177556; cv=none; b=SRYNINnYVMefKP3JfC5CNYEkjmCLKdF3DU7HIc96MND0MdI6ObndtkRqkLlCXu9LHWVVzFTob8efgLnbgx5A1YoquPo74muV3LXlDfTFCTreU51hG6Buz3X4PkfLFM3P+IXMVv7If0+NfKFvinvzwashrRFH/YuvTdGAN7psF/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177556; c=relaxed/simple;
	bh=RbMePumnu9p5AzczLWMmkrlA4lpJu1Pso6tOpOrOFhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrJxq/2/UlOf53P3ZCkxwpQJXwBO3/sKYKeGii5FC0FdfnbyPSV9dSrVFSYCr6xyXMT50bgx1Zwkp0sVAwoSpW/JHIVend8GzVLwNF4sLr+ERmzFtWDRC9JTY0f3oYUi2hQhWX9b1AZxkYs7ebNzMHgR8f3JuWrW7rEwzEvXHAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCOoWuJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCOoWuJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84363C4CEE3;
	Tue, 17 Jun 2025 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177556;
	bh=RbMePumnu9p5AzczLWMmkrlA4lpJu1Pso6tOpOrOFhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCOoWuJgaJTGmt0saauXro9XcPdihEnaH2VkN1g5A82Fm52KoRXOv6u83jt/B0H6W
	 yYT3uwEK7QnfiTD4RwCRNuruoNCGUtGEozm/lB0yVOHUZeraU3ziSKzTkTcFt0eeEC
	 EcaIjze0vqrbbFt27uwbA2Dp3Jm2fSvA5NWg1HLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Israel Rukshin <israelr@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 323/780] virtio-pci: Fix result size returned for the admin command completion
Date: Tue, 17 Jun 2025 17:20:31 +0200
Message-ID: <20250617152504.606919426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit 9ef41ebf787fcbde99ac404ae473f8467641f983 ]

The result size returned by virtio_pci_admin_dev_parts_get() is 8 bytes
larger than the actual result data size. This occurs because the
result_sg_size field of the command is filled with the result length
from virtqueue_get_buf(), which includes both the data size and an
additional 8 bytes of status.

This oversized result size causes two issues:
1. The state transferred to the destination includes 8 bytes of extra
   data at the end.
2. The allocated buffer in the kernel may be smaller than the returned
   size, leading to failures when reading beyond the allocated size.

The commit fixes this by subtracting the status size from the result of
virtqueue_get_buf().

This fix has been tested through live migrations with virtio-net,
virtio-net-transitional, and virtio-blk devices.

Fixes: 704806ca400e ("virtio: Extend the admin command to include the result size")
Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-Id: <1745318025-23103-1-git-send-email-israelr@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_modern.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index d50fe030d8253..7182f43ed0551 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -48,6 +48,7 @@ void vp_modern_avq_done(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_admin_vq *admin_vq = &vp_dev->admin_vq;
+	unsigned int status_size = sizeof(struct virtio_admin_cmd_status);
 	struct virtio_admin_cmd *cmd;
 	unsigned long flags;
 	unsigned int len;
@@ -56,7 +57,17 @@ void vp_modern_avq_done(struct virtqueue *vq)
 	do {
 		virtqueue_disable_cb(vq);
 		while ((cmd = virtqueue_get_buf(vq, &len))) {
-			cmd->result_sg_size = len;
+			/* If the number of bytes written by the device is less
+			 * than the size of struct virtio_admin_cmd_status, the
+			 * remaining status bytes will remain zero-initialized,
+			 * since the buffer was zeroed during allocation.
+			 * In this case, set the size of command_specific_result
+			 * to 0.
+			 */
+			if (len < status_size)
+				cmd->result_sg_size = 0;
+			else
+				cmd->result_sg_size = len - status_size;
 			complete(&cmd->completion);
 		}
 	} while (!virtqueue_enable_cb(vq));
-- 
2.39.5



