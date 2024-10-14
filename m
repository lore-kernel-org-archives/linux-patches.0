Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FE41BDC3;
	Mon, 14 Oct 2024 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918416; cv=none; b=HTVDNSJ23UE5slj6KnORl8e9/45vcEX40fFZKLoFNLwUREsLuzLK6WHo7jGG29jDW8xQcAYM02yM4+i7z1Z/bxqK5HV+kJMXwL88shA4fhEneYsuoDAw/zZOHAV4ctwMFDcEiz2WdFfB01p5P6NJn0O9hY4uydvaaNBjBUsO364=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918416; c=relaxed/simple;
	bh=BJPg4RGpSuN46moDCMk/W5QTrYJYJq0bCQxxvRdPito=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAiXYJ/hY2unw18B7CVmxewGzhQg8UwgByV11Bq/GBioN86wbPCz5hfQJd4OAaTH+x3lIJJmILM9aoFhdmITZBBA25lWyhC3YSpT7hWPP/rzHP7dUEZ2oHtGUjJ1W3mdiDVTPFqc6bxh9JRbq2Z/TE12nwh7mmdcAKGb9A9tr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uk7YaEeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uk7YaEeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6C3C4CEC7;
	Mon, 14 Oct 2024 15:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918416;
	bh=BJPg4RGpSuN46moDCMk/W5QTrYJYJq0bCQxxvRdPito=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk7YaEeViLGRqVJZSwBhOCzRr+yPEgDwsmc1fX+yd9S1m1G4FNqQ6QUt34hIZl3GB
	 XT0V7NGk4Q3gKYic0pacIh4i2qlJ9ru9VBTBgDf5EaFmW8CAlaaG7PUcGdCuA85Cf8
	 6GvI/MYWvldxOX/3iyuE46izGlQ5ZEFFmSPGJkZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 316/798] xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.
Date: Mon, 14 Oct 2024 16:14:30 +0200
Message-ID: <20241014141230.364831414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -534,8 +534,10 @@ put_runtime_pm:
 static void xhci_pci_remove(struct pci_dev *dev)
 {
 	struct xhci_hcd *xhci;
+	bool set_power_d3;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
+	set_power_d3 = xhci->quirks & XHCI_SPURIOUS_WAKEUP;
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
@@ -548,11 +550,11 @@ static void xhci_pci_remove(struct pci_d
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


