Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BCE322C8A;
	Mon, 27 Oct 2025 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593560; cv=none; b=HUU/5HBj1HT30Rj0EeHgslb7DXjlEV29pvdIy1YNUxEvhZ8Wll3LmHPp3M5n8lyHqDlMUz/YWgYrtyDe0N6tamj2aNoedEWEVeHKdwdr5SuUcip3vzHxZtouqGwmkSNoN4+P4fmzNnGBdQkB1B5cJyKUNBUiQhQoNLdJ1Mi2YWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593560; c=relaxed/simple;
	bh=HdkEQ14ym5zqoePMF5GI2BeUom6khGY0pZkw/aVIams=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbKSriAesF5Snxxd1c/3f0I3AkGmCNYhKDieSWh13RZcATfrJ34uJlgrsRk4m66yu3fi92sb7vzbtTQwdF94zVzaY+0VN6WtdvQnUyHryUDu/T3UqT2oZvk6AlpWQuPv8spP4QQ1/dz7yAtFtg0XotDmG3KDB5BhSBQ+NvCkqJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQzGbYMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQzGbYMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC319C4CEF1;
	Mon, 27 Oct 2025 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593560;
	bh=HdkEQ14ym5zqoePMF5GI2BeUom6khGY0pZkw/aVIams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQzGbYMiW1F7JgGCUCdL8nZDaeuJV2mxCeQUuzs6qWU2qHf3lrwySezAXyXXnyFbh
	 a05rkzTx9sBOPRDHBrp0qLnzVfCUVwMlmE/nkx5HSPsG2fQxf2lNPIrZ1o9IXToL8G
	 UgZRPsHzTa3aIYLLhsdhKASmRraTK7qqFW2ZaclM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.17 155/184] xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event
Date: Mon, 27 Oct 2025 19:37:17 +0100
Message-ID: <20251027183519.102847353@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f3d12ec847b945d5d65846c85f062d07d5e73164 upstream.

DbC may add 1024 bogus bytes to the beginneing of the receiving endpoint
if DbC hw triggers a STALL event before any Transfer Blocks (TRBs) for
incoming data are queued, but driver handles the event after it queued
the TRBs.

This is possible as xHCI DbC hardware may trigger spurious STALL transfer
events even if endpoint is empty. The STALL event contains a pointer
to the stalled TRB, and "remaining" untransferred data length.

As there are no TRBs queued yet the STALL event will just point to first
TRB position of the empty ring, with '0' bytes remaining untransferred.

DbC driver is polling for events, and may not handle the STALL event
before /dev/ttyDBC0 is opened and incoming data TRBs are queued.

The DbC event handler will now assume the first queued TRB (length 1024)
has stalled with '0' bytes remaining untransferred, and copies the data

This race situation can be practically mitigated by making sure the event
handler handles all pending transfer events when DbC reaches configured
state, and only then create dev/ttyDbC0, and start queueing transfers.
The event handler can this way detect the STALL events on empty rings
and discard them before any transfers are queued.

This does in practice solve the issue, but still leaves a small possible
gap for the race to trigger.
We still need a way to distinguish spurious STALLs on empty rings with '0'
bytes remaing, from actual STALL events with all bytes transmitted.

Cc: stable <stable@kernel.org>
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Tested-by: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -892,7 +892,8 @@ static enum evtreturn xhci_dbc_do_handle
 			dev_info(dbc->dev, "DbC configured\n");
 			portsc = readl(&dbc->regs->portsc);
 			writel(portsc, &dbc->regs->portsc);
-			return EVT_GSER;
+			ret = EVT_GSER;
+			break;
 		}
 
 		return EVT_DONE;
@@ -954,7 +955,8 @@ static enum evtreturn xhci_dbc_do_handle
 			break;
 		case TRB_TYPE(TRB_TRANSFER):
 			dbc_handle_xfer_event(dbc, evt);
-			ret = EVT_XFER_DONE;
+			if (ret != EVT_GSER)
+				ret = EVT_XFER_DONE;
 			break;
 		default:
 			break;


