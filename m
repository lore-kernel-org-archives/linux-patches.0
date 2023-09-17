Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85A37461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC9EC433C8;
	Sun, 17 Sep 2023 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980784;
	bh=6GDTOvz629F1GcjDU+IeeQ62BFO0IWoAMm0gVsB10/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcydxQs309GAxKBiEQplFhjGwOw4Gwgj0lnidbPropXbGlwdAHuziR1Q3L+/+vbGA
	 xuhA1gcIuGnh8RZQAsgN+Ck+DfuuR+V90bpEBP84KW6CwOYi3EIBYwvUy44EyFYESX
	 lW5tbyglnOBoTjqrhP5/FrP/9FE9thDsPMVMM70E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liming Sun <limings@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 267/285] platform/mellanox: mlxbf-tmfifo: Drop the Rx packet if no more descriptors
Date: Sun, 17 Sep 2023 21:14:27 +0200
Message-ID: <20230917191100.444354002@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liming Sun <limings@nvidia.com>

[ Upstream commit 78034cbece79c2d730ad0770b3b7f23eedbbecf5 ]

This commit fixes tmfifo console stuck issue when the virtual
networking interface is in down state. In such case, the network
Rx descriptors runs out and causes the Rx network packet staying
in the head of the tmfifo thus blocking the console packets. The
fix is to drop the Rx network packet when no more Rx descriptors.
Function name mlxbf_tmfifo_release_pending_pkt() is also renamed
to mlxbf_tmfifo_release_pkt() to be more approperiate.

Fixes: 1357dfd7261f ("platform/mellanox: Add TmFifo driver for Mellanox BlueField Soc")
Signed-off-by: Liming Sun <limings@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/8c0177dc938ae03f52ff7e0b62dbeee74b7bec09.1693322547.git.limings@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-tmfifo.c | 66 ++++++++++++++++++------
 1 file changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index b600b77d91ef2..5c1f859b682a8 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -59,6 +59,7 @@ struct mlxbf_tmfifo;
  * @vq: pointer to the virtio virtqueue
  * @desc: current descriptor of the pending packet
  * @desc_head: head descriptor of the pending packet
+ * @drop_desc: dummy desc for packet dropping
  * @cur_len: processed length of the current descriptor
  * @rem_len: remaining length of the pending packet
  * @pkt_len: total length of the pending packet
