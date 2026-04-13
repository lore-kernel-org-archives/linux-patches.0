Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF282F8BC3;
	Mon, 13 Apr 2026 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097432; cv=none; b=c8y1ggIFWv7CThMzI+zXdAQmifu8z4zsLoe0PcjMhKOEd0FtftbmsITe+LyMKNaFkW8wpoLNmMfqOYKYAa8tRg3+rUvPLOyBUDKtwGcDaEHnK2+oKiflaFXiMSBv/ngwIy2zIAhWsiyu9lxDlmzZJAV2zxI3h2Kyq3S9xjeKRsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097432; c=relaxed/simple;
	bh=SeKjABHmDc8GiAAVr430ZQRv/qeUIz+CHcddLj9C8As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlGAorN3VUR3yeCncs/xcl+/CmOWJwC292gtJFa05RGPQKMlqg3rEqsn/abZvyScZPyNNwP2hxvdlRAUQtT/H9nA82KfNM2e5heItudXr3/EmcjGuPjQi+1PFZGVP/2Jcg3jdVXUbxt49S4AkJZV1hVdQQvhWl3Ylk8EQXrWRXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gLSij1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gLSij1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A620C2BCB0;
	Mon, 13 Apr 2026 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097432;
	bh=SeKjABHmDc8GiAAVr430ZQRv/qeUIz+CHcddLj9C8As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gLSij1fbYFUu8d7c3sWBN4FRQpumR6mGHBKRjZsn+cydDV2XbCETzw2tt/+vEwH/
	 0PalYBme1F73RzjDdS3I8B7tlUUSIgti2MteBzzoQ4h7FPVqw77dfRdfc/md1sgO8W
	 PO2vdASl+8dVgMzUfpqP8fjvTTjP+MwfoJMP8Fng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 135/570] usb: xhci: Fix memory leak in xhci_disable_slot()
Date: Mon, 13 Apr 2026 17:54:26 +0200
Message-ID: <20260413155835.500536660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4056,7 +4056,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 	if (state == 0xffffffff || (xhci->xhc_state & XHCI_STATE_DYING) ||
 			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(command);
+		xhci_free_command(xhci, command);
 		return -ENODEV;
 	}
 
@@ -4064,7 +4064,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 				slot_id);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(command);
+		xhci_free_command(xhci, command);
 		return ret;
 	}
 	xhci_ring_cmd_db(xhci);


