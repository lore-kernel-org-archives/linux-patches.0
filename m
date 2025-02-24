Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0559618A6C5;
	Mon, 24 Feb 2025 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408017; cv=none; b=TxIAd79QSqczWuBtPCqyGYOBGKz0FLLPmIuOlT7SXFHfgKWvCr0eLlpKrajSWHJSBwy+JmrmcaTDrhzfXq9vgNeK3vqVsQAyh3DTcTWlxsI/JtK1uirNPbA0PURe3x4i7QfO+nmmr+1hhVUKFb0RThF0ZZwCHvZh6MY0m15h1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408017; c=relaxed/simple;
	bh=ncM0eKGImkI3z3Xt58oaXRsEBtU3l+Wmq/O8at/2A8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek9h12wGtJ5WH/84r2xD3YdlAeZMd7wA5jOLjcQRzOlLbXk91Iz/QEQ3li0WE7qkblu2bF4egrxwRFaM1YnP/8I3TqzY/yzYST29f37sJ6xGiheGan4pV3bh5sizLWOMh+QXhtcDSDWcr8AXoEpXQt6uCn0BP/MqzwTPjss7M80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfBlVsiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfBlVsiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6A2C4CED6;
	Mon, 24 Feb 2025 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408016;
	bh=ncM0eKGImkI3z3Xt58oaXRsEBtU3l+Wmq/O8at/2A8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfBlVsiFuvLpTASSUPfVC2mhhjXj64qyzIP7Xd3Br7yq1jM9DPZpeRjL1Z4Gmv9II
	 RJK95PIm6AH1a5CoB3fOFqbx+O9GEwBA8l4+a3r7sjIMTIOo7kNL428YpY7JCU1djk
	 HP4KCl1V6VQrfv9QtDlXyHP3JGwtavTQHqKLlFpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/140] ibmvnic: Introduce send sub-crq direct
Date: Mon, 24 Feb 2025 15:34:35 +0100
Message-ID: <20250224142605.996478511@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 74839f7a82689bf5a21a5447cae8e3a7b7a606d2 ]

Firmware supports two hcalls to send a sub-crq request:
H_SEND_SUB_CRQ_INDIRECT and H_SEND_SUB_CRQ. The indirect hcall allows
for submission of batched messages while the other hcall is limited to
only one message. This protocol is defined in PAPR section 17.2.3.3.

Previously, the ibmvnic xmit function only used the indirect hcall. This
allowed the driver to batch it's skbs. A single skb can occupy a few
entries per hcall depending on if FW requires skb header information or
not. The FW only needs header information if the packet is segmented.

By this logic, if an skb is not GSO then it can fit in one sub-crq
message and therefore is a candidate for H_SEND_SUB_CRQ.
Batching skb transmission is only useful when there are more packets
coming down the line (ie netdev_xmit_more is true).

As it turns out, H_SEND_SUB_CRQ induces less latency than
H_SEND_SUB_CRQ_INDIRECT. Therefore, use H_SEND_SUB_CRQ where
appropriate.

Small latency gains seen when doing TCP_RR_150 (request/response
workload). Ftrace results (graph-time=1):
  Previous:
     ibmvnic_xmit = 29618270.83 us / 8860058.0 hits = AVG 3.34
     ibmvnic_tx_scrq_flush = 21972231.02 us / 6553972.0 hits = AVG 3.35
  Now:
     ibmvnic_xmit = 22153350.96 us / 8438942.0 hits = AVG 2.63
     ibmvnic_tx_scrq_flush = 15858922.4 us / 6244076.0 hits = AVG 2.54

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://patch.msgid.link/20240807211809.1259563-6-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bdf5d13aa05e ("ibmvnic: Don't reference skb after sending to VIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 52 ++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e1e4dc81ad309..e2e4a1a2fa74f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -117,6 +117,7 @@ static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb);
 static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
 static void flush_reset_queue(struct ibmvnic_adapter *adapter);
+static void print_subcrq_error(struct device *dev, int rc, const char *func);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -2350,8 +2351,29 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 	}
 }
 
