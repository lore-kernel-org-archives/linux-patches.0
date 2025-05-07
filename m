Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427A428E571;
	Wed,  7 May 2025 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644672; cv=none; b=KqN62Bq9b+wxt6BHnkzzXqvVvUNt7hwcF7YcoQxKR5bd1Tp5TN/KpI3/my94d3WtpAJA7LRO3AiTK+81tcvun8PO9ZykGo4TXz5yd+kPDUfyPFuu7+9gHZZ75ls/WbXxD4mofMHkqdwhS1ZsUzppB4V1zsOqnCUZ6eSGTSfxjIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644672; c=relaxed/simple;
	bh=arI71x7d6kMKQstipZEsHYd9YQHQfrfgW4tbbuFXEDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJYmr4eEtOMmt+PcUT4XrhmlHGYar5ITZ4eko4yI4B16AglGPtceJ+z7lsbd+7VicrBGFIKDB5EWBr18NcBJtbXYfjdG83V8GJGRU765HSiP9Q/Y/Vl5uhUVUsVnjAggtsbPclmt5V27cXFKM8snanA2RBkzfLgKRA6cJCOJFfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZwRKdsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZwRKdsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66E0C4CEE2;
	Wed,  7 May 2025 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644672;
	bh=arI71x7d6kMKQstipZEsHYd9YQHQfrfgW4tbbuFXEDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZwRKdsOVTxHXkUGzFDcVME+8MCADMzVhV9SS765u6L1h/kg4oQhl5Mn0Yc9Tbb5P
	 USi9FvNteiIcteBWx/IhGA75fxTfGZR3OSNXUMnzaABTd8U8FTdizQbOpi6IElSdgf
	 Ux6XW9YL1M7ACDM8iRhWptEe3ID/ZdeZ6qIt14rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shruti Parab <shruti.parab@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/164] bnxt_en: Fix ethtool -d byte order for 32-bit values
Date: Wed,  7 May 2025 20:40:02 +0200
Message-ID: <20250507183825.709023423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 02e8be5a032cae0f4ca33c6053c44d83cf4acc93 ]

For version 1 register dump that includes the PCIe stats, the existing
code incorrectly assumes that all PCIe stats are 64-bit values.  Fix it
by using an array containing the starting and ending index of the 32-bit
values.  The loop in bnxt_get_regs() will use the array to do proper
endian swap for the 32-bit values.

Fixes: b5d600b027eb ("bnxt_en: Add support for 'ethtool -d'")
Reviewed-by: Shruti Parab <shruti.parab@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 38 ++++++++++++++++---
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 36da52c0b9af6..54ae90526d8ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2041,6 +2041,17 @@ static int bnxt_get_regs_len(struct net_device *dev)
 	return reg_len;
 }
 
+#define BNXT_PCIE_32B_ENTRY(start, end)			\
+	 { offsetof(struct pcie_ctx_hw_stats, start),	\
+	   offsetof(struct pcie_ctx_hw_stats, end) }
+
+static const struct {
+	u16 start;
+	u16 end;
+} bnxt_pcie_32b_entries[] = {
+	BNXT_PCIE_32B_ENTRY(pcie_ltssm_histogram[0], pcie_ltssm_histogram[3]),
+};
+
 static void bnxt_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 			  void *_p)
 {
@@ -2072,12 +2083,27 @@ static void bnxt_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 	req->pcie_stat_host_addr = cpu_to_le64(hw_pcie_stats_addr);
 	rc = hwrm_req_send(bp, req);
 	if (!rc) {
-		__le64 *src = (__le64 *)hw_pcie_stats;
-		u64 *dst = (u64 *)(_p + BNXT_PXP_REG_LEN);
-		int i;
-
-		for (i = 0; i < sizeof(*hw_pcie_stats) / sizeof(__le64); i++)
-			dst[i] = le64_to_cpu(src[i]);
+		u8 *dst = (u8 *)(_p + BNXT_PXP_REG_LEN);
+		u8 *src = (u8 *)hw_pcie_stats;
+		int i, j;
+
+		for (i = 0, j = 0; i < sizeof(*hw_pcie_stats); ) {
+			if (i >= bnxt_pcie_32b_entries[j].start &&
+			    i <= bnxt_pcie_32b_entries[j].end) {
+				u32 *dst32 = (u32 *)(dst + i);
+
+				*dst32 = le32_to_cpu(*(__le32 *)(src + i));
+				i += 4;
+				if (i > bnxt_pcie_32b_entries[j].end &&
+				    j < ARRAY_SIZE(bnxt_pcie_32b_entries) - 1)
+					j++;
+			} else {
+				u64 *dst64 = (u64 *)(dst + i);
+
+				*dst64 = le64_to_cpu(*(__le64 *)(src + i));
+				i += 8;
+			}
+		}
 	}
 	hwrm_req_drop(bp, req);
 }
-- 
2.39.5



