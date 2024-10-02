Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641EE1D0DC8;
	Wed,  2 Oct 2024 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878794; cv=none; b=GJsaB9GIY5GQpuoi488tICgC0Jh662W3OhB8b/L4kD4VTV28UfA5OhnUNI26edvcU4q990iekjRZ70v7JmdlCAaYS6/2teWzTPwOzpp0IciGSLcGj2zfh3zCqAAje7dsYQ2dNqGkIO50T1mdZe9NKkqpE7BhiDAVPF0agyxqcbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878794; c=relaxed/simple;
	bh=oCRHmbKyv6TvfgZOrHuuY+DOl2VMNPfJXi6OVm12nBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KShgou1HYXxefuGrJTSYcu8Bl7+3ZIyx5eIJ/tBWyJ2TXyH2cMWts2g42FGX8Foouonw76EwgwtoiQibigqSGI7U+XR46kcmSo3EoqGT+OfIlyguwzZMJnjLLFxCvdetIReb9YyF2LB8Nd7SCqPF+pOSJmamIczkUTmkcEKAAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QId5KZ1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QId5KZ1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E1CC4CEC2;
	Wed,  2 Oct 2024 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878794;
	bh=oCRHmbKyv6TvfgZOrHuuY+DOl2VMNPfJXi6OVm12nBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QId5KZ1WjtlRsxloY9brn/TLX5+jCh8HH/6+JahZXCqc9aXuQBJdeQG/gRIj5LsZn
	 xpsQ0wkzShfauQi/ti1qHqyw3A8vQlHZV7FF8Cxk1EdkphqE1fGMVKi5ctZTNoXtyI
	 /ZcRfkxDoNUGZnUPhE8n7o5f0Z+rEZ3wU/V+kLQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.10 533/634] xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.
Date: Wed,  2 Oct 2024 15:00:33 +0200
Message-ID: <20241002125832.146733836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
@@ -662,8 +662,10 @@ put_runtime_pm:
 static void xhci_pci_remove(struct pci_dev *dev)
 {
 	struct xhci_hcd *xhci;
+	bool set_power_d3;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
+	set_power_d3 = xhci->quirks & XHCI_SPURIOUS_WAKEUP;
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
@@ -676,11 +678,11 @@ static void xhci_pci_remove(struct pci_d
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


