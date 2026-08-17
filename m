Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C6D43BDA7;
	Mon, 17 Aug 2026 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974235; cv=none; b=AtHYsepoUcEDN8Uh6ar4QfQ+jEkYABab5iKXq8UkPNJQjqHUL1SJnNnXY77Ms7xxCKoY7+e55CKNQh1+b+jEvm0FNOUjvpJL47TgQZrjxYY/WgNOP3KdlVYm8EC6+P9cMoqrwE7FdojRHAP2vRoN9wxdcBfjvitmrOcTS9kIPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974235; c=relaxed/simple;
	bh=DVY3QkJhhJCkxd9x5s0YPEcXbuvnhk1Nq3oopIVW8PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrtvAoQQebdXOSKDiMQCcm2ukVOVnrYVeFR4Tq9btDGn4z9XwUNmxV4erf4pfpSnzTy209lQNV40Y19htvY6uq08d4zv66wsSTQbXGh+zz9WGdpaxCuH/yhvIxGQ1pUaNMi/wC8yNYgGLzW1WS+fYA53mZdsbG79KUlEMhRhm+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbSTLTJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbSTLTJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580881F000E9;
	Mon, 17 Aug 2026 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974232;
	bh=OQ9vtNgJOjMAcAxwYMUseZF2SDHj+OB5pP3Kj0yGYco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbSTLTJ7icNoZUHm+Dw6A1UYFIzqc9dWrN2nBPWPkvM0Qb8x3xpcX4nC4yESgAtC9
	 bbiBaWnpikF0fhNgz14CdmW1ShDhPiz+zxR/vz+BVTGQmJR0lSlu5y754N1/eDNcFK
	 o20dudjxDc793/T1+wQA0rp5kAEA/0bMDNJz4sQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 136/271] net: usb: ipheth: fix carrier_work UAF on disconnect
Date: Mon, 17 Aug 2026 15:31:01 +0200
Message-ID: <20260817132542.448153217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit fde39b8a521780391fb4e5bda2c0aa4928947f12 upstream.

ipheth_sndbulk_callback() re-arms the carrier-check work on any
non-zero URB status:

	else
		schedule_delayed_work(&dev->carrier_work, 0);

Nothing ties that to the interface being up, so the work can be armed
again after ipheth_close() has already drained it, and stay armed
until the netdev whose private area embeds it is freed.

On unplug with a TX URB in flight, ipheth_disconnect() drains the work
through unregister_netdev() -> ipheth_close() ->
cancel_delayed_work_sync() and only then calls ipheth_kill_urbs().
usb_kill_urb() completes the in-flight TX URB with -ENOENT, so
ipheth_sndbulk_callback() runs after the drain and re-arms
carrier_work.

The same completion also re-arms the work if the interface is only
brought down while a TX URB is in flight, and
ipheth_carrier_check_work() then keeps re-queueing itself once a
second. unregister_netdev() does not call ipheth_close() for an
already-down interface, so nothing drains it on the later unplug
either.

In both cases free_netdev() frees the netdev while carrier_work is
still pending, and ipheth_carrier_check_work() dereferences freed
memory.

Tie the work to the interface state instead of chasing the completion:
disable it in ipheth_close() and enable it in ipheth_open(), so a
schedule_delayed_work() from the URB completion is a no-op whenever
the interface is not up. disable_delayed_work_sync() also waits for a
running instance, so it fully replaces the cancel_delayed_work_sync()
it takes the place of. The work starts out disabled in ipheth_probe()
so the enable/disable counts balance from the first open.

Reproduced under KASAN on linux-next (next-20260731) with dummy_hcd and
raw-gadget standing in for the device, driving the second path above (the
interface is already down, so unregister_netdev() does not call
ipheth_close()): 15 of 15 unpatched boots report a slab-use-after-free in
__run_timers(), freed by ipheth_disconnect() and re-armed from
ipheth_sndbulk_callback() via queue_delayed_work_on(). The
same trigger on a kernel differing only by this patch reports 0 of 15,
and the carrier check still functions across open/close cycles.

The reproducer needs an attached USB device that stops draining bulk OUT,
plus a link down and unplug, driven as root. It is not a privilege
boundary crossing and no exploit primitive was developed.

Found by 0sec (https://0sec.ai).

Fixes: bb1b40c7cb86 ("usbnet: ipheth: prevent TX queue timeouts when device not ready")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://patch.msgid.link/20260802120602.42595-1-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -490,6 +490,7 @@ static int ipheth_open(struct net_device
 	if (retval)
 		return retval;
 
+	enable_delayed_work(&dev->carrier_work);
 	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);
 	return retval;
 }
@@ -499,7 +500,11 @@ static int ipheth_close(struct net_devic
 	struct ipheth_device *dev = netdev_priv(net);
 
 	netif_stop_queue(net);
-	cancel_delayed_work_sync(&dev->carrier_work);
+	/* A TX URB can still complete with an error after this point and
+	 * try to re-arm the carrier work. Disable it instead of cancelling
+	 * it, so that such a schedule_delayed_work() is a no-op.
+	 */
+	disable_delayed_work_sync(&dev->carrier_work);
 	return 0;
 }
 
@@ -629,6 +634,10 @@ static int ipheth_probe(struct usb_inter
 	}
 
 	INIT_DELAYED_WORK(&dev->carrier_work, ipheth_carrier_check_work);
+	/* Armed only between ipheth_open() and ipheth_close(). Start out
+	 * disabled so the enable/disable counts balance from the first open.
+	 */
+	disable_delayed_work(&dev->carrier_work);
 
 	retval = ipheth_alloc_urbs(dev);
 	if (retval) {


