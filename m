Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227721B81DC;
	Mon,  2 Jun 2025 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875092; cv=none; b=WRCUs18zI2oMU97yc2eBcmZfTRLAJQNcyV4XOAiPAFMn6i6EuyVz8J//4HyFnw81e1iv3/W1eRuaQ5u/mIwf52yG+f+tzcZAAWoETRuDEZy1rTf0wjPlSYZUDoOzVJVxxNbpkhL/OsHRXyBsQc5eTCP7/KN9s167duY4e2Vjarw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875092; c=relaxed/simple;
	bh=3McPEy8KOvNmN4PWMaJofUOE41t1Ho9iY/OM4TGGATU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwQLpCC19sffaGM+BZ3HVEAf5MYj4EDBWkfsjEYKJgi7+Z17S1EKkkMkBbh0U1FE7MQQdTPotLtzEMngvTIghCGdjvIa/wRM4btdDebFXQCTQh3+YOe0yVcBkttov/HcsfGqPoFsUC22q7pAWnnX1kST/EcP6tgj0hBdaVckk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7FAcwFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7FAcwFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E26C4CEEB;
	Mon,  2 Jun 2025 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875092;
	bh=3McPEy8KOvNmN4PWMaJofUOE41t1Ho9iY/OM4TGGATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7FAcwFvQqV4yg8kSxGM9vzzsJHzbhVQzp1zONDLjXMo8nQQYeRX3DxV53abhjzP5
	 Dr5EKiTmrejBufBgeda5IvDe31GHUYrCfi9Tc9c9HGmX0OPtc+7m1pc2BOKoIZkiyO
	 up+d26tNqGc+Y6tBxvOCKTzP7DujOUYnsKZTcCbk=
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
Subject: [PATCH 5.10 025/270] bnxt_en: Fix ethtool -d byte order for 32-bit values
Date: Mon,  2 Jun 2025 15:45:10 +0200
Message-ID: <20250602134308.230069075@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 36 ++++++++++++++++---
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 2984234df67eb..4dfb65b0bf1c6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1344,6 +1344,17 @@ static int bnxt_get_regs_len(struct net_device *dev)
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
@@ -1372,12 +1383,27 @@ static void bnxt_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
-		__le64 *src = (__le64 *)hw_pcie_stats;
-		u64 *dst = (u64 *)(_p + BNXT_PXP_REG_LEN);
-		int i;
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
 
-		for (i = 0; i < sizeof(*hw_pcie_stats) / sizeof(__le64); i++)
-			dst[i] = le64_to_cpu(src[i]);
+				*dst64 = le64_to_cpu(*(__le64 *)(src + i));
+				i += 8;
+			}
+		}
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	dma_free_coherent(&bp->pdev->dev, sizeof(*hw_pcie_stats), hw_pcie_stats,
-- 
2.39.5



