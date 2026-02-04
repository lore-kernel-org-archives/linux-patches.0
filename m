Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CE82DCF61;
	Wed,  4 Feb 2026 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218622; cv=none; b=fZbi/ABF2Lch0grPczaWWqpiDvr5LdytVx7U8GIcUfADD1TZMArtdG8M5BhdOcE5WSZDEPG0eMw3hDYaFv2RQYTtL6h/HFbShsgBgl32P/L7JiG0lAj7zjBcWz8j62jaNvbv2o89EJyGCAG5qjVDg6dbA22a/BLyeY9qE1B07ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218622; c=relaxed/simple;
	bh=ZEivupDTlLBTH+Buyb7K6pcho3UgNqQ3EW6TcGLdsIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKWowv1a7kWjW6+eozNm1COCGvNBhOZCfNti7iKCKoIa9v8HA6s4xoNxq6ARabbY+VqoqaaoZdBvtQkGRlWzSo8t0qC69maI/f0yWjkFA+BdPsM5C94T49kim243EUTNFLKSkhRspbvsWI37L78U2LM7JJvvlt1/YeUBB0WEXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InmyqMFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InmyqMFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF30C4CEF7;
	Wed,  4 Feb 2026 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218622;
	bh=ZEivupDTlLBTH+Buyb7K6pcho3UgNqQ3EW6TcGLdsIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InmyqMFxSJrMayWWWmYMZo0XSbpiEyXxfrUarX1F4PNc7ASwWBhf6o+v/zfykAC0M
	 0q5k79KN6d+Kwu2Pw45rEnUWeVZ8CHM07UrJL8wa9goLsNxwfjOynXem1FpgRskNgC
	 y+n+vC0juVEo6D+nnzXNvxK66M4ESl2LT6nS3N/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Hong Su <s11242586@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 02/87] Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work
Date: Wed,  4 Feb 2026 15:40:00 +0100
Message-ID: <20260204143846.999685580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f322f890b81f..436ee77d4bf2f 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -685,6 +685,8 @@ static int hci_uart_register_dev(struct hci_uart *hu)
 		return err;
 	}
 
+	set_bit(HCI_UART_PROTO_INIT, &hu->flags);
+
 	if (test_bit(HCI_UART_INIT_PENDING, &hu->hdev_flags))
 		return 0;
 
@@ -712,8 +714,6 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
 	hu->proto = p;
 
-	set_bit(HCI_UART_PROTO_INIT, &hu->flags);
-
 	err = hci_uart_register_dev(hu);
 	if (err) {
 		return err;
-- 
2.51.0



