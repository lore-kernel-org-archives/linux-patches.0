Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E79E2417E0;
	Wed,  4 Feb 2026 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218952; cv=none; b=lkkGwyh52rue8ERZdjWPU5b27Fk03xXxEdSmZ2c5B75UI8Tk3uzxDeGnrN8JukVK5qae4XIWMu/gfMrq67G4fxjbaIzimd/L920HYYl6KGRZRBNq5sI1i3Wxoyg4DtGdF1WY/UfjI+TmDLjKCzaXVoeBTcbIBZjZFolwUn+SD1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218952; c=relaxed/simple;
	bh=wtRkzSxgrF/043SAQ1MFnqVibQhMzfmsYu1FN1tn2Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meBBSPlgeZueWFSJmHacsHgfBsgH+yW9DvKT48WbEyJ1ZEIUwYeMBQyRg6onFh4DgQl3Eiist9QHoZQoVXpk9uiLvz6LwGRzt0PCjXqDSUsbFOzQRToA/8Ye38aqirofdgddSepOGZv6PQ9F/2F6L/Gs81JMIcjTmypExbDPc58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V402gZTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V402gZTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CCCC4CEF7;
	Wed,  4 Feb 2026 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218951;
	bh=wtRkzSxgrF/043SAQ1MFnqVibQhMzfmsYu1FN1tn2Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V402gZThUDhhmgR571/9mOtkbuPfa6wYfKEV3wcTUVjkOohSg2y8+/XlHWDBNzpdG
	 6om6HpsYFg/qnx0HAGktThAG3/X0r4/FP+nvnTeSj32HpbT6t1wz3MVw5WzZHSUuPH
	 HN1lNORKozHl0yIIn4f5a5SbIFfg0VDsi5ingc7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Hong Su <s11242586@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/122] Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work
Date: Wed,  4 Feb 2026 15:39:46 +0100
Message-ID: <20260204143852.021488357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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
index d0adae3267b41..2b28515de92c4 100644
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



