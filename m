Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE7B19F485;
	Tue, 27 Aug 2024 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770867; cv=none; b=lAnquvQdnUoFTcTh0x+U1FW89qkdJQj69OdLRDROKD+S/NlBRrCVf970J1St5OQC0aPVXYLMT7mvMzNkK6/arjCyGXU61CTwPjAhEnc4++MRBWJYyI8r7kl8kNkCxpQVDTlAC6ZLPB2EPwAGC4AEyFWe1IeIcCskn+qauQ+6oQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770867; c=relaxed/simple;
	bh=eTixWjT5F8WWaG4guHRfCRX01y/qdH4TWHS+9d8SDg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spOlVsj2bzKLsV7xqHzqN/jrhpqGHXa55Q0sv3zDodwK9UXAGfUFoKVov3k45085ksX/kO1vFyQCYOw0vQXKQ64c24k3WbvUVJL3LIx7jQ6L7GdYiNzF3fEFq+JUkav9BDeAgiajYIQBVLzC+0D8ZQd2kCfQpED1CqOyr2oRW0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE6HcOwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE6HcOwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B8FC4AF1C;
	Tue, 27 Aug 2024 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770867;
	bh=eTixWjT5F8WWaG4guHRfCRX01y/qdH4TWHS+9d8SDg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PE6HcOwy4lnJvG+Pmt6opmcFRpuQbW3vKf6fPgpqLQfUJaCPucJR9lCxp66MbeTUp
	 iej+DNjCAsRXtq+3dyHFiiW9aLnkcIBMFUaBY+tnVTX2hl0wM8P7qHlX3lWGMZfL8L
	 JJqpyvDjVAIos5BTYoyKIt03ctQBmxAZjHRq0gEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.10 017/273] usb: xhci: Check for xhci->interrupters being allocated in xhci_mem_clearup()
Date: Tue, 27 Aug 2024 16:35:41 +0200
Message-ID: <20240827143834.042505557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/usb/host/xhci-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1877,7 +1877,7 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 
 	cancel_delayed_work_sync(&xhci->cmd_timer);
 
-	for (i = 0; i < xhci->max_interrupters; i++) {
+	for (i = 0; xhci->interrupters && i < xhci->max_interrupters; i++) {
 		if (xhci->interrupters[i]) {
 			xhci_remove_interrupter(xhci, xhci->interrupters[i]);
 			xhci_free_interrupter(xhci, xhci->interrupters[i]);


