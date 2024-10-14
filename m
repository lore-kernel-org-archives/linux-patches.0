Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06EB45C1C;
	Mon, 14 Oct 2024 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918528; cv=none; b=UkF78e2ICIVYtYYLOArsqiuOn+3DQkUR9TogQrpeQOWsCKhcmRN6ZOrdyIZHSqXwYv0NOr0CdQzrqCyTTqGD0yIpkpYLAB03l4O3du6SvFPz1v9tTlnfTd8TFGrIKQ5DJHA7L1JR6XeEnF2ydtZTECnyrQRoefCdDbXRc4cP7Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918528; c=relaxed/simple;
	bh=T1KgW6QfAEjwsonpIl8zqXSVG75fkuy7EpmG18HyPgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAW527adt0/l8HszqHiMozYF35i5RDs9ed7EVpcy6yjf2imV/EjXKkfjKMDhbXrgVw18vD3sAhzwzGbBaT0GK7RjRW38eY9A2XgvauruCGGMXNv041VKWVEPMdaAn23YHRc0p+Jfmka9H83bnL3lhOTwbvIDSIvKXn0pwseyfZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3BGVWn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3BGVWn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488B3C4CEC3;
	Mon, 14 Oct 2024 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918527;
	bh=T1KgW6QfAEjwsonpIl8zqXSVG75fkuy7EpmG18HyPgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3BGVWn3Ye4mijFCQsImgMCWXW6h/OzqdKEqVXZ/B6amgHWV5HTiwri4Ot3kmT5M7
	 gEJbXrr+K6TxvI61jfi6PBtnwuwEdNQIplqvH1DGaCZt6en3WPflXKpgcuRMaI+YBa
	 AuEaRArwB5roidyKJQVwB8uh4VLYUphYUHUFmqeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/798] xhci: fix event ring segment table related masks and variables in header
Date: Mon, 14 Oct 2024 16:15:02 +0200
Message-ID: <20241014141231.619297182@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 8c1cbec9db1ab044167a7594c88bb5906c9d3ee4 ]

xHC controller can supports up to 1024 interrupters.
To fit these change the max_interrupters varable from u8 to u16.

Add a separate mask for the reserve and preserve bits [5:0] in the erst
base register and use it instead of the ERST_PRT_MASK.
ERSR_PTR_MASK [3:0] is intended for masking bits in the
event ring dequeue pointer register.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e5fa8db0be3e ("usb: xhci: fix loss of data on Cadence xHC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 4 ++--
 drivers/usb/host/xhci.h     | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 62808c98713ec..dbc9929e3259c 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2552,8 +2552,8 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 			"// Set ERST base address for ir_set 0 = 0x%llx",
 			(unsigned long long)xhci->erst.erst_dma_addr);
 	val_64 = xhci_read_64(xhci, &xhci->ir_set->erst_base);
-	val_64 &= ERST_PTR_MASK;
-	val_64 |= (xhci->erst.erst_dma_addr & (u64) ~ERST_PTR_MASK);
+	val_64 &= ERST_BASE_RSVDP;
+	val_64 |= (xhci->erst.erst_dma_addr & (u64) ~ERST_BASE_RSVDP);
 	xhci_write_64(xhci, val_64, &xhci->ir_set->erst_base);
 
 	/* Set the event ring dequeue address */
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c42058bfcd160..ac8fabd3eef44 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -513,6 +513,9 @@ struct xhci_intr_reg {
 /* Preserve bits 16:31 of erst_size */
 #define	ERST_SIZE_MASK		(0xffff << 16)
 
+/* erst_base bitmasks */
+#define ERST_BASE_RSVDP		(0x3f)
+
 /* erst_dequeue bitmasks */
 /* Dequeue ERST Segment Index (DESI) - Segment number (or alias)
  * where the current dequeue pointer lies.  This is an optional HW hint.
@@ -1781,7 +1784,7 @@ struct xhci_hcd {
 	u8		sbrn;
 	u16		hci_version;
 	u8		max_slots;
-	u8		max_interrupters;
+	u16		max_interrupters;
 	u8		max_ports;
 	u8		isoc_threshold;
 	/* imod_interval in ns (I * 250ns) */
-- 
2.43.0



