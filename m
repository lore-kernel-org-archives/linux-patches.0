Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6250F28DB6
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05O7+0K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2719C433C9;
	Mon, 16 Oct 2023 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467837;
	bh=Tx6xlgf7w6aGFD2VRlNoX885cyOlDYbgVoCkvI7NbmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05O7+0K2L8nitDrPQ+5h7RvpdGfHHLxvoHyQYUgkCLjcj5j2n1MRRuZhST4JssVo7
	 B14OMi7edj7HDXiptH98MUATCiaNBrePhveq4WAb6T0Yc+V25zVIsUqAlo/Ln/cbGz
	 q5dOLA78vlLdoNY1mXpjFxt23Bo2y9pg/8Vkhwtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.5 102/191] xhci: Preserve RsvdP bits in ERSTBA register correctly
Date: Mon, 16 Oct 2023 10:41:27 +0200
Message-ID: <20231016084017.770953967@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit cf97c5e0f7dda2edc15ecd96775fe6c355823784 upstream.

xhci_add_interrupter() erroneously preserves only the lowest 4 bits when
writing the ERSTBA register, not the lowest 6 bits.  Fix it.

Migrate the ERST_BASE_RSVDP macro to the modern GENMASK_ULL() syntax to
avoid a u64 cast.

This was previously fixed by commit 8c1cbec9db1a ("xhci: fix event ring
segment table related masks and variables in header"), but immediately
undone by commit b17a57f89f69 ("xhci: Refactor interrupter code for
initial multi interrupter support.").

Fixes: b17a57f89f69 ("xhci: Refactor interrupter code for initial multi interrupter support.")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v6.3+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230915143108.1532163-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |    4 ++--
 drivers/usb/host/xhci.h     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2288,8 +2288,8 @@ xhci_add_interrupter(struct xhci_hcd *xh
 	writel(erst_size, &ir->ir_set->erst_size);
 
 	erst_base = xhci_read_64(xhci, &ir->ir_set->erst_base);
-	erst_base &= ERST_PTR_MASK;
-	erst_base |= (ir->erst.erst_dma_addr & (u64) ~ERST_PTR_MASK);
+	erst_base &= ERST_BASE_RSVDP;
+	erst_base |= ir->erst.erst_dma_addr & ~ERST_BASE_RSVDP;
 	xhci_write_64(xhci, erst_base, &ir->ir_set->erst_base);
 
 	/* Set the event ring dequeue address of this interrupter */
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -514,7 +514,7 @@ struct xhci_intr_reg {
 #define	ERST_SIZE_MASK		(0xffff << 16)
 
 /* erst_base bitmasks */
-#define ERST_BASE_RSVDP		(0x3f)
+#define ERST_BASE_RSVDP		(GENMASK_ULL(5, 0))
 
 /* erst_dequeue bitmasks */
 /* Dequeue ERST Segment Index (DESI) - Segment number (or alias)


