Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12C11C3BF1;
	Wed, 19 Feb 2025 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953891; cv=none; b=FPA8yzl+ZGcIJPTv9CkHdsPnORyi2M7P4c/7cn7PCSmGyzw26Mg6uDJCKaNNpO831302bJ7rua+Kkii6KjUf7RZuwYt8n/AlBNwRgq22nb0tI/FfCHzUTaoByqPC3amZ0GwNw4JDyxTy8/MK/eg1iPQbaEgf294Y3l1gjkV4Sao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953891; c=relaxed/simple;
	bh=W1Ye5HSQfLD/b4yePV3c8fYlDYbwW4B5wHYxKkkzSIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtsnHw15l05p6w6HSquz4veZ0lsdoLJpuyc+FeHZB5PZpzu7GRUa51yXzuQXT0S72WZ9Kvl/Nlc/n8jyxD+vqYpdkATekWBuAhEaW41MDO7A0ttZT9EvHJkyV1ZwnU9RhMG+WUHluqkhua6lvCYRAnR0Wc5EIZza0VtLQw7KAY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUmwkQhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUmwkQhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52724C4CED1;
	Wed, 19 Feb 2025 08:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953891;
	bh=W1Ye5HSQfLD/b4yePV3c8fYlDYbwW4B5wHYxKkkzSIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUmwkQhr5lgiFrlWRdTtltHxBZ12uR3NiDRmLhIPvZ0Zd8OTZdU9QfZQB2m1IGeKK
	 iy6Om/ZqwjDo3TisWSb98kny8MzPUjh8rordq8euT/e9SKIRXNiE7dMymXY+J6B97+
	 KLUTWdh90wS9l1RMRMKC/pt4sKGNff//s6hqJAkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a9624592218c2c5e7aa@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 029/274] vxlan: check vxlan_vnigroup_init() return value
Date: Wed, 19 Feb 2025 09:24:43 +0100
Message-ID: <20250219082610.675468944@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5805402dcc56241987bca674a1b4da79a249bab7 ]

vxlan_init() must check vxlan_vnigroup_init() success
otherwise a crash happens later, spotted by syzbot.

Oops: general protection fault, probably for non-canonical address 0xdffffc000000002c: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000160-0x0000000000000167]
CPU: 0 UID: 0 PID: 7313 Comm: syz-executor147 Not tainted 6.14.0-rc1-syzkaller-00276-g69b54314c975 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
 RIP: 0010:vxlan_vnigroup_uninit+0x89/0x500 drivers/net/vxlan/vxlan_vnifilter.c:912
Code: 00 48 8b 44 24 08 4c 8b b0 98 41 00 00 49 8d 86 60 01 00 00 48 89 c2 48 89 44 24 10 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 4d 04 00 00 49 8b 86 60 01 00 00 48 ba 00 00 00
RSP: 0018:ffffc9000cc1eea8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffffff8672effb
RDX: 000000000000002c RSI: ffffffff8672ecb9 RDI: ffff8880461b4f18
RBP: ffff8880461b4ef4 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000020000
R13: ffff8880461b0d80 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fecfa95d6c0(0000) GS:ffff88806a600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fecfa95cfb8 CR3: 000000004472c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  vxlan_uninit+0x1ab/0x200 drivers/net/vxlan/vxlan_core.c:2942
  unregister_netdevice_many_notify+0x12d6/0x1f30 net/core/dev.c:11824
  unregister_netdevice_many net/core/dev.c:11866 [inline]
  unregister_netdevice_queue+0x307/0x3f0 net/core/dev.c:11736
  register_netdevice+0x1829/0x1eb0 net/core/dev.c:10901
  __vxlan_dev_create+0x7c6/0xa30 drivers/net/vxlan/vxlan_core.c:3981
  vxlan_newlink+0xd1/0x130 drivers/net/vxlan/vxlan_core.c:4407
  rtnl_newlink_create net/core/rtnetlink.c:3795 [inline]
  __rtnl_newlink net/core/rtnetlink.c:3906 [inline]

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Reported-by: syzbot+6a9624592218c2c5e7aa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/67a9d9b4.050a0220.110943.002d.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250210105242.883482-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 9ea63059d52d7..cbe0f191a116b 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2904,8 +2904,11 @@ static int vxlan_init(struct net_device *dev)
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	int err;
 
-	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
-		vxlan_vnigroup_init(vxlan);
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER) {
+		err = vxlan_vnigroup_init(vxlan);
+		if (err)
+			return err;
+	}
 
 	err = gro_cells_init(&vxlan->gro_cells, dev);
 	if (err)
-- 
2.39.5



