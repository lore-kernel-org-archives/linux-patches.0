Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637D80603;
	Mon,  8 Apr 2024 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585136; cv=none; b=UZW12r0AeWPu4JlA34+pwR2ZYsvB3vGzzhk78IfCMztaGPJsBMbzvbu9IApZH76f8De1Y9c43QrDayNJdYmuu4On2ynRSJEifGjbpeOSbtRXGiUOyYWN3w3/Wg2IxEODdXwZbOoc56kyvAeHYx0corWOSvom+r0IwH58ot6XOSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585136; c=relaxed/simple;
	bh=H3O2KRct1fR95ghpkF4AxJJtraB3K9yYHZVHYkpXTvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLf0MOsMl78c2uCse6sQK6ShGxAsxhh7rENlqYhOonX13ftTNVWtipXYuoMFZEUacwFbOROYZQkM5T3Pf4kF7Y+uslVo5UaEqSpOpTxWE4a1XvUqqwPMVCaYASjYyi22wuXOyiLptikCKf4K47X5JfQJbMQLeogWojwjlSLtiAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zv4WV2nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zv4WV2nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C3BC433F1;
	Mon,  8 Apr 2024 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585136;
	bh=H3O2KRct1fR95ghpkF4AxJJtraB3K9yYHZVHYkpXTvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zv4WV2nTLo1B8Gco3hy8E6p+9TnQ/oWnY7jVzXZN3S3Nxou3L05vJL4uQYFugVsn1
	 zSYDkuodaszPtKaXDilIz/JuJPz0GtvItoa+b/zdWfatwG4zcoUjPng9XpFItTp7au
	 Z5+y4zDnwJJcO3V5r1Wpaydb5nwRWmSx/yzmWnKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 648/690] mlxbf_gige: stop interface during shutdown
Date: Mon,  8 Apr 2024 14:58:34 +0200
Message-ID: <20240408125423.126744182@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: David Thompson <davthompson@nvidia.com>

commit 09ba28e1cd3cf715daab1fca6e1623e22fd754a6 upstream.

The mlxbf_gige driver intermittantly encounters a NULL pointer
exception while the system is shutting down via "reboot" command.
The mlxbf_driver will experience an exception right after executing
its shutdown() method.  One example of this exception is:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000070
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=000000011d373000
[0000000000000070] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] SMP
CPU: 0 PID: 13 Comm: ksoftirqd/0 Tainted: G S         OE     5.15.0-bf.6.gef6992a #1
Hardware name: https://www.mellanox.com BlueField SoC/BlueField SoC, BIOS 4.0.2.12669 Apr 21 2023
pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : mlxbf_gige_handle_tx_complete+0xc8/0x170 [mlxbf_gige]
lr : mlxbf_gige_poll+0x54/0x160 [mlxbf_gige]
sp : ffff8000080d3c10
x29: ffff8000080d3c10 x28: ffffcce72cbb7000 x27: ffff8000080d3d58
x26: ffff0000814e7340 x25: ffff331cd1a05000 x24: ffffcce72c4ea008
x23: ffff0000814e4b40 x22: ffff0000814e4d10 x21: ffff0000814e4128
x20: 0000000000000000 x19: ffff0000814e4a80 x18: ffffffffffffffff
x17: 000000000000001c x16: ffffcce72b4553f4 x15: ffff80008805b8a7
x14: 0000000000000000 x13: 0000000000000030 x12: 0101010101010101
x11: 7f7f7f7f7f7f7f7f x10: c2ac898b17576267 x9 : ffffcce720fa5404
x8 : ffff000080812138 x7 : 0000000000002e9a x6 : 0000000000000080
x5 : ffff00008de3b000 x4 : 0000000000000000 x3 : 0000000000000001
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 mlxbf_gige_handle_tx_complete+0xc8/0x170 [mlxbf_gige]
 mlxbf_gige_poll+0x54/0x160 [mlxbf_gige]
 __napi_poll+0x40/0x1c8
 net_rx_action+0x314/0x3a0
 __do_softirq+0x128/0x334
 run_ksoftirqd+0x54/0x6c
 smpboot_thread_fn+0x14c/0x190
 kthread+0x10c/0x110
 ret_from_fork+0x10/0x20
Code: 8b070000 f9000ea0 f95056c0 f86178a1 (b9407002)
---[ end trace 7cc3941aa0d8e6a4 ]---
Kernel panic - not syncing: Oops: Fatal exception in interrupt
Kernel Offset: 0x4ce722520000 from 0xffff800008000000
PHYS_OFFSET: 0x80000000
CPU features: 0x000005c1,a3330e5a
Memory Limit: none
---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

During system shutdown, the mlxbf_gige driver's shutdown() is always executed.
However, the driver's stop() method will only execute if networking interface
configuration logic within the Linux distribution has been setup to do so.

If shutdown() executes but stop() does not execute, NAPI remains enabled
and this can lead to an exception if NAPI is scheduled while the hardware
interface has only been partially deinitialized.

The networking interface managed by the mlxbf_gige driver must be properly
stopped during system shutdown so that IFF_UP is cleared, the hardware
interface is put into a clean state, and NAPI is fully deinitialized.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20240325210929.25362-1-davthompson@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
 
 #include "mlxbf_gige.h"
@@ -419,8 +420,13 @@ static void mlxbf_gige_shutdown(struct p
 {
 	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
 
-	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
-	mlxbf_gige_clean_port(priv);
+	rtnl_lock();
+	netif_device_detach(priv->netdev);
+
+	if (netif_running(priv->netdev))
+		dev_close(priv->netdev);
+
+	rtnl_unlock();
 }
 
 static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {


