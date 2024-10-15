Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A21C07FF;
	Tue, 15 Oct 2024 13:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997695; cv=none; b=cdVQn078suc3STj0Lpb2WXrst6dOK+8PSlaxGB/5jjEkoveebVWWepb26Z6h9nZjO4wr/g3WgwtggR6h67HXN5JBB0uGDYo+jLQFWpNky/AYBvQVPs47RPTlgnrs2bZHr6ZMqhlCijdMWjOpDCCSrJptTaV+xA+bT5Q5BPt4N9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997695; c=relaxed/simple;
	bh=jFgKOSeRn/pXYIg4CeIRcdopGQvglQkgGrOfWpWdRjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPyINhLVMHKA+6LahKOpexWf0o8cs7dmp81di03HHhTnnXRWS9lTBtUL/LFX1/W1PYfNSnb/8PF4MelNeBAdxYZBpjSowFloq121SNUvVpSZ+x7AqiSUoQbwaoo/XE+tGv9Xy9zbuapo+arPOYgQpVabgm/bN9K9yl1F/iXd7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adqqUbwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adqqUbwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D36AC4CEC6;
	Tue, 15 Oct 2024 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997695;
	bh=jFgKOSeRn/pXYIg4CeIRcdopGQvglQkgGrOfWpWdRjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adqqUbwDVTmSQ3JA5Utf3QdQR8SLLe1XNQzt+MiO36iMMNp+0BQ06Uj/E5v/4eXh7
	 aNrqY4Lvzq6BwbGBpj2tzb7JqFfLORCFq9uiG+xPVZQB5UR5RVjN5kzILrQTyh7Fnn
	 1+0liVpTNp8UKyvQ9HgPoPtIqfG9iJEG/G4ZFcvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/518] xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.
Date: Tue, 15 Oct 2024 14:42:42 +0200
Message-ID: <20241015123926.945841652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit f81dfa3b57c624c56f2bff171c431bc7f5b558f2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 4a88e75cd9586..82700a734f8a6 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -531,8 +531,10 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 static void xhci_pci_remove(struct pci_dev *dev)
 {
 	struct xhci_hcd *xhci;
+	bool set_power_d3;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
+	set_power_d3 = xhci->quirks & XHCI_SPURIOUS_WAKEUP;
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
@@ -545,11 +547,11 @@ static void xhci_pci_remove(struct pci_dev *dev)
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
 
 #ifdef CONFIG_PM
-- 
2.43.0



