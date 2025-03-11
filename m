Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55E425D8FF;
	Tue, 11 Mar 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705930; cv=none; b=Q8l9kC5b/5qGASyCVa6Tsy4cGxC9fEPwsm3sc8lMqQhlJ4MJhR74fTdqdwcMFYFQWVzvx6aYoQZ6eb1cVWUdwNcPM//+PfAiMCtgmKX75SU8CpsTeKvqPUMbT9HYNjV6kXjxJqWVKy2dA+3a6CQjXIbJ8ejr2w4sF++YGmY8pUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705930; c=relaxed/simple;
	bh=UIMaQKwdb+aq2aWmJxZ0eUHaRfocSrUWDCicyXMDdqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTD64FovZ+bI/ZiHlSuBCwbFbOkSs8ZsHceWTLdSE9HamQtXeqcHjtsUQ4aW/x+7PFVugIxmYiyTnLhkzPOzXA+M13bjapDAA8WHfIu0hp3ZDYnivH88CVQ+RTCp2BWzyoDRvpf/bNoLzFhIqJnEVl/1oUDBFrZuUH63wk/5AhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwUE34uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwUE34uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADAFC4CEED;
	Tue, 11 Mar 2025 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705929;
	bh=UIMaQKwdb+aq2aWmJxZ0eUHaRfocSrUWDCicyXMDdqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwUE34uPLurzLMU6wtrQ8VnhvpV0F3OgTeUwaEK/q+m1w3Ss1rOvwPz24SSX43DqF
	 qn+87CMLzBLTdl+JN39DJtZWySWxnLf7bXo26nQZgKF+se/7rt3zMedsMuSPQM+a07
	 2Wd6Eb9kZBFU87oR+jf4CajteYnJh83ZOuOBSjSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH 5.4 185/328] USB: hub: Ignore non-compliant devices with too many configs or interfaces
Date: Tue, 11 Mar 2025 15:59:15 +0100
Message-ID: <20250311145722.255012109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 2240fed37afbcdb5e8b627bc7ad986891100e05d upstream.

Robert Morris created a test program which can cause
usb_hub_to_struct_hub() to dereference a NULL or inappropriate
pointer:

Oops: general protection fault, probably for non-canonical address
0xcccccccccccccccc: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
CPU: 7 UID: 0 PID: 117 Comm: kworker/7:1 Not tainted 6.13.0-rc3-00017-gf44d154d6e3d #14
Hardware name: FreeBSD BHYVE/BHYVE, BIOS 14.0 10/17/2021
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_hub_adjust_deviceremovable+0x78/0x110
...
Call Trace:
 <TASK>
 ? die_addr+0x31/0x80
 ? exc_general_protection+0x1b4/0x3c0
 ? asm_exc_general_protection+0x26/0x30
 ? usb_hub_adjust_deviceremovable+0x78/0x110
 hub_probe+0x7c7/0xab0
 usb_probe_interface+0x14b/0x350
 really_probe+0xd0/0x2d0
 ? __pfx___device_attach_driver+0x10/0x10
 __driver_probe_device+0x6e/0x110
 driver_probe_device+0x1a/0x90
 __device_attach_driver+0x7e/0xc0
 bus_for_each_drv+0x7f/0xd0
 __device_attach+0xaa/0x1a0
 bus_probe_device+0x8b/0xa0
 device_add+0x62e/0x810
 usb_set_configuration+0x65d/0x990
 usb_generic_driver_probe+0x4b/0x70
 usb_probe_device+0x36/0xd0

The cause of this error is that the device has two interfaces, and the
hub driver binds to interface 1 instead of interface 0, which is where
usb_hub_to_struct_hub() looks.

We can prevent the problem from occurring by refusing to accept hub
devices that violate the USB spec by having more than one
configuration or interface.

Reported-and-tested-by: Robert Morris <rtm@csail.mit.edu>
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/linux-usb/95564.1737394039@localhost/
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/c27f3bf4-63d8-4fb5-ac82-09e3cd19f61c@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1793,6 +1793,17 @@ static int hub_probe(struct usb_interfac
 	hdev = interface_to_usbdev(intf);
 
 	/*
+	 * The USB 2.0 spec prohibits hubs from having more than one
+	 * configuration or interface, and we rely on this prohibition.
+	 * Refuse to accept a device that violates it.
+	 */
+	if (hdev->descriptor.bNumConfigurations > 1 ||
+			hdev->actconfig->desc.bNumInterfaces > 1) {
+		dev_err(&intf->dev, "Invalid hub with more than one config or interface\n");
+		return -EINVAL;
+	}
+
+	/*
 	 * Set default autosuspend delay as 0 to speedup bus suspend,
 	 * based on the below considerations:
 	 *


