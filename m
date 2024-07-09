Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D82A55E4C;
	Tue,  9 Jul 2024 11:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524744; cv=none; b=mpGiuLjAChIfcKh6+b7HUvLTcLu+GnfdC4kJOBSY1jCRSMzfAl1WXCjozPB76ha1aMZH3f7rZqG4hXr6Qmi8z2zP2eA+J8AWMyGXr8DeW57HJpHh83Ju7Xw8p3iokvP847S6wxRSG0I6T5UxihzwC/FA+7y5ap3C6QEHPtIqw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524744; c=relaxed/simple;
	bh=8Gs0jYKR/Wd9dgGLBe3FN9YT17rpKbLmGQbAIDqL994=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTT2akpfS2gb9UT1iNaEZZlWqn6dBm18dp/wDbw7o3YYefvCg3phMqA4+X/0Bk1irT8s9gprEtj231G/aVFSloTnkusFyg9f23GBrm3f1X5YmSMYpsPNafHmMCwlHk3Ehw7bA/7Ge0Z1lPTvdhN/l9DQRgusPIgWoQct+3CZOZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHquuOAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHquuOAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100F9C3277B;
	Tue,  9 Jul 2024 11:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524744;
	bh=8Gs0jYKR/Wd9dgGLBe3FN9YT17rpKbLmGQbAIDqL994=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHquuOACRJCx4ZBTFhSPp0NlKc5FgoaKHrWo/8eMKuE1S4JZvYGe8jkFI/jo1dsKZ
	 /c6Ts1TjvxAYyf0NX3ryoWbW+SRtVI+DOMyMxo5LXrmvcIPCOIbgkE5tssETLPiBWx
	 NAxo/4La81CKKaAS4J0qoUDYLf7uDh1GVcpVjM2E=
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
Subject: [PATCH 6.1 056/102] bonding: Fix out-of-bounds read in bond_option_arp_ip_targets_set()
Date: Tue,  9 Jul 2024 13:10:19 +0200
Message-ID: <20240709110653.561731155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
index 5bb2c098bf4df..685fb4703ee1f 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1210,9 +1210,9 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
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



