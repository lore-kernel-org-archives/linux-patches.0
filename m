Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851272CCC0;
	Tue, 27 May 2025 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364801; cv=none; b=AIGuXKEwfRpMJJFaeuQYE1qiPAMb84paNDewdQ/u06qqK0AgIEasxEp99GJa4DugZNn6WsTHOoaXW3wYVjiKGFWax0uxq/JguU1xP5flpqe39uuLw57Wie1/4TnfKV8K6lLu+xrra5j+nynvoHplRb79qLm57IBoxDFLF+vahW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364801; c=relaxed/simple;
	bh=BMwpvfQRyURMluB/iScSIIXLhDSn0NYLQtmJZM5fVQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxhCVBwXjU3/VEOQ/+T6LpIOzaYsBx8h5yXQin9j22eHVPqIMTS6ZSsBi1UV4T41GrPE+SgIGqiRviovX66kF34LqGhimDTNPqxVhQ4NITNbb/3mwi4ofcbAey4ltcNQPM8YIB3ayIesapdjpeGVlWGFhk2tFNXvQUP4QLcVw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU4ZmAeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU4ZmAeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E687C4CEE9;
	Tue, 27 May 2025 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364798;
	bh=BMwpvfQRyURMluB/iScSIIXLhDSn0NYLQtmJZM5fVQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU4ZmAeg3IHb8HQEGG1+vPDJNV39hyIZXolAES58Y7vNsMq7+QaYIgWsz0FEuk92Q
	 bi/+LTkq3HBHnxNowvAB66GJ9gKgtZj+gXFae1GTukZyVwUS4VTLqdxVznItfLuFcI
	 lMvD7jslfkH0az4NEsT0qO3kTHxjgYLqv9GOAb8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaakko Karrenpalo <jkarrenpalo@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/626] net: hsr: Fix PRP duplicate detection
Date: Tue, 27 May 2025 18:21:02 +0200
Message-ID: <20250527162451.886570271@linuxfoundation.org>
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

From: Jaakko Karrenpalo <jkarrenpalo@gmail.com>

[ Upstream commit 05fd00e5e7b1ac60d264f72423fba38cc382b447 ]

Add PRP specific function for handling duplicate
packets. This is needed because of potential
L2 802.1p prioritization done by network switches.

The L2 prioritization can re-order the PRP packets
from a node causing the existing implementation to
discard the frame(s) that have been received 'late'
because the sequence number is before the previous
received packet. This can happen if the node is
sending multiple frames back-to-back with different
priority.

