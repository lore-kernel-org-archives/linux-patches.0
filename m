Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2223D2A2;
	Wed, 30 Jul 2025 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868578; cv=none; b=P3ocwf0Db5i328Q23RT8pMHwbT1No4s3HQCjVzd7xRNn1RX9JIBF/A3Mbb+qQ6/WiXvfoHq2zVQBWNdYe1vkBg6k3I8zQ715DAT7QA/c3/aEPdsXveVmyhsXtmmm8/YTehlmjg5HfnlBrTG0NGWRZSzX5UIoMYUT0GH2RBg9W7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868578; c=relaxed/simple;
	bh=WnKsgNiL6NEtZsrKEgLL7/9oPcCIWcqeq5Qr1GOiAKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLECutXMuXvovMlJSENhXApyRTXXf5A2sfXmZf0RwW0qcUDa+2Cl6YB8dNIpWTh/CIhwlYoh+yez/2MoIlyKKFXTW1r4OWOdlpHAFjrpRzCIAe73RVERt3IDScJ3+kpWGTyq/wAXzxRsjT1rvIpFIqNMmdPp1x3+b+CGAINVWfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR6tQqxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR6tQqxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95753C4CEE7;
	Wed, 30 Jul 2025 09:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868578;
	bh=WnKsgNiL6NEtZsrKEgLL7/9oPcCIWcqeq5Qr1GOiAKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR6tQqxwZjt/DZ1YfG/Vcjf/jCCXzJXIKRM5k8pYjtrs8mXpvKgsajyflXO+OZI55
	 qtukgmGj3U9BeAA0zUClAAUQjX/ChCyokWfR1TdeohvnLe/ZTKX8clc3C3dK5VsMFR
	 cxOqhwIIz1iA8ZKHOa2LaKMhTiMkeY6p/lSBRbnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lonial Con <kongln9170@gmail.com>,
	Eyal Birger <eyal.birger@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/117] xfrm: interface: fix use-after-free after changing collect_md xfrm interface
Date: Wed, 30 Jul 2025 11:34:50 +0200
Message-ID: <20250730093234.400653752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit a90b2a1aaacbcf0f91d7e4868ad6c51c5dee814b ]

collect_md property on xfrm interfaces can only be set on device creation,
thus xfrmi_changelink() should fail when called on such interfaces.

The check to enforce this was done only in the case where the xi was
returned from xfrmi_locate() which doesn't look for the collect_md
interface, and thus the validation was never reached.

Calling changelink would thus errornously place the special interface xi
in the xfrmi_net->xfrmi hash, but since it also exists in the
xfrmi_net->collect_md_xfrmi pointer it would lead to a double free when
the net namespace was taken down [1].

Change the check to use the xi from netdev_priv which is available earlier
in the function to prevent changes in xfrm collect_md interfaces.

[1] resulting oops:
[    8.516540] kernel BUG at net/core/dev.c:12029!
[    8.516552] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[    8.516559] CPU: 0 UID: 0 PID: 12 Comm: kworker/u80:0 Not tainted 6.15.0-virtme #5 PREEMPT(voluntary)
[    8.516565] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    8.516569] Workqueue: netns cleanup_net
[    8.516579] RIP: 0010:unregister_netdevice_many_notify+0x101/0xab0
[    8.516590] Code: 90 0f 0b 90 48 8b b0 78 01 00 00 48 8b 90 80 01 00 00 48 89 56 08 48 89 32 4c 89 80 78 01 00 00 48 89 b8 80 01 00 00 eb ac 90 <0f> 0b 48 8b 45 00 4c 8d a0 88 fe ff ff 48 39 c5 74 5c 41 80 bc 24
[    8.516593] RSP: 0018:ffffa93b8006bd30 EFLAGS: 00010206
[    8.516598] RAX: ffff98fe4226e000 RBX: ffffa93b8006bd58 RCX: ffffa93b8006bc60
[    8.516601] RDX: 0000000000000004 RSI: 0000000000000000 RDI: dead000000000122
[    8.516603] RBP: ffffa93b8006bdd8 R08: dead000000000100 R09: ffff98fe4133c100
[    8.516605] R10: 0000000000000000 R11: 00000000000003d2 R12: ffffa93b8006be00
[    8.516608] R13: ffffffff96c1a510 R14: ffffffff96c1a510 R15: ffffa93b8006be00
[    8.516615] FS:  0000000000000000(0000) GS:ffff98fee73b7000(0000) knlGS:0000000000000000
[    8.516619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.516622] CR2: 00007fcd2abd0700 CR3: 000000003aa40000 CR4: 0000000000752ef0
[    8.516625] PKRU: 55555554
[    8.516627] Call Trace:
[    8.516632]  <TASK>
[    8.516635]  ? rtnl_is_locked+0x15/0x20
[    8.516641]  ? unregister_netdevice_queue+0x29/0xf0
[    8.516650]  ops_undo_list+0x1f2/0x220
[    8.516659]  cleanup_net+0x1ad/0x2e0
[    8.516664]  process_one_work+0x160/0x380
[    8.516673]  worker_thread+0x2aa/0x3c0
[    8.516679]  ? __pfx_worker_thread+0x10/0x10
[    8.516686]  kthread+0xfb/0x200
[    8.516690]  ? __pfx_kthread+0x10/0x10
[    8.516693]  ? __pfx_kthread+0x10/0x10
[    8.516697]  ret_from_fork+0x82/0xf0
[    8.516705]  ? __pfx_kthread+0x10/0x10
[    8.516709]  ret_from_fork_asm+0x1a/0x30
[    8.516718]  </TASK>

Fixes: abc340b38ba2 ("xfrm: interface: support collect metadata mode")
Reported-by: Lonial Con <kongln9170@gmail.com>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface_core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 98f1e2b67c76b..b95d882f9dbcb 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -874,7 +874,7 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
-	if (p.collect_md) {
+	if (p.collect_md || xi->p.collect_md) {
 		NL_SET_ERR_MSG(extack, "collect_md can't be changed");
 		return -EINVAL;
 	}
@@ -885,11 +885,6 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 	} else {
 		if (xi->dev != dev)
 			return -EEXIST;
-		if (xi->p.collect_md) {
-			NL_SET_ERR_MSG(extack,
-				       "device can't be changed to collect_md");
-			return -EINVAL;
-		}
 	}
 
 	return xfrmi_update(xi, &p);
-- 
2.39.5



