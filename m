Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88504350A0D;
	Tue, 21 Oct 2025 20:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077170; cv=none; b=O6Ku5x5Ze0mmqw2ncIOWKcQhHpk6Edvs+Nzj9EjzZ/qbl9PV+3tuFv8QptxT7Wv2yucYjXX0+wu5vHMd9L4JwqB3PrjErtb+lSWiZdp1xe8oytuYpwSs+9CuzAJT6z4SjQ/MkXBtXZEGhj+px2DtZ+hdR+pzU/VGNdkmJpIjLTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077170; c=relaxed/simple;
	bh=8LVBgDO+OzMB62PHN4W7gaOnZxueAZHqL6pGsT1DVmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnLJbIjWDc8PbXgNUOFmVOwhumiudIRs/Dd/+ZK+a6VT3uU2EfJxvXWxa72K6IctMlvfISaTtskX1kR5nScHiVVSCn31vixWHt+pWD7IG6g2k1yzfPNnyu0ThDufqaNX9/HEeeejD0tAPUkoNMWOJGKWX2qLweDNX3X/RFUYcMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIvAWh2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIvAWh2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07C1C4CEF1;
	Tue, 21 Oct 2025 20:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077170;
	bh=8LVBgDO+OzMB62PHN4W7gaOnZxueAZHqL6pGsT1DVmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIvAWh2WewF/6puJxyJwSB/LV3tbLZ7EjCr49jQKPP5m1LVkn3aIq8+Mk8koaWByz
	 kba5XKD8osVoqujVKHYx6mo2V6tKVl8mz4+4nvfmjXOPvFO1ez2IEe59eO5ZI0nmCl
	 YZYarhTJZMfhRX/zhlScbz28tkBOwzFRll5YQ7E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Tim Hostetler <thostet@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 021/159] gve: Check valid ts bit on RX descriptor before hw timestamping
Date: Tue, 21 Oct 2025 21:49:58 +0200
Message-ID: <20251021195043.699417231@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Hostetler <thostet@google.com>

commit bfdd74166a639930baaba27a8d729edaacd46907 upstream.

The device returns a valid bit in the LSB of the low timestamp byte in
the completion descriptor that the driver should check before
setting the SKB's hardware timestamp. If the timestamp is not valid, do not
hardware timestamp the SKB.

Cc: stable@vger.kernel.org
Fixes: b2c7aeb49056 ("gve: Implement ndo_hwtstamp_get/set for RX timestamping")
Reviewed-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Tim Hostetler <thostet@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251014004740.2775957-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve.h          |    2 ++
 drivers/net/ethernet/google/gve/gve_desc_dqo.h |    3 ++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c   |   16 +++++++++++-----
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -100,6 +100,8 @@
  */
 #define GVE_DQO_QPL_ONDEMAND_ALLOC_THRESHOLD 96
 
+#define GVE_DQO_RX_HWTSTAMP_VALID 0x1
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
--- a/drivers/net/ethernet/google/gve/gve_desc_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
@@ -236,7 +236,8 @@ struct gve_rx_compl_desc_dqo {
 
 	u8 status_error1;
 
-	__le16 reserved5;
+	u8 reserved5;
+	u8 ts_sub_nsecs_low;
 	__le16 buf_id; /* Buffer ID which was sent on the buffer queue. */
 
 	union {
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -456,14 +456,20 @@ static void gve_rx_skb_hash(struct sk_bu
  * Note that this means if the time delta between packet reception and the last
  * clock read is greater than ~2 seconds, this will provide invalid results.
  */
-static void gve_rx_skb_hwtstamp(struct gve_rx_ring *rx, u32 hwts)
+static void gve_rx_skb_hwtstamp(struct gve_rx_ring *rx,
+				const struct gve_rx_compl_desc_dqo *desc)
 {
 	u64 last_read = READ_ONCE(rx->gve->last_sync_nic_counter);
 	struct sk_buff *skb = rx->ctx.skb_head;
-	u32 low = (u32)last_read;
-	s32 diff = hwts - low;
+	u32 ts, low;
+	s32 diff;
 
-	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(last_read + diff);
+	if (desc->ts_sub_nsecs_low & GVE_DQO_RX_HWTSTAMP_VALID) {
+		ts = le32_to_cpu(desc->ts);
+		low = (u32)last_read;
+		diff = ts - low;
+		skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(last_read + diff);
+	}
 }
 
 static void gve_rx_free_skb(struct napi_struct *napi, struct gve_rx_ring *rx)
@@ -919,7 +925,7 @@ static int gve_rx_complete_skb(struct gv
 		gve_rx_skb_csum(rx->ctx.skb_head, desc, ptype);
 
 	if (rx->gve->ts_config.rx_filter == HWTSTAMP_FILTER_ALL)
-		gve_rx_skb_hwtstamp(rx, le32_to_cpu(desc->ts));
+		gve_rx_skb_hwtstamp(rx, desc);
 
 	/* RSC packets must set gso_size otherwise the TCP stack will complain
 	 * that packets are larger than MTU.


