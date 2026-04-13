Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8B26ED41;
	Mon, 13 Apr 2026 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097912; cv=none; b=JJnp/WIzCUU2tbtk4n8SfvrVEn0sqnWSjN1a3onzHO3XYzI8hTUDrfHPd9z5Bz7buiOuqKEhA0d8z8DrUWvKs+ZaXEF7NqZPFfDdXmkAM3dRF/HCVMYxNUjlBmPSiP8FXQSxCte2W+I+GeduAvtyT7q407nGvHYHAMbANWnaoU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097912; c=relaxed/simple;
	bh=nxcrBVKnrhHcXFSdjjI1v2LYZV8oQLjQwsPQNImYgsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYckQIpzaoUfuH6/ZgYmp/SDDzWJ8mDCnbz0tA342h4rh1KqNP5qatFMqgVL1pdb6EhlncQRBArIfhKgtNHaVc9nK949UdAUQPgaEWSzXRnicjDKhPEI0tY5i2JAoFYQiQWtcRnlVu9V9hAdVhGTXfQOq547vTewYrHq6IoAuqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGu4KqLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGu4KqLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AD6C2BCAF;
	Mon, 13 Apr 2026 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097911;
	bh=nxcrBVKnrhHcXFSdjjI1v2LYZV8oQLjQwsPQNImYgsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGu4KqLgCdfCNohesgfZNQxV6V7HPeYFev3N+i5OalKBI50R+pwvixlFogQeFZpvw
	 5CVlVDzPoTMHDSYdVeeCaVlTYS9ujMy/F2IIdRoUI/rn1lVOgKxDYbFzSNPQs2iyzO
	 4oNAEKBp8zNV5iI9xtXq6NriUK+Ywuk1q4BOvQ/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/570] Bluetooth: L2CAP: Fix null-ptr-deref on l2cap_sock_ready_cb
Date: Mon, 13 Apr 2026 17:57:31 +0200
Message-ID: <20260413155842.482871706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

[ Upstream commit b6552e0503973daf6f23bd6ed9273ef131ee364f ]

Before using sk pointer, check if it is null.

Fix the following:

 KASAN: null-ptr-deref in range [0x0000000000000260-0x0000000000000267]
 CPU: 0 UID: 0 PID: 5985 Comm: kworker/0:5 Not tainted 7.0.0-rc4-00029-ga989fde763f4 #1 PREEMPT(full)
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-9.fc43 06/10/2025
 Workqueue: events l2cap_info_timeout
 RIP: 0010:kasan_byte_accessible+0x12/0x30
 Code: 79 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c 08 0f 92 c0 c3 cc cce
 veth0_macvtap: entered promiscuous mode
 RSP: 0018:ffffc90006e0f808 EFLAGS: 00010202
 RAX: dffffc0000000000 RBX: ffffffff89746018 RCX: 0000000080000001
 RDX: 0000000000000000 RSI: ffffffff89746018 RDI: 000000000000004c
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
 R10: dffffc0000000000 R11: ffffffff8aae3e70 R12: 0000000000000000
 R13: 0000000000000260 R14: 0000000000000260 R15: 0000000000000001
 FS:  0000000000000000(0000) GS:ffff8880983c2000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005582615a5008 CR3: 000000007007e000 CR4: 0000000000752ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  __kasan_check_byte+0x12/0x40
  lock_acquire+0x79/0x2e0
  lock_sock_nested+0x48/0x100
  ? l2cap_sock_ready_cb+0x46/0x160
  l2cap_sock_ready_cb+0x46/0x160
  l2cap_conn_start+0x779/0xff0
  ? __pfx_l2cap_conn_start+0x10/0x10
  ? l2cap_info_timeout+0x60/0xa0
  ? __pfx___mutex_lock+0x10/0x10
  l2cap_info_timeout+0x68/0xa0
  ? process_scheduled_works+0xa8d/0x18c0
  process_scheduled_works+0xb6e/0x18c0
  ? __pfx_process_scheduled_works+0x10/0x10
  ? assign_work+0x3d5/0x5e0
  worker_thread+0xa53/0xfc0
  kthread+0x388/0x470
  ? __pfx_worker_thread+0x10/0x10
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x51e/0xb90
  ? __pfx_ret_from_fork+0x10/0x10
 veth1_macvtap: entered promiscuous mode
  ? __switch_to+0xc7d/0x1450
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 Modules linked in:
 ---[ end trace 0000000000000000 ]---
 batman_adv: batadv0: Interface activated: batadv_slave_0
 batman_adv: batadv0: Interface activated: batadv_slave_1
 netdevsim netdevsim7 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
 netdevsim netdevsim7 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
 netdevsim netdevsim7 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
 netdevsim netdevsim7 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
 RIP: 0010:kasan_byte_accessible+0x12/0x30
 Code: 79 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c 08 0f 92 c0 c3 cc cce
 ieee80211 phy39: Selected rate control algorithm 'minstrel_ht'
 RSP: 0018:ffffc90006e0f808 EFLAGS: 00010202
 RAX: dffffc0000000000 RBX: ffffffff89746018 RCX: 0000000080000001
 RDX: 0000000000000000 RSI: ffffffff89746018 RDI: 000000000000004c
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
 R10: dffffc0000000000 R11: ffffffff8aae3e70 R12: 0000000000000000
 R13: 0000000000000260 R14: 0000000000000260 R15: 0000000000000001
 FS:  0000000000000000(0000) GS:ffff8880983c2000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f7e16139e9c CR3: 000000000e74e000 CR4: 0000000000752ef0
 PKRU: 55555554
 Kernel panic - not syncing: Fatal exception

Fixes: 54a59aa2b562 ("Bluetooth: Add l2cap_chan->ops->ready()")
Signed-off-by: Helen Koike <koike@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 8e2e6d1a6dd15..faaa5e4525c07 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1649,6 +1649,9 @@ static void l2cap_sock_ready_cb(struct l2cap_chan *chan)
 	struct sock *sk = chan->data;
 	struct sock *parent;
 
+	if (!sk)
+		return;
+
 	lock_sock(sk);
 
 	parent = bt_sk(sk)->parent;
-- 
2.51.0



