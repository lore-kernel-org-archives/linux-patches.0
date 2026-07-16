Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10DB3009E2;
	Thu, 16 Jul 2026 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210669; cv=none; b=UUUFco1crOz/JwReJTjsmiqbz/Ra5nGC7brTzWi7hAlJ90HbbsbZPnqXq/7ovGS8K3Dhb6PEZj+c3N0YlV/Aa0lluyXeJMSaVY8GrUzE6C6VbnHTp5amxDI8yMm7qa4MArkeK452ZAruryKD+g7qF+Hy/JckzfjTV0Ya8ne+W4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210669; c=relaxed/simple;
	bh=qOXYAqagQKQrk7k9vcaUkATtPe1HspnfxJ/4fU5ngmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjnc0E0Yxxl9UYQKXzmx3yI6CPXGYRNDx+paNbaT77230V4838K09DA9SC+GJc1HwKur6KXb6+1hFbZqkMkMRP43ksLeaVE/XY5PHLpYFoC2sQ5ieCUq0Wo291O48utoqZJT9frn3M19z0EdcBiIjLf4tD0wXqRt6WTt2LupPwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaE1rtgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaE1rtgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324291F000E9;
	Thu, 16 Jul 2026 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210668;
	bh=VnGAxupngLSOHi2mhbJsKPvEphHWp35HfwSX2xJuPEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaE1rtgU5sRr7lk8a/kDEDCFlUjXLEq0uCTrKmj2o+BiGin1P8HIY4tBQne7unSg2
	 03eaqya8mAtKcXkJMmT66bDaGOw3Qhe/gN2njvxYkFWwc51mlz6n9+yiR/VYRhwX8W
	 P0pSDi7B/+YXXM+hg2V8UfYr7ivKQCgYYflHfoDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 133/480] xhci: sideband: fix ring sg table pages leak
Date: Thu, 16 Jul 2026 15:28:00 +0200
Message-ID: <20260716133047.588040162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 49f6e3c3ef19f04f6657ed8dce550e36c763abb8 upstream.

xhci_ring_to_sgtable() allocates a temporary pages array and
uses it to build the returned sg_table with
sg_alloc_table_from_pages().

The error paths free the pages array, but the success path
returns the sg_table without freeing it. This leaks the temporary
array every time a sideband client gets an endpoint or event ring
buffer.

Free the pages array after sg_alloc_table_from_pages() succeeds.
The returned sg_table has its own scatterlist entries and does not
depend on the temporary array after construction.

Fixes: de66754e9f80 ("xhci: sideband: add initial api to register a secondary interrupter entity")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260703144033.483286-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-sideband.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-sideband.c
+++ b/drivers/usb/host/xhci-sideband.c
@@ -58,6 +58,8 @@ xhci_ring_to_sgtable(struct xhci_sideban
 	if (sg_alloc_table_from_pages(sgt, pages, n_pages, 0, sz, GFP_KERNEL))
 		goto err;
 
+	kvfree(pages);
+
 	/*
 	 * Save first segment dma address to sg dma_address field for the sideband
 	 * client to have access to the IOVA of the ring.


