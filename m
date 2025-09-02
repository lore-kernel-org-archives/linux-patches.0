Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD7431158C;
	Tue,  2 Sep 2025 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820200; cv=none; b=krz1kGCrnrTePMh+kAYIVA/TczF7cEIe4P+VpLI9j+XeqIJg9sJ225LuEGHW1PezZp/Ad9H08MVFu/D9xhMgDDdihTw29k52TUmXIz2sFv08B5sJaP2XWojcVY/uVqf24513vEAq2Dc6PN+0Bqc8a5/69EBqNZ8Mc06ihHTEaMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820200; c=relaxed/simple;
	bh=OiJnUspedxT4/wkYOwAT/wZNT7RR9PzkrXEaL2jT3KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAUmoXKfJV7bP/7xlmoRVsm8CG/FwlrYNZ53JRL67RHjOrFJFHDCJJm3qiByzCF85NxGIeY4+xLhq31lpzTOEQ1yW/ibPhJhWuKRdbiledbaRjwjysH9xKY9h4N8BMPsFpocHy8nygsMf0ubJDtDTg5MQzF2bOJCwxKSUSbYbR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izOk+kJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izOk+kJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25110C4CEED;
	Tue,  2 Sep 2025 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820200;
	bh=OiJnUspedxT4/wkYOwAT/wZNT7RR9PzkrXEaL2jT3KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izOk+kJZpnTG42pxbpF+qlAqgQi0/sZhqchfJ447qul/IhhnGY6DfGx8vPSULFjHz
	 rOu9wOOcIxF8MDSW3+3pumEtPMLnLSmlo3XNbIuUWQU10BoDW7ddyApAXOpjxmiDjR
	 JakJ9cbchrOAH8xUVKbzObshqG5+xZ+AbpeQ4+80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 29/75] ice: Introduce ice_xdp_buff
Date: Tue,  2 Sep 2025 15:20:41 +0200
Message-ID: <20250902131936.259016855@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit d951c14ad237b087f0d1377c44932fcc0b322c40 ]

In order to use XDP hints via kfuncs we need to put
RX descriptor and miscellaneous data next to xdp_buff.
Same as in hints implementations in other drivers, we achieve
this through putting xdp_buff into a child structure.

Currently, xdp_buff is stored in the ring structure,
so replace it with union that includes child structure.
This way enough memory is available while existing XDP code
remains isolated from hints.

Minimum size of the new child structure (ice_xdp_buff) is exactly
64 bytes (single cache line). To place it at the start of a cache line,
move 'next' field from CL1 to CL4, as it isn't used often. This still
leaves 192 bits available in CL3 for packet context extensions.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20231205210847.28460-5-larysa.zaremba@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: b1a0c977c6f1 ("ice: fix incorrect counter for buffer allocation failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  7 +++++--
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 18 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 10 ++++++++++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index f5023ac9ab832..46f10f32924ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -528,13 +528,14 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
  * @xdp_prog: XDP program to run
  * @xdp_ring: ring to be used for XDP_TX action
  * @rx_buf: Rx buffer to store the XDP action
+ * @eop_desc: Last descriptor in packet to read metadata from
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static void
 ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
-	    struct ice_rx_buf *rx_buf)
+	    struct ice_rx_buf *rx_buf, union ice_32b_rx_flex_desc *eop_desc)
 {
 	unsigned int ret = ICE_XDP_PASS;
 	u32 act;
@@ -542,6 +543,8 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	if (!xdp_prog)
 		goto exit;
 
+	ice_xdp_meta_set_desc(xdp, eop_desc);
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
@@ -1240,7 +1243,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
-		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf);
+		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf, rx_desc);
 		if (rx_buf->act == ICE_XDP_PASS)
 			goto construct_skb;
 		total_rx_bytes += xdp_get_buff_len(xdp);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 407d4c320097f..ad2d286bd359d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -257,6 +257,14 @@ enum ice_rx_dtype {
 	ICE_RX_DTYPE_SPLIT_ALWAYS	= 2,
 };
 
+struct ice_xdp_buff {
+	struct xdp_buff xdp_buff;
+	const union ice_32b_rx_flex_desc *eop_desc;
+};
+
+/* Required for compatibility with xdp_buffs from xsk_pool */
+static_assert(offsetof(struct ice_xdp_buff, xdp_buff) == 0);
+
 /* indices into GLINT_ITR registers */
 #define ICE_RX_ITR	ICE_IDX_ITR0
 #define ICE_TX_ITR	ICE_IDX_ITR1
@@ -298,7 +306,6 @@ enum ice_dynamic_itr {
 /* descriptor ring, associated with a VSI */
 struct ice_rx_ring {
 	/* CL1 - 1st cacheline starts here */
-	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */
 	void *desc;			/* Descriptor ring memory */
 	struct device *dev;		/* Used for DMA mapping */
 	struct net_device *netdev;	/* netdev ring maps to */
@@ -310,12 +317,16 @@ struct ice_rx_ring {
 	u16 count;			/* Number of descriptors */
 	u16 reg_idx;			/* HW register index of the ring */
 	u16 next_to_alloc;
-	/* CL2 - 2nd cacheline starts here */
+
 	union {
 		struct ice_rx_buf *rx_buf;
 		struct xdp_buff **xdp_buf;
 	};
-	struct xdp_buff xdp;
+	/* CL2 - 2nd cacheline starts here */
+	union {
+		struct ice_xdp_buff xdp_ext;
+		struct xdp_buff xdp;
+	};
 	/* CL3 - 3rd cacheline starts here */
 	struct bpf_prog *xdp_prog;
 	u16 rx_offset;
@@ -332,6 +343,7 @@ struct ice_rx_ring {
 	/* CL4 - 4th cacheline starts here */
 	struct ice_channel *ch;
 	struct ice_tx_ring *xdp_ring;
+	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */
 	struct xsk_buff_pool *xsk_pool;
 	u32 nr_frags;
 	dma_addr_t dma;			/* physical address of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index b0e56675f98b2..00971f8491358 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -164,4 +164,14 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       struct sk_buff *skb, u16 ptype);
 void
 ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
+
+static inline void
+ice_xdp_meta_set_desc(struct xdp_buff *xdp,
+		      union ice_32b_rx_flex_desc *eop_desc)
+{
+	struct ice_xdp_buff *xdp_ext = container_of(xdp, struct ice_xdp_buff,
+						    xdp_buff);
+
+	xdp_ext->eop_desc = eop_desc;
+}
 #endif /* !_ICE_TXRX_LIB_H_ */
-- 
2.50.1



