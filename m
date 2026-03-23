Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D63ACA68;
	Mon, 23 Mar 2026 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274971; cv=none; b=FtC5pNI0+cjyRy0y6EPXWnNHcATjkC6Gvw5/5hYoQ4ePMut2PKtT0idCflhwdeWNU9GK3sW5oJ5gTKCR/VWaCMojYeePDZBqThL8uCpVef6mJ192CI8lX0am1yJBYZgy6aTk9zHh9QbnMRyrklR+DKGZTR30lUyo3IsLEaRoo2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274971; c=relaxed/simple;
	bh=1OfCvfVVFDyt2VPoRclNi3fX+Q+e8irVpPv7+n4l0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvJD0rm/KXOE6zlBbF0qWVeqTHaZ2Y26u7+facgUbX0GjtPOo5FJ+kJthW8trKvI2BVDeE2JgTcwTgsvX5V7vVfIy1IxWDiC2X9BC8t98YHmz/hYRHIlVqeMw5BhKvOx4c9j3/ZYLO6MqagdXig9/QEqhW4c19bx1f7aAdtUeSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMrlfYlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMrlfYlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89C9C4CEF7;
	Mon, 23 Mar 2026 14:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274971;
	bh=1OfCvfVVFDyt2VPoRclNi3fX+Q+e8irVpPv7+n4l0T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMrlfYlEYt1NfF/fBrUayZue57B+vJopjMoV4Bl5Tb+Fkl7quWW5ZmpDleB655utu
	 jHpx5dJi+gosqRuqs+L1AoZAHMqBxp1vW0ah9mfC0MdK4dDdbf368LOTnyI/5B2YXx
	 NE28T/8ntaE6L/52HBHkYRNcukDIwQuYgHXclTUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/212] net: bonding: fix NULL deref in bond_debug_rlb_hash_show
Date: Mon, 23 Mar 2026 14:46:31 +0100
Message-ID: <20260323134509.143018417@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 605b52497bf89b3b154674deb135da98f916e390 ]

rlb_clear_slave intentionally keeps RLB hash-table entries on
the rx_hashtbl_used_head list with slave set to NULL when no
replacement slave is available. However, bond_debug_rlb_hash_show
visites client_info->slave without checking if it's NULL.

Other used-list iterators in bond_alb.c already handle this NULL-slave
state safely:

- rlb_update_client returns early on !client_info->slave
- rlb_req_update_slave_clients, rlb_clear_slave, and rlb_rebalance
compare slave values before visiting
- lb_req_update_subnet_clients continues if slave is NULL

The following NULL deref crash can be trigger in
bond_debug_rlb_hash_show:

[    1.289791] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.292058] RIP: 0010:bond_debug_rlb_hash_show (drivers/net/bonding/bond_debugfs.c:41)
[    1.293101] RSP: 0018:ffffc900004a7d00 EFLAGS: 00010286
[    1.293333] RAX: 0000000000000000 RBX: ffff888102b48200 RCX: ffff888102b48204
[    1.293631] RDX: ffff888102b48200 RSI: ffffffff839daad5 RDI: ffff888102815078
[    1.293924] RBP: ffff888102815078 R08: ffff888102b4820e R09: 0000000000000000
[    1.294267] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888100f929c0
[    1.294564] R13: ffff888100f92a00 R14: 0000000000000001 R15: ffffc900004a7ed8
[    1.294864] FS:  0000000001395380(0000) GS:ffff888196e75000(0000) knlGS:0000000000000000
[    1.295239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.295480] CR2: 0000000000000000 CR3: 0000000102adc004 CR4: 0000000000772ef0
[    1.295897] Call Trace:
[    1.296134]  seq_read_iter (fs/seq_file.c:231)
[    1.296341]  seq_read (fs/seq_file.c:164)
[    1.296493]  full_proxy_read (fs/debugfs/file.c:378 (discriminator 1))
[    1.296658]  vfs_read (fs/read_write.c:572)
[    1.296981]  ksys_read (fs/read_write.c:717)
[    1.297132]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1) arch/x86/entry/syscall_64.c:94 (discriminator 1))
[    1.297325]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Add a NULL check and print "(none)" for entries with no assigned slave.

Fixes: caafa84251b88 ("bonding: add the debugfs interface to see RLB hash table")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260317005034.1888794-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_debugfs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 8adbec7c5084a..8967b65f6d840 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -34,11 +34,17 @@ static int bond_debug_rlb_hash_show(struct seq_file *m, void *v)
 	for (; hash_index != RLB_NULL_INDEX;
 	     hash_index = client_info->used_next) {
 		client_info = &(bond_info->rx_hashtbl[hash_index]);
-		seq_printf(m, "%-15pI4 %-15pI4 %-17pM %s\n",
-			&client_info->ip_src,
-			&client_info->ip_dst,
-			&client_info->mac_dst,
-			client_info->slave->dev->name);
+		if (client_info->slave)
+			seq_printf(m, "%-15pI4 %-15pI4 %-17pM %s\n",
+				   &client_info->ip_src,
+				   &client_info->ip_dst,
+				   &client_info->mac_dst,
+				   client_info->slave->dev->name);
+		else
+			seq_printf(m, "%-15pI4 %-15pI4 %-17pM (none)\n",
+				   &client_info->ip_src,
+				   &client_info->ip_dst,
+				   &client_info->mac_dst);
 	}
 
 	spin_unlock_bh(&bond->mode_lock);
-- 
2.51.0



