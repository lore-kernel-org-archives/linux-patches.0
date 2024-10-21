Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F27E1E0087;
	Mon, 21 Oct 2024 10:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507201; cv=none; b=aoTMCFD4oHpQJUoN5d+LnIDQQ7o4wo3Ut5jFUmEUesr2sdfYWhRoWtTXcbdHr8a9Ty5ldWuR/4v6J2A/F8ht4dEIIO+85lnnIvfc1HQCfz8L6wB8KmhL/TwSTCAgx4aYSAUq4+5clTZP2FuS0uVtWf1vKbN0AyM4gbV5y797XjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507201; c=relaxed/simple;
	bh=ReXjEnyU2zgu16G8naMrWWgZX2oa64X4PjPEmfYfU8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJNv1tGhdaKBOBeAeko5ceohh82/YED7Me3X/2KTSQPNzSJAfXXOVSjQYypRiGRLNV2DT7oMts6EwNZ7rGZfk24HFsXpcYqzksNdF2aX7F4fE/mIKn0V+CjCfDzm6hAWurOWgMhSb3GMfMq1Uw4xHsks46jiFofFMmXgNsLRfBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mn1dR2XT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mn1dR2XT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9777C4CEC7;
	Mon, 21 Oct 2024 10:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507201;
	bh=ReXjEnyU2zgu16G8naMrWWgZX2oa64X4PjPEmfYfU8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mn1dR2XT6ED7cdnIEPGO5GAVZimgko5E1hjoS/OeiXegOpMGZI4CX85oAfWUYSeT2
	 DCtaNQ6Ao0MhomtgR8pmGj8X0kZ7fh95XFTw4U2+390TBxaHDiAIQ+7GcP00ztohuh
	 HZdx9raR9+W6uS6rPCHHTBnkaThOL3xgdf0a2G7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Lin <henryl@nvidia.com>
Subject: [PATCH 6.6 092/124] xhci: tegra: fix checked USB2 port number
Date: Mon, 21 Oct 2024 12:24:56 +0200
Message-ID: <20241021102300.284306321@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Lin <henryl@nvidia.com>

commit 7d381137cb6ecf558ef6698c7730ddd482d4c8f2 upstream.

If USB virtualizatoin is enabled, USB2 ports are shared between all
Virtual Functions. The USB2 port number owned by an USB2 root hub in
a Virtual Function may be less than total USB2 phy number supported
by the Tegra XUSB controller.

Using total USB2 phy number as port number to check all PORTSC values
would cause invalid memory access.

[  116.923438] Unable to handle kernel paging request at virtual address 006c622f7665642f
...
[  117.213640] Call trace:
[  117.216783]  tegra_xusb_enter_elpg+0x23c/0x658
[  117.222021]  tegra_xusb_runtime_suspend+0x40/0x68
[  117.227260]  pm_generic_runtime_suspend+0x30/0x50
[  117.232847]  __rpm_callback+0x84/0x3c0
[  117.237038]  rpm_suspend+0x2dc/0x740
[  117.241229] pm_runtime_work+0xa0/0xb8
[  117.245769]  process_scheduled_works+0x24c/0x478
[  117.251007]  worker_thread+0x23c/0x328
[  117.255547]  kthread+0x104/0x1b0
[  117.259389]  ret_from_fork+0x10/0x20
[  117.263582] Code: 54000222 f9461ae8 f8747908 b4ffff48 (f9400100)

Cc: stable@vger.kernel.org # v6.3+
Fixes: a30951d31b25 ("xhci: tegra: USB2 pad power controls")
Signed-off-by: Henry Lin <henryl@nvidia.com>
Link: https://lore.kernel.org/r/20241014042134.27664-1-henryl@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -2183,7 +2183,7 @@ static int tegra_xusb_enter_elpg(struct
 		goto out;
 	}
 
-	for (i = 0; i < tegra->num_usb_phys; i++) {
+	for (i = 0; i < xhci->usb2_rhub.num_ports; i++) {
 		if (!xhci->usb2_rhub.ports[i])
 			continue;
 		portsc = readl(xhci->usb2_rhub.ports[i]->addr);


