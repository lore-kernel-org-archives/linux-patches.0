Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64645369993;
	Wed,  3 Dec 2025 16:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779465; cv=none; b=cexN0nunRx9Hd12r52PJeo6eI/tU4aueAk4RnlPzN/PQ2nBLPzveoCYbDHUXAneh3RVgER0ZYvmFk+TeZv5f8cbe+5fm3Rz+JW/m/NCFqvqITWN5VrDvyB6XtWRZDR6EFWx0ZIarLhIq1OhBYIv04atVGENqe5PIgbt/jr+Qmbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779465; c=relaxed/simple;
	bh=FbmdB5F6cEPS1eAOuqK2Va3Y+YtG1LabIn/lkLDkQ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej2sUmWc882Jtwckr9eTwboXiPAzCC9DtJvzxCHoW+ZNnyDmTg2ASn0dWNwLSs2Pt55HooEjvTxugR1b0ubyl8vl1nK20NIELEnre+BOptsJ6XVyaJNNLuIp7PZJLfTU+37Nn1WFUCglm+iTAqpk+Vlm70/0eaFwcr/jfjH7R0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/ksSYQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/ksSYQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2586C4CEF5;
	Wed,  3 Dec 2025 16:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779465;
	bh=FbmdB5F6cEPS1eAOuqK2Va3Y+YtG1LabIn/lkLDkQ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/ksSYQ0nqae2MGNckizQWuHGLeMCxMUQYnBs55ipXrgblGgx4h/hB0IupiS/ZWRD
	 AG6dm1ill4iBKkj4hbTWzsaPlCdtrt62hy5QxJt4Zb/3vtpmOPGtqo4HcNhy49OFg3
	 z0jJBf/qC1uIraGduQ2JwbyHtEUNZNRVJMsbD2A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4ed6852d4da4606c93da@syzkaller.appspotmail.com,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/568] Bluetooth: bcsp: receive data only if registered
Date: Wed,  3 Dec 2025 16:24:27 +0100
Message-ID: <20251203152450.423404313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Pravdin <ipravdin.official@gmail.com>

[ Upstream commit ca94b2b036c22556c3a66f1b80f490882deef7a6 ]

Currently, bcsp_recv() can be called even when the BCSP protocol has not
been registered. This leads to a NULL pointer dereference, as shown in
the following stack trace:

    KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
    RIP: 0010:bcsp_recv+0x13d/0x1740 drivers/bluetooth/hci_bcsp.c:590
    Call Trace:
     <TASK>
     hci_uart_tty_receive+0x194/0x220 drivers/bluetooth/hci_ldisc.c:627
     tiocsti+0x23c/0x2c0 drivers/tty/tty_io.c:2290
     tty_ioctl+0x626/0xde0 drivers/tty/tty_io.c:2706
     vfs_ioctl fs/ioctl.c:51 [inline]
     __do_sys_ioctl fs/ioctl.c:907 [inline]
     __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
     do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

To prevent this, ensure that the HCI_UART_REGISTERED flag is set before
processing received data. If the protocol is not registered, return
-EUNATCH.

Reported-by: syzbot+4ed6852d4da4606c93da@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4ed6852d4da4606c93da
Tested-by: syzbot+4ed6852d4da4606c93da@syzkaller.appspotmail.com
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 8055f63603f45..8ff69111ceede 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -582,6 +582,9 @@ static int bcsp_recv(struct hci_uart *hu, const void *data, int count)
 	struct bcsp_struct *bcsp = hu->priv;
 	const unsigned char *ptr;
 
+	if (!test_bit(HCI_UART_REGISTERED, &hu->flags))
+		return -EUNATCH;
+
 	BT_DBG("hu %p count %d rx_state %d rx_count %ld",
 	       hu, count, bcsp->rx_state, bcsp->rx_count);
 
-- 
2.51.0



