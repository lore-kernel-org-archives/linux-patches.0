Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5744B403B13;
	Tue, 21 Jul 2026 22:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674069; cv=none; b=I/9+iOsbYbq90hbYsLHRu4e49WfSy4xyCmF0PfLVdKsHKB8cUkD70U3oUcABlgW07oGvXL8JiH1eOJ+3tcEx5UnAnO7l1U4byGsHAMAwmmuVrLlP1DtlZV1QroDezp+yCSQUCmRU1Z74upfMo0xVJk9DBzbSy3NIm7fev94R5Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674069; c=relaxed/simple;
	bh=8oWgTyZSXtQ5qAd5Zk73MFaZTcKLX/38JjBdAU1e0b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYfH59XV/vYoIvReh9hofNq7rEzh8OV/80KYTuwHpAbCAPoDNrGf+v30G25aO6zY2cEvJPYbFkJNBfX/vNR1QFjHQA3NqVyZtVdv9gEunymgrZVv945OM68sHh0JekL3MptUNhkbtt68BgTFj2LScPKPy/opM8aINmty91+Ld2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ibez2Xf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ibez2Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206841F000E9;
	Tue, 21 Jul 2026 22:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674064;
	bh=GASceALhid4E/ETeKYN7zT22jSml1dr+u3mlo+ufDHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ibez2XfAnKC30Uq3APOI3DViEmlJ4DAKZaSTYnBexg+2P6Y1zp0Dc/Cwb/l0Gqy8
	 ym90Agl0z4DBY+bCVzaA7+BjBOIJYcHDB8t1fmJDhP5jOxuBquPnzs6sl7phiJarsa
	 MJQ7JgwBDXhR5Ri4nXPsfdCagek7uQQBAim/BsEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/699] net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
Date: Tue, 21 Jul 2026 17:22:37 +0200
Message-ID: <20260721152404.674177337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@linaro.org>

[ Upstream commit 9d131d044f89a808f947d49f1a1865815c610158 ]

The following macros, defined in "rmnet_map.h", assume a socket
buffer is provided as an argument without any real indication this
is the case.
    RMNET_MAP_GET_MUX_ID()
    RMNET_MAP_GET_CD_BIT()
    RMNET_MAP_GET_PAD()
    RMNET_MAP_GET_CMD_START()
    RMNET_MAP_GET_LENGTH()
What they hide is pretty trivial accessing of fields in a structure,
and it's much clearer to see this if we do these accesses directly.

So rather than using these accessor macros, assign a local
variable of the map header pointer type to the socket buffer data
pointer, and derereference that pointer variable.

In "rmnet_map_data.c", use sizeof(object) rather than sizeof(type)
in one spot.  Also, there's no need to byte swap 0; it's all zeros
irrespective of endianness.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f0f1887a9e30 ("net: qualcomm: rmnet: validate MAP frame length before ingress parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 10 ++++++----
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h      | 12 ------------
 .../net/ethernet/qualcomm/rmnet/rmnet_map_command.c  | 11 ++++++++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c |  4 ++--
 4 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 3d7d3ab383f85a..df924f7a1f4c72 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -56,20 +56,22 @@ static void
 __rmnet_map_ingress_handler(struct sk_buff *skb,
 			    struct rmnet_port *port)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_endpoint *ep;
 	u16 len, pad;
 	u8 mux_id;
 
-	if (RMNET_MAP_GET_CD_BIT(skb)) {
+	if (map_header->cd_bit) {
+		/* Packet contains a MAP command (not data) */
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
 
 		goto free_skb;
 	}
 
-	mux_id = RMNET_MAP_GET_MUX_ID(skb);
-	pad = RMNET_MAP_GET_PAD(skb);
-	len = RMNET_MAP_GET_LENGTH(skb) - pad;
+	mux_id = map_header->mux_id;
+	pad = map_header->pad_len;
+	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
 		goto free_skb;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 576501db2a0bcb..2aea153f42473a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -32,18 +32,6 @@ enum rmnet_map_commands {
 	RMNET_MAP_COMMAND_ENUM_LENGTH
 };
 
-#define RMNET_MAP_GET_MUX_ID(Y) (((struct rmnet_map_header *) \
-				 (Y)->data)->mux_id)
-#define RMNET_MAP_GET_CD_BIT(Y) (((struct rmnet_map_header *) \
-				(Y)->data)->cd_bit)
-#define RMNET_MAP_GET_PAD(Y) (((struct rmnet_map_header *) \
-				(Y)->data)->pad_len)
-#define RMNET_MAP_GET_CMD_START(Y) ((struct rmnet_map_control_command *) \
-				    ((Y)->data + \
-				      sizeof(struct rmnet_map_header)))
-#define RMNET_MAP_GET_LENGTH(Y) (ntohs(((struct rmnet_map_header *) \
-					(Y)->data)->pkt_len))
-
 #define RMNET_MAP_COMMAND_REQUEST     0
 #define RMNET_MAP_COMMAND_ACK         1
 #define RMNET_MAP_COMMAND_UNSUPPORTED 2
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
index beaee496212875..add0f5ade2e617 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
@@ -12,12 +12,13 @@ static u8 rmnet_map_do_flow_control(struct sk_buff *skb,
 				    struct rmnet_port *port,
 				    int enable)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_endpoint *ep;
 	struct net_device *vnd;
 	u8 mux_id;
 	int r;
 
-	mux_id = RMNET_MAP_GET_MUX_ID(skb);
+	mux_id = map_header->mux_id;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP) {
 		kfree_skb(skb);
@@ -49,6 +50,7 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
 			       unsigned char type,
 			       struct rmnet_port *port)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_map_control_command *cmd;
 	struct net_device *dev = skb->dev;
 
@@ -58,7 +60,8 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
 
 	skb->protocol = htons(ETH_P_MAP);
 
-	cmd = RMNET_MAP_GET_CMD_START(skb);
+	/* Command data immediately follows the MAP header */
+	cmd = (struct rmnet_map_control_command *)(map_header + 1);
 	cmd->cmd_type = type & 0x03;
 
 	netif_tx_lock(dev);
@@ -71,11 +74,13 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
  */
 void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_map_control_command *cmd;
 	unsigned char command_name;
 	unsigned char rc = 0;
 
-	cmd = RMNET_MAP_GET_CMD_START(skb);
+	/* Command data immediately follows the MAP header */
+	cmd = (struct rmnet_map_control_command *)(map_header + 1);
 	command_name = cmd->command_name;
 
 	switch (command_name) {
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 0bfe69698b278f..3af68368fc3155 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -315,7 +315,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 		return NULL;
 
 	maph = (struct rmnet_map_header *)skb->data;
-	packet_len = ntohs(maph->pkt_len) + sizeof(struct rmnet_map_header);
+	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
@@ -324,7 +324,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 		return NULL;
 
 	/* Some hardware can send us empty frames. Catch them */
-	if (ntohs(maph->pkt_len) == 0)
+	if (!maph->pkt_len)
 		return NULL;
 
 	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
-- 
2.53.0



