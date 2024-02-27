Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11B513AA2F;
	Tue, 27 Feb 2024 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042074; cv=none; b=sNs4o0yueANGMyhBlVf/tzNPXxiUYnXnCA1GVlM8Y6y0rf0LNd95lb7bgiUtB61sbP7kgSfbJl421dK2iQDvV4XcPHZRTtoJcl6TSxdkBsFnVbxBRSPQS1mSmxVRN+YRRjJPH3KLbeRTCkRfEvpEw+Ze/FaEMb/45xL6+y/RRtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042074; c=relaxed/simple;
	bh=we7/nt9FVwCPENE0L957wILYAlZWX9I2X6KYMYWQcX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPh9fETK4co7kPqP6essQyT9muG7K6IXROfO9aOp00+44aNPqDi/c9N+ZERSUxHRi4uzQVkhSex9Hmf+zvvn3IRFWKLSXW9NDYapoMB/I8EqBaj+absr5vDUZYsUpxhxsLt4bHSiWENZsU3K414g7DtXW+QTHc6qksCvHAeS+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnBNB8+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnBNB8+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A6DC433C7;
	Tue, 27 Feb 2024 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042074;
	bh=we7/nt9FVwCPENE0L957wILYAlZWX9I2X6KYMYWQcX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnBNB8+ZCF+ABtNzRqGwkmS+c3WYuDizhlngrbqTfT/j5jo6epaDwm4Yz1byq4it/
	 g1Z8ES7Us45Bj8DyUn387C8IMUlMTTR/rfn6sgMOD6BAL8nETyz+oLca3rso4kkHuu
	 ARjqP5RqBy5+3KDp+uE6XWY2srEMIxQ9ekx3hvmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 170/299] gtp: fix use-after-free and null-ptr-deref in gtp_genl_dump_pdp()
Date: Tue, 27 Feb 2024 14:24:41 +0100
Message-ID: <20240227131631.316523508@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit 136cfaca22567a03bbb3bf53a43d8cb5748b80ec upstream.

The gtp_net_ops pernet operations structure for the subsystem must be
registered before registering the generic netlink family.

Syzkaller hit 'general protection fault in gtp_genl_dump_pdp' bug:

general protection fault, probably for non-canonical address
0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 5826 Comm: gtp Not tainted 6.8.0-rc3-std-def-alt1 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-alt1 04/01/2014
RIP: 0010:gtp_genl_dump_pdp+0x1be/0x800 [gtp]
Code: c6 89 c6 e8 64 e9 86 df 58 45 85 f6 0f 85 4e 04 00 00 e8 c5 ee 86
      df 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80>
      3c 02 00 0f 85 de 05 00 00 48 8b 44 24 18 4c 8b 30 4c 39 f0 74
RSP: 0018:ffff888014107220 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88800fcda588 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f1be4eb05c0(0000) GS:ffff88806ce80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1be4e766cf CR3: 000000000c33e000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? show_regs+0x90/0xa0
 ? die_addr+0x50/0xd0
 ? exc_general_protection+0x148/0x220
 ? asm_exc_general_protection+0x22/0x30
 ? gtp_genl_dump_pdp+0x1be/0x800 [gtp]
 ? __alloc_skb+0x1dd/0x350
 ? __pfx___alloc_skb+0x10/0x10
 genl_dumpit+0x11d/0x230
 netlink_dump+0x5b9/0xce0
 ? lockdep_hardirqs_on_prepare+0x253/0x430
 ? __pfx_netlink_dump+0x10/0x10
 ? kasan_save_track+0x10/0x40
 ? __kasan_kmalloc+0x9b/0xa0
 ? genl_start+0x675/0x970
 __netlink_dump_start+0x6fc/0x9f0
 genl_family_rcv_msg_dumpit+0x1bb/0x2d0
 ? __pfx_genl_family_rcv_msg_dumpit+0x10/0x10
 ? genl_op_from_small+0x2a/0x440
 ? cap_capable+0x1d0/0x240
 ? __pfx_genl_start+0x10/0x10
 ? __pfx_genl_dumpit+0x10/0x10
 ? __pfx_genl_done+0x10/0x10
 ? security_capable+0x9d/0xe0

Cc: stable@vger.kernel.org
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Link: https://lore.kernel.org/r/20240214162733.34214-1-kovalev@altlinux.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1907,20 +1907,20 @@ static int __init gtp_init(void)
 	if (err < 0)
 		goto error_out;
 
-	err = genl_register_family(&gtp_genl_family);
+	err = register_pernet_subsys(&gtp_net_ops);
 	if (err < 0)
 		goto unreg_rtnl_link;
 
-	err = register_pernet_subsys(&gtp_net_ops);
+	err = genl_register_family(&gtp_genl_family);
 	if (err < 0)
-		goto unreg_genl_family;
+		goto unreg_pernet_subsys;
 
 	pr_info("GTP module loaded (pdp ctx size %zd bytes)\n",
 		sizeof(struct pdp_ctx));
 	return 0;
 
-unreg_genl_family:
-	genl_unregister_family(&gtp_genl_family);
+unreg_pernet_subsys:
+	unregister_pernet_subsys(&gtp_net_ops);
 unreg_rtnl_link:
 	rtnl_link_unregister(&gtp_link_ops);
 error_out:


