Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E7046C4DA;
	Tue, 21 Jul 2026 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657816; cv=none; b=tWsPzNra+73vjmco5DrK0jb7hMxb+KhHp4U4teGfsp5oBUAIvBMYgSACMrQm8dRt362M+mLawfJHRm2FYuYwZhLKo+CGoXnx06DWG83iZrVO+0fbIPMQLFLximb73u5A2mPp8vbHyymz0bnEwsOGn7rvBFCHzVLz2t+hERbFm7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657816; c=relaxed/simple;
	bh=D5FEWBMaG1urtXjDzlVPBz1mCs/Pjdo8jHkhkxlIvDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e733cx86cniJHWdQTipxo6zhDri9MTKZcNjTZiRtbty0fF1nZ3lfva1i3/dQ0oGBd5R8mwyH+EORiOTm3y135XAHf37XLsblznTjPrXU14MFGe6NjhrY1y+8bnluy5g94BRybxE0ft1Ph6r3UhYK9VflEz9NwAvFkXmDw9yzxA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6jBVA2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6jBVA2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74551F000E9;
	Tue, 21 Jul 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657815;
	bh=cgwk+kRj/UcybYixnXCDN6jXwbadZa4I53xnCi9ktpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6jBVA2yRAkRBOdA9jqJaZ6akNSbr0R8cWV7KUBYPad44BU9Whfxl9Vgaxq/hh6NT
	 dLGTVpNFS1sfV5yPGMW4IshjMPQZAu+pgLiKRt3ghNmvYcrm20JUnnbGsaoXB4ah0J
	 aEVh6E7ux+KbJWtoANd9oM9e2ifcf/NNM0mJA6ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0908/1611] NTB: epf: Report 0-based doorbell vector via ntb_db_event()
Date: Tue, 21 Jul 2026 17:17:04 +0200
Message-ID: <20260721152535.812606365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 3147f0964cecca15e349cbfbdd6a28eb6d50379d ]

ntb_db_event() expects the vector number to be relative to the first
doorbell vector starting at 0.

Vector 0 is reserved for link events in the EPF driver, so doorbells
start at vector 1. However, both supported peers (ntb_hw_epf with
pci-epf-ntb, and pci-epf-vntb) have historically skipped vector 1 and
started doorbells at vector 2.

Pass (irq_no - 2) to ntb_db_event() so doorbells are reported as 0..N-1.
If irq_no == 1 is ever observed, warn and ignore it, since the slot is
reserved in the legacy layout and reporting it as DB#0 would collide with
the real DB#0 slot.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Suggested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260513024923.451765-11-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/hw/epf/ntb_hw_epf.c b/drivers/ntb/hw/epf/ntb_hw_epf.c
index 051af2a45c6f98..292e2ca059ac39 100644
--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -69,6 +69,12 @@ enum epf_ntb_bar {
 	NTB_BAR_NUM,
 };
 
+enum epf_irq_slot {
+	EPF_IRQ_LINK = 0,
+	EPF_IRQ_RESERVED_DB, /* Historically skipped slot */
+	EPF_IRQ_DB_START,
+};
+
 #define NTB_EPF_MAX_MW_COUNT	(NTB_BAR_NUM - BAR_MW1)
 
 struct ntb_epf_dev {
@@ -322,10 +328,14 @@ static irqreturn_t ntb_epf_vec_isr(int irq, void *dev)
 	irq_no = irq - ndev->irq_base;
 	ndev->db_val = irq_no + 1;
 
-	if (irq_no == 0)
+	if (irq_no == EPF_IRQ_LINK) {
 		ntb_link_event(&ndev->ntb);
-	else
-		ntb_db_event(&ndev->ntb, irq_no);
+	} else if (irq_no == EPF_IRQ_RESERVED_DB) {
+		dev_warn_ratelimited(ndev->dev,
+				     "Unexpected reserved doorbell slot IRQ received\n");
+	} else {
+		ntb_db_event(&ndev->ntb, irq_no - EPF_IRQ_DB_START);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



