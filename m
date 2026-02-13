Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B8536075F;
	Fri, 13 Feb 2026 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990874; cv=none; b=jhbm/zM8F3b+kXmda9M1Tnk0ZnunF8dDB9DYE3NyrQNC9n6xEhufw1EEZLWEKnTjtQT16dq2aJ0WwWqKaICKwCBsPjRwvFC0DgQH/nP2Q7+pysGeGSXXi1dUMxP8jGsvtYFXi/syDhC4YmltaRBDSGK795qcARw1JNECSXn8j0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990874; c=relaxed/simple;
	bh=TTDhDaGSpl/LuZnqkyw9IJBnHiCHj+67YFM1elVml2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjCqBeUitIFTXijf7uPxuP2Ocj1ijFTG2RF0WxhTCvGXQBPd4NynGZPijLrVq0TO0ZzQ+bHVzfEjiLmHPxQciAhYiNinHaDnrUVCxhjB4mlYRDJJ5O4AjZTF9avwTBTNmSIWgo8HUIgH5kRNQwNDENNM6hKthtBzpu55CC+dX4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyFRizw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyFRizw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90732C116C6;
	Fri, 13 Feb 2026 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990874;
	bh=TTDhDaGSpl/LuZnqkyw9IJBnHiCHj+67YFM1elVml2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyFRizw8febCITXyRhDnoNF8O/DkDWwx6N+RCbfdw3AedZSdsOZSs4Gtjw9BWYnqD
	 0c8efUQasR2BBrlg6WQaF+AZaRs3UsX9P+3SB58OM487Z9GqI17kb5vhn1NVwcPxVz
	 Cc1bGpsjLoH+7B5vpwG7Qlw4iREI0lUHWDepZJow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 37/49] wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()
Date: Fri, 13 Feb 2026 14:48:21 +0100
Message-ID: <20260213134710.231618688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 0177aa828d966117ea30a44f2e1890fdb356118e upstream.

rtw_core_enable_beacon() reads 4 bytes from an address that is not a
multiple of 4. This results in a crash on some systems.

Do 1 byte reads/writes instead.

Unable to handle kernel paging request at virtual address ffff8000827e0522
Mem abort info:
  ESR = 0x0000000096000021
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x21: alignment fault
Data abort info:
  ISV = 0, ISS = 0x00000021, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000005492000
[ffff8000827e0522] pgd=0000000000000000, p4d=10000001021d9403, pud=10000001021da403, pmd=100000011061c403, pte=00780000f3200f13
Internal error: Oops: 0000000096000021 [#1]  SMP
Modules linked in: [...] rtw88_8822ce rtw88_8822c rtw88_pci rtw88_core [...]
CPU: 0 UID: 0 PID: 73 Comm: kworker/u32:2 Tainted: G        W           6.17.9 #1-NixOS VOLUNTARY
Tainted: [W]=WARN
Hardware name: FriendlyElec NanoPC-T6 LTS (DT)
Workqueue: phy0 rtw_c2h_work [rtw88_core]
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : rtw_pci_read32+0x18/0x40 [rtw88_pci]
lr : rtw_core_enable_beacon+0xe0/0x148 [rtw88_core]
sp : ffff800080cc3ca0
x29: ffff800080cc3ca0 x28: ffff0001031fc240 x27: ffff000102100828
x26: ffffd2cb7c9b4088 x25: ffff0001031fc2c0 x24: ffff000112fdef00
x23: ffff000112fdef18 x22: ffff000111c29970 x21: 0000000000000001
x20: 0000000000000001 x19: ffff000111c22040 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : ffffd2cb6507c090
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000007f10 x1 : 0000000000000522 x0 : ffff8000827e0522
Call trace:
 rtw_pci_read32+0x18/0x40 [rtw88_pci] (P)
 rtw_hw_scan_chan_switch+0x124/0x1a8 [rtw88_core]
 rtw_fw_c2h_cmd_handle+0x254/0x290 [rtw88_core]
 rtw_c2h_work+0x50/0x98 [rtw88_core]
 process_one_work+0x178/0x3f8
 worker_thread+0x208/0x418
 kthread+0x120/0x220
 ret_from_fork+0x10/0x20
Code: d28fe202 8b020000 f9524400 8b214000 (b9400000)
---[ end trace 0000000000000000 ]---

Fixes: ad6741b1e044 ("wifi: rtw88: Stop high queue during scan")
Cc: stable@vger.kernel.org
Closes: https://github.com/lwfinger/rtw88/issues/418
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/6345300d-8c93-464c-9b05-d0d9af3c97ad@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2444,10 +2444,10 @@ void rtw_core_enable_beacon(struct rtw_d
 
 	if (enable) {
 		rtw_write32_set(rtwdev, REG_BCN_CTRL, BIT_EN_BCN_FUNCTION);
-		rtw_write32_clr(rtwdev, REG_TXPAUSE, BIT_HIGH_QUEUE);
+		rtw_write8_clr(rtwdev, REG_TXPAUSE, BIT_HIGH_QUEUE);
 	} else {
 		rtw_write32_clr(rtwdev, REG_BCN_CTRL, BIT_EN_BCN_FUNCTION);
-		rtw_write32_set(rtwdev, REG_TXPAUSE, BIT_HIGH_QUEUE);
+		rtw_write8_set(rtwdev, REG_TXPAUSE, BIT_HIGH_QUEUE);
 	}
 }
 


