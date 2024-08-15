Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E319EECF;
	Thu, 15 Aug 2024 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728849; cv=none; b=JEXlM9+sqDD0WP3HFH1x/3q5dhvXYXkczo8iZqCVTHJICjSIlTvfVXtGabBexpsSeaIdoGZWFAVXu21VtwwK0d+lxp/hFUc/KBhLuNpBaNUVXpiwc4uzJejw1BT6hxSsVocTxXb12hCMRNXMxMbn7pbl6N3IO19CfCeJ8ndxEfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728849; c=relaxed/simple;
	bh=rszRp1NhMiUiH14DYGApzeQyS0SF2fr+V5XIYqjcHDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFAXsjwmAW+ltOZX2j7KrvwzQkH5o0xW/2VxyV+WAh6M+ZHMfdclnH326qS6qnkYG5DBVqh1TALmYCxrIOvz1X2rwXEUcWJ79EG9Gobl3pWKx7SY+zGDtjKVYUznrtuEgbnOqIXeO1azZz4q6ITEcnKq7B3sjaghCXtgnn6yiYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDNJe2oZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDNJe2oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3ABC32786;
	Thu, 15 Aug 2024 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728849;
	bh=rszRp1NhMiUiH14DYGApzeQyS0SF2fr+V5XIYqjcHDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDNJe2oZKLdnyVQ++eHYoyNcO33gpnGMn+M+txLi+5NLyS6Vm6gF0ZOzgLDC/pXwR
	 OoJtIabSob0WTfQJZ/xb+m/BN6FGHibY5YE4adpSKVq75U/1ZSzUdk+w/Lkze9G4ze
	 SWAUjjQTkd8FcZvzoi9TTzsSh/FTu5h+XoP7Ge7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/196] irqchip/mbigen: Fix mbigen node address layout
Date: Thu, 15 Aug 2024 15:24:06 +0200
Message-ID: <20240815131857.010901857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit 6be6cba9c4371d27f78d900ccfe34bb880d9ee20 ]

The mbigen interrupt chip has its per node registers located in a
contiguous region of page sized chunks. The code maps them into virtual
address space as a contiguous region and determines the address of a node
by using the node ID as index.

                    mbigen chip
       |-----------------|------------|--------------|
   mgn_node_0         mgn_node_1     ...         mgn_node_i
|--------------|   |--------------|       |----------------------|
[0x0000, 0x0x0FFF] [0x1000, 0x1FFF]    [i*0x1000, (i+1)*0x1000 - 1]

This works correctly up to 10 nodes, but then fails because the 11th's
array slot is used for the MGN_CLEAR registers.

                         mbigen chip
    |-----------|--------|--------|---------------|--------|
mgn_node_0  mgn_node_1  ...  mgn_clear_register  ...   mgn_node_i
                            |-----------------|
                             [0xA000, 0xAFFF]

Skip the MGN_CLEAR register space when calculating the offset for node IDs
greater than or equal to ten.

Fixes: a6c2f87b8820 ("irqchip/mbigen: Implement the mbigen irq chip operation functions")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20240730014400.1751530-1-zouyipeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mbigen.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-mbigen.c b/drivers/irqchip/irq-mbigen.c
index c98358be0bc8b..19cf1239c7d3b 100644
--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -75,6 +75,20 @@ struct mbigen_device {
 	void __iomem		*base;
 };
 
+static inline unsigned int get_mbigen_node_offset(unsigned int nid)
+{
+	unsigned int offset = nid * MBIGEN_NODE_OFFSET;
+
+	/*
+	 * To avoid touched clear register in unexpected way, we need to directly
+	 * skip clear register when access to more than 10 mbigen nodes.
+	 */
+	if (nid >= (REG_MBIGEN_CLEAR_OFFSET / MBIGEN_NODE_OFFSET))
+		offset += MBIGEN_NODE_OFFSET;
+
+	return offset;
+}
+
 static inline unsigned int get_mbigen_vec_reg(irq_hw_number_t hwirq)
 {
 	unsigned int nid, pin;
@@ -83,8 +97,7 @@ static inline unsigned int get_mbigen_vec_reg(irq_hw_number_t hwirq)
 	nid = hwirq / IRQS_PER_MBIGEN_NODE + 1;
 	pin = hwirq % IRQS_PER_MBIGEN_NODE;
 
-	return pin * 4 + nid * MBIGEN_NODE_OFFSET
-			+ REG_MBIGEN_VEC_OFFSET;
+	return pin * 4 + get_mbigen_node_offset(nid) + REG_MBIGEN_VEC_OFFSET;
 }
 
 static inline void get_mbigen_type_reg(irq_hw_number_t hwirq,
@@ -99,8 +112,7 @@ static inline void get_mbigen_type_reg(irq_hw_number_t hwirq,
 	*mask = 1 << (irq_ofst % 32);
 	ofst = irq_ofst / 32 * 4;
 
-	*addr = ofst + nid * MBIGEN_NODE_OFFSET
-		+ REG_MBIGEN_TYPE_OFFSET;
+	*addr = ofst + get_mbigen_node_offset(nid) + REG_MBIGEN_TYPE_OFFSET;
 }
 
 static inline void get_mbigen_clear_reg(irq_hw_number_t hwirq,
-- 
2.43.0



