Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E54A232392;
	Mon,  2 Jun 2025 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873946; cv=none; b=lTAnkOs0LZ6ZxbFtO6fRvW3WTrZ3ga2SR7R2C/4KH3e4gqIl3mwzKfVqReCWqiE7admj/g/9l5xH2T3ZjS4LfGHrWuue2h1GZ8t+W5YSg1zv1wnzV8lkJ5UIrkVAy+BbtLG51eU/LNDS0UiOa+wwXn5y2FZVm12xE85Kq1Vmjjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873946; c=relaxed/simple;
	bh=noaDekzZWSqDV1XdW8WJsy9rj9jSk+eo0wMznoVoEr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7iyPsMvSsAhmTgdCHxfpog4zHGI7MqHcYySTpNIGEISjjXiWZNigTyoQRAWsRiKEy/yKxQphIdxmK8QVMPrxGhnwQt/SEeFagtr8AabcRdZqHbEos77VyiLJMJRUNRfVCRuw1CKVj067T84Wh9IkNNBCtysxkGIshd/oSe8S9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxuJNITB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxuJNITB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514B6C4CEEB;
	Mon,  2 Jun 2025 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873944;
	bh=noaDekzZWSqDV1XdW8WJsy9rj9jSk+eo0wMznoVoEr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxuJNITBJ+KrVKNcEAVyvC6owBBIcqTXZL6SnM5x4QAcSGsQi9QgJ1cHrBKxh4vFL
	 UB2wRBk1JTVWgL02ZZNMdsE/lGKmIYt2yOWxmrVQ+OA0KJb0iiyIdEvYAB2DKaerkj
	 T6BkTVV0mFj2RuWyjje42vRmSCDHOR9m77jy1lGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/444] vxlan: Annotate FDB data races
Date: Mon,  2 Jun 2025 15:45:39 +0200
Message-ID: <20250602134352.121446169@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f6205f8215f12a96518ac9469ff76294ae7bd612 ]

The 'used' and 'updated' fields in the FDB entry structure can be
accessed concurrently by multiple threads, leading to reports such as
[1]. Can be reproduced using [2].

Suppress these reports by annotating these accesses using
READ_ONCE() / WRITE_ONCE().

[1]
BUG: KCSAN: data-race in vxlan_xmit / vxlan_xmit

write to 0xffff942604d263a8 of 8 bytes by task 286 on cpu 0:
 vxlan_xmit+0xb29/0x2380
 dev_hard_start_xmit+0x84/0x2f0
 __dev_queue_xmit+0x45a/0x1650
 packet_xmit+0x100/0x150
 packet_sendmsg+0x2114/0x2ac0
 __sys_sendto+0x318/0x330
 __x64_sys_sendto+0x76/0x90
 x64_sys_call+0x14e8/0x1c00
 do_syscall_64+0x9e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff942604d263a8 of 8 bytes by task 287 on cpu 2:
 vxlan_xmit+0xadf/0x2380
 dev_hard_start_xmit+0x84/0x2f0
 __dev_queue_xmit+0x45a/0x1650
 packet_xmit+0x100/0x150
 packet_sendmsg+0x2114/0x2ac0
 __sys_sendto+0x318/0x330
 __x64_sys_sendto+0x76/0x90
 x64_sys_call+0x14e8/0x1c00
 do_syscall_64+0x9e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x00000000fffbac6e -> 0x00000000fffbac6f

Reported by Kernel Concurrency Sanitizer on:
CPU: 2 UID: 0 PID: 287 Comm: mausezahn Not tainted 6.13.0-rc7-01544-gb4b270f11a02 #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-3.fc41 04/01/2014

[2]
 #!/bin/bash

 set +H
 echo whitelist > /sys/kernel/debug/kcsan
 echo !vxlan_xmit > /sys/kernel/debug/kcsan

 ip link add name vx0 up type vxlan id 10010 dstport 4789 local 192.0.2.1
 bridge fdb add 00:11:22:33:44:55 dev vx0 self static dst 198.51.100.1
 taskset -c 0 mausezahn vx0 -a own -b 00:11:22:33:44:55 -c 0 -q &
 taskset -c 2 mausezahn vx0 -a own -b 00:11:22:33:44:55 -c 0 -q &

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250204145549.1216254-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 822cf49d82676..2ed879a0abc6c 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -227,9 +227,9 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 			be32_to_cpu(fdb->vni)))
 		goto nla_put_failure;
 
-	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
+	ci.ndm_used	 = jiffies_to_clock_t(now - READ_ONCE(fdb->used));
 	ci.ndm_confirmed = 0;
-	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
+	ci.ndm_updated	 = jiffies_to_clock_t(now - READ_ONCE(fdb->updated));
 	ci.ndm_refcnt	 = 0;
 
 	if (nla_put(skb, NDA_CACHEINFO, sizeof(ci), &ci))
@@ -435,8 +435,8 @@ static struct vxlan_fdb *vxlan_find_mac(struct vxlan_dev *vxlan,
 	struct vxlan_fdb *f;
 
 	f = __vxlan_find_mac(vxlan, mac, vni);
-	if (f && f->used != jiffies)
-		f->used = jiffies;
+	if (f && READ_ONCE(f->used) != jiffies)
+		WRITE_ONCE(f->used, jiffies);
 
 	return f;
 }
@@ -1010,12 +1010,12 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 	    !(f->flags & NTF_VXLAN_ADDED_BY_USER)) {
 		if (f->state != state) {
 			f->state = state;
-			f->updated = jiffies;
+			WRITE_ONCE(f->updated, jiffies);
 			notify = 1;
 		}
 		if (f->flags != fdb_flags) {
 			f->flags = fdb_flags;
-			f->updated = jiffies;
+			WRITE_ONCE(f->updated, jiffies);
 			notify = 1;
 		}
 	}
@@ -1049,7 +1049,7 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 	}
 
 	if (ndm_flags & NTF_USE)
-		f->used = jiffies;
+		WRITE_ONCE(f->used, jiffies);
 
 	if (notify) {
 		if (rd == NULL)
@@ -1478,7 +1478,7 @@ static bool vxlan_snoop(struct net_device *dev,
 				    src_mac, &rdst->remote_ip.sa, &src_ip->sa);
 
 		rdst->remote_ip = *src_ip;
-		f->updated = jiffies;
+		WRITE_ONCE(f->updated, jiffies);
 		vxlan_fdb_notify(vxlan, f, rdst, RTM_NEWNEIGH, true, NULL);
 	} else {
 		u32 hash_index = fdb_head_index(vxlan, src_mac, vni);
@@ -2920,7 +2920,7 @@ static void vxlan_cleanup(struct timer_list *t)
 			if (f->flags & NTF_EXT_LEARNED)
 				continue;
 
-			timeout = f->used + vxlan->cfg.age_interval * HZ;
+			timeout = READ_ONCE(f->used) + vxlan->cfg.age_interval * HZ;
 			if (time_before_eq(timeout, jiffies)) {
 				netdev_dbg(vxlan->dev,
 					   "garbage collect %pM\n",
-- 
2.39.5



