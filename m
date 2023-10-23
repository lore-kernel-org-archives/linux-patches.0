Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E7715E87
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bz8exB69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16191C433C7;
	Mon, 23 Oct 2023 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060706;
	bh=yXoaaCIouEmrPlzvyfPczOfAo3HQJEos4ypNdxF2bAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz8exB691MFiUSPliBt+X5arjkoR3jwORKjzm2p/10LDX4id/5PVVb/HEsUWtzJcG
	 V26E6paHCFi42ts9b880trLXPOFj28HIcpHrJQt04FPBjV8sxmSGXg9gGLD7yU9mBJ
	 RCRxR89c8gU5fa3vb1sTjW7L57bnpmemk3tt9gEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 065/123] tun: prevent negative ifindex
Date: Mon, 23 Oct 2023 12:57:03 +0200
Message-ID: <20231023104819.858334323@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit cbfbfe3aee718dc4c3c837f5d2463170ee59d78c upstream.

After commit 956db0a13b47 ("net: warn about attempts to register
negative ifindex") syzbot is able to trigger the following splat.

Negative ifindex are not supported.

WARNING: CPU: 1 PID: 6003 at net/core/dev.c:9596 dev_index_reserve+0x104/0x210
Modules linked in:
CPU: 1 PID: 6003 Comm: syz-executor926 Not tainted 6.6.0-rc4-syzkaller-g19af4a4ed414 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/06/2023
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : dev_index_reserve+0x104/0x210
lr : dev_index_reserve+0x100/0x210
sp : ffff800096a878e0
x29: ffff800096a87930 x28: ffff0000d04380d0 x27: ffff0000d04380f8
x26: ffff0000d04380f0 x25: 1ffff00012d50f20 x24: 1ffff00012d50f1c
x23: dfff800000000000 x22: ffff8000929c21c0 x21: 00000000ffffffea
x20: ffff0000d04380e0 x19: ffff800096a87900 x18: ffff800096a874c0
x17: ffff800084df5008 x16: ffff80008051f9c4 x15: 0000000000000001
x14: 1fffe0001a087198 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
x8 : ffff0000d41c9bc0 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff800091763d88 x4 : 0000000000000000 x3 : ffff800084e04748
x2 : 0000000000000001 x1 : 00000000fead71c7 x0 : 0000000000000000
Call trace:
dev_index_reserve+0x104/0x210
register_netdevice+0x598/0x1074 net/core/dev.c:10084
tun_set_iff+0x630/0xb0c drivers/net/tun.c:2850
__tun_chr_ioctl+0x788/0x2af8 drivers/net/tun.c:3118
tun_chr_ioctl+0x38/0x4c drivers/net/tun.c:3403
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:871 [inline]
__se_sys_ioctl fs/ioctl.c:857 [inline]
__arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:857
__invoke_syscall arch/arm64/kernel/syscall.c:37 [inline]
invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:51
el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:136
do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:155
el0_svc+0x58/0x16c arch/arm64/kernel/entry-common.c:678
el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:696
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:595
irq event stamp: 11348
hardirqs last enabled at (11347): [<ffff80008a716574>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last enabled at (11347): [<ffff80008a716574>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:194
hardirqs last disabled at (11348): [<ffff80008a627820>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:436
softirqs last enabled at (11138): [<ffff8000887ca53c>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
softirqs last enabled at (11138): [<ffff8000887ca53c>] release_sock+0x15c/0x1b0 net/core/sock.c:3531
softirqs last disabled at (11136): [<ffff8000887ca41c>] spin_lock_bh include/linux/spinlock.h:356 [inline]
softirqs last disabled at (11136): [<ffff8000887ca41c>] release_sock+0x3c/0x1b0 net/core/sock.c:3518

Fixes: fb7589a16216 ("tun: Add ability to create tun device with given index")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20231016180851.3560092-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3134,10 +3134,11 @@ static long __tun_chr_ioctl(struct file
 	struct net *net = sock_net(&tfile->sk);
 	struct tun_struct *tun;
 	void __user* argp = (void __user*)arg;
-	unsigned int ifindex, carrier;
+	unsigned int carrier;
 	struct ifreq ifr;
 	kuid_t owner;
 	kgid_t group;
+	int ifindex;
 	int sndbuf;
 	int vnet_hdr_sz;
 	int le;
@@ -3194,7 +3195,9 @@ static long __tun_chr_ioctl(struct file
 		ret = -EFAULT;
 		if (copy_from_user(&ifindex, argp, sizeof(ifindex)))
 			goto unlock;
-
+		ret = -EINVAL;
+		if (ifindex < 0)
+			goto unlock;
 		ret = 0;
 		tfile->ifindex = ifindex;
 		goto unlock;


