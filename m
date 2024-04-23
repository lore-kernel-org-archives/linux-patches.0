Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62861448DF;
	Tue, 23 Apr 2024 21:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908517; cv=none; b=g8eoEl049Z+lUrMC9ZNhZI1wogdWfFmS2cVGbS7CTT6Tg5OhqW0FlGQrJzptlUDMj0Si2Qy6jjT4seMC8hbw5SXQXA4G1kjRbB6QEhXYxMISHxfllG+dyOSJfYnsgJDSAdLGrLE6LqLNFRYy/EFJ7Lr/JjX6lWZRBD8aLqBXOSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908517; c=relaxed/simple;
	bh=O9wdK6njTPYm1F7aHpRWw91Nx8rRq4asvP2UZRC+ny8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFVQF+9zOVmmrB+scnzf13afCM7cWLPq+C7rzH406VEEEZePzW59BpbjknqOmNvum+uR0wgUu4g2KES2cCTn0PUX3/qKZmidmtb6hWXcQ3C3OZprwuyg1ScoAozUliNK4enR5n2UgCemvhy8apFiysA/fsIDvBVKt1h2UsdL6MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzBeYOGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzBeYOGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA766C116B1;
	Tue, 23 Apr 2024 21:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908516;
	bh=O9wdK6njTPYm1F7aHpRWw91Nx8rRq4asvP2UZRC+ny8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzBeYOGN6maSO4/6zJOR0hbDY6vzZgYwTdAjFho8JwpaJsvd8L10mjBBk7Kfy4wz9
	 UQGF0+moKSb/TQHmiMBVYcubBR8+0n7pUMI2GjQhCqrhWub4G6mnvWg3golneGPMAp
	 xc2J3LTeXhvXQq0Iiiu1ZqKFrW6gS2T8TpsaNdD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.8 103/158] serial: 8250_dw: Revert: Do not reclock if already at correct rate
Date: Tue, 23 Apr 2024 14:38:45 -0700
Message-ID: <20240423213859.294089905@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7dfae6cbadc1ac99e38ad19fb08810b31ff167be upstream.

Commit e5d6bd25f93d ("serial: 8250_dw: Do not reclock if already at
correct rate") breaks the dw UARTs on Intel Bay Trail (BYT) and
Cherry Trail (CHT) SoCs.

Before this change the RTL8732BS Bluetooth HCI which is found
connected over the dw UART on both BYT and CHT boards works properly:

Bluetooth: hci0: RTL: examining hci_ver=06 hci_rev=000b lmp_ver=06 lmp_subver=8723
Bluetooth: hci0: RTL: rom_version status=0 version=1
Bluetooth: hci0: RTL: loading rtl_bt/rtl8723bs_fw.bin
Bluetooth: hci0: RTL: loading rtl_bt/rtl8723bs_config-OBDA8723.bin
Bluetooth: hci0: RTL: cfg_sz 64, total sz 24508
Bluetooth: hci0: RTL: fw version 0x365d462e

where as after this change probing it fails:

Bluetooth: hci0: RTL: examining hci_ver=06 hci_rev=000b lmp_ver=06 lmp_subver=8723
Bluetooth: hci0: RTL: rom_version status=0 version=1
Bluetooth: hci0: RTL: loading rtl_bt/rtl8723bs_fw.bin
Bluetooth: hci0: RTL: loading rtl_bt/rtl8723bs_config-OBDA8723.bin
Bluetooth: hci0: RTL: cfg_sz 64, total sz 24508
Bluetooth: hci0: command 0xfc20 tx timeout
Bluetooth: hci0: RTL: download fw command failed (-110)

Revert the changes to fix this regression.

Fixes: e5d6bd25f93d ("serial: 8250_dw: Do not reclock if already at correct rate")
Cc: stable@vger.kernel.org
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Peter Collingbourne <pcc@google.com>
Link: https://lore.kernel.org/r/20240317214123.34482-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -357,9 +357,9 @@ static void dw8250_set_termios(struct ua
 	long rate;
 	int ret;
 
+	clk_disable_unprepare(d->clk);
 	rate = clk_round_rate(d->clk, newrate);
-	if (rate > 0 && p->uartclk != rate) {
-		clk_disable_unprepare(d->clk);
+	if (rate > 0) {
 		/*
 		 * Note that any clock-notifer worker will block in
 		 * serial8250_update_uartclk() until we are done.
@@ -367,8 +367,8 @@ static void dw8250_set_termios(struct ua
 		ret = clk_set_rate(d->clk, newrate);
 		if (!ret)
 			p->uartclk = rate;
-		clk_prepare_enable(d->clk);
 	}
+	clk_prepare_enable(d->clk);
 
 	dw8250_do_set_termios(p, termios, old);
 }


