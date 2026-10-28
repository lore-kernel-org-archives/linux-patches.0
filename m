Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211439;
	b=UE47wtA945bQT7daWZi438znKdyDqztV5VjdzWzs49usswXWkDLzrvtl3qvNg2VNAvox
	 SblMLh6kgYlXi0hTPiLLII8zdUhD7HarlJd8olz381l+2sQ+yvH5CKEXhD9GipoZ3nen9
	 7ZmOvDj/jYwclRyUl80kJ6NQ8jQrJZBhuyaXpWCBH9yo7V6/kxDhJhTsZQtcZrdBZCMrw
	 Vl7mcoaH7jUzKkEAJp/FrWH4H9V7RuNuCknwpyH3FqsbnYtEYcZp2NOTEl+3PChRV5wvv
	 J3DOJqGeqn94nUPiKji05OUR1cDT7MtIi/vdJ7u340KjV4n3qvcS4Qs2pOgBfrNmy9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jh2UJjN/Ms9HZgxm1KFbT2UnixrvSjtW4crZFkGZMvc=;
	b=y96TyLzErUqEHrSP480HBxU/BnZNEz/QlcmFYmZOsdKDY8kpMjJZnLyZLEivRk8i/ofP
	 a5X4jTimx7/8XSVPPBy7TTHJpZzUMATrUThGv+GpOqXa2xEHUxeyhr8LVloo8fdw4mivj
	 MfqtTrPA/H+LDjlmKBc4sfPRe3wyp2Ij8klv5RPe1h/OItAIf7QJ2UutAiaPMErJ8bvUe
	 4WDmwktQtUmnkGO7ynQ7N4/VHIoYcMrgjq2dMz4cuj9ECr6/9Vnb1Ww1VcJgb7p/p0jTL
	 7X1fc+83bxTTufGm4hRqi2Rp+82lx6goTUVa6N2xH0LzrU1f4rhCR0MO8cPfLQjDOJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzjgAS6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033F1606A327;
	Wed, 28 Oct 2026 18:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzjgAS6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551921F01828;
	Wed, 28 Oct 2026 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211438;
	bh=Jh2UJjN/Ms9HZgxm1KFbT2UnixrvSjtW4crZFkGZMvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzjgAS6vbtDnD6JmQSwtNq4lPDqDvXD6N2/gyjDg2Jx/3GJ8hbInDD8Oem4BuRs4l
	 r3Y+Yhh3g6VNffWh0RnWcfRvaDQ1870d7m6InxkvBpFClh2wYgaX9DKfy2TlGRBty7
	 4hkFTrryNoJQcUmes1urJkrzKQGF0FLvth6F0+8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 379/571] Bluetooth: hci_sock: Serialize dead-device detachment
Date: Wed, 28 Oct 2026 17:58:46 +0100
Message-ID: <20261028170017.005050962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1157,8 +1157,10 @@ static int hci_sock_bind(struct socket *
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


