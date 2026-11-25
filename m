Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621373;
	b=gsFY3tNVxkS/ICDYRbJ0C6+AGwbFASB9FnDcG9tMbibiRqcaM/ynbTcTa/uiNqMiqiSO
	 z4T0W9er0mPd6+geQsGXAbgjLVCcVxecFaGRxGtaTRLAQPAWeYZrPn0mXQWYsXcGvuxOE
	 OfiTS3cV8zZHovzwWDLjLl6m4Bo4nykBEYHUzkp7Uikupk23J7z8IOiPlVhmSz5M0yO4X
	 WYjn7Zb/NNHuq3Ey02IjcMHCXbs8hNA1eWs+tMAtUzih3wtASZjuk+xY8Qumbq7E86x87
	 UbBqO1zKJcdOh+LFltDSJrc4X7tfm+yIMMFqxtf5GAIBLD1ZkmwqLcSboKWboAvG4Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YVmqJKypP/dv4eEY++J6c5NzZULg5LK+Fv7XpExCCNQ=;
	b=dZDGdgpLisklLnaCDf6XT31uxoOO0qvFC1T+pm6tCCAh4M6BxjW8mj+DujAyb9ukaF/B
	 4EpjJBNKb1oVhW4bTiHKS8s770TC4CTr6WMIQmsWn+SHJ13I7LkUu36xyuA0q75b878iJ
	 hNNeDIHxNbQmSu+cG/4nGxaadPvXlB3LIQuuR057hGcoqgat0MOJ2G1Jc2RBA2pa0HeIh
	 XC0nwSjzJFvB1+p986a+YdpEO7wAbU/Ca3BpFNYJaELmg2ejBkls8Vz6ZARRZIbJhtJrP
	 UPbpHdXT4mCob4j6DWpZTk718Z+RbdxkRgVUwLFz1YeZO3JFsRaMLPqRfcIjVvFliNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Eug/62r/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA04C606B3A6;
	Wed, 25 Nov 2026 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eug/62r/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05171F000E0;
	Wed, 25 Nov 2026 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621373;
	bh=YVmqJKypP/dv4eEY++J6c5NzZULg5LK+Fv7XpExCCNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eug/62r/SxcGLkt7MKdRM24/p99pTR517J3J0xqwxf9SY0pPFJLt+EsBUzKiVBlfR
	 sMU66wLI52D1CdlaGbVeA1bs8ihRH4aUm5d2bwkE0Dj9z8g9cj7wuHaWt85yJgmJ2a
	 3hnmKWB95KAAGFngv8nv1EflUaGbulb7iC+ZMO9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/990] virtio_ring: factor out split indirect detaching logic
Date: Wed, 25 Nov 2026 15:26:10 +0100
Message-ID: <20261125143826.847808539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 9dc6b944f16c0904331903ba0ec36e558e1a3537 ]

Factor out the split indirect descriptor detaching logic in order to
allow it to be reused by the in order support.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251230064649.55597-18-jasowang@redhat.com>
Stable-dep-of: e498eb93f961 ("virtio_ring: use shadow flags when detaching split descriptors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 62 ++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c51a6fc187f26..09b9b6a17f5f0 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -748,11 +748,41 @@ static bool virtqueue_kick_prepare_split(struct virtqueue *_vq)
 	return needs_kick;
 }
 
+static void detach_indirect_split(struct vring_virtqueue *vq,
+				  unsigned int head)
+{
+	struct vring_desc_extra *extra = vq->split.desc_extra;
+	struct vring_desc *indir_desc = vq->split.desc_state[head].indir_desc;
+	unsigned int j;
+	u32 len, num;
+
+	/* Free the indirect table, if any, now that it's unmapped. */
+	if (!indir_desc)
+		return;
+	len = vq->split.desc_extra[head].len;
+
+	BUG_ON(!(vq->split.desc_extra[head].flags &
+			VRING_DESC_F_INDIRECT));
+	BUG_ON(len == 0 || len % sizeof(struct vring_desc));
+
+	num = len / sizeof(struct vring_desc);
+
+	extra = (struct vring_desc_extra *)&indir_desc[num];
+
+	if (vq->use_map_api) {
+		for (j = 0; j < num; j++)
+			vring_unmap_one_split(vq, &extra[j]);
+	}
+
+	kfree(indir_desc);
+	vq->split.desc_state[head].indir_desc = NULL;
+}
+
 static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 			     void **ctx)
 {
 	struct vring_desc_extra *extra;
-	unsigned int i, j;
+	unsigned int i;
 	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
 
 	/* Clear data ptr. */
@@ -775,34 +805,10 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	/* Plus final descriptor */
 	vq->vq.num_free++;
 
-	if (vq->indirect) {
-		struct vring_desc *indir_desc =
-				vq->split.desc_state[head].indir_desc;
-		u32 len, num;
-
-		/* Free the indirect table, if any, now that it's unmapped. */
-		if (!indir_desc)
-			return;
-		len = vq->split.desc_extra[head].len;
-
-		BUG_ON(!(vq->split.desc_extra[head].flags &
-				VRING_DESC_F_INDIRECT));
-		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
-
-		num = len / sizeof(struct vring_desc);
-
-		extra = (struct vring_desc_extra *)&indir_desc[num];
-
-		if (vq->use_map_api) {
-			for (j = 0; j < num; j++)
-				vring_unmap_one_split(vq, &extra[j]);
-		}
-
-		kfree(indir_desc);
-		vq->split.desc_state[head].indir_desc = NULL;
-	} else if (ctx) {
+	if (vq->indirect)
+		detach_indirect_split(vq, head);
+	else if (ctx)
 		*ctx = vq->split.desc_state[head].indir_desc;
-	}
 }
 
 static bool more_used_split(const struct vring_virtqueue *vq)
-- 
2.53.0



