Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3FB33065C;
	Sat, 12 Sep 2026 14:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222443; cv=none; b=WfJKKoP6/DeXulX1fWx9k9M763d6taUsUBqyqNmd8J2DxBgPIn0969OHEqd9GtMApWqh4QHbPfCjursutoi3UD7WbzuKqaisvCA4Whr/f4lCNfF3X+NsC+e/KhXFCVjzmrVKO4AtQwgTuGoKlvB3bhX6PxtCutHVnTTR2Jutqo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222443; c=relaxed/simple;
	bh=ac6hjqointJhxVeMwhaYc/KS2KzmSykJozm/X6eAg6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+274ZDU7cpMsp4/aUQVoK6rMcBfu0cfKd5BU+ece9/X71b5UX6Eth1B8tUupUpTUMxK1VrPa7Js70a/b72JfSrpo5Oxu0cR9YM3jmHy2ql3CxJOilRBKLR/7sK05+CzJaqoW0GVmQpjdsQaYSlWlAcRmSav0SOesMclqUUBKXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlZ9JhwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlZ9JhwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896E01F000FF;
	Sat, 12 Sep 2026 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222441;
	bh=PNNOlyWIhXoqQy2sIBlgVObhaUif2O7XvKf/6gUDN8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlZ9JhwV7zJJdvujx19f8t7ivU6MCYb1RzJGCu0HA0kVgVVYY8IwgOFE9SXEgmxKU
	 Rkd7ihoeoqpgsmfLujfkb6EjLQMvIBKLNRkVnI8iGb174ubP1tH31uBb6vlu8vxaAZ
	 2vK3gwbcAUaroU7NUtEiuY/v/I5G+Dl+mu8ccBGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Currier <dullfire@yahoo.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0545/1424] net/niu: Niu requires MSIX ENTRY_DATA fields touch before entry reads
Date: Sat, 12 Sep 2026 08:49:37 +0200
Message-ID: <20260912065619.507414771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Currier <dullfire@yahoo.com>

[ Upstream commit fbb429ddff5c8e479edcc7dde5a542c9295944e6 ]

Fix niu_try_msix() to not cause a fatal trap on sparc systems.

Set PCI_DEV_FLAGS_MSIX_TOUCH_ENTRY_DATA_FIRST on the struct pci_dev to
work around a bug in the hardware or firmware.

For each vector entry in the msix table, niu chips will cause a fatal
trap if any registers in that entry are read before that entries'
ENTRY_DATA register is written to. Testing indicates writes to other
registers are not sufficient to prevent the fatal trap, however the value
does not appear to matter. This only needs to happen once after power up,
so simply rebooting into a kernel lacking this fix will NOT cause the
trap.

NON-RESUMABLE ERROR: Reporting on cpu 64
NON-RESUMABLE ERROR: TPC [0x00000000005f6900] <msix_prepare_msi_desc+0x90/0xa0>
NON-RESUMABLE ERROR: RAW [4010000000000016:00000e37f93e32ff:0000000202000080:ffffffffffffffff
NON-RESUMABLE ERROR:      0000000800000000:0000000000000000:0000000000000000:0000000000000000]
NON-RESUMABLE ERROR: handle [0x4010000000000016] stick [0x00000e37f93e32ff]
NON-RESUMABLE ERROR: type [precise nonresumable]
NON-RESUMABLE ERROR: attrs [0x02000080] < ASI sp-faulted priv >
NON-RESUMABLE ERROR: raddr [0xffffffffffffffff]
NON-RESUMABLE ERROR: insn effective address [0x000000c50020000c]
NON-RESUMABLE ERROR: size [0x8]
NON-RESUMABLE ERROR: asi [0x00]
CPU: 64 UID: 0 PID: 745 Comm: kworker/64:1 Not tainted 6.11.5 #63
Workqueue: events work_for_cpu_fn
TSTATE: 0000000011001602 TPC: 00000000005f6900 TNPC: 00000000005f6904 Y: 00000000    Not tainted
TPC: <msix_prepare_msi_desc+0x90/0xa0>
g0: 00000000000002e9 g1: 000000000000000c g2: 000000c50020000c g3: 0000000000000100
g4: ffff8000470307c0 g5: ffff800fec5be000 g6: ffff800047a08000 g7: 0000000000000000
o0: ffff800014feb000 o1: ffff800047a0b620 o2: 0000000000000011 o3: ffff800047a0b620
o4: 0000000000000080 o5: 0000000000000011 sp: ffff800047a0ad51 ret_pc: 00000000005f7128
RPC: <__pci_enable_msix_range+0x3cc/0x460>
l0: 000000000000000d l1: 000000000000c01f l2: ffff800014feb0a8 l3: 0000000000000020
l4: 000000000000c000 l5: 0000000000000001 l6: 0000000020000000 l7: ffff800047a0b734
i0: ffff800014feb000 i1: ffff800047a0b730 i2: 0000000000000001 i3: 000000000000000d
i4: 0000000000000000 i5: 0000000000000000 i6: ffff800047a0ae81 i7: 00000000101888b0
I7: <niu_try_msix.constprop.0+0xc0/0x130 [niu]>
Call Trace:
[<00000000101888b0>] niu_try_msix.constprop.0+0xc0/0x130 [niu]
[<000000001018f840>] niu_get_invariants+0x183c/0x207c [niu]
[<00000000101902fc>] niu_pci_init_one+0x27c/0x2fc [niu]
[<00000000005ef3e4>] local_pci_probe+0x28/0x74
[<0000000000469240>] work_for_cpu_fn+0x8/0x1c
[<000000000046b008>] process_scheduled_works+0x144/0x210
[<000000000046b518>] worker_thread+0x13c/0x1c0
[<00000000004710e0>] kthread+0xb8/0xc8
[<00000000004060c8>] ret_from_fork+0x1c/0x2c
[<0000000000000000>] 0x0
Kernel panic - not syncing: Non-resumable error.

Fixes: 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X entries")
Signed-off-by: Jonathan Currier <dullfire@yahoo.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241117234843.19236-3-dullfire@yahoo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/niu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index fc6217917fc22..0645ef20f6645 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9075,6 +9075,8 @@ static void niu_try_msix(struct niu *np, u8 *ldg_num_map)
 		msi_vec[i].entry = i;
 	}
 
+	pdev->dev_flags |= PCI_DEV_FLAGS_MSIX_TOUCH_ENTRY_DATA_FIRST;
+
 	num_irqs = pci_enable_msix_range(pdev, msi_vec, 1, num_irqs);
 	if (num_irqs < 0) {
 		np->flags &= ~NIU_FLAGS_MSIX;
-- 
2.53.0



