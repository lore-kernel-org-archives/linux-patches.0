Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881053BC67C;
	Mon, 23 Mar 2026 16:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282574; cv=none; b=GO8sQbyp0ATXuWQvHr4IbQlS4B+mjMYExHuVtNGf9jYfteoHRC0h5D41svfYYzof74I76HNHpTpoDCNuxmd79JvhrXAZAl5Rw09bKOVJJ1OuWuPBtBbt63jFj4cXqG5yfKUNHzNctVxyIU6pCWchMSbG+lMAT7ky9+I/YlIl+QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282574; c=relaxed/simple;
	bh=gBiDp7IrWOzblvltTh/67NqDhWeYYNAfUY6+VjiAfPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBRZi6WPP3a18IjhTztN2+3llzSJrq3f46OUKt80pzbva5bl6fsE0ikmKA6M7xKYEZ/RX6qZMzJykcwMqY7O+d1Zij9/h5P3RPH7mV8e0jPFg/YnXzqD/pabGgZ8EzcnTp88kH/63byc/9uO0hi3TSq9FzcW2AWOB3Y9Lu2Eqeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgFwaqYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgFwaqYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C748C2BCB0;
	Mon, 23 Mar 2026 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282574;
	bh=gBiDp7IrWOzblvltTh/67NqDhWeYYNAfUY6+VjiAfPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgFwaqYjiFWOkiyG7bAswKLQnkbD+aBLxW6GBcHCNxVxli2TXLYDoidwf2MFFXpi9
	 RQj2yaaWkArsWil216ftLZvBNHUuwejtpwijq5WgvNvvXl0plVhGtTsmFqSfAKReRJ
	 S3M4IYa9KmUG2g6v4fwUxGT45pH7+Q3iPC198WAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 207/481] usb: xhci: Fix memory leak in xhci_disable_slot()
Date: Mon, 23 Mar 2026 14:43:09 +0100
Message-ID: <20260323134530.213642975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4067,7 +4067,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 	if (state == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
 			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(command);
+		xhci_free_command(xhci, command);
 		return -ENODEV;
 	}
 
@@ -4075,7 +4075,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 				slot_id);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(command);
+		xhci_free_command(xhci, command);
 		return ret;
 	}
 	xhci_ring_cmd_db(xhci);


