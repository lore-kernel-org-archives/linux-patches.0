Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622118;
	b=fzgAaaeGwGR9Mq4z+ZrLIObXa4msZ3+z/bzUdaTUJbFzbSHXRsV3VDmnNahbze6suqLA
	 efllTihzs/OTcJkIsfiAKCchlaeetXBs6ce+KmJS1z5c2vhlTCxZmfl+RLTBA4Gi0Qttg
	 xnL/nBzJ3IHozxUGZ3YOsmKvQuk1V6EGnHRXFC7nbCO/go9iJano7jLQwpgVIluKNYaPr
	 F4uiHmklpxSoauWoHpR0/mU4qwtk0vEX9b+KSZjv3l3z0EvXVJFPCjc7v7EbnASwVgwPy
	 fbmPurcjwwH6Js8rF+ir2Nd0KTeOmRfEwRXIrvH0A6j+iuhwkegdPBjIvmlQV/4h0CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qm/LSxTAW9PhbuTkJUZw4G2elrYqPjrn56U00hlnazo=;
	b=JPi4lawbBTzvcJYvB3EeBlbqk8kxvaPtM6We8/49DbOeQQCSu3iReHayxn9YiJ7fQnny
	 7m3pD0PRunzj6allxwUaz9+34Rq+tdoaEkkYVeuVVRMMFSqTGCqTP5ng6le+Him1tlz8q
	 YVAi4VM+pA7SOk9lhib9sE6Wxyvpl3VOLQ9lzR3/yAJip+6c6Kh+Kc8zZlscjWbbFRmOp
	 dYlav4PuDlNryBGKFedBr6ejhaS14wdlGkEdr9WILPart24IPhJQ3A36P6TJOO13vCduW
	 rZkSw6jDuY5R966EcIaJDGUMUqgF8HlnVGJbObPukWETioHcdl2MwmQjcNIn0RrA7XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1s2z0DP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6A9606A32A;
	Wed, 25 Nov 2026 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1s2z0DP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51981F000E1;
	Wed, 25 Nov 2026 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622118;
	bh=Qm/LSxTAW9PhbuTkJUZw4G2elrYqPjrn56U00hlnazo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1s2z0DPMuKnmU24E92Nzd/EDPEdfCc4XFYr+xSFuq8rXFjUh2pFSRSUSRXO2xb4V
	 IqWP696RNFPrRjs1XYPBDbxbNoadKGpP2hK9pSJXupNtp2awej3mlj9jHfkEAz5SGt
	 7V699rApDn9ih0EkXI/db0yb47ieHVj8CG9HJYes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/990] fbnic: Wait for the outbound flush to complete on mailbox teardown
Date: Wed, 25 Nov 2026 15:29:55 +0100
Message-ID: <20261125143832.120694694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit c5820a8cf59b03d59f2f5f9b3754ad27a6014a41 ]

The fbnic_mbx_reset_desc_ring function drops bus mastering and arms the
outbound flush for its ring: the write flush for the Rx ring and the
read flush for the Tx ring. Nothing waits for that flush to finish.
The fbnic_mbx_clean_desc_ring function goes straight on to unmap and
free the ring's buffers, so a device read of a Tx buffer, or a write to
an Rx buffer, can still be outstanding after the buffer is gone. With
an IOMMU it can also target an IOVA that has been unmapped or reused.

The PUL link reset status register reports when each direction's flush
has drained. Poll the done bit for the ring's direction after arming
the flush and before freeing its buffers. The flush only has to retire
what the outbound path already holds; the 1ms cap keeps a wedged device
from spinning.

Every caller of the fbnic_mbx_clean function runs with the datapath
already down, which matters because the read flush covers all
outstanding reads, not just the mailbox ones. A device that has lost
its link reads back as all ones, so the done bit appears set and the
poll ends on the first pass.

Fixes: 3b12f00ddd08 ("fbnic: Gate AXI read/write enabling on FW mailbox")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://patch.msgid.link/179381517319.9644.1165591016149104577.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h |  4 ++++
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c  | 16 ++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
index 9ef4dd9609edf..e93f9ff6f4d14 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
@@ -960,6 +960,10 @@ enum {
 
 /* PUL User Registers */
 #define FBNIC_CSR_START_PUL_USER	0x31000	/* CSR section delimiter */
+#define FBNIC_PUL_USER_IP_LINK_RST_STATUS \
+					0x31030		/* 0xc40c0 */
+#define FBNIC_PUL_USER_IP_LINK_RST_STATUS_AW_FLUSH_DONE	CSR_BIT(7)
+#define FBNIC_PUL_USER_IP_LINK_RST_STATUS_AR_FLUSH_DONE	CSR_BIT(8)
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG	0x3103d		/* 0xc40f4 */
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH_MODE	CSR_BIT(20)
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH	CSR_BIT(19)
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 36607840de1ee..e642bedd2ffa0 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -7,6 +7,7 @@
 #include <linux/dev_printk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
+#include <linux/iopoll.h>
 #include <linux/types.h>
 
 #include "fbnic.h"
@@ -176,10 +177,25 @@ static void fbnic_mbx_unmap_and_free_msg(struct fbnic_dev *fbd, int mbx_idx,
 
 static void fbnic_mbx_clean_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
+	u32 flush_done, val;
 	int i;
 
 	fbnic_mbx_reset_desc_ring(fbd, mbx_idx);
 
+	/* Arming the flush only starts it. Wait for the outbound path to
+	 * retire the requests it still holds before the buffers they may
+	 * target are unmapped and freed. A lost link reads back as all ones,
+	 * which ends the poll on the first pass.
+	 */
+	flush_done = mbx_idx == FBNIC_IPC_MBX_RX_IDX ?
+		     FBNIC_PUL_USER_IP_LINK_RST_STATUS_AW_FLUSH_DONE :
+		     FBNIC_PUL_USER_IP_LINK_RST_STATUS_AR_FLUSH_DONE;
+	if (read_poll_timeout_atomic(fbnic_rd32, val, val & flush_done, 2,
+				     1000, false, fbd,
+				     FBNIC_PUL_USER_IP_LINK_RST_STATUS))
+		dev_warn(fbd->dev, "Outbound flush did not complete: %08x\n",
+			 val);
+
 	for (i = FBNIC_IPC_MBX_DESC_LEN; i--;)
 		fbnic_mbx_unmap_and_free_msg(fbd, mbx_idx, i);
 }
-- 
2.53.0



