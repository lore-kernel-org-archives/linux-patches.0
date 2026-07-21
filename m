Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39723E9C37;
	Tue, 21 Jul 2026 21:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668112; cv=none; b=OAJ862CvHgb64P5EzB9FIpI/1ePCNua25pdgexq9yMFl0239Hb0JX8wcdh0Hqdi2iYOQ3L+8TbJHjK7kcIcy7AGGNHKeBbvzu4hQ9D1arbF66EBaJpFYbgBvFmBnj/n8WTPBUxj+zWuoazN/9briNtzrm+jVskEtuqbKzeAf/mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668112; c=relaxed/simple;
	bh=zwG2pVG8WDzHIT4bbVcWAf/4w/mXYTgwE2yIL1dRCS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/NSA+Q10Vy+1bJRUWaATvbKo/aqhOtfcdLcLG9PgVet31vkLaYxzw6/YJqCquP8MgAURznu7L9CXREfl+eH5OUPQBHITVH4SbSyuu0B/Ph0wUVTa4waW8fefvviKUH7vRnNGUvaV8xBoTG2jECqhfuzbe5EcCn25na6U1srfL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX60pJp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX60pJp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC211F000E9;
	Tue, 21 Jul 2026 21:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668110;
	bh=rVbG96Io6uV9RU65Yy7INF5s4lP0Wkx0kPuVPFX6nVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX60pJp36AsnuiXSUmkb1BBtnAIMnDAxtX/YzdVbSFzpLfFvHt6NrRVFMxSBD7BT8
	 nBXaAETHw+9kb64Juv7ZA2aQa4xfJeqMnmq6QZz8FglIxN+Mh0YN4vPvef/XysCs5K
	 HDP5PDpzHAEVW9QW43Y6dc2aIZrpr2bYKZY5fbxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Joe Damato <jdamato@fastly.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Hyokyung Kim <pulpannie@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0050/1067] virtio_net: Support dynamic rss indirection table size
Date: Tue, 21 Jul 2026 17:10:51 +0200
Message-ID: <20260721152425.683262289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

commit 86a48a00efdf61197b6658e52c6140463eb313dc upstream.

When reading/writing virtio_net_ctrl_rss, the indirection table size is
obtained from vi->rss_indir_table_size, initialized during virtnet_probe().
However, the indirection_table was statically sized as
VIRTIO_NET_RSS_MAX_TABLE_LEN=128, potentially causing issues when
vi->rss_indir_table_size exceeds this limit.

This patch implements dynamic allocation for the indirection table,
allocated alongside vi->rss after vi->rss_indir_table_size is initialized,
and freed in virtnet_remove().

In virtnet_commit_rss_command(), scatter-gather lists for RSS are
initialized differently based on hash_report presence, so indirection_table
is unused when !vi->has_rss. Therefore, allocation is unnecessary for
hash_report-only scenarios.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Joe Damato <jdamato@fastly.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Hyokyung Kim: 6.1.y predates the refactor that moved the RSS config into
  struct virtnet_info, so struct virtio_net_ctrl_rss is still embedded in
  struct control_buf and reached through the heap-allocated vi->ctrl. Every
  adaptation below follows from that single difference:
  - the new allocation and all indirection_table accesses use vi->ctrl->rss
    in place of upstream's vi->rss;
  - because vi->ctrl is allocated in virtnet_alloc_queues() (via init_vqs())
    and freed in virtnet_free_queues(), the table is allocated and freed there
    too, not in virtnet_probe()/virtnet_remove(), so its lifetime tracks
    vi->ctrl across the probe error-unwind and freeze/restore paths;
  - since freeing the table now dereferences vi->ctrl, vi->ctrl is set to NULL
    after each kfree so a re-entered virtnet_free_queues() cannot dereference
    or free a stale pointer;
  - the table is allocated with kcalloc() so it is zero-filled when
    reallocated on the restore path (upstream never reallocates it). ]
Signed-off-by: Hyokyung Kim <pulpannie@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 43 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b62b7696313757..2fb00df795d4ab 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -179,15 +179,16 @@ struct receive_queue {
  * because table sizes may be differ according to the device configuration.
  */
 #define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
-#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
 struct virtio_net_ctrl_rss {
 	u32 hash_types;
 	u16 indirection_table_mask;
 	u16 unclassified_queue;
-	u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
+	u16 hash_cfg_reserved; /* for HASH_CONFIG (see virtio_net_hash_config for details) */
 	u16 max_tx_vq;
 	u8 hash_key_length;
 	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+
+	u16 *indirection_table;
 };
 
 /* Control VQ buffers: protected by the rtnl lock */
@@ -2488,6 +2489,25 @@ static int virtnet_set_ringparam(struct net_device *dev,
 	return 0;
 }
 
+static int rss_indirection_table_alloc(struct virtio_net_ctrl_rss *rss, u16 indir_table_size)
+{
+	if (!indir_table_size) {
+		rss->indirection_table = NULL;
+		return 0;
+	}
+
+	rss->indirection_table = kcalloc(indir_table_size, sizeof(u16), GFP_KERNEL);
+	if (!rss->indirection_table)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void rss_indirection_table_free(struct virtio_net_ctrl_rss *rss)
+{
+	kfree(rss->indirection_table);
+}
+
 static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 {
 	struct net_device *dev = vi->dev;
@@ -2497,11 +2517,15 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 	/* prepare sgs */
 	sg_init_table(sgs, 4);
 
-	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
+	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, hash_cfg_reserved);
 	sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
 
-	sg_buf_size = sizeof(uint16_t) * (vi->ctrl->rss.indirection_table_mask + 1);
-	sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
+	if (vi->has_rss) {
+		sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
+		sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
+	} else {
+		sg_set_buf(&sgs[1], &vi->ctrl->rss.hash_cfg_reserved, sizeof(uint16_t));
+	}
 
 	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
 			- offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
@@ -3415,7 +3439,10 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 
 	kfree(vi->rq);
 	kfree(vi->sq);
+	if (vi->ctrl)
+		rss_indirection_table_free(&vi->ctrl->rss);
 	kfree(vi->ctrl);
+	vi->ctrl = NULL;
 }
 
 static void _free_receive_bufs(struct virtnet_info *vi)
@@ -3610,6 +3637,9 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
 		if (!vi->ctrl)
 			goto err_ctrl;
+		if ((vi->has_rss || vi->has_rss_hash_report) &&
+		    rss_indirection_table_alloc(&vi->ctrl->rss, vi->rss_indir_table_size))
+			goto err_sq;
 	} else {
 		vi->ctrl = NULL;
 	}
@@ -3642,7 +3672,10 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 err_rq:
 	kfree(vi->sq);
 err_sq:
+	if (vi->ctrl)
+		rss_indirection_table_free(&vi->ctrl->rss);
 	kfree(vi->ctrl);
+	vi->ctrl = NULL;
 err_ctrl:
 	return -ENOMEM;
 }
-- 
2.53.0



