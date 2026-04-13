Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BF73382C8;
	Mon, 13 Apr 2026 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099458; cv=none; b=oU1d1emYGrxf47olxMP1FhoBQ/1rKxmCyyNbg/GIFTntGKXSODrvCapWTlDfZO2NDykm1qYF8Z1GDQ3kxDB98kONxTaRHAutKjV3IyMpRZ9NjMa5pWBeHbmYRAzYUKhOgwySLSANbnzydOnyYi3x5wVkCr7/mXzYIE9JV9Gzr7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099458; c=relaxed/simple;
	bh=kzOfr1pdZYKGhlI6uBQD3ocG8kIvIfzgMqYsLoHaRxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHULPP9PhLj0eGMrfeHJKfQdXAOyQ+XlHoil63opTH0/+np1GiwWtnxTA1DI378lhByfJpYFscHircZh2uSTlND31iXjcQFlspr3DjKc6a4le1Q+nWtUpwX4FvclWBDbtdpHfFpKTvHzLWD7rSPLkP6qGtNGnoLvIZbvbnPrwoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9wrzj5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9wrzj5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CFEC2BCAF;
	Mon, 13 Apr 2026 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099457;
	bh=kzOfr1pdZYKGhlI6uBQD3ocG8kIvIfzgMqYsLoHaRxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9wrzj5GkvLbAonxdx+M+HRMSUKP07vL2axSnfJBbaKolHAIcODWqG1+00CzdK6Mi
	 do1rHPLjnXqhYi3e21ryLZIpVhkW6RC/FNSmaUcKZesmGMA3ah9vPOQFnYTZnn/RjT
	 FG66UdAT4xkBUl5OTXOiCAd/34NfRDRq9a4MlIsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/491] net: macb: fix clk handling on PCI glue driver removal
Date: Mon, 13 Apr 2026 17:59:51 +0200
Message-ID: <20260413155831.992068566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit ce8fe5287b87e24e225c342f3b0ec04f0b3680fe ]

platform_device_unregister() may still want to use the registered clks
during runtime resume callback.

Note that there is a commit d82d5303c4c5 ("net: macb: fix use after free
on rmmod") that addressed the similar problem of clk vs platform device
unregistration but just moved the bug to another place.

Save the pointers to clks into local variables for reuse after platform
device is unregistered.

BUG: KASAN: use-after-free in clk_prepare+0x5a/0x60
Read of size 8 at addr ffff888104f85e00 by task modprobe/597

CPU: 2 PID: 597 Comm: modprobe Not tainted 6.1.164+ #114
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x8d/0xba
 print_report+0x17f/0x496
 kasan_report+0xd9/0x180
 clk_prepare+0x5a/0x60
 macb_runtime_resume+0x13d/0x410 [macb]
 pm_generic_runtime_resume+0x97/0xd0
 __rpm_callback+0xc8/0x4d0
 rpm_callback+0xf6/0x230
 rpm_resume+0xeeb/0x1a70
 __pm_runtime_resume+0xb4/0x170
 bus_remove_device+0x2e3/0x4b0
 device_del+0x5b3/0xdc0
 platform_device_del+0x4e/0x280
 platform_device_unregister+0x11/0x50
 pci_device_remove+0xae/0x210
 device_remove+0xcb/0x180
 device_release_driver_internal+0x529/0x770
 driver_detach+0xd4/0x1a0
 bus_remove_driver+0x135/0x260
 driver_unregister+0x72/0xb0
 pci_unregister_driver+0x26/0x220
 __do_sys_delete_module+0x32e/0x550
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
 </TASK>

Allocated by task 519:
 kasan_save_stack+0x2c/0x50
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x8e/0x90
 __clk_register+0x458/0x2890
 clk_hw_register+0x1a/0x60
 __clk_hw_register_fixed_rate+0x255/0x410
 clk_register_fixed_rate+0x3c/0xa0
 macb_probe+0x1d8/0x42e [macb_pci]
 local_pci_probe+0xd7/0x190
 pci_device_probe+0x252/0x600
 really_probe+0x255/0x7f0
 __driver_probe_device+0x1ee/0x330
 driver_probe_device+0x4c/0x1f0
 __driver_attach+0x1df/0x4e0
 bus_for_each_dev+0x15d/0x1f0
 bus_add_driver+0x486/0x5e0
 driver_register+0x23a/0x3d0
 do_one_initcall+0xfd/0x4d0
 do_init_module+0x18b/0x5a0
 load_module+0x5663/0x7950
 __do_sys_finit_module+0x101/0x180
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Freed by task 597:
 kasan_save_stack+0x2c/0x50
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0x106/0x180
 __kmem_cache_free+0xbc/0x320
 clk_unregister+0x6de/0x8d0
 macb_remove+0x73/0xc0 [macb_pci]
 pci_device_remove+0xae/0x210
 device_remove+0xcb/0x180
 device_release_driver_internal+0x529/0x770
 driver_detach+0xd4/0x1a0
 bus_remove_driver+0x135/0x260
 driver_unregister+0x72/0xb0
 pci_unregister_driver+0x26/0x220
 __do_sys_delete_module+0x32e/0x550
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: d82d5303c4c5 ("net: macb: fix use after free on rmmod")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260330184542.626619-1-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 3593b310c325d..9be050c5d83e0 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -110,10 +110,12 @@ static void macb_remove(struct pci_dev *pdev)
 {
 	struct platform_device *plat_dev = pci_get_drvdata(pdev);
 	struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
+	struct clk *pclk = plat_data->pclk;
+	struct clk *hclk = plat_data->hclk;
 
-	clk_unregister(plat_data->pclk);
-	clk_unregister(plat_data->hclk);
 	platform_device_unregister(plat_dev);
+	clk_unregister(pclk);
+	clk_unregister(hclk);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.53.0



