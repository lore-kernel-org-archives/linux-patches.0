Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B04317592;
	Tue, 30 Apr 2024 11:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476442; cv=none; b=e0tNyeglg6jcZz6AXQo1QXeppNknDtfadFnXLrxwywvqZK/IcDaehFLVvlaKd+6m1dwoxGb0JMe+0q5tbIE//Lx15c39zZQ45RLhaTHT96hAh/kA47Ff1iNrZBcX4GsUgO59h2Wn3E440jttao/tLfYM4c9tW/FsNAsNpJEl/7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476442; c=relaxed/simple;
	bh=iEEIfj/U5hYqidZh5uFCop7GLy23uzXFpOYTFaZP6rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krjWmca8P5UEESmtrqb870EZGZI8W8fWA9Wa75J3KHnO8vcMuXNDZNLrFhkoA3QBrWcInlWNj2tdyGixfGVBYJXWFv1/B114pPFsYvYEe3PpS13HyLl0UBeazLqM8wOlmjWTHqNVhUX3CxJT4R5WkrcQa0JnGnlAUuHSLNJZ0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aviCfnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aviCfnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF26FC2BBFC;
	Tue, 30 Apr 2024 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476442;
	bh=iEEIfj/U5hYqidZh5uFCop7GLy23uzXFpOYTFaZP6rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aviCfnLQRSc7aXhBKqH/GqTf0xs2fA/LqXWP4ckajwdqDpUj6NSk/D/vyZ3YUcaR
	 VdTq0AfMg+vojZviSkkNjoLWOmUFW9Fzt8NnkTPrLLa/P+DpQY5U6n8y31s8QZV5Nd
	 9k31gFSWcv3Pxvid+rFw6uFTcgy/kCVtergmbN3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/110] ax25: Fix netdev refcount issue
Date: Tue, 30 Apr 2024 12:40:02 +0200
Message-ID: <20240430103048.546745310@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 467324bcfe1a31ec65d0cf4aa59421d6b7a7d52b ]

The dev_tracker is added to ax25_cb in ax25_bind(). When the
ax25 device is detaching, the dev_tracker of ax25_cb should be
deallocated in ax25_kill_by_device() instead of the dev_tracker
of ax25_dev. The log reported by ref_tracker is shown below:

[   80.884935] ref_tracker: reference already released.
[   80.885150] ref_tracker: allocated in:
[   80.885349]  ax25_dev_device_up+0x105/0x540
[   80.885730]  ax25_device_event+0xa4/0x420
[   80.885730]  notifier_call_chain+0xc9/0x1e0
[   80.885730]  __dev_notify_flags+0x138/0x280
[   80.885730]  dev_change_flags+0xd7/0x180
[   80.885730]  dev_ifsioc+0x6a9/0xa30
[   80.885730]  dev_ioctl+0x4d8/0xd90
[   80.885730]  sock_do_ioctl+0x1c2/0x2d0
[   80.885730]  sock_ioctl+0x38b/0x4f0
[   80.885730]  __se_sys_ioctl+0xad/0xf0
[   80.885730]  do_syscall_64+0xc4/0x1b0
[   80.885730]  entry_SYSCALL_64_after_hwframe+0x67/0x6f
[   80.885730] ref_tracker: freed in:
[   80.885730]  ax25_device_event+0x272/0x420
[   80.885730]  notifier_call_chain+0xc9/0x1e0
[   80.885730]  dev_close_many+0x272/0x370
[   80.885730]  unregister_netdevice_many_notify+0x3b5/0x1180
[   80.885730]  unregister_netdev+0xcf/0x120
[   80.885730]  sixpack_close+0x11f/0x1b0
[   80.885730]  tty_ldisc_kill+0xcb/0x190
[   80.885730]  tty_ldisc_hangup+0x338/0x3d0
[   80.885730]  __tty_hangup+0x504/0x740
[   80.885730]  tty_release+0x46e/0xd80
[   80.885730]  __fput+0x37f/0x770
[   80.885730]  __x64_sys_close+0x7b/0xb0
[   80.885730]  do_syscall_64+0xc4/0x1b0
[   80.885730]  entry_SYSCALL_64_after_hwframe+0x67/0x6f
[   80.893739] ------------[ cut here ]------------
[   80.894030] WARNING: CPU: 2 PID: 140 at lib/ref_tracker.c:255 ref_tracker_free+0x47b/0x6b0
[   80.894297] Modules linked in:
[   80.894929] CPU: 2 PID: 140 Comm: ax25_conn_rel_6 Not tainted 6.9.0-rc4-g8cd26fd90c1a #11
[   80.895190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qem4
[   80.895514] RIP: 0010:ref_tracker_free+0x47b/0x6b0
[   80.895808] Code: 83 c5 18 4c 89 eb 48 c1 eb 03 8a 04 13 84 c0 0f 85 df 01 00 00 41 83 7d 00 00 75 4b 4c 89 ff 9
[   80.896171] RSP: 0018:ffff888009edf8c0 EFLAGS: 00000286
[   80.896339] RAX: 1ffff1100141ac00 RBX: 1ffff1100149463b RCX: dffffc0000000000
[   80.896502] RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff88800a0d6518
[   80.896925] RBP: ffff888009edf9b0 R08: ffff88806d3288d3 R09: 1ffff1100da6511a
[   80.897212] R10: dffffc0000000000 R11: ffffed100da6511b R12: ffff88800a4a31d4
[   80.897859] R13: ffff88800a4a31d8 R14: dffffc0000000000 R15: ffff88800a0d6518
[   80.898279] FS:  00007fd88b7fe700(0000) GS:ffff88806d300000(0000) knlGS:0000000000000000
[   80.899436] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.900181] CR2: 00007fd88c001d48 CR3: 000000000993e000 CR4: 00000000000006f0
...
[   80.935774] ref_tracker: sp%d@000000000bb9df3d has 1/1 users at
[   80.935774]      ax25_bind+0x424/0x4e0
[   80.935774]      __sys_bind+0x1d9/0x270
[   80.935774]      __x64_sys_bind+0x75/0x80
[   80.935774]      do_syscall_64+0xc4/0x1b0
[   80.935774]      entry_SYSCALL_64_after_hwframe+0x67/0x6f

Change ax25_dev->dev_tracker to the dev_tracker of ax25_cb
in order to mitigate the bug.

Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20240419020456.29826-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6b4c25a923774..0bffac238b615 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -103,7 +103,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			s->ax25_dev = NULL;
 			if (sk->sk_socket) {
 				netdev_put(ax25_dev->dev,
-					   &ax25_dev->dev_tracker);
+					   &s->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
 			ax25_cb_del(s);
-- 
2.43.0



