Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4026C3A3E9C;
	Wed, 20 May 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299712; cv=none; b=HXtbMnoen1UBdDnIghFf8Ubwvr+bY8sXBhi7xcLbIh1h76aFZRY1z0lavXUBpSDOUG643n18EPg8oCo/z3ZciyDqgcAnTPbUDHd6y4JMXzSvmSYEezqLbciDUoE3fDAdj6hNKiUDIr21VxTIvJaXxK0UFxrv/cN9v+pRtZQ6v8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299712; c=relaxed/simple;
	bh=B54sqhuhUm0BZgYjl0murBoSDyZMYTfQyMuYk5q83mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRYluPYgviyGVcmCMCbPm6zeLDSiR6Pvfu3+LAk1jI75Ja/M8dgmGfpxsZpo5ya7aFtRXtxpZsKQHdFIDPa3vMOCZumhr2lqH+WTUCZ8TYYYUhtq6JxIVJrxeQsRUjWOE+iMNMt8V5HFT9aW/QEwYT+tDqRXus6LZXDne/A9gcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7lB+WMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7lB+WMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18201F000E9;
	Wed, 20 May 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299711;
	bh=6PfFTfM3hjmaSfYBbUW7guzLKGSVAEahztnl8pM8fI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7lB+WMoCaB6A8p9pKeSHqlJwCDkJ8G9k7nwjpKiSsEnZfNdoi5b1NiB4xahZv4q+
	 YEenv86rTMwkIIJdHN2g/eTvSIVhART2t54j3IbPArmVc6frTdrWt5ljiFAzqLEqFK
	 3FPHwT3EbCop4KZafj+MtelC/x8qt9rRkPnQF0is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Long Li <longli@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 875/957] net: mana: Fix use-after-free in reset service rescan path
Date: Wed, 20 May 2026 18:22:38 +0200
Message-ID: <20260520162153.541441318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 3387a7ad478b46970ae8254049167d166e398aeb ]

When mana_serv_reset() encounters -ETIMEDOUT or -EPROTO from
mana_gd_resume(), it performs a PCI rescan via mana_serv_rescan().

mana_serv_rescan() calls pci_stop_and_remove_bus_device(), which can
invoke the driver's remove path and free the gdma_context associated
with the device. After returning, mana_serv_reset() currently jumps to
the out label and attempts to clear gc->in_service, dereferencing a
freed gdma_context.

The issue was observed with the following call logs:
[  698.942636] BUG: unable to handle page fault for address: ff6c2b638088508d
[  698.943121] #PF: supervisor write access in kernel mode
[  698.943423] #PF: error_code(0x0002) - not-present page
[S[  698.943793] Pat Dec  6 07:GD5 100000067 P4D 1002f7067 PUD 1002f8067 PMD 101bef067 PTE 0
0:56 2025] hv_[n e 698.944283] Oops: Oops: 0002 [#1] SMP NOPTI
tvsc f8615163-00[  698.944611] CPU: 28 UID: 0 PID: 249 Comm: kworker/28:1
...
[Sat Dec  6 07:50:56 2025] R10: [  699.121594] mana 7870:00:00.0 enP30832s1: Configured vPort 0 PD 18 DB 16
000000000000001b R11: 0000000000000000 R12: ff44cf3f40270000
[Sat Dec  6 07:50:56 2025] R13: 0000000000000001 R14: ff44cf3f402700c8 R15: ff44cf3f4021b405
[Sat Dec  6 07:50:56 2025] FS:  0000000000000000(0000) GS:ff44cf7e9fcf9000(0000) knlGS:0000000000000000
[Sat Dec  6 07:50:56 2025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Sat Dec  6 07:50:56 2025] CR2: ff6c2b638088508d CR3: 000000011fe43001 CR4: 0000000000b73ef0
[Sat Dec  6 07:50:56 2025] Call Trace:
[Sat Dec  6 07:50:56 2025]  <TASK>
[Sat Dec  6 07:50:56 2025]  mana_serv_func+0x24/0x50 [mana]
[Sat Dec  6 07:50:56 2025]  process_one_work+0x190/0x350
[Sat Dec  6 07:50:56 2025]  worker_thread+0x2b7/0x3d0
[Sat Dec  6 07:50:56 2025]  kthread+0xf3/0x200
[Sat Dec  6 07:50:56 2025]  ? __pfx_worker_thread+0x10/0x10
[Sat Dec  6 07:50:56 2025]  ? __pfx_kthread+0x10/0x10
[Sat Dec  6 07:50:56 2025]  ret_from_fork+0x21a/0x250
[Sat Dec  6 07:50:56 2025]  ? __pfx_kthread+0x10/0x10
[Sat Dec  6 07:50:56 2025]  ret_from_fork_asm+0x1a/0x30
[Sat Dec  6 07:50:56 2025]  </TASK>

Fix this by returning immediately after mana_serv_rescan() to avoid
accessing GC state that may no longer be valid.

Fixes: 9bf66036d686 ("net: mana: Handle hardware recovery events when probing the device")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20251218131054.GA3173@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 0ad082b566f5e..45ee0774522a1 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -481,7 +481,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 		/* Perform PCI rescan on device if we failed on HWC */
 		dev_err(&pdev->dev, "MANA service: resume failed, rescanning\n");
 		mana_serv_rescan(pdev);
-		goto out;
+		return;
 	}
 
 	if (ret)
-- 
2.53.0



