Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032934;
	b=Q0m6BHjYxQezamsz6HcxJTtTn8cJBq/zMde0xEUgQxVKGRWspmnx7PM7DRruP4nvjx2S
	 wV1OUS4hUtmUFRPCMOSmej/dnC6NFsEW5VbuMNU/BGaT4dL3VBZSw0D+URfzeSiWpo1Tw
	 mHh6Ei2WhzkJjlvp4qwAJD1/YHYVXLTClTPZRpFk2AozHOq228hdZxILuwaQpp2zjcdZt
	 U9704lAW8VCjKEz6hgzj2yXJhpOwUA4a9hE6KQAUnXYcZoKSmuTiXqauBtdWKFyySBnaa
	 L4klyK3/1d71+rlQb6SStPk5ZEoYiLQzH4yQtpfRc7tuM7+YbDGKJRqF8aGF7IuBTtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=evbx/jWVZa6zCcUmWU+ZelIdlPmHFGOz98pZLyOBpQY=;
	b=dJkB7yNKxJCpi2Qa+gyvypuV+ca0Z+pu/9aiAXQVmrbRC/aZM8PRHfr5Sbh0XsxvtZXe
	 fc+MzhvKvJhismGefHNrCuWyimS8PgA/WGLwzFjszFdIXY3Fj/SV9gHLXYUyzF1ryu6kS
	 xCLr2Olkjb7Fug71IxAgI2yK0MZ6pDQP0xiKWMgq85HQDKzp7L6hTie1hUJ9daJ2Ni4r/
	 9QVPxv1gUple4wHsqTddVNPM18zYY4UyRzdHyf07MwQA2cnUu9COX7sbWMAjewq59+Lxa
	 v/GRrRmQbGDrK8g+mz/bZhC3np0Pr9+QuO929vCdtZK77yt9geP0ht5/Rwgl3GFFX1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ct9OENFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778A0606A331;
	Wed, 18 Nov 2026 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ct9OENFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FAF1F000C4;
	Wed, 18 Nov 2026 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032934;
	bh=evbx/jWVZa6zCcUmWU+ZelIdlPmHFGOz98pZLyOBpQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ct9OENFckDsxj/yQA9IdwMMMTAE7ovXDKo9rpXNvkJFFJtNcNXCkQrW84jIyUS0NT
	 e3D42DR6YgtabpQ9O48qTnKoK2ERs9OVHv2fiLH35qODXb2aWQueIcUY7HUil9GQB8
	 xa7UYbB73mvO+eYPKRCHsrvJsQToS+jLSzBDtjlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	alex todadze <todadzealexi19@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1587/1756] net: stmmac: fix rx checksum offload with extended descriptors
Date: Wed, 18 Nov 2026 16:01:54 +0100
Message-ID: <20261118150113.064536319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: alex todadze <todadzealexi19@proton.me>

[ Upstream commit 72ee27b97986f4d331fe1c26e4333f12738d982f ]

With extended descriptors, bit 0 of RDES0 is the Extended Status
Available flag. enh_desc_get_rx_status() still reads it as the payload
checksum error bit of the checksum offload table, so every IP frame that
has extended status is reported as csum_none and its checksum is
verified again in software.

When extended status is available, take the result from RDES4 instead.
A TCP, UDP or ICMP payload with no IP header error, no payload error and
no checksum bypass is a good frame. Everything else keeps the status
from RDES0. Since RDES4 now decides the checksum status, read it after
the own bit with dma_rmb(). While at it, fix the IP payload type mask,
which covered bits 6:2 instead of 2:0 and had no users.

Tested on a Siflower SF19A2890 (GMAC 3.70) with the board as the iperf3
endpoint. TCP receive goes from 326 to 378 Mbit/s with one stream and
from 259 to 329 Mbit/s with four, and CPU use while receiving 200 Mbit/s
drops from 26.6% to 21.5%. In stmmac_rx(), frames with a bad TCP, UDP or
ICMP checksum, over IPv4 and IPv6 and including fragmented UDP, are
still passed up as CHECKSUM_NONE and dropped by the stack.

Fixes: c24602ef8664 ("stmmac: support extend descriptors")
Signed-off-by: alex todadze <todadzealexi19@proton.me>
Link: https://patch.msgid.link/20261020-stmmac-rx-csum-v2-1-330c8d0951ea@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/descs.h   |  6 ++++-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    | 25 +++++++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  6 ++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 ++++++++++----
 4 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/descs.h b/drivers/net/ethernet/stmicro/stmmac/descs.h
index 49d6a866244f4..4fc5f69aeaa98 100644
--- a/drivers/net/ethernet/stmicro/stmmac/descs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/descs.h
@@ -123,7 +123,7 @@
 #define	ETDES1_BUFFER2_SIZE_SHIFT	16
 
 /* Extended Receive descriptor definitions */
-#define	ERDES4_IP_PAYLOAD_TYPE_MASK	GENMASK(6, 2)
+#define	ERDES4_IP_PAYLOAD_TYPE_MASK	GENMASK(2, 0)
 #define	ERDES4_IP_HDR_ERR		BIT(3)
 #define	ERDES4_IP_PAYLOAD_ERR		BIT(4)
 #define	ERDES4_IP_CSUM_BYPASSED		BIT(5)
