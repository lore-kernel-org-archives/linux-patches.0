Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1F82116E9;
	Wed,  7 May 2025 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644122; cv=none; b=DMeP9Yl3hMyA5pIBz0IFHftWZghhFCy5JjhNswJfq1Zo7oG4q7T9n3ELIQ0Q8vsuUzhYa0jeGFzVG8aDQCnx9XvsSU00N5GJN8w3XuEzoq85hwsKzaiQpMcRiw/ttRYRkdKvtTzV8f3QjRhhkIGj9aU33phcEP2HE6fE+bqWJTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644122; c=relaxed/simple;
	bh=cb3s9FGU98MryfVvCZpqWQ5VFePfrUAlac32XHOjfXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyYeTGDOj3/wBc8655/OK/+buUriFJArBe2qLCGAYn/zaV8r7YEihWI1tg/g6gV+DkyfsvJeTlhWl6M6ffHJ3D+qL/oOGi9OkKoaVfJ2h4TEEWwzmwe/9yQn1g/c4RW5YG+6a3sSN2+oChRZm26QBg7kjCuBg0wNFt9p2Aq5gK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frijUT3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frijUT3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77413C4CEE2;
	Wed,  7 May 2025 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644122;
	bh=cb3s9FGU98MryfVvCZpqWQ5VFePfrUAlac32XHOjfXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frijUT3GKDeq6HJS1nrMQxF8U0oXTAEW/yTuY7S/sWO8nbPJZNf6l+0DC/GXERMah
	 90g65NQAvGshVQcw0BHQbnOl7J3wfSQ7zxeaPgWydIsLzD98D2G+WAMhU3XdPJU7KS
	 Hv7rXzETBtsTkXRfKlIM6Wmt3cWmPlnTf8W3FanI=
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
Subject: [PATCH 6.14 127/183] bnxt_en: Fix ethtool -d byte order for 32-bit values
Date: Wed,  7 May 2025 20:39:32 +0200
Message-ID: <20250507183829.962309465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index d974f71074a76..54208e0495983 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2062,6 +2062,17 @@ static int bnxt_get_regs_len(struct net_device *dev)
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
@@ -2094,12 +2105,27 @@ static void bnxt_get_regs(struct net_device *dev, struct ethtool_regs *regs,
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



