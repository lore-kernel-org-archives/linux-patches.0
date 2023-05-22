Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D6171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AA1C433EF;
	Mon, 22 May 2023 19:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783267;
	bh=nLf8ibnvWqESvji5xsiqT7Npg7mxt0Z5XMPRUT3p5l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7jWgcpluBiYt+Ot2l0F0SBLhr/dWcNpWgNK25X/Epza9WJxT0fI3L0OJqald4yd/
	 b4BFiuWWsapeFmjfA6MeZepfU11ATUY4dMIasC/vsg7xlpkng/BOF+3l6Ohh6x1G+f
	 Min6OtrWvqdwJnNlIlSdFkmEoxBtKTxyVp/du/CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 193/203] thunderbolt: Clear registers properly when auto clear isnt in use
Date: Mon, 22 May 2023 20:10:17 +0100
Message-Id: <20230522190400.372386541@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit c4af8e3fecd03b0aedcd38145955605cfebe7e3a upstream.

When `QUIRK_AUTO_CLEAR_INT` isn't set, interrupt masking should be
cleared by writing to Interrupt Mask Clear (IMR) and interrupt
status should be cleared properly at shutdown/init.

This fixes an error where interrupts are left enabled during resume
from hibernation with `CONFIG_USB4=y`.

Fixes: 468c49f44759 ("thunderbolt: Disable interrupt auto clear for rings")
Cc: stable@vger.kernel.org # v6.3
Reported-by: Takashi Iwai <tiwai@suse.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217343
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c      |   29 ++++++++++++++++++++++++-----
 drivers/thunderbolt/nhi_regs.h |    2 ++
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -51,6 +51,21 @@ static int ring_interrupt_index(const st
 	return bit;
 }
 
+static void nhi_mask_interrupt(struct tb_nhi *nhi, int mask, int ring)
+{
+	if (nhi->quirks & QUIRK_AUTO_CLEAR_INT)
+		return;
+	iowrite32(mask, nhi->iobase + REG_RING_INTERRUPT_MASK_CLEAR_BASE + ring);
+}
+
+static void nhi_clear_interrupt(struct tb_nhi *nhi, int ring)
+{
+	if (nhi->quirks & QUIRK_AUTO_CLEAR_INT)
+		ioread32(nhi->iobase + REG_RING_NOTIFY_BASE + ring);
+	else
+		iowrite32(~0, nhi->iobase + REG_RING_INT_CLEAR + ring);
+}
+
 /*
  * ring_interrupt_active() - activate/deactivate interrupts for a single ring
  *
@@ -58,8 +73,8 @@ static int ring_interrupt_index(const st
  */
 static void ring_interrupt_active(struct tb_ring *ring, bool active)
 {
-	int reg = REG_RING_INTERRUPT_BASE +
-		  ring_interrupt_index(ring) / 32 * 4;
+	int index = ring_interrupt_index(ring) / 32 * 4;
+	int reg = REG_RING_INTERRUPT_BASE + index;
 	int interrupt_bit = ring_interrupt_index(ring) & 31;
 	int mask = 1 << interrupt_bit;
 	u32 old, new;
@@ -120,7 +135,11 @@ static void ring_interrupt_active(struct
 					 "interrupt for %s %d is already %s\n",
 					 RING_TYPE(ring), ring->hop,
 					 active ? "enabled" : "disabled");
-	iowrite32(new, ring->nhi->iobase + reg);
+
+	if (active)
+		iowrite32(new, ring->nhi->iobase + reg);
+	else
+		nhi_mask_interrupt(ring->nhi, mask, index);
 }
 
 /*
@@ -133,11 +152,11 @@ static void nhi_disable_interrupts(struc
 	int i = 0;
 	/* disable interrupts */
 	for (i = 0; i < RING_INTERRUPT_REG_COUNT(nhi); i++)
-		iowrite32(0, nhi->iobase + REG_RING_INTERRUPT_BASE + 4 * i);
+		nhi_mask_interrupt(nhi, ~0, 4 * i);
 
 	/* clear interrupt status bits */
 	for (i = 0; i < RING_NOTIFY_REG_COUNT(nhi); i++)
-		ioread32(nhi->iobase + REG_RING_NOTIFY_BASE + 4 * i);
+		nhi_clear_interrupt(nhi, 4 * i);
 }
 
 /* ring helper methods */
--- a/drivers/thunderbolt/nhi_regs.h
+++ b/drivers/thunderbolt/nhi_regs.h
@@ -93,6 +93,8 @@ struct ring_desc {
 #define REG_RING_INTERRUPT_BASE	0x38200
 #define RING_INTERRUPT_REG_COUNT(nhi) ((31 + 2 * nhi->hop_count) / 32)
 
+#define REG_RING_INTERRUPT_MASK_CLEAR_BASE	0x38208
+
 #define REG_INT_THROTTLING_RATE	0x38c00
 
 /* Interrupt Vector Allocation */


