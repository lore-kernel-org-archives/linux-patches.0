Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45593E122D;
	Tue, 17 Mar 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767642; cv=none; b=aqa+Zs6n+ag07mS6i8J40VZcIsldxHSAMtJg8lgCCWb9m62I/NzPbzskmNxBUgmB+RJ7Hjvx7D+ZK2HtNK8YMmZzEse9035fo6OcnnH478/vjeSFuiMF2MI2yeFu1I3rw29PtzmUUMW447mtYGSt6zMWHdY35Gh4PE4qOOFMFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767642; c=relaxed/simple;
	bh=f7Vyz9Wq4jTUeRMCaiZwwIGxDfbtf+lB/80pxAC5A4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5udIlOvZtnIP8vNVMep2GjeEiwBqc3ugDWiI3X59nJQqnnn+XEl1WvlFHLVkQblMqL3BuKDcJ+exR3psEibgRprHg8hnvvjUUAu6fYEF8KTGEm3AxvBN0L5yp8LZTI++FENp/DQKGMal0ApXKVYriKCEz86e2p2gaPOBXpPexc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH3kqRN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH3kqRN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8358C4CEF7;
	Tue, 17 Mar 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767642;
	bh=f7Vyz9Wq4jTUeRMCaiZwwIGxDfbtf+lB/80pxAC5A4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH3kqRN/bhGzy2KmgfQeML3BQy0U/wNCieIZfKM2ENqJb9HzK48/2L06vsHS+P+N6
	 GgbJasMZLPcWl12Fbkb5tPFYNNHHjcgFVBLoNJkM1E1/o4RAj73FOqY8e16D77tu8W
	 OQfPY8hjU26XUS+THuzzucqoX4OTapL7xtHDrPQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 129/333] usb: xhci: Fix memory leak in xhci_disable_slot()
Date: Tue, 17 Mar 2026 17:32:38 +0100
Message-ID: <20260317163004.147754500@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

commit c1c8550e70401159184130a1afc6261db01fc0ce upstream.

xhci_alloc_command() allocates a command structure and, when the
second argument is true, also allocates a completion structure.
Currently, the error handling path in xhci_disable_slot() only frees
the command structure using kfree(), causing the completion structure
to leak.

Use xhci_free_command() instead of kfree(). xhci_free_command() correctly
frees both the command structure and the associated completion structure.
Since the command structure is allocated with zero-initialization,
command->in_ctx is NULL and will not be erroneously freed by
xhci_free_command().

This bug was found using an experimental static analysis tool we are
developing. The tool is based on the LLVM framework and is specifically
designed to detect memory management issues. It is currently under
active development and not yet publicly available, but we plan to
open-source it after our research is published.

The bug was originally detected on v6.13-rc1 using our static analysis
tool, and we have verified that the issue persists in the latest mainline
kernel.

We performed build testing on x86_64 with allyesconfig using GCC=11.4.0.
Since triggering these error paths in xhci_disable_slot() requires specific
hardware conditions or abnormal state, we were unable to construct a test
case to reliably trigger these specific error paths at runtime.

Fixes: 7faac1953ed1 ("xhci: avoid race between disable slot command and host runtime suspend")
CC: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260304223639.3882398-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4139,7 +4139,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 	if (state == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
 			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(command);
+		xhci_free_command(xhci, command);
 		return -ENODEV;
 	}
 
@@ -4147,7 +4147,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 				slot_id);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(command);
+		xhci_free_command(xhci, command);
 		return ret;
 	}
 	xhci_ring_cmd_db(xhci);


