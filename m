Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314033C1984;
	Sat, 17 Oct 2026 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257306; cv=none; b=clO60DTSYj54QEnbpBn58IYOQAwgNgMHtICV3PT4W8I3TqS1sVtHsFaH25nIK0w1fOFsabPv0+nCz5a7l+pbcqgOEyNR6HOtyC8wEG5E2hmRa5w9jzZg3Qnq9U8UDcKiz9T2+8IU78qacPn0c8AjxF89Iojk2Yl56WyMEB889/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257306; c=relaxed/simple;
	bh=7Ubo86kwdIUoWmucdxkOE47FXTl5XnubMraWU6iXqpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtumJDVClZiD6SOXMoT2WHGbsIN8iwA3Z+e26SfzyBKBfKd5ns5sx18VYDK5XkZyTioh6Sbv/lwa+DSVDApgpYvy+4gHdSgJTyPDJUGtS36AU9syBk2VVVT6aasdx0CSkghMpjQM20Ujh+++lkb5bMLyNcjNhHDi7+C2qjQDH8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJiRrVbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJiRrVbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA641F000C6;
	Sat, 17 Oct 2026 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257305;
	bh=9zRQhIx9f4iNgHTEUgGo9WO947x2wsfs+RBF2Sma3+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJiRrVbrNYHRMhWOxBv2KKZCUahQIzvdFq199sLexD3ZKtATi7qXEM1FfPzADnFJb
	 4YtZ7SCE5OCCDYmOTHeu4Ee99qXZPNo8RLeLg7XQTMo1yH2kTcb29u5wPRDJK7nKAU
	 hQ0vImGYGLqRPxo8ODy1uRQQXOyGXbR2RYncdGjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0516/1674] Bluetooth: hci_sock: Serialize dead-device detachment
Date: Sat, 17 Oct 2026 17:46:28 +0200
Message-ID: <20261017160444.349807769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 381a0925c556a8d91a80a9b9e3e86651d60ffee3 upstream.

Rebinding an HCI socket after its controller is unregistered can race
monitor control replay and crash the kernel. hci_sock_bind() clears
hci_pi(sk)->hdev and drops the device reference under only the socket
lock, whereas send_monitor_control_replay() holds hci_sk_list.lock for
reading.

Replay can observe a non-NULL hdev, then bind can clear it and drop the
last reference before create_monitor_ctrl_open() reads hdev->id. This
can cause a NULL pointer dereference if the pointer is reloaded, or a
use-after-free if the old pointer is retained.

The kernel reported:

  KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
  RIP: 0010:create_monitor_ctrl_open+0x579/0x800
  Call Trace:
   hci_sock_bind+0xd96/0x1190
   __sys_bind+0x166/0x200
   __x64_sys_bind+0x6d/0xb0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

The same missing serialization lets hci_send_to_sock() select a socket
for the old device and queue its frame after bind has detached the socket
or installed a new binding.

Take hci_sk_list.lock for writing when clearing the device pointer and
resetting the socket state. This waits for existing replay and delivery
readers to finish before detachment and prevents later readers from
using the old binding. Keep hci_dev_put() outside the critical section
because the final device release can sleep.

Fixes: e04480920d1e ("Bluetooth: defer cleanup of resources in hci_unregister_dev()")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6 Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1218,8 +1218,10 @@ static int hci_sock_bind(struct socket *
 	 */
 	hdev = hci_pi(sk)->hdev;
 	if (hdev && hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
+		write_lock(&hci_sk_list.lock);
 		hci_pi(sk)->hdev = NULL;
 		sk->sk_state = BT_OPEN;
+		write_unlock(&hci_sk_list.lock);
 		hci_dev_put(hdev);
 	}
 	hdev = NULL;


