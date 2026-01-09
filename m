Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5072B328B58;
	Fri,  9 Jan 2026 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960791; cv=none; b=GBcQ3yy6PsJ4e6nRyF09PS8UFus/gPHDnRjwppP5Gp1snBkrmlxuyRq9Zzlu33zr88jhTii8op1WM1SRnBua+qJHdT5LIBUNJhV+fT7ocAdaqHHLJpqdV+9+O0eeJ58aaSciyIYHj0HCT+VqOj4JpOs5gJKIlvY8dHJXRjSp7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960791; c=relaxed/simple;
	bh=IH5ZZqbBLQlf82nYvff0ix3+iLaYFSV6WYBdKfsAPYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQD4R1nrUJvMIZVmuFJuY3UTvdVl/oW6D4fJoUQxbDuF7wbkNEnrSodCQqNfvYQCntG7OnI0UlNWDpeiia0GqTj01dV+Q9CilHDwK5ZjqVGn7h55j2oRgtU9XLJlPp3pzm0EhqyNpiIqSNNZ0p4h8TKCGeie86tvuHYb299BaZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmqIjAM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmqIjAM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55FAC16AAE;
	Fri,  9 Jan 2026 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960791;
	bh=IH5ZZqbBLQlf82nYvff0ix3+iLaYFSV6WYBdKfsAPYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmqIjAM4hvSPSgE8PzqslR5LP0wtrfoE23pUtRQXmk9CRUIpvtrc1tKIMHCg05aDJ
	 CCsYk6pUz6jUHLG8q0IfFAsXymwXu3ZgZHj+2TsSsflPdWG5rD6KZJdFK/cD2EsdLp
	 KUhGm1Y8khKFxfkpq0hmsDdj9TFmEGzv+mbrINsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 525/737] net: stmmac: fix the crash issue for zero copy XDP_TX action
Date: Fri,  9 Jan 2026 12:41:04 +0100
Message-ID: <20260109112153.747461251@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit a48e232210009be50591fdea8ba7c07b0f566a13 ]

There is a crash issue when running zero copy XDP_TX action, the crash
log is shown below.

[  216.122464] Unable to handle kernel paging request at virtual address fffeffff80000000
[  216.187524] Internal error: Oops: 0000000096000144 [#1]  SMP
[  216.301694] Call trace:
[  216.304130]  dcache_clean_poc+0x20/0x38 (P)
[  216.308308]  __dma_sync_single_for_device+0x1bc/0x1e0
[  216.313351]  stmmac_xdp_xmit_xdpf+0x354/0x400
[  216.317701]  __stmmac_xdp_run_prog+0x164/0x368
[  216.322139]  stmmac_napi_poll_rxtx+0xba8/0xf00
[  216.326576]  __napi_poll+0x40/0x218
[  216.408054] Kernel panic - not syncing: Oops: Fatal exception in interrupt

For XDP_TX action, the xdp_buff is converted to xdp_frame by
xdp_convert_buff_to_frame(). The memory type of the resulting xdp_frame
depends on the memory type of the xdp_buff. For page pool based xdp_buff
it produces xdp_frame with memory type MEM_TYPE_PAGE_POOL. For zero copy
XSK pool based xdp_buff it produces xdp_frame with memory type
MEM_TYPE_PAGE_ORDER0. However, stmmac_xdp_xmit_back() does not check the
memory type and always uses the page pool type, this leads to invalid
mappings and causes the crash. Therefore, check the xdp_buff memory type
in stmmac_xdp_xmit_back() to fix this issue.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20251204071332.1907111-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 255c95988675..7a8861d77e04 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -87,6 +87,7 @@ MODULE_PARM_DESC(phyaddr, "Physical device address");
 #define STMMAC_XDP_CONSUMED	BIT(0)
 #define STMMAC_XDP_TX		BIT(1)
 #define STMMAC_XDP_REDIRECT	BIT(2)
+#define STMMAC_XSK_CONSUMED	BIT(3)
 
 static int flow_ctrl = FLOW_AUTO;
 module_param(flow_ctrl, int, 0644);
@@ -4875,6 +4876,7 @@ static int stmmac_xdp_get_tx_queue(struct stmmac_priv *priv,
 static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 				struct xdp_buff *xdp)
 {
+	bool zc = !!(xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL);
 	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 	int cpu = smp_processor_id();
 	struct netdev_queue *nq;
@@ -4891,9 +4893,18 @@ static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 	/* Avoids TX time-out as we are sharing with slow path */
 	txq_trans_cond_update(nq);
 
-	res = stmmac_xdp_xmit_xdpf(priv, queue, xdpf, false);
-	if (res == STMMAC_XDP_TX)
+	/* For zero copy XDP_TX action, dma_map is true */
+	res = stmmac_xdp_xmit_xdpf(priv, queue, xdpf, zc);
+	if (res == STMMAC_XDP_TX) {
 		stmmac_flush_tx_descriptors(priv, queue);
+	} else if (res == STMMAC_XDP_CONSUMED && zc) {
+		/* xdp has been freed by xdp_convert_buff_to_frame(),
+		 * no need to call xsk_buff_free() again, so return
+		 * STMMAC_XSK_CONSUMED.
+		 */
+		res = STMMAC_XSK_CONSUMED;
+		xdp_return_frame(xdpf);
+	}
 
 	__netif_tx_unlock(nq);
 
@@ -5239,6 +5250,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 		case STMMAC_XDP_CONSUMED:
 			xsk_buff_free(buf->xdp);
+			fallthrough;
+		case STMMAC_XSK_CONSUMED:
 			rx_dropped++;
 			break;
 		case STMMAC_XDP_TX:
-- 
2.51.0



