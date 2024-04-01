Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632A3F8F4;
	Mon,  1 Apr 2024 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989614; cv=none; b=NrUYpI3kyCjxgXi+uscmJrXcMJjV2Gbj+DZXxCJpZVmT2/I6wi0dxhNWPOLz6XKrv1B81+qs7fNtW/+qLcVzVm+pobu5T/A3LhJb6jTQ31J9xvcGRIyplR6rqq28NBFmJ1G6TVupX19+ZhB4vFDqpl6gPQtwvCVGmfvAnJDHFBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989614; c=relaxed/simple;
	bh=GahXY6c7oxWUq61piySXa4eXVkM9PGtEel95g92VbLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRsHxArC8y+w2uOAJK8LgaKOR6ci6cNWCBzbncrwP+YwPzuWEf9IG/jqJ28kDLnd6WL1LWW2n6+N3eYHiZlZ+pWGO0t3CX8EeN27WWGh6PTAAW3/rvUSEXF5SOKp7V2Md0EyMNs/FH0S/jfKvL7EUPrxVEfoPJl3RN6QD4MOxEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDUIp/iJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDUIp/iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457D9C433F1;
	Mon,  1 Apr 2024 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989614;
	bh=GahXY6c7oxWUq61piySXa4eXVkM9PGtEel95g92VbLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDUIp/iJ42iOu3NYhLxQWlxrgAmLZHQjgxCTLral+JgmJHMzQSIIElcV9y4riHTdP
	 Po7uzmvfxatM9kjJmJWlbiR5PsC33eSqpkQmVvBZRDQogNeT/5vKvabKf2pHvBK8ip
	 f1o8WQRBJxPvqS+VaBa0uQN8xJGiXW6V1XHSLIQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/396] Bluetooth: btnxpuart: Fix btnxpuart_close
Date: Mon,  1 Apr 2024 17:42:31 +0200
Message-ID: <20240401152550.963753872@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 664130c0b0309b360bc5bdd40a30604a9387bde8 ]

Fix scheduling while atomic BUG in btnxpuart_close(), properly
purge the transmit queue and free the receive skb.

[   10.973809] BUG: scheduling while atomic: kworker/u9:0/80/0x00000002
...
[   10.980740] CPU: 3 PID: 80 Comm: kworker/u9:0 Not tainted 6.8.0-rc7-0.0.0-devel-00005-g61fdfceacf09 #1
[   10.980751] Hardware name: Toradex Verdin AM62 WB on Dahlia Board (DT)
[   10.980760] Workqueue: hci0 hci_power_off [bluetooth]
[   10.981169] Call trace:
...
[   10.981363]  uart_update_mctrl+0x58/0x78
[   10.981373]  uart_dtr_rts+0x104/0x114
[   10.981381]  tty_port_shutdown+0xd4/0xdc
[   10.981396]  tty_port_close+0x40/0xbc
[   10.981407]  uart_close+0x34/0x9c
[   10.981414]  ttyport_close+0x50/0x94
[   10.981430]  serdev_device_close+0x40/0x50
[   10.981442]  btnxpuart_close+0x24/0x98 [btnxpuart]
[   10.981469]  hci_dev_close_sync+0x2d8/0x718 [bluetooth]
[   10.981728]  hci_dev_do_close+0x2c/0x70 [bluetooth]
[   10.981862]  hci_power_off+0x20/0x64 [bluetooth]

Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 951fe3014a3f3..abccd571cf3ee 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1234,6 +1234,9 @@ static int btnxpuart_close(struct hci_dev *hdev)
 
 	ps_wakeup(nxpdev);
 	serdev_device_close(nxpdev->serdev);
+	skb_queue_purge(&nxpdev->txq);
+	kfree_skb(nxpdev->rx_skb);
+	nxpdev->rx_skb = NULL;
 	clear_bit(BTNXPUART_SERDEV_OPEN, &nxpdev->tx_state);
 	return 0;
 }
-- 
2.43.0



