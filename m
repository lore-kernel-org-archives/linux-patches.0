Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097F4634FB;
	Tue, 23 Jan 2024 01:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975036; cv=none; b=sszIuQTIMZQx4/OFjLfaKIoE8aghqPCZVs8CN/DM5vKU7D5NmjXEZAMHfHbmOjFHK2pEb/6wuyQpL+ubf6VmcPQRcWOeP0Sv1nJqceBWMhKmSi+Ds3nqa0utfMFYsKPp0EqFg6qmdbHVyp8GmhH5i+O28jfQiDc95pFL9YGuVuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975036; c=relaxed/simple;
	bh=5g7kjPo/Olfe8KKmDyUq3QqeJtWd9g7sYvyboGp/3gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtSWzmfzW53O+k5bbJfOksf8PMaagheclpVH0pisnK46Bcak6vzBF0g1Cahtfx+oNg+0SWqc+cPxJkZmQMInFCfNGrnxwbKxJO1kYMUm87Fi9wzGYisfK6aMCu60hwzFIe82sh3KyfhEVtX3r6rDZDxSTD75PNE2s6yl+cjR1Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=av1sq6Ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="av1sq6Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD62C433C7;
	Tue, 23 Jan 2024 01:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975035;
	bh=5g7kjPo/Olfe8KKmDyUq3QqeJtWd9g7sYvyboGp/3gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=av1sq6EfSAnPMUP+LbDZICYo1V8XfIjdcKIavsJL4VsutJqAeOr7/fd0QgbdVxNJt
	 uXVXqvjYye3NGT7bQT2QnHEpehmB+L/Fo8d/+zGaF8wwAekIEIngodXF8yda/Xz5p9
	 8OMV07pr0O1XseriE/HQM1UO+e4Nm8dGZyErY3Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/583] Bluetooth: btnxpuart: fix recv_buf() return value
Date: Mon, 22 Jan 2024 15:54:17 -0800
Message-ID: <20240122235818.303880287@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 94d05394254401e503867c16aff561d3e687dfdc ]

Serdev recv_buf() callback is supposed to return the amount of bytes
consumed, therefore an int in between 0 and count.

Do not return a negative number in case of issue, just print an error
and return count. Before this change, in case of error, the returned
negative number was internally converted to 0 in ttyport_receive_buf,
now when the receive buffer is corrupted we return the size of the whole
received data (`count`). This should allow for better recovery in case
receiver/transmitter get out of sync if some data is lost.

This fixes a WARN in ttyport_receive_buf().

  Bluetooth: hci0: Frame reassembly failed (-84)
  ------------[ cut here ]------------
  serial serial0: receive_buf returns -84 (count = 6)
  WARNING: CPU: 0 PID: 37 at drivers/tty/serdev/serdev-ttyport.c:37 ttyport_receive_buf+0xd8/0xf8
  Modules linked in: mwifiex_sdio(+) ...
  CPU: 0 PID: 37 Comm: kworker/u4:2 Not tainted 6.7.0-rc2-00147-gf1a09972a45a #1
  Hardware name: Toradex Verdin AM62 WB on Verdin Development Board (DT)
  Workqueue: events_unbound flush_to_ldisc
  pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : ttyport_receive_buf+0xd8/0xf8
  lr : ttyport_receive_buf+0xd8/0xf8
...
  Call trace:
   ttyport_receive_buf+0xd8/0xf8
   flush_to_ldisc+0xbc/0x1a4
   process_scheduled_works+0x16c/0x28c

Closes: https://lore.kernel.org/all/ZWEIhcUXfutb5SY6@francesco-nb.int.toradex.com/
Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index b7e66b7ac570..951fe3014a3f 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1276,11 +1276,10 @@ static int btnxpuart_receive_buf(struct serdev_device *serdev, const u8 *data,
 	if (IS_ERR(nxpdev->rx_skb)) {
 		int err = PTR_ERR(nxpdev->rx_skb);
 		/* Safe to ignore out-of-sync bootloader signatures */
-		if (is_fw_downloading(nxpdev))
-			return count;
-		bt_dev_err(nxpdev->hdev, "Frame reassembly failed (%d)", err);
+		if (!is_fw_downloading(nxpdev))
+			bt_dev_err(nxpdev->hdev, "Frame reassembly failed (%d)", err);
 		nxpdev->rx_skb = NULL;
-		return err;
+		return count;
 	}
 	if (!is_fw_downloading(nxpdev))
 		nxpdev->hdev->stat.byte_rx += count;
-- 
2.43.0



