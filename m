Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4B7217666;
	Tue, 12 Nov 2024 10:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408100; cv=none; b=gUZOrlQ5oWCMYr9QsnUE+gFMNZA4t6MlrduaedqJvsosMg6R4wCZrmp/Om8KqykcHxEws7odHgs2Fuga3yXZtyqlP4MviMOm6LPWFYtAVx3Zy8zqVX0KdI2is5RS6wmvC9lxJq5Co3tocQSvgohbYGqJZZ0EquryBsLOdix7Qfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408100; c=relaxed/simple;
	bh=hYxR2kIA0+O76kmhsUBDvC3tX/fr5b4zFyKtlJnas6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt/fYPQjHP5lLyRFmj+V8Wbx3itSq2ZV3Wj4pEWjBDUtBfHvr8DcbdZq+zEAqfJpjfmxrlKLXZePPQc1/wa8sqJsuE4KWPDJ13VtqO5xneyNyRSy1eq3tjqXbBpbfZ4AP6CknJ9Fb+ynSzBQOyx84btwl5ptDN3AQFAETeZ9oJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StbrRQn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StbrRQn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CADC4CECD;
	Tue, 12 Nov 2024 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408100;
	bh=hYxR2kIA0+O76kmhsUBDvC3tX/fr5b4zFyKtlJnas6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StbrRQn+k0GI/aQHR4ttoZE3ZJ+rJeZKkPE8HLZw2NAf5qaaVLSCa9yvfpxhKapQ2
	 xYMg7x0YVe68qhXRHCYdadVOneMTU4N6EAV4zskrEPUdCdNNn7QLICUFh6VqYlM6cP
	 xSPJUB8N4LIMrP+MNJpxushVT5YapKBNciiZrjWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 058/184] virtio_net: Update rss when set queue
Date: Tue, 12 Nov 2024 11:20:16 +0100
Message-ID: <20241112101903.089323040@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit 50bfcaedd78e53135ec0504302269b3b65bf1eff ]

RSS configuration should be updated with queue number. In particular, it
should be updated when (1) rss enabled and (2) default rss configuration
is used without user modification.

During rss command processing, device updates queue_pairs using
rss.max_tx_vq. That is, the device updates queue_pairs together with
rss, so we can skip the sperate queue_pairs update
(VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET below) and return directly.

Also remove the `vi->has_rss ?` check when setting vi->rss.max_tx_vq,
because this is not used in the other hash_report case.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 65 +++++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b3232b8baa256..53a038fcbe991 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3394,15 +3394,59 @@ static void virtnet_ack_link_announce(struct virtnet_info *vi)
 		dev_warn(&vi->dev->dev, "Failed to ack link announce.\n");
 }
 
+static bool virtnet_commit_rss_command(struct virtnet_info *vi);
+
+static void virtnet_rss_update_by_qpairs(struct virtnet_info *vi, u16 queue_pairs)
+{
+	u32 indir_val = 0;
+	int i = 0;
+
+	for (; i < vi->rss_indir_table_size; ++i) {
+		indir_val = ethtool_rxfh_indir_default(i, queue_pairs);
+		vi->rss.indirection_table[i] = indir_val;
+	}
+	vi->rss.max_tx_vq = queue_pairs;
+}
+
 static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 {
 	struct virtio_net_ctrl_mq *mq __free(kfree) = NULL;
-	struct scatterlist sg;
+	struct virtio_net_ctrl_rss old_rss;
 	struct net_device *dev = vi->dev;
+	struct scatterlist sg;
 
 	if (!vi->has_cvq || !virtio_has_feature(vi->vdev, VIRTIO_NET_F_MQ))
 		return 0;
 
+	/* Firstly check if we need update rss. Do updating if both (1) rss enabled and
+	 * (2) no user configuration.
+	 *
+	 * During rss command processing, device updates queue_pairs using rss.max_tx_vq. That is,
+	 * the device updates queue_pairs together with rss, so we can skip the sperate queue_pairs
+	 * update (VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET below) and return directly.
+	 */
+	if (vi->has_rss && !netif_is_rxfh_configured(dev)) {
+		memcpy(&old_rss, &vi->rss, sizeof(old_rss));
+		if (rss_indirection_table_alloc(&vi->rss, vi->rss_indir_table_size)) {
+			vi->rss.indirection_table = old_rss.indirection_table;
+			return -ENOMEM;
+		}
+
+		virtnet_rss_update_by_qpairs(vi, queue_pairs);
+
+		if (!virtnet_commit_rss_command(vi)) {
+			/* restore ctrl_rss if commit_rss_command failed */
+			rss_indirection_table_free(&vi->rss);
+			memcpy(&vi->rss, &old_rss, sizeof(old_rss));
+
+			dev_warn(&dev->dev, "Fail to set num of queue pairs to %d, because committing RSS failed\n",
+				 queue_pairs);
+			return -EINVAL;
+		}
+		rss_indirection_table_free(&old_rss);
+		goto succ;
+	}
+
 	mq = kzalloc(sizeof(*mq), GFP_KERNEL);
 	if (!mq)
 		return -ENOMEM;
@@ -3415,12 +3459,12 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 		dev_warn(&dev->dev, "Fail to set num of queue pairs to %d\n",
 			 queue_pairs);
 		return -EINVAL;
-	} else {
-		vi->curr_queue_pairs = queue_pairs;
-		/* virtnet_open() will refill when device is going to up. */
-		if (dev->flags & IFF_UP)
-			schedule_delayed_work(&vi->refill, 0);
 	}
+succ:
+	vi->curr_queue_pairs = queue_pairs;
+	/* virtnet_open() will refill when device is going to up. */
+	if (dev->flags & IFF_UP)
+		schedule_delayed_work(&vi->refill, 0);
 
 	return 0;
 }
@@ -3880,21 +3924,14 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 
 static void virtnet_init_default_rss(struct virtnet_info *vi)
 {
-	u32 indir_val = 0;
-	int i = 0;
-
 	vi->rss.hash_types = vi->rss_hash_types_supported;
 	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
 	vi->rss.indirection_table_mask = vi->rss_indir_table_size
 						? vi->rss_indir_table_size - 1 : 0;
 	vi->rss.unclassified_queue = 0;
 
-	for (; i < vi->rss_indir_table_size; ++i) {
-		indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
-		vi->rss.indirection_table[i] = indir_val;
-	}
+	virtnet_rss_update_by_qpairs(vi, vi->curr_queue_pairs);
 
-	vi->rss.max_tx_vq = vi->has_rss ? vi->curr_queue_pairs : 0;
 	vi->rss.hash_key_length = vi->rss_key_size;
 
 	netdev_rss_key_fill(vi->rss.key, vi->rss_key_size);
-- 
2.43.0



