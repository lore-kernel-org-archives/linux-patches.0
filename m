Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8953FE2D;
	Mon,  1 Apr 2024 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986892; cv=none; b=et6+Caef3xp6Uzoai/r33ccglrH+ZUlGjo4B5zNF21f4K5MDbmwkCTWM+lFUbG18mraMqCYnVilrqeadvVzPYScLQvv2iZS0EqYsk/T3v+bKEphmnqaNnEDKa3cQtLLTf4uAuAkiAGjTe0erzPKKdjM7CyzMvHdCkyEVvLzLuvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986892; c=relaxed/simple;
	bh=7E8P2GrsGd4ve7bPe+/OV5MUJ9O+RdGd9PG38IPKc+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxFMKdmdLfNtzGksnYILtcF9icvNYoJIcQ0EMRLjT7lHeb8xNxhG4I/B2uvGLF65BzU4FOTgQIviND26/cAVjXXatMlNyBqJI0TUy/pb+tKecjoObtU9DC09j/D1VDhOrqw3avqWEM7oDE45WRqyzFWzKzTzba7TKvpERhEeuIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAGJAC98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAGJAC98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB984C43390;
	Mon,  1 Apr 2024 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986892;
	bh=7E8P2GrsGd4ve7bPe+/OV5MUJ9O+RdGd9PG38IPKc+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAGJAC98uBEXqXQIqJATAIwgJrN++VWgf0JdBvx3OqMbWptEjJsIAzODRbC0MjcOd
	 JtDxROQ0HCwlfAZV/F/F1Wd9CbiIIlN6j8gITUad03EKKDXmvUzBiBpTFsLlvRJdeD
	 M5rZJhGVhwPn7EUenI1KD/lHsc5Wg/W6Afa2BbuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 118/399] Bluetooth: btnxpuart: Fix btnxpuart_close
Date: Mon,  1 Apr 2024 17:41:24 +0200
Message-ID: <20240401152552.711474195@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
index 1d592ac413d1f..c19dc8a2987f3 100644
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



