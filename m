Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B6F4E7807;
	Fri,  9 Oct 2026 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555720; cv=none; b=QeDJMTHQqsXoeBQcuOh3pBQdQrete6irVGOj9hWqUHYKezdMgsn6y5tBbjnlrz2hEVU92gep9YeB8KaMrp7yMPGjJpyI6hJ7SlylfbB4uuIK1ohVck3QvuMwBNRtU62Cj5plB9EArh7UTxgJgTKulGtqO7TsAthFQvlSTUOPXN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555720; c=relaxed/simple;
	bh=RyG2qQ5ZPQHdc9oCBMhgx1VS4Bj9F/fvzb2/H9LqnOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpDYAJYEasK3b+/FDHylG0Iw5b1T7JKbzEb3Ly2yr4/ecKsbDoLoH5d2hRyAjHCzYjd2aOv9PZ3BBEwmIrwtGhwa6QRjx4q83LA0YbnlHE7/QyEE9KM6cwvCVLQr0heecD+v0D52/vkSE3PCsU0idII26vALG4C9dc4aBXlZ96s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b45kpEDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b45kpEDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A311F00893;
	Fri,  9 Oct 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555719;
	bh=wbK5my2Zz722XwWioK33Hs5KoC3XdUNDB/qSjoSrXyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b45kpEDGD664AxahV/sDExXCYLgC8W3lsBYH28aF7o+Jm04T2cnnOTbP4dph27DTG
	 dikq7qSka7JzkJ5NMZ+Nbkn+X1+dehbearFm8IieHL5EhXUQBaR1DtyL46AuFgIkB7
	 5BG8NbpUjslGdk7OsI5TAz94PvhIQzpuZc9j7nB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhichen Wang <wangzhichen@manus.ai>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 7.2 054/428] virt: vmgenid: set driver_data before registering notification handlers
Date: Fri,  9 Oct 2026 16:06:31 +0200
Message-ID: <20261009140947.313715912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -83,6 +83,8 @@ static int vmgenid_add_acpi(struct devic
 	}
 	setup_vmgenid_state(state, virt_addr);
 
+	dev->driver_data = state;
+
 	status = acpi_install_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
 					     vmgenid_acpi_handler, dev);
 	if (ACPI_FAILURE(status)) {
@@ -90,7 +92,6 @@ static int vmgenid_add_acpi(struct devic
 		goto out;
 	}
 
-	dev->driver_data = state;
 out:
 	ACPI_FREE(parsed.pointer);
 	return ret;
@@ -124,12 +125,13 @@ static int vmgenid_add_of(struct platfor
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
 


