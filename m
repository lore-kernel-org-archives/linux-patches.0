Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7007179EE;
	Sat, 30 Dec 2023 12:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qx8MdnrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC348C433C8;
	Sat, 30 Dec 2023 12:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937883;
	bh=DPSZkhNXUWAPss/uXVZZtNDHki5806NqObZhvQuxqFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qx8MdnrZznbLwj7Zk1+vnz9aqqkzOIOcRn/A6F/7SQPGu2zjJEGMF3d7y0tAFXT8x
	 X8/vrUYzTMipYs4tdkp3yg96kkAtWoASPpC6QXNWebE8hM8fLkRGOPVJHpy/V5dOmo
	 gNbVM/H5GVLPfWtDplvw0zUgLxCYxL610XhNWvaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.6 099/156] wifi: mt76: fix crash with WED rx support enabled
Date: Sat, 30 Dec 2023 11:59:13 +0000
Message-ID: <20231230115815.602112471@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

commit cd607f2cbbbec90682b2f6d6b85e1525d0f43b19 upstream.

If WED rx is enabled, rx buffers are added to a buffer pool that can be
filled from multiple page pools. Because buffers freed from rx poll are
not guaranteed to belong to the processed queue's page pool, lockless
caching must not be used in this case.

Cc: stable@vger.kernel.org
Fixes: 2f5c3c77fc9b ("wifi: mt76: switch to page_pool allocator")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231208075004.69843-1-nbd@nbd.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -776,7 +776,7 @@ mt76_dma_rx_reset(struct mt76_dev *dev,
 
 static void
 mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
-		  int len, bool more, u32 info)
+		  int len, bool more, u32 info, bool allow_direct)
 {
 	struct sk_buff *skb = q->rx_head;
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -788,7 +788,7 @@ mt76_add_fragment(struct mt76_dev *dev,
 
 		skb_add_rx_frag(skb, nr_frags, page, offset, len, q->buf_size);
 	} else {
-		mt76_put_page_pool_buf(data, true);
+		mt76_put_page_pool_buf(data, allow_direct);
 	}
 
 	if (more)
@@ -808,6 +808,7 @@ mt76_dma_rx_process(struct mt76_dev *dev
 	struct sk_buff *skb;
 	unsigned char *data;
 	bool check_ddone = false;
+	bool allow_direct = !mt76_queue_is_wed_rx(q);
 	bool more;
 
 	if (IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED) &&
@@ -848,7 +849,8 @@ mt76_dma_rx_process(struct mt76_dev *dev
 		}
 
 		if (q->rx_head) {
-			mt76_add_fragment(dev, q, data, len, more, info);
+			mt76_add_fragment(dev, q, data, len, more, info,
+					  allow_direct);
 			continue;
 		}
 
@@ -877,7 +879,7 @@ mt76_dma_rx_process(struct mt76_dev *dev
 		continue;
 
 free_frag:
-		mt76_put_page_pool_buf(data, true);
+		mt76_put_page_pool_buf(data, allow_direct);
 	}
 
 	mt76_dma_rx_fill(dev, q, true);


