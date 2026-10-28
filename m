Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209071;
	b=NWIn/vEhgJC7/gsuheVlJmoqxqcMNwWpz/M97OaxtNOyjUF2q848U9w4baXEEgYcobjR
	 QUH33vuZ2RTYXAOBffqj0mJzDFzblv65VGA9gNPa4JcXi0kY3WOcytR8p7JC51DkQwbjH
	 RLPzV5i4/oHS6rucDRpcQc2Bkf7mqjOU6hN0cEOncmENVZrXbDRRj77CPA2NNErKZWHmu
	 iBk1cm+88MXwsMWCHrKG/7g9t8K3WyOrDHHqETVxAv9yLJ7g9e2ECQVgmfCDVey2VRBAb
	 IbEmMr3I0PFFYpCASRoU24bKkwOUcZG+Si8pfM9F+boLnZjAebpZJmZtnhvi/mOcUKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/LQfrIvUqTSFZIkpLXcc0WYGQpbJadm0FeUPQEqUao=;
	b=TgcAKFVcxHFCODkG148rpQeZdml3JqPVGAknnmFAqZcsq0+5QuTVUkDaFvR4yysivH0F
	 Qol+ZANjxwaGq8WNbA4erlvrJXJagzQX4xNFDFYSNRUHwDTFekTXAPfQyZ15FpAM0jdJz
	 x9rYzTwJA06Enx5M986qDCMnQvdij3JHKPXoYMMzvz1Fn/ZKBb80VwdpeTwktX7TO12xN
	 +O8x8a0DaLWqHK44sW6Jxm5tLjhPWOMvfi/Y9K2TGUsTECmFks65mKAsxG/MOwBoEfUYD
	 LBeHapHYZ4OIF+iC41d1qx9EEIX4ck65ooDZgX6PYkYQ7QsYoFsMUHQ7OEfBs+h9tRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh2FZd+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19553606A33E;
	Wed, 28 Oct 2026 17:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh2FZd+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668C31F031E5;
	Wed, 28 Oct 2026 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209071;
	bh=1/LQfrIvUqTSFZIkpLXcc0WYGQpbJadm0FeUPQEqUao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh2FZd+RJTL5hYwJfqJ+iYRqm3xVg0i0PLgNufOhYRZcAmNWJkhpKxz8sdF3/N2u+
	 ky0jwitYYRAs35OtvhYdlEX07XrjaXRc0MCYEc0s+dS9/Dmzdb6iouSVScLCyWjCYu
	 Cs4DT/rSfyaQpLOmmXwVZwZXfAbMQw7dDaLPy/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 343/516] Bluetooth: hci_sock: Serialize dead-device detachment
Date: Wed, 28 Oct 2026 17:58:15 +0100
Message-ID: <20261028170011.612722708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


