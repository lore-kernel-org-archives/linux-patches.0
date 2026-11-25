Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624989;
	b=bGSYvLn0XzQvjvgm/C0w4gwNqYqX1Qt4dhLJDmV/qmU0Qgi1jhAM+jcBhXsg47aahYjO
	 2u0txhjAXzf2Qw5Kji0FUEKH5Gz43cO7VDuzHWK8lUnudEo6m1bxi0ehQ194ADxglc5zK
	 AWCg3eleOYnJq/214IElutu0Vqxr80zGjeTKeXsTx9kuHl1XqPjwSFFNSUXpYHwnEm8n3
	 GFni6kjLXCMR9xh17yPFfc95IiF7w22yCKZ/sPvjLVQJ3jbHWbze0VdlFUBwmUoEssPqO
	 pdwK7qATydIjYLDKtyPHJFvxBJuUrhyYqnJMCW27pYpLaLSIavtk6iL0SgZ8oepGojw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cnV7w0716s2STzmbZLTFEyTXqtzVghzOxzGo6uKggGk=;
	b=11o40nsh+ND/cBi5hHxkodaqAUUcJofY+CzV0uG/WMWp+ed3YbIoIMCr/rSWE9ILep/x
	 vJ8HcJTPy2K83gWs1I3ToW2K7lFVtfp/hiPROHcdghKLfQWzi0P9y2KJ3Bj4s5E0M/OE8
	 O5kAUjtW9csba3z93zvxZa9sbBmWtmN8GyhBiihBuwY62ea2OfBGOc4WRpwZJAZLMTI6R
	 V8btd4zWxxb05BDGR0kDimlsyufuquEPRUQseJisOUTvBe4fBZdMkzqXo9aZTDJjjPZhD
	 MJ1vm+Y7hVDTYDAxsLsWt71fWsCYCa352NUaIITb6/p1YCQevZOoyv4MkMJygLsE2/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2FQW222;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B100F606A31E;
	Wed, 25 Nov 2026 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2FQW222
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97461F000C4;
	Wed, 25 Nov 2026 16:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624989;
	bh=cnV7w0716s2STzmbZLTFEyTXqtzVghzOxzGo6uKggGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2FQW222/2LKMkCqSFjTxVOfq0Mv4zsGf+6S46fsPC0AD0QeInNam+bjzr86c6v4I
	 5nGK5GUBWu+/g4c7YWji1la4RX4aR7SRvKSvoQah/AQMOIPls0gqfXGBCAR+EpbkXg
	 thJFu6tGU9yd1J8DNrklVJeMD8O6kSYFWuEuJ5ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/816] fbnic: Wait for the outbound flush to complete on mailbox teardown
Date: Wed, 25 Nov 2026 15:31:13 +0100
Message-ID: <20261125143856.724612302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 2da0f5f8882bc..24e29755211e9 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
@@ -699,6 +699,10 @@ enum {
 #define FBNIC_MAC_STAT_TX_BROADCAST_H	0x11a4d		/* 0x46934 */
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
index 175ad17bd47b5..0bc6d495bfb59 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -7,6 +7,7 @@
 #include <linux/dev_printk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
+#include <linux/iopoll.h>
 #include <linux/types.h>
 
 #include "fbnic.h"
@@ -173,10 +174,25 @@ static void fbnic_mbx_unmap_and_free_msg(struct fbnic_dev *fbd, int mbx_idx,
 
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



