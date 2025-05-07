Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE145214813;
	Wed,  7 May 2025 19:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645192; cv=none; b=GNr+ahg45J7bwr2jmJw8mQwUjyQw74kEy784hNdJvhhPPdyMg/P3hGoEz14arUtbwmusl+usCiWgeuxlyy8ulSlOSizYjV+hOSE0GXbUccGZ1R/Gq+McveJP4G33aBuwdELRRSk2Hgsbqg+JwI0eoN3cuJI9ZXoaYO1gZ/Pe2E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645192; c=relaxed/simple;
	bh=7xDLO8vN0Bz8t0QAwRT1OVralVBS2s9j29l49182xvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmgvWA/uLiXez0Gyb2LEd8GfIsRMJ043oQaGgoy3HL+yWR6OhYF9co0OtAX3ztxKIvFaQjhZWBfgVF8EocGijjnPxGNUBkyDuCVavvpr/tAdOOfDqxxMtRoamvU5A7FFg2VQ6JGIYmE+9cemiXjhcRAmOfMJrEV/eRsivpC4/MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=au0ojDmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="au0ojDmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB5DC4CEE2;
	Wed,  7 May 2025 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645192;
	bh=7xDLO8vN0Bz8t0QAwRT1OVralVBS2s9j29l49182xvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au0ojDmT4s/KzA4gWTE2N3m8GTulWJjhgiwsGs6mJSczLDcPre1+Y9HOuTRhGsqDL
	 YDOsitsVsPRN5TW1Fqf3scHB88JcyK+kO26pUBfZGaZVCG29Sylqpbx5QMG49x21ku
	 yoFlIijSl0OiDWtB6hfQFdT9RIPeAoy28ScZ1FK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/129] usb: xhci: check if requested segments exceeds ERST capacity
Date: Wed,  7 May 2025 20:40:52 +0200
Message-ID: <20250507183818.292403174@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit db4460b6ecf07574d580f01cd88054a62607068c ]

Check if requested segments ('segs' or 'ERST_DEFAULT_SEGS') exceeds the
maximum amount ERST supports.

When 'segs' is '0', 'ERST_DEFAULT_SEGS' is used instead. But both values
may not exceed ERST max.

Macro 'ERST_MAX_SEGS' is renamed to 'ERST_DEFAULT_SEGS'. The new name
better represents the macros, which is the number of Event Ring segments
to allocate, when the amount is not specified.

Additionally, rename and change xhci_create_secondary_interrupter()'s
argument 'int num_segs' to 'unsigned int segs'. This makes it the same
as its counter part in xhci_alloc_interrupter().

Fixes: c99b38c41234 ("xhci: add support to allocate several interrupters")
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240429140245.3955523-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 22 +++++++++++-----------
 drivers/usb/host/xhci.h     |  6 +++---
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 3ab547a6e4ce9..489f54cf9a8a2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2275,24 +2275,24 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 }
 
 static struct xhci_interrupter *
-xhci_alloc_interrupter(struct xhci_hcd *xhci, int segs, gfp_t flags)
+xhci_alloc_interrupter(struct xhci_hcd *xhci, unsigned int segs, gfp_t flags)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	struct xhci_interrupter *ir;
-	unsigned int num_segs = segs;
+	unsigned int max_segs;
 	int ret;
 
+	if (!segs)
+		segs = ERST_DEFAULT_SEGS;
+
+	max_segs = BIT(HCS_ERST_MAX(xhci->hcs_params2));
+	segs = min(segs, max_segs);
+
 	ir = kzalloc_node(sizeof(*ir), flags, dev_to_node(dev));
 	if (!ir)
 		return NULL;
 
-	/* number of ring segments should be greater than 0 */
-	if (segs <= 0)
-		num_segs = min_t(unsigned int, 1 << HCS_ERST_MAX(xhci->hcs_params2),
-			 ERST_MAX_SEGS);
-
-	ir->event_ring = xhci_ring_alloc(xhci, num_segs, 1, TYPE_EVENT, 0,
-					 flags);
+	ir->event_ring = xhci_ring_alloc(xhci, segs, 1, TYPE_EVENT, 0, flags);
 	if (!ir->event_ring) {
 		xhci_warn(xhci, "Failed to allocate interrupter event ring\n");
 		kfree(ir);
@@ -2353,7 +2353,7 @@ xhci_add_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir,
 }
 
 struct xhci_interrupter *
-xhci_create_secondary_interrupter(struct usb_hcd *hcd, int num_seg)
+xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_interrupter *ir;
@@ -2363,7 +2363,7 @@ xhci_create_secondary_interrupter(struct usb_hcd *hcd, int num_seg)
 	if (!xhci->interrupters || xhci->max_interrupters <= 1)
 		return NULL;
 
-	ir = xhci_alloc_interrupter(xhci, num_seg, GFP_KERNEL);
+	ir = xhci_alloc_interrupter(xhci, segs, GFP_KERNEL);
 	if (!ir)
 		return NULL;
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9d2cf11cef846..156e43977cdd4 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1423,8 +1423,8 @@ struct urb_priv {
 	struct	xhci_td	td[];
 };
 
-/* Reasonable limit for number of Event Ring segments (spec allows 32k) */
-#define	ERST_MAX_SEGS	2
+/* Number of Event Ring segments to allocate, when amount is not specified. (spec allows 32k) */
+#define	ERST_DEFAULT_SEGS	2
 /* Poll every 60 seconds */
 #define	POLL_TIMEOUT	60
 /* Stop endpoint command timeout (secs) for URB cancellation watchdog timer */
@@ -1867,7 +1867,7 @@ struct xhci_container_ctx *xhci_alloc_container_ctx(struct xhci_hcd *xhci,
 void xhci_free_container_ctx(struct xhci_hcd *xhci,
 		struct xhci_container_ctx *ctx);
 struct xhci_interrupter *
-xhci_create_secondary_interrupter(struct usb_hcd *hcd, int num_seg);
+xhci_create_secondary_interrupter(struct usb_hcd *hcd, unsigned int segs);
 void xhci_remove_secondary_interrupter(struct usb_hcd
 				       *hcd, struct xhci_interrupter *ir);
 
-- 
2.39.5



