Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4030CB2B;
	Wed, 17 Sep 2025 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113121; cv=none; b=o37393OyPSuD9FvR2SeyXPqVyiZ+Y3xs61ZshOSPN5AwbtpVB6FJ5Mt0oqsS+jeR4dNvNugsSVybQ8pomU+JKEE0i39F1HlsNIlV0U9Nf5UP0XK5gO8aAWICeVadVwF/qp4/tQwZLZNnwz7lMMyxGKP3fVvGBYDnOPYwEwh/1Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113121; c=relaxed/simple;
	bh=fz+0LhTTrrIupYF34IGJAfNMi5isLY41Fok6mr08lx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A//CmPGK58GzU6mBrkARwbGB8U28rOP0Bp9wNbA6gVkTbpKk4ZhHO5Vr3qTrs2nPdzJzGKSjBQ+f1mjjCO5GSGxapZa9yhGwAqbQoirt0HuiKHfGigl4umavLH9GABjeNw2VjQu7sJvJ6vLy9Xd/uWhUz9S9SrMYnvkZ4IOtbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuuUUUwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuuUUUwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48213C4CEF0;
	Wed, 17 Sep 2025 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113120;
	bh=fz+0LhTTrrIupYF34IGJAfNMi5isLY41Fok6mr08lx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuuUUUwyU0fMXYTedPzQi7lcWX64+xzJmchzzqA0/jHLb91yiRBK/gNFHXnWEBwUL
	 18g5M1qW/pb0oKYIX/RQ5gr/FDvWn/X5FwLbHjUCYBJwbHq00bFdfC6bMXt8PMtt0c
	 ogK7ColO9+S/SJtR0zoaFvfcqYa3U8+IGaxPTs4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.16 178/189] xhci: dbc: Fix full DbC transfer ring after several reconnects
Date: Wed, 17 Sep 2025 14:34:48 +0200
Message-ID: <20250917123356.233094513@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a5c98e8b1398534ae1feb6e95e2d3ee5215538ed upstream.

Pending requests will be flushed on disconnect, and the corresponding
TRBs will be turned into No-op TRBs, which are ignored by the xHC
controller once it starts processing the ring.

If the USB debug cable repeatedly disconnects before ring is started
then the ring will eventually be filled with No-op TRBs.
No new transfers can be queued when the ring is full, and driver will
print the following error message:

    "xhci_hcd 0000:00:14.0: failed to queue trbs"

This is a normal case for 'in' transfers where TRBs are always enqueued
in advance, ready to take on incoming data. If no data arrives, and
device is disconnected, then ring dequeue will remain at beginning of
the ring while enqueue points to first free TRB after last cancelled
No-op TRB.
s
Solve this by reinitializing the rings when the debug cable disconnects
and DbC is leaving the configured state.
Clear the whole ring buffer and set enqueue and dequeue to the beginning
of ring, and set cycle bit to its initial state.

Cc: stable@vger.kernel.org
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250902105306.877476-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -462,6 +462,25 @@ static void xhci_dbc_ring_init(struct xh
 	xhci_initialize_ring_info(ring);
 }
 
+static int xhci_dbc_reinit_ep_rings(struct xhci_dbc *dbc)
+{
+	struct xhci_ring *in_ring = dbc->eps[BULK_IN].ring;
+	struct xhci_ring *out_ring = dbc->eps[BULK_OUT].ring;
+
+	if (!in_ring || !out_ring || !dbc->ctx) {
+		dev_warn(dbc->dev, "Can't re-init unallocated endpoints\n");
+		return -ENODEV;
+	}
+
+	xhci_dbc_ring_init(in_ring);
+	xhci_dbc_ring_init(out_ring);
+
+	/* set ep context enqueue, dequeue, and cycle to initial values */
+	xhci_dbc_init_ep_contexts(dbc);
+
+	return 0;
+}
+
 static struct xhci_ring *
 xhci_dbc_ring_alloc(struct device *dev, enum xhci_ring_type type, gfp_t flags)
 {
@@ -885,7 +904,7 @@ static enum evtreturn xhci_dbc_do_handle
 			dev_info(dbc->dev, "DbC cable unplugged\n");
 			dbc->state = DS_ENABLED;
 			xhci_dbc_flush_requests(dbc);
-
+			xhci_dbc_reinit_ep_rings(dbc);
 			return EVT_DISC;
 		}
 
@@ -895,7 +914,7 @@ static enum evtreturn xhci_dbc_do_handle
 			writel(portsc, &dbc->regs->portsc);
 			dbc->state = DS_ENABLED;
 			xhci_dbc_flush_requests(dbc);
-
+			xhci_dbc_reinit_ep_rings(dbc);
 			return EVT_DISC;
 		}
 


