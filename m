Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CB91F8EEF;
	Sat,  7 Jun 2025 10:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290908; cv=none; b=H/Djtyi1z99eRAEaCSiKds2ishmdCKCGDDepCpyRlU2WgfThLDk9GrLiMDswXzu8GKkB0aUJidVR0XTLCIh4ImUPGBT5ffz+ItaSkuPsg6o2SVQjv+WfeRy2hmQojS5KYu59gAZKMXHKLcTNkOLgj3bTC1D0M5byK6CdwA7qPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290908; c=relaxed/simple;
	bh=JRKrvY1DsEwtVCwcmFR7iSEcY6YRWu1JtRzDv/sp/ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osNA3FUVZ6Ln8A0GkB/gER3U+ce/5rrNpNt/YTB/lwgYY+J0np9m9CsZAPtx7R9Z+RgoDbi7B8z76O3wQjxpJ+lpyZqrQPUXEqbdvc80jwF+MaLByWCtpq400WpRSijk4MFmyrp2/IBu3LIZ0muWmOuz/AnUwD5MY5T1LRlzquU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlB4d6lE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlB4d6lE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D02C4CEE4;
	Sat,  7 Jun 2025 10:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290908;
	bh=JRKrvY1DsEwtVCwcmFR7iSEcY6YRWu1JtRzDv/sp/ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlB4d6lEubvS2nvcgSqAKGt0BCossL3qI2+l6ImvYML+7kC4dyrCmazdCiO6Lt8PM
	 bZcMGE5TV8fdROLU4g6uC5zunaEUtf0KtNXsPkMoHX5n1jM3Pl9YSGLy45vqIFcrAc
	 Lp8VYCmXjQcGKE4eu5APB7URnkPElfimuB2pCSS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dustin Lundquist <dustin@null-ptr.net>
Subject: [PATCH 6.12 19/24] serial: jsm: fix NPE during jsm_uart_port_init
Date: Sat,  7 Jun 2025 12:07:50 +0200
Message-ID: <20250607100718.646458340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


