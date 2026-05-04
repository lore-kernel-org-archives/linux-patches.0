Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DED3B19D1;
	Mon,  4 May 2026 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903252; cv=none; b=XVR+CtkkK4K7UkbJKy7g/0fhJrLJafXKJ4yPJyAu1maTnfF3yYoPSeMT5/EvobYq54wyXFTR7+tA+lxVPBkR87NkhDMheP7HjRi8ePfk/T6sioKJJ7r59imPZGJaxM6avoSt6XumYS2cbpc5GqhGvq2wRS4N+rOkaoSJTgmBN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903252; c=relaxed/simple;
	bh=lTaH+uV/5p2d+82yv2u+W9+Pnb+9qwl2dMp749U1II8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD338FfwsgEBfGGRbH7Mq2xV71LVT+SWi/GmX2U7XoZZ/Kbi7xhE7ByrbM4TKiHd3gCgL3XAd0GniUnAXxyi8Nl6a/O3h0g03drkuYvOdKWGc8GU38FvHHET72YV2KXjrDBocSKs10adDlF7fm7gRm3McBb9ZsJFqN1kFquhmI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e42miZkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e42miZkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D41EC2BCB8;
	Mon,  4 May 2026 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903252;
	bh=lTaH+uV/5p2d+82yv2u+W9+Pnb+9qwl2dMp749U1II8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e42miZkQO+faaYrsDvY5NnKyFz1vKGvHP4YxW2G89akTL1S4C7fRwRSEaEX90e0uL
	 y/myRdIUXtmAQaWYpNwvFxaGM/HRn8ZjF9iTTgtBVboa9ZlM3fKoqnqkGJWgxaiKEN
	 HZDU/VCdQAGnqKXTqe2/dSGC+Z1pPSLnCGI+Rk/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 135/307] net: txgbe: fix RTNL assertion warning when remove module
Date: Mon,  4 May 2026 15:50:20 +0200
Message-ID: <20260504135147.867766279@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit e159f05e12cc1111a3103b99375ddf0dfd0e7d63 upstream.

For the copper NIC with external PHY, the driver called
phylink_connect_phy() during probe and phylink_disconnect_phy() during
remove. It caused an RTNL assertion warning in phylink_disconnect_phy()
upon module remove.

To fix this, add rtnl_lock() and rtnl_unlock() around the
phylink_disconnect_phy() in remove function.

 ------------[ cut here ]------------
 RTNL: assertion failed at drivers/net/phy/phylink.c (2351)
 WARNING: drivers/net/phy/phylink.c:2351 at
phylink_disconnect_phy+0xd8/0xf0 [phylink], CPU#0: rmmod/4464
 Modules linked in: ...
 CPU: 0 UID: 0 PID: 4464 Comm: rmmod Kdump: loaded Not tainted 7.0.0-rc4+
 Hardware name: Micro-Star International Co., Ltd. MS-7E16/X670E GAMING
PLUS WIFI (MS-7E16), BIOS 1.90 12/31/2024
 RIP: 0010:phylink_disconnect_phy+0xe4/0xf0 [phylink]
 Code: 5b 41 5c 41 5d 41 5e 41 5f 5d 31 c0 31 d2 31 f6 31 ff e9 3a 38 8f e7
48 8d 3d 48 87 e2 ff ba 2f 09 00 00 48 c7 c6 c1 22 24 c0 <67> 48 0f b9 3a
e9 34 ff ff ff 66 90 90 90 90 90 90 90 90 90 90 90
 RSP: 0018:ffffce7288363ac0 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff89654b2a1a00 RCX: 0000000000000000
 RDX: 000000000000092f RSI: ffffffffc02422c1 RDI: ffffffffc0239020
 RBP: ffffce7288363ae8 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff8964c4022000
 R13: ffff89654fce3028 R14: ffff89654ebb4000 R15: ffffffffc0226348
 FS:  0000795e80d93780(0000) GS:ffff896c52857000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005b528b592000 CR3: 0000000170d0f000 CR4: 0000000000f50ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  txgbe_remove_phy+0xbb/0xd0 [txgbe]
  txgbe_remove+0x4c/0xb0 [txgbe]
  pci_device_remove+0x41/0xb0
  device_remove+0x43/0x80
  device_release_driver_internal+0x206/0x270
  driver_detach+0x4a/0xa0
  bus_remove_driver+0x83/0x120
  driver_unregister+0x2f/0x60
  pci_unregister_driver+0x40/0x90
  txgbe_driver_exit+0x10/0x850 [txgbe]
  __do_sys_delete_module.isra.0+0x1c3/0x2f0
  __x64_sys_delete_module+0x12/0x20
  x64_sys_call+0x20c3/0x2390
  do_syscall_64+0x11c/0x1500
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x15a/0x1500
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_fault+0x312/0x580
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __handle_mm_fault+0x9d5/0x1040
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? count_memcg_events+0x101/0x1d0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? handle_mm_fault+0x1e8/0x2f0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_user_addr_fault+0x2f8/0x820
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? irqentry_exit+0xb2/0x600
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? exc_page_fault+0x92/0x1c0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 02b2a6f91b90 ("net: txgbe: support copper NIC with external PHY")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/8B47A5872884147D+20260407094041.4646-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -657,7 +657,9 @@ void txgbe_remove_phy(struct txgbe *txgb
 		return;
 	case wx_mac_sp:
 		if (txgbe->wx->media_type == wx_media_copper) {
+			rtnl_lock();
 			phylink_disconnect_phy(txgbe->wx->phylink);
+			rtnl_unlock();
 			phylink_destroy(txgbe->wx->phylink);
 			return;
 		}


