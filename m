Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974327713;
	Tue,  9 Jul 2024 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524243; cv=none; b=Y1PF6LWyzCKuKO9oe972UZi0lO88ABa1lTHfndyN2uwW576inXAR8bXuIVZslusmyyfneSovPkbtoyhaesGPyQOI6QsWfVaJpQnb7A2n+RzR9xSyumNLY4nNZ1OAg+qlByuUosbGBk1PWPTM+o0bD28EmSH+8amH0vGt3InbJsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524243; c=relaxed/simple;
	bh=VBuB3OgYSB+7x0L+OgxDg9y+kAa9/qnedAUStOtxedI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mp5LS5R8VB/CFgWqySgssdh58x419z8EPNifYGEZhed/hK51SQtO4+QMaXmPTLc0RBW0Cq9XHSPw8KDTCS98OarMyBok1hjh+MgSv8g9fU6/jP8DBHIde+3W/9dTCwqXTflmoXsrSaEz04lp7PNZb+9TwBJBzDbugSiuvTFrYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2DdY3Y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2DdY3Y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B412DC3277B;
	Tue,  9 Jul 2024 11:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524243;
	bh=VBuB3OgYSB+7x0L+OgxDg9y+kAa9/qnedAUStOtxedI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2DdY3Y9E34KrA3MJdqA8JKKqKSER/bsu7yOBEJdOjUhrurO6uF44gB4DPJwi7YAD
	 5vzA19l2qJ8bofBZmDF+6gs26T9q1+25hkQ51WlQ0mEbcXJLoNq++751VYiUbD6XGb
	 6hhQECTewpZhCjVMq4nx1G7AHsZXlzdcjD2/7QxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 118/197] bonding: Fix out-of-bounds read in bond_option_arp_ip_targets_set()
Date: Tue,  9 Jul 2024 13:09:32 +0200
Message-ID: <20240709110713.515814915@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Sun <samsun1006219@gmail.com>

[ Upstream commit e271ff53807e8f2c628758290f0e499dbe51cb3d ]

In function bond_option_arp_ip_targets_set(), if newval->string is an
empty string, newval->string+1 will point to the byte after the
string, causing an out-of-bound read.

BUG: KASAN: slab-out-of-bounds in strlen+0x7d/0xa0 lib/string.c:418
Read of size 1 at addr ffff8881119c4781 by task syz-executor665/8107
CPU: 1 PID: 8107 Comm: syz-executor665 Not tainted 6.7.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:364 [inline]
 print_report+0xc1/0x5e0 mm/kasan/report.c:475
 kasan_report+0xbe/0xf0 mm/kasan/report.c:588
 strlen+0x7d/0xa0 lib/string.c:418
 __fortify_strlen include/linux/fortify-string.h:210 [inline]
 in4_pton+0xa3/0x3f0 net/core/utils.c:130
 bond_option_arp_ip_targets_set+0xc2/0x910
drivers/net/bonding/bond_options.c:1201
 __bond_opt_set+0x2a4/0x1030 drivers/net/bonding/bond_options.c:767
 __bond_opt_set_notify+0x48/0x150 drivers/net/bonding/bond_options.c:792
 bond_opt_tryset_rtnl+0xda/0x160 drivers/net/bonding/bond_options.c:817
 bonding_sysfs_store_option+0xa1/0x120 drivers/net/bonding/bond_sysfs.c:156
 dev_attr_store+0x54/0x80 drivers/base/core.c:2366
 sysfs_kf_write+0x114/0x170 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x337/0x500 fs/kernfs/file.c:334
 call_write_iter include/linux/fs.h:2020 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x96a/0xd80 fs/read_write.c:584
 ksys_write+0x122/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b
---[ end trace ]---

Fix it by adding a check of string length before using it.

Fixes: f9de11a16594 ("bonding: add ip checks when store ip target")
Signed-off-by: Yue Sun <samsun1006219@gmail.com>
Signed-off-by: Simon Horman <horms@kernel.org>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20240702-bond-oob-v6-1-2dfdba195c19@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_options.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 4cdbc7e084f4b..fea1d87a97539 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1214,9 +1214,9 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
 	__be32 target;
 
 	if (newval->string) {
-		if (!in4_pton(newval->string+1, -1, (u8 *)&target, -1, NULL)) {
-			netdev_err(bond->dev, "invalid ARP target %pI4 specified\n",
-				   &target);
+		if (strlen(newval->string) < 1 ||
+		    !in4_pton(newval->string + 1, -1, (u8 *)&target, -1, NULL)) {
+			netdev_err(bond->dev, "invalid ARP target specified\n");
 			return ret;
 		}
 		if (newval->string[0] == '+')
-- 
2.43.0