+static int send_subcrq_direct(struct ibmvnic_adapter *adapter,
+			      u64 remote_handle, u64 *entry)
+{
+	unsigned int ua = adapter->vdev->unit_address;
+	struct device *dev = &adapter->vdev->dev;
+	int rc;
+
+	/* Make sure the hypervisor sees the complete request */
+	dma_wmb();
+	rc = plpar_hcall_norets(H_SEND_SUB_CRQ, ua,
+				cpu_to_be64(remote_handle),
+				cpu_to_be64(entry[0]), cpu_to_be64(entry[1]),
+				cpu_to_be64(entry[2]), cpu_to_be64(entry[3]));
+
+	if (rc)
+		print_subcrq_error(dev, rc, __func__);
+
+	return rc;
+}
+
 static int ibmvnic_tx_scrq_flush(struct ibmvnic_adapter *adapter,
-				 struct ibmvnic_sub_crq_queue *tx_scrq)
+				 struct ibmvnic_sub_crq_queue *tx_scrq,
+				 bool indirect)
 {
 	struct ibmvnic_ind_xmit_queue *ind_bufp;
 	u64 dma_addr;
@@ -2366,7 +2388,13 @@ static int ibmvnic_tx_scrq_flush(struct ibmvnic_adapter *adapter,
 
 	if (!entries)
 		return 0;
-	rc = send_subcrq_indirect(adapter, handle, dma_addr, entries);
+
+	if (indirect)
+		rc = send_subcrq_indirect(adapter, handle, dma_addr, entries);
+	else
+		rc = send_subcrq_direct(adapter, handle,
+					(u64 *)ind_bufp->indir_arr);
+
 	if (rc)
 		ibmvnic_tx_scrq_clean_buffer(adapter, tx_scrq);
 	else
@@ -2424,7 +2452,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_dropped++;
 		tx_send_failed++;
 		ret = NETDEV_TX_OK;
-		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq, true);
 		if (lpar_rc != H_SUCCESS)
 			goto tx_err;
 		goto out;
@@ -2442,7 +2470,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_send_failed++;
 		tx_dropped++;
 		ret = NETDEV_TX_OK;
-		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq, true);
 		if (lpar_rc != H_SUCCESS)
 			goto tx_err;
 		goto out;
@@ -2540,6 +2568,16 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_crq.v1.flags1 |= IBMVNIC_TX_LSO;
 		tx_crq.v1.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
 		hdrs += 2;
+	} else if (!ind_bufp->index && !netdev_xmit_more()) {
+		ind_bufp->indir_arr[0] = tx_crq;
+		ind_bufp->index = 1;
+		tx_buff->num_entries = 1;
+		netdev_tx_sent_queue(txq, skb->len);
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq, false);
+		if (lpar_rc != H_SUCCESS)
+			goto tx_err;
+
+		goto early_exit;
 	}
 
 	if ((*hdrs >> 7) & 1)
@@ -2549,7 +2587,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	tx_buff->num_entries = num_entries;
 	/* flush buffer if current entry can not fit */
 	if (num_entries + ind_bufp->index > IBMVNIC_MAX_IND_DESCS) {
-		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq, true);
 		if (lpar_rc != H_SUCCESS)
 			goto tx_flush_err;
 	}
@@ -2557,15 +2595,17 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	indir_arr[0] = tx_crq;
 	memcpy(&ind_bufp->indir_arr[ind_bufp->index], &indir_arr[0],
 	       num_entries * sizeof(struct ibmvnic_generic_scrq));
+
 	ind_bufp->index += num_entries;
 	if (__netdev_tx_sent_queue(txq, skb->len,
 				   netdev_xmit_more() &&
 				   ind_bufp->index < IBMVNIC_MAX_IND_DESCS)) {
-		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq);
+		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq, true);
 		if (lpar_rc != H_SUCCESS)
 			goto tx_err;
 	}
 
+early_exit:
 	if (atomic_add_return(num_entries, &tx_scrq->used)
 					>= adapter->req_tx_entries_per_subcrq) {
 		netdev_dbg(netdev, "Stopping queue %d\n", queue_num);
-- 
2.39.5