Signed-off-by: Jaakko Karrenpalo <jkarrenpalo@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250307161700.1045-1-jkarrenpalo@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c   |  2 +
 net/hsr/hsr_forward.c  |  4 +-
 net/hsr/hsr_framereg.c | 95 ++++++++++++++++++++++++++++++++++++++++--
 net/hsr/hsr_framereg.h |  8 +++-
 net/hsr/hsr_main.h     |  2 +
 5 files changed, 104 insertions(+), 7 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 44048d7538ddc..9d0754b3642fd 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -543,6 +543,7 @@ static struct hsr_proto_ops hsr_ops = {
 	.drop_frame = hsr_drop_frame,
 	.fill_frame_info = hsr_fill_frame_info,
 	.invalid_dan_ingress_frame = hsr_invalid_dan_ingress_frame,
+	.register_frame_out = hsr_register_frame_out,
 };
 
 static struct hsr_proto_ops prp_ops = {
@@ -553,6 +554,7 @@ static struct hsr_proto_ops prp_ops = {
 	.fill_frame_info = prp_fill_frame_info,
 	.handle_san_frame = prp_handle_san_frame,
 	.update_san_info = prp_update_san_info,
+	.register_frame_out = prp_register_frame_out,
 };
 
 void hsr_dev_setup(struct net_device *dev)
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index c0217476eb17f..ace4e355d1647 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -524,8 +524,8 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		 * Also for SAN, this shouldn't be done.
 		 */
 		if (!frame->is_from_san &&
-		    hsr_register_frame_out(port, frame->node_src,
-					   frame->sequence_nr))
+		    hsr->proto_ops->register_frame_out &&
+		    hsr->proto_ops->register_frame_out(port, frame))
 			continue;
 
 		if (frame->is_supervision && port->type == HSR_PT_MASTER &&
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 73bc6f659812f..85991fab7db58 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -35,6 +35,7 @@ static bool seq_nr_after(u16 a, u16 b)
 
 #define seq_nr_before(a, b)		seq_nr_after((b), (a))
 #define seq_nr_before_or_eq(a, b)	(!seq_nr_after((a), (b)))
+#define PRP_DROP_WINDOW_LEN 32768
 
 bool hsr_addr_is_redbox(struct hsr_priv *hsr, unsigned char *addr)
 {
@@ -176,8 +177,11 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 		new_node->time_in[i] = now;
 		new_node->time_out[i] = now;
 	}
-	for (i = 0; i < HSR_PT_PORTS; i++)
+	for (i = 0; i < HSR_PT_PORTS; i++) {
 		new_node->seq_out[i] = seq_out;
+		new_node->seq_expected[i] = seq_out + 1;
+		new_node->seq_start[i] = seq_out + 1;
+	}
 
 	if (san && hsr->proto_ops->handle_san_frame)
 		hsr->proto_ops->handle_san_frame(san, rx_port, new_node);
@@ -482,9 +486,11 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
  *	 0 otherwise, or
  *	 negative error code on error
  */
-int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
-			   u16 sequence_nr)
+int hsr_register_frame_out(struct hsr_port *port, struct hsr_frame_info *frame)
 {
+	struct hsr_node *node = frame->node_src;
+	u16 sequence_nr = frame->sequence_nr;
+
 	spin_lock_bh(&node->seq_out_lock);
 	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
 	    time_is_after_jiffies(node->time_out[port->type] +
@@ -499,6 +505,89 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 	return 0;
 }
 
+/* Adaptation of the PRP duplicate discard algorithm described in wireshark
+ * wiki (https://wiki.wireshark.org/PRP)
+ *
+ * A drop window is maintained for both LANs with start sequence set to the
+ * first sequence accepted on the LAN that has not been seen on the other LAN,
+ * and expected sequence set to the latest received sequence number plus one.
+ *
+ * When a frame is received on either LAN it is compared against the received
+ * frames on the other LAN. If it is outside the drop window of the other LAN
+ * the frame is accepted and the drop window is updated.
+ * The drop window for the other LAN is reset.
+ *
+ * 'port' is the outgoing interface
+ * 'frame' is the frame to be sent
+ *
+ * Return:
+ *	 1 if frame can be shown to have been sent recently on this interface,
+ *	 0 otherwise
+ */
+int prp_register_frame_out(struct hsr_port *port, struct hsr_frame_info *frame)
+{
+	enum hsr_port_type other_port;
+	enum hsr_port_type rcv_port;
+	struct hsr_node *node;
+	u16 sequence_diff;
+	u16 sequence_exp;
+	u16 sequence_nr;
+
+	/* out-going frames are always in order
+	 * and can be checked the same way as for HSR
+	 */
+	if (frame->port_rcv->type == HSR_PT_MASTER)
+		return hsr_register_frame_out(port, frame);
+
+	/* for PRP we should only forward frames from the slave ports
+	 * to the master port
+	 */
+	if (port->type != HSR_PT_MASTER)
+		return 1;
+
+	node = frame->node_src;
+	sequence_nr = frame->sequence_nr;
+	sequence_exp = sequence_nr + 1;
+	rcv_port = frame->port_rcv->type;
+	other_port = rcv_port == HSR_PT_SLAVE_A ? HSR_PT_SLAVE_B :
+				 HSR_PT_SLAVE_A;
+
+	spin_lock_bh(&node->seq_out_lock);
+	if (time_is_before_jiffies(node->time_out[port->type] +
+	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)) ||
+	    (node->seq_start[rcv_port] == node->seq_expected[rcv_port] &&
+	     node->seq_start[other_port] == node->seq_expected[other_port])) {
+		/* the node hasn't been sending for a while
+		 * or both drop windows are empty, forward the frame
+		 */
+		node->seq_start[rcv_port] = sequence_nr;
+	} else if (seq_nr_before(sequence_nr, node->seq_expected[other_port]) &&
+		   seq_nr_before_or_eq(node->seq_start[other_port], sequence_nr)) {
+		/* drop the frame, update the drop window for the other port
+		 * and reset our drop window
+		 */
+		node->seq_start[other_port] = sequence_exp;
+		node->seq_expected[rcv_port] = sequence_exp;
+		node->seq_start[rcv_port] = node->seq_expected[rcv_port];
+		spin_unlock_bh(&node->seq_out_lock);
+		return 1;
+	}
+
+	/* update the drop window for the port where this frame was received
+	 * and clear the drop window for the other port
+	 */
+	node->seq_start[other_port] = node->seq_expected[other_port];
+	node->seq_expected[rcv_port] = sequence_exp;
+	sequence_diff = sequence_exp - node->seq_start[rcv_port];
+	if (sequence_diff > PRP_DROP_WINDOW_LEN)
+		node->seq_start[rcv_port] = sequence_exp - PRP_DROP_WINDOW_LEN;
+
+	node->time_out[port->type] = jiffies;
+	node->seq_out[port->type] = sequence_nr;
+	spin_unlock_bh(&node->seq_out_lock);
+	return 0;
+}
+
 static struct hsr_port *get_late_port(struct hsr_priv *hsr,
 				      struct hsr_node *node)
 {
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index 993fa950d8144..b04948659d84d 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -44,8 +44,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 
 void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 			   u16 sequence_nr);
-int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
-			   u16 sequence_nr);
+int hsr_register_frame_out(struct hsr_port *port, struct hsr_frame_info *frame);
 
 void hsr_prune_nodes(struct timer_list *t);
 void hsr_prune_proxy_nodes(struct timer_list *t);
@@ -73,6 +72,8 @@ void prp_update_san_info(struct hsr_node *node, bool is_sup);
 bool hsr_is_node_in_db(struct list_head *node_db,
 		       const unsigned char addr[ETH_ALEN]);
 
+int prp_register_frame_out(struct hsr_port *port, struct hsr_frame_info *frame);
+
 struct hsr_node {
 	struct list_head	mac_list;
 	/* Protect R/W access to seq_out */
@@ -89,6 +90,9 @@ struct hsr_node {
 	bool			san_b;
 	u16			seq_out[HSR_PT_PORTS];
 	bool			removed;
+	/* PRP specific duplicate handling */
+	u16			seq_expected[HSR_PT_PORTS];
+	u16			seq_start[HSR_PT_PORTS];
 	struct rcu_head		rcu_head;
 };
 
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index fcfeb79bb0401..e26244456f639 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -183,6 +183,8 @@ struct hsr_proto_ops {
 			       struct hsr_frame_info *frame);
 	bool (*invalid_dan_ingress_frame)(__be16 protocol);
 	void (*update_san_info)(struct hsr_node *node, bool is_sup);
+	int (*register_frame_out)(struct hsr_port *port,
+				  struct hsr_frame_info *frame);
 };
 
 struct hsr_self_node {
-- 
2.39.5



