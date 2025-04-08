Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9EB268FFA;
	Tue,  8 Apr 2025 11:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113425; cv=none; b=jkrFocaSofKAcRgacJNiWO/cCRV4QN+nApMiDY870HVVseWPBj1xZvTriIK6AFU93HC2vsg2VC9jIgBCqJuryZ3SrtfcEKRk43+wD117BDbDsHw98nCuENI3Q9SrVzkS7UQ8VMGInZ+Gfw4wQsgQRH2RyTSzM4VHGHnPZ/GkKWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113425; c=relaxed/simple;
	bh=gDnhljdyE42miuLxRnehbojh+Y5hQAdHoCvw+oLN6i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQoYLmNuCi+d/o3bxQjfg8W5HCGAZZVSE5g3NpAR23JSXW0li7W8qO0o/4T6gjSfPqXkl+ZMBWsNwc7KN17344D35Cf0o2DGV24TC6FO4U5w+creKZmbddCF9gCsfztf3nluJebRxoa6dARgNpQpaGHYXvJQ4IfMunQL+e0h7Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osTc1xzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osTc1xzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DCCC4CEE5;
	Tue,  8 Apr 2025 11:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113425;
	bh=gDnhljdyE42miuLxRnehbojh+Y5hQAdHoCvw+oLN6i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osTc1xzmxUz1uk9rY8ugrHbyHYrh3B80AyG0iy4tUG/jRalIIyMLQTNOUgEft2cQW
	 QAclDGvvKNHrXJMCmsrvI7RfffPqfP7O2KYg+wBvyt7NJY01Q5W4qe0QV0IVfWqNG8
	 UjqcXkzAtDxh21dZd/t8q25fezFvXTF8Va4kJxDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/268] usb: xhci: correct debug message page size calculation
Date: Tue,  8 Apr 2025 12:48:46 +0200
Message-ID: <20250408104831.600282621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

[ Upstream commit 55741c723318905e6d5161bf1e12749020b161e3 ]

The ffs() function returns the index of the first set bit, starting from 1.
If no bits are set, it returns zero. This behavior causes an off-by-one
page size in the debug message, as the page size calculation [1]
is zero-based, while ffs() is one-based.

Fix this by subtracting one from the result of ffs(). Note that since
variable 'val' is unsigned, subtracting one from zero will result in the
maximum unsigned integer value. Consequently, the condition 'if (val < 16)'
will still function correctly.

[1], Page size: (2^(n+12)), where 'n' is the set page size bit.

Fixes: 81720ec5320c ("usb: host: xhci: use ffs() in xhci_mem_init()")
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250306144954.3507700-9-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index b0137eac7ab38..fbc486546b853 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2318,10 +2318,10 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	page_size = readl(&xhci->op_regs->page_size);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Supported page size register = 0x%x", page_size);
-	i = ffs(page_size);
-	if (i < 16)
+	val = ffs(page_size) - 1;
+	if (val < 16)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
-			"Supported page size of %iK", (1 << (i+12)) / 1024);
+			"Supported page size of %iK", (1 << (val + 12)) / 1024);
 	else
 		xhci_warn(xhci, "WARN: no supported page size\n");
 	/* Use 4K pages, since that's common and the minimum the HC supports */
-- 
2.39.5



