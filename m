Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9657A230BD4;
	Mon, 10 Mar 2025 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628294; cv=none; b=aiaRJHcuqrFY3i+ud5i+ZvRGqhQQ1Z+K0QvlNo5LBWz9aZq0SYEwhdRqIoz8AV8FNoQUiVq7ybmePoIH/GjifIZfVxuRzJwCmWnSNyiU4jjK6kRIqTvrje/U5QRs/9QZJ4QaY1zJICb0ft4/yfkkDCjjIhqVjnU96fjUZS5Z8DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628294; c=relaxed/simple;
	bh=y9Th0CYYsyU/bkZpZEaV+deCsdXpGy49+E0ldqBc07A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM0S+tj/miiwywvNcOp3gZSPXu44MMXC3XfDxeX04AQ7OiWJds8hVmp503zrJvXf1Z6T4O99CuR4QlHJ64gLakyy4gEHWdIsRO9FFxacxu9kuv0NBeP64PQBfwXRkwRZJN48myi/f5t2fAtNtuMCx6jSgEtcLahRj3hwqwYvgxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0cu+4R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0cu+4R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24931C4CEEE;
	Mon, 10 Mar 2025 17:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628294;
	bh=y9Th0CYYsyU/bkZpZEaV+deCsdXpGy49+E0ldqBc07A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0cu+4R3wgcSW02j9QM4+XEzFZ8t5cWWZqbsV87w9t7iOorNTBiPl/ltBnUGYorWC
	 TpgGYuUK2x2wVPcPa/Xfp1bNrvWdJ3YY9F9sZO+2RP90rCxpWSQOgYkYQJXgCvTETZ
	 1+nH9I0xz+DbGZpbf8AWVXLrHypNF0U/Cy26W+WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/109] ibmvnic: Perform tx CSO during send scrq direct
Date: Mon, 10 Mar 2025 18:05:45 +0100
Message-ID: <20250310170427.597226299@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit e633e32b60fd6701bed73599b273a2a03621ea54 ]

During initialization with the vnic server, a bitstring is communicated
to the client regarding header info needed during CSO (See "VNIC
Capabilities" in PAPR). Most of the time, to be safe, vnic server
requests header info for CSO. When header info is needed, multiple TX
descriptors are required per skb; This limits the driver to use
send_subcrq_indirect instead of send_subcrq_direct.

Previously, the vnic server request for header info was ignored. This
allowed the use of send_sub_crq_direct. Transmissions were successful
because the bitstring returned by vnic server is broad and over
cautionary. It was observed that mlx backing devices could actually
transmit and handle CSO packets without the vnic server receiving
header info (despite the fact that the bitstring requested it).

There was a trust issue: The bitstring was overcautionary. This extra
precaution (requesting header info when the backing device may not use
it) comes at the cost of performance (using direct vs indirect hcalls
has a 30% delta in small packet RR transaction rate). So it has been
requested that the vnic server team tries to ensure that the bitstring
is more exact. In the meantime, disable CSO when it is possible to use
the skb in the send_subcrq_direct path. In other words, calculate the
checksum before handing the packet to FW when the packet is not
segmented and xmit_more is false.

Since the code path is only possible if the skb is non GSO and xmit_more
is false, the cost of doing checksum in the send_subcrq_direct path is
minimal. Any large segmented skb will have xmit_more set to true more
frequently and it is inexpensive to do checksumming on a small skb.
The worst-case workload would be a 9000 MTU TCP_RR test with close
to MTU sized packets (and TSO off). This allows xmit_more to be false
more frequently and open the code path up to use send_subcrq_direct.
Observing trace data (graph-time = 1) and packet rate with this workload
shows minimal performance degradation:

1. NIC does checksum w headers, safely use send_subcrq_indirect:
  - Packet rate: 631k txs
  - Trace data:
    ibmvnic_xmit = 44344685.87 us / 6234576 hits = AVG 7.11 us
      skb_checksum_help = 4.07 us / 2 hits = AVG 2.04 us
       ^ Notice hits, tracing this just for reassurance
      ibmvnic_tx_scrq_flush = 33040649.69 us / 5638441 hits = AVG 5.86 us
        send_subcrq_indirect = 37438922.24 us / 6030859 hits = AVG 6.21 us

2. NIC does checksum w/o headers, dangerously use send_subcrq_direct:
  - Packet rate: 831k txs
  - Trace data:
    ibmvnic_xmit = 48940092.29 us / 8187630 hits = AVG 5.98 us
      skb_checksum_help = 2.03 us / 1 hits = AVG 2.03
      ibmvnic_tx_scrq_flush = 31141879.57 us / 7948960 hits = AVG 3.92 us
        send_subcrq_indirect = 8412506.03 us / 728781 hits = AVG 11.54
         ^ notice hits is much lower b/c send_subcrq_direct was called
                                            ^ wasn't traceable

3. driver does checksum, safely use send_subcrq_direct (THIS PATCH):
  - Packet rate: 829k txs
  - Trace data:
    ibmvnic_xmit = 56696077.63 us / 8066168 hits = AVG 7.03 us
      skb_checksum_help = 8587456.16 us / 7526072 hits = AVG 1.14 us
      ibmvnic_tx_scrq_flush = 30219545.55 us / 7782409 hits = AVG 3.88 us
        send_subcrq_indirect = 8638326.44 us / 763693 hits = AVG 11.31 us

When the bitstring ever specifies that CSO does not require headers
(dependent on VIOS vnic server changes), then this patch should be
removed and replaced with one that investigates the bitstring before
using send_subcrq_direct.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://patch.msgid.link/20240807211809.1259563-8-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: de390657b5d6 ("ibmvnic: Inspect header requirements before using scrq direct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 44991cae94045..578b9b5460108 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2237,6 +2237,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned int skblen;
 	union sub_crq tx_crq;
 	unsigned int offset;
+	bool use_scrq_send_direct = false;
 	int num_entries = 1;
 	unsigned char *dst;
 	int bufidx = 0;
@@ -2296,6 +2297,18 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	memset(dst, 0, tx_pool->buf_size);
 	data_dma_addr = ltb->addr + offset;
 
+	/* if we are going to send_subcrq_direct this then we need to
+	 * update the checksum before copying the data into ltb. Essentially
+	 * these packets force disable CSO so that we can guarantee that
+	 * FW does not need header info and we can send direct.
+	 */
+	if (!skb_is_gso(skb) && !ind_bufp->index && !netdev_xmit_more()) {
+		use_scrq_send_direct = true;
+		if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		    skb_checksum_help(skb))
+			use_scrq_send_direct = false;
+	}
+
 	if (skb_shinfo(skb)->nr_frags) {
 		int cur, i;
 
@@ -2381,11 +2394,13 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_crq.v1.flags1 |= IBMVNIC_TX_LSO;
 		tx_crq.v1.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
 		hdrs += 2;
-	} else if (!ind_bufp->index && !netdev_xmit_more()) {
-		ind_bufp->indir_arr[0] = tx_crq;
+	} else if (use_scrq_send_direct) {
+		/* See above comment, CSO disabled with direct xmit */
+		tx_crq.v1.flags1 &= ~(IBMVNIC_TX_CHKSUM_OFFLOAD);
 		ind_bufp->index = 1;
 		tx_buff->num_entries = 1;
 		netdev_tx_sent_queue(txq, skb->len);
+		ind_bufp->indir_arr[0] = tx_crq;
 		lpar_rc = ibmvnic_tx_scrq_flush(adapter, tx_scrq, false);
 		if (lpar_rc != H_SUCCESS)
 			goto tx_err;
-- 
2.39.5



