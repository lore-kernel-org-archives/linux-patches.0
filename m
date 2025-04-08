Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA9C26656B;
	Tue,  8 Apr 2025 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114760; cv=none; b=kzk/IVP9LEWK9d4ewgRrNPkxEXvqkeRjNrfbQ7cJg2PraNKre+MWjC7r8K/LnlJJ4AHBDVxSFfHKMdHB8JuPwzANa5jHb2N42dof3IW+Ll6K0chy5R4rE1K+jsowJsDxky3fYPe3iijfVJKIvYlQxN/kGt1IrxkjoMu7H1bDpLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114760; c=relaxed/simple;
	bh=bW2OneRt9YfBZ58y0qqY5PfDkmUMMSjE1/cOonYsUoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPl33xJnfowXvgRoqDIOf3BOMa99JjKq4IGmhW7gvreufrjlvRIQPFO5+yjMHMoi1h51mr5uVSss45t5N/IZZxP2QtTioJH7ucksI3AanBo+4M86GEiFB7iMEhvkI3oGnoXDrfAjcGP0ipNm+Hnn6N0yeJF+vGDpnjZx0ihfy9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iquyKcD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iquyKcD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA0DC4CEE5;
	Tue,  8 Apr 2025 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114759;
	bh=bW2OneRt9YfBZ58y0qqY5PfDkmUMMSjE1/cOonYsUoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iquyKcD7tB9tlnQleeFD++t1MH9O+KSMc259bHyRiB3UJ/OoIokfxjNQmgtenYceU
	 0BrGyB3uR8gNRrFcy/QXvX70VjdYKfKH+xASpFEp/01qZqzfnd2OO2pPZY6wrPE98G
	 q2aa0VK/JF8tzBOpxY20gr7Xg2mdwRBGIAqh+Ax4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 226/499] usb: xhci: correct debug message page size calculation
Date: Tue,  8 Apr 2025 12:47:18 +0200
Message-ID: <20250408104856.848166013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index fdf0c1008225a..9aa7e2a876ec1 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2391,10 +2391,10 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
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



