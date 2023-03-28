Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01C58BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F1FC433D2;
	Tue, 28 Mar 2023 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016142;
	bh=euySgtFla8nW1hKEmnuwoq4Dc8abVxKVz5lV6/AqKiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDcXkTLwHKLrJfSRK8T8FdQDuf7ORRJHAyFVXS45ma9ZbN9sOp+KitU/LMF9fphll
	 Giaw8YJA7TmlgZb2xoyrvU4KX2ARn7SgUl824rNda3vVakwbJPKOER7SsUnsktlgzt
	 lDBrDpVjPi/L/M2GplZdeLs7woKTzakUdxXeqQlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 081/146] thunderbolt: Rename shadowed variables bit to interrupt_bit and auto_clear_bit
Date: Tue, 28 Mar 2023 16:42:50 +0200
Message-Id: <20230328142606.087832792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

commit 58cdfe6f58b35f17f56386f5fcf937168a423ad1 upstream.

cppcheck reports
drivers/thunderbolt/nhi.c:74:7: style: Local variable 'bit' shadows outer variable [shadowVariable]
  int bit;
      ^
drivers/thunderbolt/nhi.c:66:6: note: Shadowed declaration
 int bit = ring_interrupt_index(ring) & 31;
     ^
drivers/thunderbolt/nhi.c:74:7: note: Shadow variable
  int bit;
      ^
For readablity rename the outer to interrupt_bit and the innner
to auto_clear_bit.

Fixes: 468c49f44759 ("thunderbolt: Disable interrupt auto clear for ring")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -60,15 +60,15 @@ static void ring_interrupt_active(struct
 {
 	int reg = REG_RING_INTERRUPT_BASE +
 		  ring_interrupt_index(ring) / 32 * 4;
-	int bit = ring_interrupt_index(ring) & 31;
-	int mask = 1 << bit;
+	int interrupt_bit = ring_interrupt_index(ring) & 31;
+	int mask = 1 << interrupt_bit;
 	u32 old, new;
 
 	if (ring->irq > 0) {
 		u32 step, shift, ivr, misc;
 		void __iomem *ivr_base;
+		int auto_clear_bit;
 		int index;
-		int bit;
 
 		if (ring->is_tx)
 			index = ring->hop;
@@ -88,11 +88,12 @@ static void ring_interrupt_active(struct
 		 */
 		misc = ioread32(ring->nhi->iobase + REG_DMA_MISC);
 		if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT)
-			bit = REG_DMA_MISC_INT_AUTO_CLEAR;
+			auto_clear_bit = REG_DMA_MISC_INT_AUTO_CLEAR;
 		else
-			bit = REG_DMA_MISC_DISABLE_AUTO_CLEAR;
-		if (!(misc & bit))
-			iowrite32(misc | bit, ring->nhi->iobase + REG_DMA_MISC);
+			auto_clear_bit = REG_DMA_MISC_DISABLE_AUTO_CLEAR;
+		if (!(misc & auto_clear_bit))
+			iowrite32(misc | auto_clear_bit,
+				  ring->nhi->iobase + REG_DMA_MISC);
 
 		ivr_base = ring->nhi->iobase + REG_INT_VEC_ALLOC_BASE;
 		step = index / REG_INT_VEC_ALLOC_REGS * REG_INT_VEC_ALLOC_BITS;
@@ -112,7 +113,7 @@ static void ring_interrupt_active(struct
 
 	dev_dbg(&ring->nhi->pdev->dev,
 		"%s interrupt at register %#x bit %d (%#x -> %#x)\n",
-		active ? "enabling" : "disabling", reg, bit, old, new);
+		active ? "enabling" : "disabling", reg, interrupt_bit, old, new);
 
 	if (new == old)
 		dev_WARN(&ring->nhi->pdev->dev,


