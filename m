Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21C45013AA;
	Tue, 13 Oct 2026 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896001; cv=none; b=HvDqCpqv3HeFdWc08svIulul1ZsKit7VrWFrusfhQU3PbIQcYB4PnpXFXKVOfXUO/zfMZ0Rpakr73U37teakZfcGiBuJqYoeY5Mm9R0YIXI8zSyUw7Nk3j5s+a0wMhnfya7qvZtWAk1Z8h6gKR0DS0b8FDh505WX12y69ntmSKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896001; c=relaxed/simple;
	bh=VycmRM1SZ/clsO6FcMMx1boJnE7Cm3PmQBB/dVbl/Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dq5nOnZVjRwi6j8OUHVhpls9pzXZzl/wJRiw2dqlZIx8cry56IcF/VSQ/i7hhrkOU0/9NrBNFdbKw1ZvAplxMJ3+iAB/fy4J8ARCjUB3VLJNzPV4hbcnFtdOJoJSAdjXMzY7D6yUi4iUwPI3+OlmM0YPob0RcDOQ+hLxitkW+AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYefLMgM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYefLMgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A5C1F000FF;
	Tue, 13 Oct 2026 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896000;
	bh=kU0oLHjUDIgVpDQ+0A/mep4pKwUC8uLeLBkgoxxNccc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYefLMgMNBLmnWFC/soeErLaNJwOJpIEDMJX61KW+8dt2nBzjcIgQQyksm4yOYOj6
	 sQk5yrEOFvZipef6e7XKfIwvwL9sq/Z9MmlzuafNHtdPesSmfC0iN1PjfATbhPT0Bv
	 MnRJUpmBArYuEk16pmxYsewvHSdhFOyeb7Ird96I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 420/497] Bluetooth: hci_sock: Serialize dead-device detachment
Date: Tue, 13 Oct 2026 13:39:47 +0200
Message-ID: <20261013112917.856000263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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


