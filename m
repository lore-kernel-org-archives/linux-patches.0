Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5EBD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F01C433EF;
	Mon, 12 Jun 2023 10:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566335;
	bh=qCEq7K6hQu2H61RH5dG2GNlZnmnve5rza38ghjZiEiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N373o15xSA3qNrodJjwigimKQeWO2/ZU4Q9pZ0qHB+GlwvDsgGYEaSRRvrhCzq2fC
	 nYvSQBUQBtf72BXEBsDN6qfhz8I1NlAlWGWWOON4JYH69GZHiFvZc97L9QBrEA7kRa
	 hPJ+DF6JQhbGZSqCh53TY4X9fnSi5epoplloYM+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 85/91] vhost: support PACKED when setting-getting vring_base
Date: Mon, 12 Jun 2023 12:27:14 +0200
Message-ID: <20230612101705.669484340@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 55d8122f5cd62d5aaa225d7167dcd14a44c850b9 ]

Use the right structs for PACKED or split vqs when setting and
getting the vring base.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Message-Id: <20230424225031.18947-3-shannon.nelson@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 18 +++++++++++++-----
 drivers/vhost/vhost.h |  8 ++++++--
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c0f926a9c298f..047fa2faef566 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1628,17 +1628,25 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
-		if (s.num > 0xffff) {
-			r = -EINVAL;
-			break;
+		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
+			vq->last_avail_idx = s.num & 0xffff;
+			vq->last_used_idx = (s.num >> 16) & 0xffff;
+		} else {
+			if (s.num > 0xffff) {
+				r = -EINVAL;
+				break;
+			}
+			vq->last_avail_idx = s.num;
 		}
-		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
-		s.num = vq->last_avail_idx;
+		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+			s.num = (u32)vq->last_avail_idx | ((u32)vq->last_used_idx << 16);
+		else
+			s.num = vq->last_avail_idx;
 		if (copy_to_user(argp, &s, sizeof s))
 			r = -EFAULT;
 		break;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f2675c0aa08ee..6378f020e6d53 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -86,13 +86,17 @@ struct vhost_virtqueue {
 	/* The routine to call when the Guest pings us, or timeout. */
 	vhost_work_fn_t handle_kick;
 
-	/* Last available index we saw. */
+	/* Last available index we saw.
+	 * Values are limited to 0x7fff, and the high bit is used as
+	 * a wrap counter when using VIRTIO_F_RING_PACKED. */
 	u16 last_avail_idx;
 
 	/* Caches available index value from user. */
 	u16 avail_idx;
 
-	/* Last index we used. */
+	/* Last index we used.
+	 * Values are limited to 0x7fff, and the high bit is used as
+	 * a wrap counter when using VIRTIO_F_RING_PACKED. */
 	u16 last_used_idx;
 
 	/* Used flags */
-- 
2.39.2