@@ -154,6 +154,10 @@
 #define RDES_PTP_SIGNALING		0xa
 #define RDES_PTP_PKT_RESERVED_TYPE	0xf
 
+#define RDES_EXT_PAYLOAD_UDP		0x1
+#define RDES_EXT_PAYLOAD_TCP		0x2
+#define RDES_EXT_PAYLOAD_ICMP		0x3
+
 /* Basic descriptor structure for normal and alternate descriptors */
 struct dma_desc {
 	__le32 des0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index 937b7a0466fca..963579518405c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -114,8 +114,25 @@ static int enh_desc_coe_rdes0(int ipc_err, int type, int payload_err)
 	return ret;
 }
 
-static void enh_desc_get_ext_status(struct stmmac_extra_stats *x,
-				    struct dma_extended_desc *p)
+static int enh_desc_ext_rx_csum(u32 rdes0, u32 rdes4, int status)
+{
+	u32 type = FIELD_GET(ERDES4_IP_PAYLOAD_TYPE_MASK, rdes4);
+
+	if (status != csum_none || !(rdes0 & RDES0_FRAME_TYPE))
+		return status;
+	if (!(rdes4 & (ERDES4_IPV4_PKT_RCVD | ERDES4_IPV6_PKT_RCVD)) ||
+	    (rdes4 & (ERDES4_IP_HDR_ERR | ERDES4_IP_PAYLOAD_ERR |
+		      ERDES4_IP_CSUM_BYPASSED)))
+		return status;
+	if (type != RDES_EXT_PAYLOAD_UDP && type != RDES_EXT_PAYLOAD_TCP &&
+	    type != RDES_EXT_PAYLOAD_ICMP)
+		return status;
+
+	return good_frame;
+}
+
+static int enh_desc_get_ext_status(struct stmmac_extra_stats *x,
+				   struct dma_extended_desc *p, int status)
 {
 	unsigned int rdes0 = le32_to_cpu(p->basic.des0);
 	unsigned int rdes4 = le32_to_cpu(p->des4);
@@ -175,7 +192,11 @@ static void enh_desc_get_ext_status(struct stmmac_extra_stats *x,
 			x->l4_filter_match++;
 		if ((rdes4 & ERDES4_L3_L4_FILT_NO_MATCH_MASK) >> 26)
 			x->l3_l4_filter_no_match++;
+
+		status = enh_desc_ext_rx_csum(rdes0, rdes4, status);
 	}
+
+	return status;
 }
 
 static int enh_desc_get_rx_status(struct stmmac_extra_stats *x,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 4376d61db969f..c0fc126d3a3ee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -75,8 +75,8 @@ struct stmmac_desc_ops {
 	/* Return the reception status looking at the RDES1 */
 	int (*rx_status)(struct stmmac_extra_stats *x,
 			 struct dma_desc *p);
-	void (*rx_extended_status)(struct stmmac_extra_stats *x,
-				   struct dma_extended_desc *p);
+	int (*rx_extended_status)(struct stmmac_extra_stats *x,
+				  struct dma_extended_desc *p, int status);
 	/* Set tx timestamp enable bit */
 	void (*enable_tx_timestamp) (struct dma_desc *p);
 	/* get tx timestamp status */
@@ -139,7 +139,7 @@ struct stmmac_desc_ops {
 #define stmmac_rx_status(__priv, __args...) \
 	stmmac_do_callback(__priv, desc, rx_status, __args)
 #define stmmac_rx_extended_status(__priv, __args...) \
-	stmmac_do_void_callback(__priv, desc, rx_extended_status, __args)
+	stmmac_do_callback(__priv, desc, rx_extended_status, __args)
 #define stmmac_enable_tx_timestamp(__priv, __args...) \
 	stmmac_do_void_callback(__priv, desc, enable_tx_timestamp, __args)
 #define stmmac_get_tx_timestamp_status(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index adb530635f30b..d8988ca3d163f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5380,9 +5380,13 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 		if (!buf->xdp)
 			break;
 
-		if (priv->extend_desc)
-			stmmac_rx_extended_status(priv, &priv->xstats,
-						  rx_q->dma_erx + entry);
+		if (priv->extend_desc) {
+			/* Read the extended status after the own bit */
+			dma_rmb();
+			status = stmmac_rx_extended_status(priv, &priv->xstats,
+							   &rx_q->dma_erx[entry],
+							   status);
+		}
 		if (unlikely(status == discard_frame)) {
 			xsk_buff_free(buf->xdp);
 			buf->xdp = NULL;
@@ -5574,8 +5578,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		prefetch(np);
 
-		if (priv->extend_desc)
-			stmmac_rx_extended_status(priv, &priv->xstats, rx_q->dma_erx + entry);
+		if (priv->extend_desc) {
+			/* Read the extended status after the own bit */
+			dma_rmb();
+			status = stmmac_rx_extended_status(priv, &priv->xstats,
+							   &rx_q->dma_erx[entry],
+							   status);
+		}
 		if (unlikely(status == discard_frame)) {
 			page_pool_recycle_direct(rx_q->page_pool, buf->page);
 			buf->page = NULL;
-- 
2.53.0



