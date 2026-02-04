Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4E92C08AC;
	Wed,  4 Feb 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216541; cv=none; b=my8ZTxCZlg3M0FVeY9tDqw2Ps5yPTJFTQxFM5i25o2DI1Xz+8A8fq4qSsF54z/LaDx5Woj2klx3OypBDSfaG1yBnvxOiN8pm9JXc8f/KKyWl8aFn6Nqrg+s/QmNEj0eLkXpzzqQZmLvAwHmA5CmotbZ00GXNhlK94tcqv10e2nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216541; c=relaxed/simple;
	bh=i77LEJQcugac6NGynHcYc0q5IFrTRWi/xcgU6J2nsn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d95JVmsg0RGWV3qk24yTAuGLx11Hyey7QQc+xx5p3rvbhnfMBALruuSrns0Wx49GAi5+pmhqUp42y1Ij0hH+BIFQcElNF6kB50CbZzfC/7CnErgaQBC2rrKurruSUFYgmqw5KB74vn2WbXmRMjIAjZ3EfJlxlzFSYzh0xUUy2Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pb+sO1vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pb+sO1vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3A1C4CEF7;
	Wed,  4 Feb 2026 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216541;
	bh=i77LEJQcugac6NGynHcYc0q5IFrTRWi/xcgU6J2nsn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pb+sO1vi7Wiq8PIq4kVWFLoSqfPre7fIyjgqtpzkkMNekKNwWB2Syc6mM563B9EZo
	 esXSGjQzbgzlGi/0svoZH1E+WJPkXcVro438uHzI1IrytJWz7jkQw+uorlPnPyR/jy
	 SKKwivbhZYKb0RUGjUEHCq0+KJwDrZ8UfG/y+d6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Hong Su <s11242586@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/161] Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work
Date: Wed,  4 Feb 2026 15:39:41 +0100
Message-ID: <20260204143855.993027063@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Jia-Hong Su <s11242586@gmail.com>

[ Upstream commit 0c3cd7a0b862c37acbee6d9502107146cc944398 ]

hci_uart_set_proto() sets HCI_UART_PROTO_INIT before calling
hci_uart_register_dev(), which calls proto->open() to initialize
hu->priv. However, if a TTY write wakeup occurs during this window,
hci_uart_tx_wakeup() may schedule write_work before hu->priv is
initialized, leading to a NULL pointer dereference in
hci_uart_write_work() when proto->dequeue() accesses hu->priv.

The race condition is:

  CPU0                              CPU1
  ----                              ----
  hci_uart_set_proto()
    set_bit(HCI_UART_PROTO_INIT)
    hci_uart_register_dev()
                                    tty write wakeup
                                      hci_uart_tty_wakeup()
                                        hci_uart_tx_wakeup()
                                          schedule_work(&hu->write_work)
      proto->open(hu)
        // initializes hu->priv
                                    hci_uart_write_work()
                                      hci_uart_dequeue()
                                        proto->dequeue(hu)
                                          // accesses hu->priv (NULL!)

Fix this by moving set_bit(HCI_UART_PROTO_INIT) after proto->open()
succeeds, ensuring hu->priv is initialized before any work can be
scheduled.

Fixes: 5df5dafc171b ("Bluetooth: hci_uart: Fix another race during initialization")
Link: https://lore.kernel.org/linux-bluetooth/6969764f.170a0220.2b9fc4.35a7@mx.google.com/

Signed-off-by: Jia-Hong Su <s11242586@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 93bb58971dbe6..436d82a7f5871 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -684,6 +684,8 @@ static int hci_uart_register_dev(struct hci_uart *hu)
 		return err;
 	}
 
+	set_bit(HCI_UART_PROTO_INIT, &hu->flags);
+
 	if (test_bit(HCI_UART_INIT_PENDING, &hu->hdev_flags))
 		return 0;
 
@@ -711,8 +713,6 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
 	hu->proto = p;
 
-	set_bit(HCI_UART_PROTO_INIT, &hu->flags);
-
 	err = hci_uart_register_dev(hu);
 	if (err) {
 		return err;
-- 
2.51.0



