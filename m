Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EDC274B46;
	Sat, 12 Sep 2026 18:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237694; cv=none; b=MXJ50mVhIxTFtqXlk0K3xzLbCQLUFBve9cQwv4EnZfqIW9uFK9YC5guVD6uh7gDVVNDZh4mlBK4bmbAX2Lyi1HwZBa6bTC7FD0FVOZGw4+dufgR4+/JgrCr+V5Ko1kuCM1w9tmnEB0Iz4a1YuoDiYvyhR6jXG3i182h01pN0FzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237694; c=relaxed/simple;
	bh=GHZ+HVQC8KRR8Mv84FTBpys33p/lQjbhJGEPf0JlGMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEzLg4X00c2dWdGDjgDNNu2UvxGRJDkZIkoOiCW7LTn6K/OL5UlR5ilWg5gHNatWwVuwN2xDFPyuEhX2Z8TeI1Kfp9pIp7HUwjEXz4kwke8i3wPsuIQ9ecKSy+pfUy22HBKSbLfvlXEysmTBOfi5N7swk2jV0NOaGVl9Bvx/8tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRhzEEcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRhzEEcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1EB1F000FF;
	Sat, 12 Sep 2026 18:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237693;
	bh=QTMyupEGO9tc5ctXsO0l5nkogcjNuXryc9a4Pa41+kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRhzEEcUPediXa3T9Yz19L07pFfdeu9rkxnCCFiuGft9QKsM//4aKAlh21IU5Rcwf
	 z9KcxbCZnPTrlJgmc/lTFnCxUuVvQ8INtyLNCL3qAEUUgXSVlE5qIJuMmBao/aU1nE
	 HynWvzlfD2GzBv6neVXC+WaXwWCKQDx+cNHKahXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	caina <caina@uniontech.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Yipeng Zou <zouyipeng@huawei.com>
Subject: [PATCH 5.15 267/935] Revert "irqchip/mbigen: Fix mbigen node address layout"
Date: Sat, 12 Sep 2026 08:54:57 +0200
Message-ID: <20260912065532.949271323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: caina <caina@uniontech.com>

commit e67091609cf85962f64391c1b0f93d4cbfcd4e22 upstream.

This reverts commit 6be6cba9c4371d27f78d900ccfe34bb880d9ee20.

Commit 6be6cba9c437 ("irqchip/mbigen: Fix mbigen node address layout")
appears to cause a regression on Hi1616.

On-board hns NIC has two ports, enahisic2i0 and enahisic2i1, both
behind mbigen-v2.  Port 0 works; port 1 cannot pass any traffic.

Their interrupt pins fall on different mbigen nodes:

  enahisic2i0: pins 1152-1198 -> all in node 9
  enahisic2i1: pins 1200-1246 -> node 9 (1200-1215) + node 10 (1216-1246)

  (nid = (hwirq - 64) / 128 + 1; pin 1215 = node 9, pin 1216 = node 10)

/proc/interrupts shows the break happens exactly at the node boundary:

  enahisic2i1-rx0  pin 1200  count 102   <- node 9
  enahisic2i1-rx5  pin 1215  count   1   <- node 9, last pin
  enahisic2i1-tx5  pin 1216  count   0   <- node 10, first pin
  enahisic2i1-rx6  pin 1218  count   0   <- node 10
  ...all node 10 pins stay at zero.

Port 0 (entirely node 9) is unaffected.  Reverting the commit restores
normal operation.

The commit assumes CLEAR occupies a full 4 KB page at [0xa000, 0xb000)
and collides with node 10, so node 10+ gets shifted by 0x1000.

But get_mbigen_clear_reg() uses flat, chip-wide addressing -- it never
multiplies by the node ID:

    *addr = (hwirq / 32) * 4 + REG_MBIGEN_CLEAR_OFFSET;  /* 0xa000 */

Over the valid hwirq range [64, 1407], CLEAR only spans 0xa008-0xa0af
(168 bytes).  Node 10's registers are:

    TYPE: 0xa000-0xa00f  (16 B)   overlaps CLEAR by 8 B (0xa008-0xa00f)
    VEC:  0xa200-0xa3ff  (512 B)  no overlap with CLEAR

Shifting the whole page moves VEC from 0xa200 to 0xb200.  The hardware
reads the event ID from the fixed silicon address 0xa200 on interrupt
firing, but software wrote it to 0xb200 -- so the hardware gets an
uninitialised value and the interrupt is lost.

The only real overlap is 8 bytes of TYPE.  It can only trigger when a
single mbigen instance has devices on both node 1 (CLEAR 0xa008) and
node 10 (TYPE 0xa008).  On Hi1616 those nodes are on separate mbigen
instances, so it never triggers.

Fixes: 6be6cba9c4371d27f78d900ccfe34bb880d9ee20 ("irqchip/mbigen: Fix mbigen node address layout")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: caina <caina@uniontech.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Yipeng Zou <zouyipeng@huawei.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260821091720.16665-1-caina@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mbigen.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -64,20 +64,6 @@ struct mbigen_device {
 	void __iomem		*base;
 };
 
-static inline unsigned int get_mbigen_node_offset(unsigned int nid)
-{
-	unsigned int offset = nid * MBIGEN_NODE_OFFSET;
-
-	/*
-	 * To avoid touched clear register in unexpected way, we need to directly
-	 * skip clear register when access to more than 10 mbigen nodes.
-	 */
-	if (nid >= (REG_MBIGEN_CLEAR_OFFSET / MBIGEN_NODE_OFFSET))
-		offset += MBIGEN_NODE_OFFSET;
-
-	return offset;
-}
-
 static inline unsigned int get_mbigen_vec_reg(irq_hw_number_t hwirq)
 {
 	unsigned int nid, pin;
@@ -86,7 +72,8 @@ static inline unsigned int get_mbigen_ve
 	nid = hwirq / IRQS_PER_MBIGEN_NODE + 1;
 	pin = hwirq % IRQS_PER_MBIGEN_NODE;
 
-	return pin * 4 + get_mbigen_node_offset(nid) + REG_MBIGEN_VEC_OFFSET;
+	return pin * 4 + nid * MBIGEN_NODE_OFFSET
+			+ REG_MBIGEN_VEC_OFFSET;
 }
 
 static inline void get_mbigen_type_reg(irq_hw_number_t hwirq,
@@ -101,7 +88,8 @@ static inline void get_mbigen_type_reg(i
 	*mask = 1 << (irq_ofst % 32);
 	ofst = irq_ofst / 32 * 4;
 
-	*addr = ofst + get_mbigen_node_offset(nid) + REG_MBIGEN_TYPE_OFFSET;
+	*addr = ofst + nid * MBIGEN_NODE_OFFSET
+		+ REG_MBIGEN_TYPE_OFFSET;
 }
 
 static inline void get_mbigen_clear_reg(irq_hw_number_t hwirq,


