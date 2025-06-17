Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FAC2EF659;
	Tue, 17 Jun 2025 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174256; cv=none; b=nbT1gv01Cn7Ol9TkDr16pzTNdljWp8sloAGm8RtCK1mBx1wv95dPT+bQ0PCOhdjwgq4kA2mqMHp9qX+oiQgw+ubMka4r5T8Gq/fFwYyqUetWoufjlTIYV7OV61ENAL7l6mXpX+7BqlZvArIey0wXra2pcwB/89qTAqS1Y/TcVT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174256; c=relaxed/simple;
	bh=Ei+LsHMg6JvmwhOZnacN4lLKbz4n+uQbgJbi8C5VwMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olHm5/T/l8PCP6YnGaCjKm8vkjqPRkN3/Q6p/IKbPFpeXqUBeU8HgejdG6PCKz/pmwuF2SXL8dlDahdLSx9CjH0DnxXL6EXiV+k6o+5Svz88Fd6Rnl8SmF6U4hIIGaNXffzgjCMhX1+Yu811NEx9U/SbuY6Byl4gcKuuQP3eR1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L58J/hcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L58J/hcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD98C4CEE7;
	Tue, 17 Jun 2025 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174256;
	bh=Ei+LsHMg6JvmwhOZnacN4lLKbz4n+uQbgJbi8C5VwMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L58J/hcVAnU5VupKHdqMJaRbBYi0wpi1Z9Q29pCvGGuTDSJJX69LRFtu7xNcshfEh
	 8vQhHpnRpjSCYfknNRErl0hXNBk2mH5I9KyvUnoA0cYFKnZ/AbjXx9YF3TjsL7Mjzm
	 rkaR78OM+8oXX6LCZkj0U4vTpgf65KfsMFTbN7ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dustin Lundquist <dustin@null-ptr.net>
Subject: [PATCH 6.6 012/356] serial: jsm: fix NPE during jsm_uart_port_init
Date: Tue, 17 Jun 2025 17:22:07 +0200
Message-ID: <20250617152338.722831903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dustin Lundquist <dustin@null-ptr.net>

commit e3975aa899c0a3bbc10d035e699b142cd1373a71 upstream.

No device was set which caused serial_base_ctrl_add to crash.

 BUG: kernel NULL pointer dereference, address: 0000000000000050
 Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 16 UID: 0 PID: 368 Comm: (udev-worker) Not tainted 6.12.25-amd64 #1  Debian 6.12.25-1
 RIP: 0010:serial_base_ctrl_add+0x96/0x120
 Call Trace:
  <TASK>
  serial_core_register_port+0x1a0/0x580
  ? __setup_irq+0x39c/0x660
  ? __kmalloc_cache_noprof+0x111/0x310
  jsm_uart_port_init+0xe8/0x180 [jsm]
  jsm_probe_one+0x1f4/0x410 [jsm]
  local_pci_probe+0x42/0x90
  pci_device_probe+0x22f/0x270
  really_probe+0xdb/0x340
  ? pm_runtime_barrier+0x54/0x90
  ? __pfx___driver_attach+0x10/0x10
  __driver_probe_device+0x78/0x110
  driver_probe_device+0x1f/0xa0
  __driver_attach+0xba/0x1c0
  bus_for_each_dev+0x8c/0xe0
  bus_add_driver+0x112/0x1f0
  driver_register+0x72/0xd0
  jsm_init_module+0x36/0xff0 [jsm]
  ? __pfx_jsm_init_module+0x10/0x10 [jsm]
  do_one_initcall+0x58/0x310
  do_init_module+0x60/0x230

Tested with Digi Neo PCIe 8 port card.

Fixes: 84a9582fd203 ("serial: core: Start managing serial controllers to enable runtime PM")
Cc: stable <stable@kernel.org>
Signed-off-by: Dustin Lundquist <dustin@null-ptr.net>
Link: https://lore.kernel.org/r/3f31d4f75863614655c4673027a208be78d022ec.camel@null-ptr.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/jsm/jsm_tty.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -451,6 +451,7 @@ int jsm_uart_port_init(struct jsm_board
 		if (!brd->channels[i])
 			continue;
 
+		brd->channels[i]->uart_port.dev = &brd->pci_dev->dev;
 		brd->channels[i]->uart_port.irq = brd->irq;
 		brd->channels[i]->uart_port.uartclk = 14745600;
 		brd->channels[i]->uart_port.type = PORT_JSM;


