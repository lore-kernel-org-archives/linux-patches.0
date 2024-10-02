Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC501D096B;
	Wed,  2 Oct 2024 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880390; cv=none; b=Rl7sYTWzS0GH2tlk4beEr0UUFL5/jiDz8oMftb1d+DxBBRtpmgaTusw/HM+HPDYWgSDfKcAqHbEL0szjWW43BGfqiE/q4gQREQZklWJkWDtLO7c+V5NZmu73s+237XOSBGfTDMZUqwE8X2ZMwTOHbLefaM9SFtnrJFa+48URmjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880390; c=relaxed/simple;
	bh=9mIvHmxda1j/4oOqn83C16RYwoy8sXze5RE/4OAJOQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjlwySPH3EpbpyDsZLh1/v6yN5SIduTN4hS9Phs65DG2a/Ds4BpgMBt4NEU49Vh0zOK3z3ir7qqC306IgMchtGZEt++ajAmQcDA8phk5Nt6HNvlnkNmwYSDNddioq0QpKVetSfOHKHx8UaavZZHQNap8GKDidwyE3x2u5/WTa1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEjpt158; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEjpt158"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF441C4CEC2;
	Wed,  2 Oct 2024 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880390;
	bh=9mIvHmxda1j/4oOqn83C16RYwoy8sXze5RE/4OAJOQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEjpt1585GFY6+qVBDvh5CYTMXn3P9A44InKwtW6MuBLYM3ZGuGKpYxSY1rwt8Z8G
	 aFcQBVd4M56kVDTB9aDUak/cXAfPrr/+oWd0NZIcZhV01C+rPZf03Q2kV1dWAQJUAZ
	 6N6pbPv2fTMmJx7AI3MbDKKDBAw4ySBU+lISP+6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 443/538] xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.
Date: Wed,  2 Oct 2024 15:01:22 +0200
Message-ID: <20241002125809.926995043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f81dfa3b57c624c56f2bff171c431bc7f5b558f2 upstream.

PCI xHC host should be stopped and xhci driver memory freed before putting
host to PCI D3 state during PCI remove callback.

Hosts with XHCI_SPURIOUS_WAKEUP quirk did this the wrong way around
and set the host to D3 before calling usb_hcd_pci_remove(dev), which will
access the host to stop it, and then free xhci.

Fixes: f1f6d9a8b540 ("xhci: don't dereference a xhci member after removing xhci")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240905143300.1959279-12-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -721,8 +721,10 @@ put_runtime_pm:
 static void xhci_pci_remove(struct pci_dev *dev)
 {
 	struct xhci_hcd *xhci;
+	bool set_power_d3;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
+	set_power_d3 = xhci->quirks & XHCI_SPURIOUS_WAKEUP;
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
@@ -735,11 +737,11 @@ static void xhci_pci_remove(struct pci_d
 		xhci->shared_hcd = NULL;
 	}
 
+	usb_hcd_pci_remove(dev);
+
 	/* Workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+	if (set_power_d3)
 		pci_set_power_state(dev, PCI_D3hot);
-
-	usb_hcd_pci_remove(dev);
 }
 
 /*


