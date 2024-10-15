Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B9E1E9080;
	Tue, 15 Oct 2024 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993152; cv=none; b=if5eAf2IXrw1ep2WBg09M/m4dAHrDOvvjp5dHm7DLz3JHKmJuLxrolWyNOaeE6mgDjvsmktE68qSHh+Rjx4i6sVVhVJS2HkWazCU2koqf4cpZZ4KyZfrnMbNpDfATGUEJoI4j896HbP5ZUtLbq+XogQiqaXd6KIlm8WrQVgXOgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993152; c=relaxed/simple;
	bh=McMpkH8lS7x0fpHH39EUNlfDklfiqbpiQ5W4PIwiTcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6Ry6h3HBr40b3FBPUfUr81CVqMdE0hhFCjeCwEEJWaNv1wAu84VzOHEv7Fj8dPxwzMW8hwxf5BdEY0uPsSw4w/CV/l9jf8I9ifeWeoTvdmvbNuea+lcUoyxz8q++0LxYqIMB1PuA7nk0pUl9JXGokga8DCfDbZ35Caf3RGTsXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/OvhFBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/OvhFBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CA2C4CEC6;
	Tue, 15 Oct 2024 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993152;
	bh=McMpkH8lS7x0fpHH39EUNlfDklfiqbpiQ5W4PIwiTcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/OvhFBF2JHgRNI4sVbmHK7dYLvvXc3YBW7hyFRHNxu7kZ9V8jC/GW00rrqUc+P/T
	 62ywI0pBaYmBsDGEYKYkT80XwWWXvM3hR3rqoJJSiNM7jnTu9v6FnOOzvovina8FhN
	 b9SqIzz0kP5PKxHvmzfBIesMLeDYg0XREQKykKgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 327/691] xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.
Date: Tue, 15 Oct 2024 13:24:35 +0200
Message-ID: <20241015112453.315533922@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -535,8 +535,10 @@ put_runtime_pm:
 static void xhci_pci_remove(struct pci_dev *dev)
 {
 	struct xhci_hcd *xhci;
+	bool set_power_d3;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
+	set_power_d3 = xhci->quirks & XHCI_SPURIOUS_WAKEUP;
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
@@ -549,11 +551,11 @@ static void xhci_pci_remove(struct pci_d
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


