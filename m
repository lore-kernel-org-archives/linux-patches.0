Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8587A211278;
	Wed,  7 May 2025 19:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645205; cv=none; b=nzjtu+oK2/GNxdv8BJYVPEm13j8fHpSLqyCJ2Tv+uTEs11ug6mdxL4mkjUmLMmU07pneeH34iR4o8RKw3XPbflYXPCv56lLF50NcgDGCZ7ewODqlH58hvZKkOhUAygkmEKF+cjjWHH7YUnP8gsBqQtHzH5z7nCqRLUf0V9fvmck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645205; c=relaxed/simple;
	bh=tldShgX1bnYGvrKPA7y8d0pU5eATgMl0bhss4JcJZdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPeslrvQzeqQLiFsVKRaz9HOGyQ11+fNPcxYkPnNA2TgDncy2bjYf1NrXAi5fsy/qRuEJVSRZYH7AqQ//p5frc9rM0QEuPK5bvg0zVW/kRWDs68mY7opu+yS9g46tITQ/MANtT519x7DAJTXCzX9HfxROVuwOIITEX1Ia15fp8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8Z9eZr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8Z9eZr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64F8C4CEE2;
	Wed,  7 May 2025 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645205;
	bh=tldShgX1bnYGvrKPA7y8d0pU5eATgMl0bhss4JcJZdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8Z9eZr21tYEX4KgqK7CZZQJSlF9jMKOtw+8ItjajO9435xdp1sdmSt1NAsCIApXr
	 wgSDMiAY3VqzKCkn5HF8dPViJeUEfqvSsHtTSX1yJvOGjhONJ7FVe2TgmjDQtqRUxP
	 EJvd8XbqBanIjNQieFEW456CVDbk3GWwWJAdpQaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 128/129] usb: xhci: Check for xhci->interrupters being allocated in xhci_mem_clearup()
Date: Wed,  7 May 2025 20:41:04 +0200
Message-ID: <20250507183818.781442532@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit dcdb52d948f3a17ccd3fce757d9bd981d7c32039 upstream.

If xhci_mem_init() fails, it calls into xhci_mem_cleanup() to mop
up the damage. If it fails early enough, before xhci->interrupters
is allocated but after xhci->max_interrupters has been set, which
happens in most (all?) cases, things get uglier, as xhci_mem_cleanup()
unconditionally derefences xhci->interrupters. With prejudice.

Gate the interrupt freeing loop with a check on xhci->interrupters
being non-NULL.

Found while debugging a DMA allocation issue that led the XHCI driver
on this exact path.

Fixes: c99b38c41234 ("xhci: add support to allocate several interrupters")
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Wesley Cheng <quic_wcheng@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240809124408.505786-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1882,7 +1882,7 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 
 	cancel_delayed_work_sync(&xhci->cmd_timer);
 
-	for (i = 0; i < xhci->max_interrupters; i++) {
+	for (i = 0; xhci->interrupters && i < xhci->max_interrupters; i++) {
 		if (xhci->interrupters[i]) {
 			xhci_remove_interrupter(xhci, xhci->interrupters[i]);
 			xhci_free_interrupter(xhci, xhci->interrupters[i]);