@@ -75,6 +76,7 @@ struct mlxbf_tmfifo_vring {
 	struct virtqueue *vq;
 	struct vring_desc *desc;
 	struct vring_desc *desc_head;
+	struct vring_desc drop_desc;
 	int cur_len;
 	int rem_len;
 	u32 pkt_len;
@@ -86,6 +88,14 @@ struct mlxbf_tmfifo_vring {
 	struct mlxbf_tmfifo *fifo;
 };
 
+/* Check whether vring is in drop mode. */
+#define IS_VRING_DROP(_r) ({ \
+	typeof(_r) (r) = (_r); \
+	(r->desc_head == &r->drop_desc ? true : false); })
+
+/* A stub length to drop maximum length packet. */
+#define VRING_DROP_DESC_MAX_LEN		GENMASK(15, 0)
+
 /* Interrupt types. */
 enum {
 	MLXBF_TM_RX_LWM_IRQ,
@@ -262,6 +272,7 @@ static int mlxbf_tmfifo_alloc_vrings(struct mlxbf_tmfifo *fifo,
 		vring->align = SMP_CACHE_BYTES;
 		vring->index = i;
 		vring->vdev_id = tm_vdev->vdev.id.device;
+		vring->drop_desc.len = VRING_DROP_DESC_MAX_LEN;
 		dev = &tm_vdev->vdev.dev;
 
 		size = vring_size(vring->num, vring->align);
@@ -367,7 +378,7 @@ static u32 mlxbf_tmfifo_get_pkt_len(struct mlxbf_tmfifo_vring *vring,
 	return len;
 }
 
-static void mlxbf_tmfifo_release_pending_pkt(struct mlxbf_tmfifo_vring *vring)
+static void mlxbf_tmfifo_release_pkt(struct mlxbf_tmfifo_vring *vring)
 {
 	struct vring_desc *desc_head;
 	u32 len = 0;
@@ -596,19 +607,25 @@ static void mlxbf_tmfifo_rxtx_word(struct mlxbf_tmfifo_vring *vring,
 
 	if (vring->cur_len + sizeof(u64) <= len) {
 		/* The whole word. */
-		if (is_rx)
-			memcpy(addr + vring->cur_len, &data, sizeof(u64));
-		else
-			memcpy(&data, addr + vring->cur_len, sizeof(u64));
+		if (!IS_VRING_DROP(vring)) {
+			if (is_rx)
+				memcpy(addr + vring->cur_len, &data,
+				       sizeof(u64));
+			else
+				memcpy(&data, addr + vring->cur_len,
+				       sizeof(u64));
+		}
 		vring->cur_len += sizeof(u64);
 	} else {
 		/* Leftover bytes. */
-		if (is_rx)
-			memcpy(addr + vring->cur_len, &data,
-			       len - vring->cur_len);
-		else
-			memcpy(&data, addr + vring->cur_len,
-			       len - vring->cur_len);
+		if (!IS_VRING_DROP(vring)) {
+			if (is_rx)
+				memcpy(addr + vring->cur_len, &data,
+				       len - vring->cur_len);
+			else
+				memcpy(&data, addr + vring->cur_len,
+				       len - vring->cur_len);
+		}
 		vring->cur_len = len;
 	}
 
@@ -709,8 +726,16 @@ static bool mlxbf_tmfifo_rxtx_one_desc(struct mlxbf_tmfifo_vring *vring,
 	/* Get the descriptor of the next packet. */
 	if (!vring->desc) {
 		desc = mlxbf_tmfifo_get_next_pkt(vring, is_rx);
-		if (!desc)
-			return false;
+		if (!desc) {
+			/* Drop next Rx packet to avoid stuck. */
+			if (is_rx) {
+				desc = &vring->drop_desc;
+				vring->desc_head = desc;
+				vring->desc = desc;
+			} else {
+				return false;
+			}
+		}
 	} else {
 		desc = vring->desc;
 	}
@@ -743,17 +768,24 @@ static bool mlxbf_tmfifo_rxtx_one_desc(struct mlxbf_tmfifo_vring *vring,
 		vring->rem_len -= len;
 
 		/* Get the next desc on the chain. */
-		if (vring->rem_len > 0 &&
+		if (!IS_VRING_DROP(vring) && vring->rem_len > 0 &&
 		    (virtio16_to_cpu(vdev, desc->flags) & VRING_DESC_F_NEXT)) {
 			idx = virtio16_to_cpu(vdev, desc->next);
 			desc = &vr->desc[idx];
 			goto mlxbf_tmfifo_desc_done;
 		}
 
-		/* Done and release the pending packet. */
-		mlxbf_tmfifo_release_pending_pkt(vring);
+		/* Done and release the packet. */
 		desc = NULL;
 		fifo->vring[is_rx] = NULL;
+		if (!IS_VRING_DROP(vring)) {
+			mlxbf_tmfifo_release_pkt(vring);
+		} else {
+			vring->pkt_len = 0;
+			vring->desc_head = NULL;
+			vring->desc = NULL;
+			return false;
+		}
 
 		/*
 		 * Make sure the load/store are in order before
@@ -933,7 +965,7 @@ static void mlxbf_tmfifo_virtio_del_vqs(struct virtio_device *vdev)
 
 		/* Release the pending packet. */
 		if (vring->desc)
-			mlxbf_tmfifo_release_pending_pkt(vring);
+			mlxbf_tmfifo_release_pkt(vring);
 		vq = vring->vq;
 		if (vq) {
 			vring->vq = NULL;
-- 
2.40.1



