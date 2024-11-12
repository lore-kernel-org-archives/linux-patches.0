Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694FD2123FF;
	Tue, 12 Nov 2024 10:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408091; cv=none; b=Ijty2xa9TwKhRYapQUpQnE0hV8hjhzGgOx6BMZcRcpL/TlEL6RagEU8UZwTNCT3gzs27Owdiiqck4YcMDZyA5LNfiQEYWuNpbiGe1/ppfmYHQ+zxHYDvHygS9H38DVicVpzFZO14HXBTbelC45kLRG/1wVkh+zwM5QWh9Z29vGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408091; c=relaxed/simple;
	bh=JWdLJPU+LqVWiNXBUYkNm/yd3E7fgYKi5i12Br0y2+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAZmrCQrB7vNNvU1lC6+Ai1lhxpoVDOJ6T19v0xNbSVuofTsGfzVYS4kwViEYU6mW7AiGW7jc+f7Lh7in9z2RWsyGRVJXGMV7yzqi5DSHkR2eXs/prVp67QcG0xyjCHq/b0+hZGQOIrEJn9RlD9OAtHT42OHAw1YGxZOZ7F+Dak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPXc+1ZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPXc+1ZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3CCC4CECD;
	Tue, 12 Nov 2024 10:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408091;
	bh=JWdLJPU+LqVWiNXBUYkNm/yd3E7fgYKi5i12Br0y2+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPXc+1ZCj2J+9WW/6F51FrHtRS7VLMDw5h3rQ3uTpww4ljOpG56OTiGXbiXmgCJVa
	 jiBE54yf1Tob87shKdOukIAiE1kGu2Pfkxw6QOpmRqf5C5SlHOnlN7CUqzVedQQMgR
	 b4RLpZ04uRXdpr9XNuJmi3Q1ioFQFdeF4EWc7ho0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Joe Damato <jdamato@fastly.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 055/184] virtio_net: Support dynamic rss indirection table size
Date: Tue, 12 Nov 2024 11:20:13 +0100
Message-ID: <20241112101902.973830389@linuxfoundation.org>
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

[ Upstream commit 86a48a00efdf61197b6658e52c6140463eb313dc ]

When reading/writing virtio_net_ctrl_rss, we get the indirection table
size from vi->rss_indir_table_size, which is initialized in
virtnet_probe(). However, the actual size of indirection_table was set
as VIRTIO_NET_RSS_MAX_TABLE_LEN=128. This collision may cause issues if
the vi->rss_indir_table_size exceeds 128.

This patch instead uses dynamic indirection table, allocated with
vi->rss after vi->rss_indir_table_size initialized. And free it in
virtnet_remove().

In virtnet_commit_rss_command(), sgs for rss is initialized differently
with hash_report. So indirection_table is not used if !vi->has_rss, and
then we don't need to alloc indirection_table for hash_report only uses.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Joe Damato <jdamato@fastly.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 792e9eadbfc3d..4b507007d242b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -368,15 +368,16 @@ struct receive_queue {
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
@@ -512,6 +513,25 @@ static struct sk_buff *virtnet_skb_append_frag(struct sk_buff *head_skb,
 					       struct page *page, void *buf,
 					       int len, int truesize);
 
+static int rss_indirection_table_alloc(struct virtio_net_ctrl_rss *rss, u16 indir_table_size)
+{
+	if (!indir_table_size) {
+		rss->indirection_table = NULL;
+		return 0;
+	}
+
+	rss->indirection_table = kmalloc_array(indir_table_size, sizeof(u16), GFP_KERNEL);
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
 static bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
@@ -3828,11 +3848,15 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 	/* prepare sgs */
 	sg_init_table(sgs, 4);
 
-	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
+	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, hash_cfg_reserved);
 	sg_set_buf(&sgs[0], &vi->rss, sg_buf_size);
 
-	sg_buf_size = sizeof(uint16_t) * (vi->rss.indirection_table_mask + 1);
-	sg_set_buf(&sgs[1], vi->rss.indirection_table, sg_buf_size);
+	if (vi->has_rss) {
+		sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
+		sg_set_buf(&sgs[1], vi->rss.indirection_table, sg_buf_size);
+	} else {
+		sg_set_buf(&sgs[1], &vi->rss.hash_cfg_reserved, sizeof(uint16_t));
+	}
 
 	sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
 			- offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
@@ -6420,6 +6444,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 			virtio_cread16(vdev, offsetof(struct virtio_net_config,
 				rss_max_indirection_table_length));
 	}
+	err = rss_indirection_table_alloc(&vi->rss, vi->rss_indir_table_size);
+	if (err)
+		goto free;
 
 	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_key_size =
@@ -6674,6 +6701,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 
 	remove_vq_common(vi);
 
+	rss_indirection_table_free(&vi->rss);
+
 	free_netdev(vi->dev);
 }
 
-- 
2.43.0



