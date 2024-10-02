Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A9317B421;
	Wed,  2 Oct 2024 13:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876995; cv=none; b=RuX9+QGUHnxXB7eG/xHK5/VTFxog4N3cZOLKwQVt20HwyWgVD4nJPJah1yZlOOTvQhuzeloZR4g8yxrsnnWiLlla/5CdGji6GoQq2q7yMmTS+P5PZFETllRfZ655JwCtjDjlt4aO0ugF9AApzYGxVDguWSALSnyDxTmNBcNNf7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876995; c=relaxed/simple;
	bh=idTk8TXN0HZy4jM3liLTJ4Wezmi2Z2hdbnmg0gAKCoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzT5qt+EQ4V5/cFwSR2yQlUkEAzPuTofCXMQ5JLG7QoxoWom6yH34EKgdDLL5q5newYa5ktvRv8AXiDMJY00ZTXNX36ckbAA9efZTPpWIx7rRybE6VQJUpWHR2y7DUNRlSSgQ1CfvWDQfv/dzaD+E8aSBILktvDh0s83sqWEKDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQhGDgwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQhGDgwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBEDC4CEC2;
	Wed,  2 Oct 2024 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876995;
	bh=idTk8TXN0HZy4jM3liLTJ4Wezmi2Z2hdbnmg0gAKCoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQhGDgwCqfoEw2pubPbFh4sxqI/Yz+53kVMF8SE+fScHo4FjvYWFlrLS3XT45qRso
	 hPvO3uD4BV+ix6xjY7HXwwpPhYOu6ezOEYcsZg55awvlcSUp11Xg5GWG7lNZXBJiVn
	 y0S2Bcmb4xc8xq84aqYqzNe3ISHc2ommBzsGJfkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.11 597/695] xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.
Date: Wed,  2 Oct 2024 14:59:55 +0200
Message-ID: <20241002125846.342624296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -669,8 +669,10 @@ put_runtime_pm:
 static void xhci_pci_remove(struct pci_dev *dev)
 {
 	struct xhci_hcd *xhci;
+	bool set_power_d3;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
+	set_power_d3 = xhci->quirks & XHCI_SPURIOUS_WAKEUP;
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
@@ -683,11 +685,11 @@ static void xhci_pci_remove(struct pci_d
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


