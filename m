Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFE81D0492;
	Tue, 15 Oct 2024 11:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993256; cv=none; b=MXagRlX2WKILBxo9rAGb+Pm7k7pxO7zN0i8pfVSaZP/Mh93SOVNJ5OPHcQHEfQWS4Js3MH+vMGQt0R4Ae8Fv45BXRCyzHifl6OXE3TeNgHT9fffHrNbyKWuONNZbP8gPsm574+sShMzQdYh+rCz7Cu2kMjuZ7euNCH3a29sZsZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993256; c=relaxed/simple;
	bh=PwqUpFR1gBFsAJnTEAg6BzYvpS5dyKk12JCtLpOOWUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdiGiVYlgmHgKfl2Jp0VoJCtnigOISbBE9k+HdWIVH6IdHzLAMnMKaWZDuR3RPjp4rEtHqod6rIsuJL5XQsU3uaOVtezIkwuxy+//LNJJt8zU2KoVZszY78qJXTuCMGf2UnOYGlqreITf1L4YkvCic6XZCnuXpk/sFytxfFXkjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rV67P0pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rV67P0pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A437C4CEC6;
	Tue, 15 Oct 2024 11:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993256;
	bh=PwqUpFR1gBFsAJnTEAg6BzYvpS5dyKk12JCtLpOOWUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rV67P0pt/HbQJ2zdGZQmtXT9M9Ot10tOS0+WciXQ7ICI2Q9rRzitgZyp0QManpX1F
	 l7jSAnuLmRyfdhGvER0bHjtWXtVLxvxESvHGhZYmxf78a+X4s9vvU1Cl6+xCl0tEHz
	 c1prvrxo4ONX+QqaRubD4fNaXr/UhBcQW7/eYVuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehwan Jung <dh10.jung@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/691] xhci: Add a quirk for writing ERST in high-low order
Date: Tue, 15 Oct 2024 13:25:06 +0200
Message-ID: <20241015112454.554965074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e762b82545753..c44b66628a6dc 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2318,7 +2318,10 @@ xhci_alloc_interrupter(struct xhci_hcd *xhci, unsigned int intr_num, gfp_t flags
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
index 9d63f39398d08..c6162140d641d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/usb/hcd.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 
 /* Code sharing between pci-quirks and xhci hcd */
 #include	"xhci-ext-caps.h"
@@ -1916,6 +1917,7 @@ struct xhci_hcd {
 #define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 #define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(45)
 #define XHCI_ZHAOXIN_HOST	BIT_ULL(46)
+#define XHCI_WRITE_64_HI_LO	BIT_ULL(47)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.43.0



