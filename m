Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DBE3074A4;
	Sat, 25 Oct 2025 16:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409400; cv=none; b=tZSkXuF+gpunERWqsSDejgVHd8Rr/2fqTrCGGbaBg7hKyhicvLRekmmYIKS78zkPzPX2IV3JFQ025cSR8pDFW7hfxUJmPrcohDHczew7/tLjbwMJMGM2yLnB+gxjFcT+FIAwFgci6XGTCPvPJp2EaY2fyiD1EZ5GD05XCv4S/uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409400; c=relaxed/simple;
	bh=kvOgwdQrw973c1NxaZGdn6a9qg1RHHxO83UtbFKpj0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFLjvjvfiLzRoHRSddyURyvLHh45zQdv49timIRuRhXepZMlcGodneaVJKeS7G7s160GAhDe+JvaZLlElpVaOEvX3Wt+8v8BHNj+o+fn8pFZxfM3a35gfk81rI8nDt0Q7KXG+XoLBpW6vbddfMsf2fwT2IRzawmSqQvSsBqmFXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/7MKA6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/7MKA6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E11C4CEFF;
	Sat, 25 Oct 2025 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409400;
	bh=kvOgwdQrw973c1NxaZGdn6a9qg1RHHxO83UtbFKpj0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/7MKA6fBJMJpjU0k3IL4rHozeNOwEaqZW0OMIfTp0TAj0wyXJGqw5q2XHDEq+sNO
	 /ErRrFGFVCO75E/qfFAEBXYkQQnfMsmzi5++w936pP+ePz409ih8fJadZ8+YBqFzCi
	 o97ZcNlXcHMe/kFMve9rmuB4tsXPdJijaaC6fqEU4tZHhEfayPlcZVriKJiiWOsRa3
	 iqS2G40CbMOr3m11+s3FTRu3EtUsOO8Rcl3/mdgIUIOyH3U7i2EGiYC3DADm1OlOcH
	 5Hu7X5zZFRaHKrF/iskP152qXcDcP6gb4m9y3U7ZAbJhhsUbwM+tpsOubES/AUUqH+
	 mHfCOPA1YHdDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+4ed6852d4da4606c93da@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] Bluetooth: bcsp: receive data only if registered
Date: Sat, 25 Oct 2025 11:58:57 -0400
Message-ID: <20251025160905.3857885-306-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – Guarding `bcsp_recv()` until the HCI UART core has successfully
registered the driver prevents the real NULL-deref crash syzbot found,
and the change is tiny, self-contained, and consistent with the rest of
the UART transports.

- `bcsp_complete_rx_pkt()` still hands completed frames to the core with
  `hci_recv_frame(hu->hdev, …)` (`drivers/bluetooth/hci_bcsp.c:562`), so
  if registration fails or has not finished, `hu->hdev` stays NULL and
  the dereference blows up exactly as in the reported stack trace.
- The fix adds a single early `test_bit(HCI_UART_REGISTERED…)` gate
  (`drivers/bluetooth/hci_bcsp.c:585-586`). Returning `-EUNATCH` in this
  situation matches what the other UART transports already do
  (`drivers/bluetooth/hci_h4.c:112-113`,
  `drivers/bluetooth/hci_bcm.c:698-699`, etc.), so runtime behavior
  becomes consistent across protocols.
- Callers ignore the return value and only bump stats when `hu->hdev` is
  valid (`drivers/bluetooth/hci_ldisc.c:618-631`), so refusing to
  process data before registration has no side effects beyond dropping
  input that could not be delivered anyway.
- `HCI_UART_REGISTERED` is set only after `hci_register_dev()` succeeds
  (`drivers/bluetooth/hci_ldisc.c:691-699`) and is left clear when the
  registration path fails and `hu->hdev` is nulled
  (`drivers/bluetooth/hci_ldisc.c:693-695`), so the new guard precisely
  covers the hazardous window.
- The change is minimal (two new lines), purely defensive, and fixes a
  syzbot-reported NULL dereference without touching protocol state
  machines or timing, making it an excellent candidate for stable
  backporting.

 drivers/bluetooth/hci_bcsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 664d82d1e6139..591abe6d63ddb 100644
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

