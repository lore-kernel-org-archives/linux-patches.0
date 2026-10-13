Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659724F4753;
	Tue, 13 Oct 2026 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894731; cv=none; b=HOP7QBu8T7XJkwnTteKHvZofe1XCerHUeJg+rsEarlgyHVJG5E3yT9DikijYwG+C8W+EzfkFNNTDbhO2qc+if/TqJzZUOoF1N32EGejASkETpHCCv0KVScViL3vpff/bQJwM0SshD8YCSaelQ1qlVdpK2HHRxz7ou2OjDom4n0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894731; c=relaxed/simple;
	bh=bEYEkh0MpqYp62o1BUzWkxiKCy8z453k23D8UhL2spY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPANLVtdFNMEpcsOZqzr3S7rNgg9XkfkCGlU2vR5gbKg9F4pdf7OdcX+FMBgDuIAZoF68GAC31v7NfC5WBBU+DUUrR2LCIzaTtGW76X9vaMmy/XPrPEyxnWTWfCsTzWPXAVl4KI3fWk0k10l0Y9yB1d8D2xBw7pmLETrF6Wb03Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6b85YXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6b85YXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78C51F000FF;
	Tue, 13 Oct 2026 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894730;
	bh=OF+X9XtyaWjmMlKzAlY63c8T/rnCKzORS8l0iVO2ytk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6b85YXcwizPaMbqIMlrvxSLu/itODF4ddqjRXF9CTUn++amu0oECZyqwFeKZ93Y6
	 c8P3je7EEd02ZWC+xhlAyoaDxlczlUMDUKkwR8wWh8+RuQcQgwuR/+Kj6sCm+eg8zp
	 9WDABznWLNE8ldXLI70s8ikiV/C1k97MGjVqA7wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhichen Wang <wangzhichen@manus.ai>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.12 036/497] virt: vmgenid: set driver_data before registering notification handlers
Date: Tue, 13 Oct 2026 13:33:23 +0200
Message-ID: <20261013112908.746720250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhichen Wang <wangzhichen@manus.ai>

commit 9f8139c6145cf17d690d6c414d43b4c0bef632fb upstream.

Both probe paths register their notification handler before assigning
driver_data, which the handler dereferences.

In the devicetree path, the notification IRQ can fire as soon as
devm_request_irq() registers the handler: the interrupt may already be
pending at probe time, for example when a VMM injects the
generation-changed notification while restoring a guest from a snapshot
that was taken before the driver had probed (Firecracker does exactly
this on snapshot restore). The IRQ is also requested with IRQF_SHARED,
so another device sharing the line can trigger the handler just as
early. The handler then calls vmgenid_notify(), which dereferences the
still-NULL driver_data and panics:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.38+ #1 PREEMPT(none)
  Hardware name: linux,dummy-virt (DT)
  pc : vmgenid_notify.isra.0+0x24/0x8c
  lr : vmgenid_of_irq_handler+0x14/0x34
  Call trace:
   vmgenid_notify.isra.0+0x24/0x8c (P)
   vmgenid_of_irq_handler+0x14/0x34
   __handle_irq_event_percpu+0x44/0x1bc
   handle_irq_event+0x4c/0xb4
   handle_fasteoi_irq+0xf8/0x1f8

The ACPI path has the same ordering problem: the handler is installed
with acpi_install_notify_handler() before driver_data is assigned.
ACPI notifications are dispatched asynchronously from a workqueue, so
the window is narrow, but a notification arriving between the two calls
hits the same NULL dereference.

Assign driver_data before registering the handlers. The state is fully
initialized at that point, so the handlers are safe to run. Should
registration fail, the probe error path leaves no dangling pointer
behind: the driver core clears driver_data in device_unbind_cleanup().

Fixes: 7b1bcd6b50a6 ("virt: vmgenid: add support for devicetree bindings")
Fixes: e07606713a90 ("virt: vmgenid: change implementation to use a platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zhichen Wang <wangzhichen@manus.ai>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/vmgenid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/virt/vmgenid.c
+++ b/drivers/virt/vmgenid.c
@@ -82,6 +82,8 @@ static int vmgenid_add_acpi(struct devic
 	}
 	setup_vmgenid_state(state, virt_addr);
 
+	dev->driver_data = state;
+
 	status = acpi_install_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
 					     vmgenid_acpi_handler, dev);
 	if (ACPI_FAILURE(status)) {
@@ -89,7 +91,6 @@ static int vmgenid_add_acpi(struct devic
 		goto out;
 	}
 
-	dev->driver_data = state;
 out:
 	ACPI_FREE(parsed.pointer);
 	return ret;
@@ -123,12 +124,13 @@ static int vmgenid_add_of(struct platfor
 	if (ret < 0)
 		return ret;
 
+	pdev->dev.driver_data = state;
+
 	ret = devm_request_irq(&pdev->dev, ret, vmgenid_of_irq_handler,
 			       IRQF_SHARED, "vmgenid", &pdev->dev);
 	if (ret < 0)
 		return ret;
 
-	pdev->dev.driver_data = state;
 	return 0;
 }
 


