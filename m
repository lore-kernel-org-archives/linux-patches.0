Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B01E45C1C;
	Mon, 14 Oct 2024 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918542; cv=none; b=j5l5DD0Try8SK3E+S7d8c6a1/2fRLOvb2XsvcmioupBzwiHtcrl+4drfhfLQ1uAOLp6dQmcEzC7sTkHuuRLXEbLHXg5BbpjdLxoE4uadwWDuiEulz54fwQHQbcOeTZWCQXqUMFpwWbi0lxPgTOqUiq4SX23doQ7a1LDJDqTQA5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918542; c=relaxed/simple;
	bh=1u7WIzmQdLUl2XTFzhv5nntsnnXSSGMp0lPKNMNFPgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ayt7/UTwAMn3G0RRrECa0Ya9/TU4Yt+hfAO6plnPVs2jymbnxRXLKHHKVvsMvdofeOAUhjPi5ObCXaDYbIv5jcOtCoRpiNOa8H6GbrR2xxG73iSyZa0atfTyB9muYSiciHeLalv5lukfXP5Q4MoCXw/Dr7VvwauJAZocuvcmYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gykcER2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gykcER2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AEBC4CEC3;
	Mon, 14 Oct 2024 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918542;
	bh=1u7WIzmQdLUl2XTFzhv5nntsnnXSSGMp0lPKNMNFPgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gykcER2wPkTx88/EI534wiomd/kk7iJbr8Iquz6yJO1XoBGr7DkbRyQaq9g7d2bPo
	 TGIxlc5BBZwCHUJqZP1QvmCnspjpmogkzSHD31zn2DaDPlAS1bvPOgyKI0vwuMp09d
	 Jwr0oY1OpDEKaCjKfdR4LDaXRKXvZ8sTqju4OIak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehwan Jung <dh10.jung@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 352/798] xhci: Add a quirk for writing ERST in high-low order
Date: Mon, 14 Oct 2024 16:15:06 +0200
Message-ID: <20241014141231.774563207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehwan Jung <dh10.jung@samsung.com>

[ Upstream commit bc162403e33e1d57e40994977acaf19f1434e460 ]

This quirk is for the controller that has a limitation in supporting
separate ERSTBA_HI and ERSTBA_LO programming. It's supported when
the ERSTBA is programmed ERSTBA_HI before ERSTBA_LO. That's because
the internal initialization of event ring fetches the
"Event Ring Segment Table Entry" based on the indication of ERSTBA_LO
written.

Signed-off-by: Daehwan Jung <dh10.jung@samsung.com>
Link: https://lore.kernel.org/r/1718019553-111939-3-git-send-email-dh10.jung@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e5fa8db0be3e ("usb: xhci: fix loss of data on Cadence xHC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 5 ++++-
 drivers/usb/host/xhci.h     | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index ac5fa86b0889c..88402cf424d11 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2306,7 +2306,10 @@ xhci_alloc_interrupter(struct xhci_hcd *xhci, unsigned int intr_num, gfp_t flags
 	erst_base = xhci_read_64(xhci, &ir->ir_set->erst_base);
 	erst_base &= ERST_BASE_RSVDP;
 	erst_base |= ir->erst.erst_dma_addr & ~ERST_BASE_RSVDP;
-	xhci_write_64(xhci, erst_base, &ir->ir_set->erst_base);
+	if (xhci->quirks & XHCI_WRITE_64_HI_LO)
+		hi_lo_writeq(erst_base, &ir->ir_set->erst_base);
+	else
+		xhci_write_64(xhci, erst_base, &ir->ir_set->erst_base);
 
 	/* Set the event ring dequeue address of this interrupter */
 	xhci_set_hc_event_deq(xhci, ir);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 368098496d20c..09fe993d67762 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/usb/hcd.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 
 /* Code sharing between pci-quirks and xhci hcd */
 #include	"xhci-ext-caps.h"
@@ -1915,6 +1916,7 @@ struct xhci_hcd {
 #define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 #define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(45)
 #define XHCI_ZHAOXIN_HOST	BIT_ULL(46)
+#define XHCI_WRITE_64_HI_LO	BIT_ULL(47)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.43.0



