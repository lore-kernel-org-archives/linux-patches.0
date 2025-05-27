Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E027CCF0;
	Tue, 27 May 2025 17:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365994; cv=none; b=ARhlsL1iQXSBMn/93Q6dMegQP5i49vL8H4kEvDVdLC2pPSelP21HSRl//EvvxSfqZpiGWcJLBH3a2PrLBOmcgsTkJVJkhMVksso+yH8vR+PgYscPus93B2SRF7SEJ0YiRm10Ff8q2gIAx7UXMAOMZvFld15OJgTOjgwy6hCiAuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365994; c=relaxed/simple;
	bh=SRoKYaaJi0CTZDRmOD+1xVgyGMR0puS9MPh6dhz9/lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQeCb/zPAcziHq9bJwnGC4Eh8hc8aMwOqp/C243MZ9iVjHQZzBmzFvS8mn17TtzSWG72ygAGSVnRACyIfFFn2v7n6ahBs6wMJdU5R6KEy25VfozYuTaNod0jBDqx7qYCY5gtd5b96jK7fuZKKC8CDpCgT8ci3CSiY0QEafN1GgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goi7DnNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goi7DnNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A655C4CEE9;
	Tue, 27 May 2025 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365994;
	bh=SRoKYaaJi0CTZDRmOD+1xVgyGMR0puS9MPh6dhz9/lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goi7DnNlbVjNu35xiNeX+6Kyx1W2jN/vPU6dLiD+eQ2prTekoKptZlji1tDRATc1T
	 UkYwhV8ys3yFjD7UJchMD9kGz9DhBqiaHVrRSKkZOJj6v9dZejPqQlTl1cXJkzdaMw
	 s5SrJnWm/XDNSYzWPl612FZXiY1tHTSaAa1LDEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhu Chititm <madhu.chittim@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 557/626] idpf: fix null-ptr-deref in idpf_features_check
Date: Tue, 27 May 2025 18:27:30 +0200
Message-ID: <20250527162507.603050866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>

[ Upstream commit 2dabe349f7882ff1407a784d54d8541909329088 ]

idpf_features_check is used to validate the TX packet. skb header
length is compared with the hardware supported value received from
the device control plane. The value is stored in the adapter structure
and to access it, vport pointer is used. During reset all the vports
are released and the vport pointer that the netdev private structure
points to is NULL.

To avoid null-ptr-deref, store the max header length value in netdev
private structure. This also helps to cache the value and avoid
accessing adapter pointer in hot path.

BUG: kernel NULL pointer dereference, address: 0000000000000068
...
RIP: 0010:idpf_features_check+0x6d/0xe0 [idpf]
Call Trace:
 <TASK>
 ? __die+0x23/0x70
 ? page_fault_oops+0x154/0x520
 ? exc_page_fault+0x76/0x190
 ? asm_exc_page_fault+0x26/0x30
 ? idpf_features_check+0x6d/0xe0 [idpf]
 netif_skb_features+0x88/0x310
 validate_xmit_skb+0x2a/0x2b0
 validate_xmit_skb_list+0x4c/0x70
 sch_direct_xmit+0x19d/0x3a0
 __dev_queue_xmit+0xb74/0xe70
 ...

Fixes: a251eee62133 ("idpf: add SRIOV support and other ndo_ops")
Reviewed-by: Madhu Chititm <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h     |  2 ++
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index aef0e9775a330..70dbf80f3bb75 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -143,6 +143,7 @@ enum idpf_vport_state {
  * @vport_id: Vport identifier
  * @link_speed_mbps: Link speed in mbps
  * @vport_idx: Relative vport index
+ * @max_tx_hdr_size: Max header length hardware can support
  * @state: See enum idpf_vport_state
  * @netstats: Packet and byte stats
  * @stats_lock: Lock to protect stats update
@@ -153,6 +154,7 @@ struct idpf_netdev_priv {
 	u32 vport_id;
 	u32 link_speed_mbps;
 	u16 vport_idx;
+	u16 max_tx_hdr_size;
 	enum idpf_vport_state state;
 	struct rtnl_link_stats64 netstats;
 	spinlock_t stats_lock;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 5ce663d04de00..615e74d038457 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -723,6 +723,7 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 		np->vport = vport;
 		np->vport_idx = vport->idx;
 		np->vport_id = vport->vport_id;
+		np->max_tx_hdr_size = idpf_get_max_tx_hdr_size(adapter);
 		vport->netdev = netdev;
 
 		return idpf_init_mac_addr(vport, netdev);
@@ -740,6 +741,7 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 	np->adapter = adapter;
 	np->vport_idx = vport->idx;
 	np->vport_id = vport->vport_id;
+	np->max_tx_hdr_size = idpf_get_max_tx_hdr_size(adapter);
 
 	spin_lock_init(&np->stats_lock);
 
@@ -2189,8 +2191,8 @@ static netdev_features_t idpf_features_check(struct sk_buff *skb,
 					     struct net_device *netdev,
 					     netdev_features_t features)
 {
-	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
-	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_netdev_priv *np = netdev_priv(netdev);
+	u16 max_tx_hdr_size = np->max_tx_hdr_size;
 	size_t len;
 
 	/* No point in doing any of this if neither checksum nor GSO are
@@ -2213,7 +2215,7 @@ static netdev_features_t idpf_features_check(struct sk_buff *skb,
 		goto unsupported;
 
 	len = skb_network_header_len(skb);
-	if (unlikely(len > idpf_get_max_tx_hdr_size(adapter)))
+	if (unlikely(len > max_tx_hdr_size))
 		goto unsupported;
 
 	if (!skb->encapsulation)
@@ -2226,7 +2228,7 @@ static netdev_features_t idpf_features_check(struct sk_buff *skb,
 
 	/* IPLEN can support at most 127 dwords */
 	len = skb_inner_network_header_len(skb);
-	if (unlikely(len > idpf_get_max_tx_hdr_size(adapter)))
+	if (unlikely(len > max_tx_hdr_size))
 		goto unsupported;
 
 	/* No need to validate L4LEN as TCP is the only protocol with a
-- 
2.39.5



