Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971494F390D;
	Tue, 13 Oct 2026 12:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893074; cv=none; b=csLfrBN9KFOzy/ta4LaRRIKmm8KapgZ3/IXmMf4T0PNjMbpgEvmESGXVBGeVb6vybxlQKR8EBfqs1KEzpT4DxW41nyz3BYbipoHbP2rLWt/ZizTwyREE9H6x/6by/OUsPxQ37D2h/Zte6mnWjYUWTrGsng6bBr0O6lmRYHKECZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893074; c=relaxed/simple;
	bh=pi41zExv3TA/yF8KO8wGVcnopofq+k7U0uYmHYi5HTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhJG+3XPCIuiqV2zRcPsGlpf+UXIAawc/vK7f4saH2cVNZSAN0r2Jw01ela+0/BVsX5/vVI3ASYgyrZ4lMYy96BP3Oh4EM4RAJP92EGgOJmFw0oiuBuEV4TrM8SC+9qX+6TPSC4Kx0GuMOIf98C45F6Veq2K85SZDsQZiyPljmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kC/LPlP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kC/LPlP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AA51F000FF;
	Tue, 13 Oct 2026 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893073;
	bh=qBX5NSjfSa7cHbL8w+LU6bAhHH/ux/BujEvCznZQ4xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kC/LPlP6lnvGMHt0vi4o3oCEQ1IcPOpK81OXXoYSfIgucL9AIv1MxySrb58NG10ly
	 DjQm4z6wm5RWwk3NJwA9FmhR0PJ1uagweiYTUlhPoNiISbtP9rxrmtgDnaubTdZwPY
	 5MEMb79f4gU2+j8c81boUf4a4m+hq3i6+UPhM6nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 102/621] Bluetooth: hci_sock: Serialize dead-device detachment
Date: Tue, 13 Oct 2026 13:31:37 +0200
Message-ID: <20261013112923.267908439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
@@ -1225,8 +1225,10 @@ static int hci_sock_bind(struct socket *
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


