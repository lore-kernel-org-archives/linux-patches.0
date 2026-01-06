Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2DC33EC;
	Tue,  6 Jan 2026 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721132; cv=none; b=PqRxWWLR1MUaqpUgUtxB/kaBnCIMZLjdRGI99ch74+06TtdNN6y7b3CU5TebuJplrC+dp7phlkPHjG5yYlbXzS0rvtUoFaunUSfbIGDPSQ69XkakthUQZEr0xVv24gmREOycgipWcjIBPFCLkzMiG/64TPX0LhcKGZS9U81XYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721132; c=relaxed/simple;
	bh=45+qB7m8z+zw+cNKgTxn4CEDsvR+sxieRcpV4OQ6yyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n17VN4mkGu0zoPED3oH8tluC1bikit5RHP3HuIvgob7Yr1yCCLj93juL9Tlnb27Dl8gXTBGx0aHIa2x291/NPNSDxA7yNQvp5at/c8Q0uNMIcl4OULGsIfB/O8rSMLscgsBotA/W3ogMHgITsxaFSd68uh/ihXOuXd879BsO3Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KblP+DTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KblP+DTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AFFC116C6;
	Tue,  6 Jan 2026 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721131;
	bh=45+qB7m8z+zw+cNKgTxn4CEDsvR+sxieRcpV4OQ6yyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KblP+DTJwUejr1Mxu7+kIZB6it/kr2FevpxA3U9XQN6waIVk9hVeRlzVfKKHI+klH
	 g7uWxqA89LYrZxFZayRC2MmSma99TUc/U2CRa57ho32coj5XLVLh6vYCTM8o1Au0IL
	 uC6eq7H/wXzhJg+MukEHZUMsDrc25/0v6rqMdBDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+938fcd548c303fe33c1a@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 445/567] RDMA/core: Check for the presence of LS_NLA_TYPE_DGID correctly
Date: Tue,  6 Jan 2026 18:03:47 +0100
Message-ID: <20260106170507.811530162@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit a7b8e876e0ef0232b8076972c57ce9a7286b47ca upstream.

The netlink response for RDMA_NL_LS_OP_IP_RESOLVE should always have a
LS_NLA_TYPE_DGID attribute, it is invalid if it does not.

Use the nl parsing logic properly and call nla_parse_deprecated() to fill
the nlattrs array and then directly index that array to get the data for
the DGID. Just fail if it is NULL.

Remove the for loop searching for the nla, and squash the validation and
parsing into one function.

Fixes an uninitialized read from the stack triggered by userspace if it
does not provide the DGID to a kernel initiated RDMA_NL_LS_OP_IP_RESOLVE
query.

    BUG: KMSAN: uninit-value in hex_byte_pack include/linux/hex.h:13 [inline]
    BUG: KMSAN: uninit-value in ip6_string+0xef4/0x13a0 lib/vsprintf.c:1490
     hex_byte_pack include/linux/hex.h:13 [inline]
     ip6_string+0xef4/0x13a0 lib/vsprintf.c:1490
     ip6_addr_string+0x18a/0x3e0 lib/vsprintf.c:1509
     ip_addr_string+0x245/0xee0 lib/vsprintf.c:1633
     pointer+0xc09/0x1bd0 lib/vsprintf.c:2542
     vsnprintf+0xf8a/0x1bd0 lib/vsprintf.c:2930
     vprintk_store+0x3ae/0x1530 kernel/printk/printk.c:2279
     vprintk_emit+0x307/0xcd0 kernel/printk/printk.c:2426
     vprintk_default+0x3f/0x50 kernel/printk/printk.c:2465
     vprintk+0x36/0x50 kernel/printk/printk_safe.c:82
     _printk+0x17e/0x1b0 kernel/printk/printk.c:2475
     ib_nl_process_good_ip_rsep drivers/infiniband/core/addr.c:128 [inline]
     ib_nl_handle_ip_res_resp+0x963/0x9d0 drivers/infiniband/core/addr.c:141
     rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:-1 [inline]
     rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
     rdma_nl_rcv+0xefa/0x11c0 drivers/infiniband/core/netlink.c:259
     netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
     netlink_unicast+0xf04/0x12b0 net/netlink/af_netlink.c:1346
     netlink_sendmsg+0x10b3/0x1250 net/netlink/af_netlink.c:1896
     sock_sendmsg_nosec net/socket.c:714 [inline]
     __sock_sendmsg+0x333/0x3d0 net/socket.c:729
     ____sys_sendmsg+0x7e0/0xd80 net/socket.c:2617
     ___sys_sendmsg+0x271/0x3b0 net/socket.c:2671
     __sys_sendmsg+0x1aa/0x300 net/socket.c:2703
     __compat_sys_sendmsg net/compat.c:346 [inline]
     __do_compat_sys_sendmsg net/compat.c:353 [inline]
     __se_compat_sys_sendmsg net/compat.c:350 [inline]
     __ia32_compat_sys_sendmsg+0xa4/0x100 net/compat.c:350
     ia32_sys_call+0x3f6c/0x4310 arch/x86/include/generated/asm/syscalls_32.h:371
     do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
     __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
     do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
     do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:3

Link: https://patch.msgid.link/r/0-v1-3fbaef094271+2cf-rdma_op_ip_rslv_syz_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: ae43f8286730 ("IB/core: Add IP to GID netlink offload")
Reported-by: syzbot+938fcd548c303fe33c1a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/68dc3dac.a00a0220.102ee.004f.GAE@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -80,37 +80,25 @@ static const struct nla_policy ib_nl_add
 		.min = sizeof(struct rdma_nla_ls_gid)},
 };
 
-static inline bool ib_nl_is_good_ip_resp(const struct nlmsghdr *nlh)
+static void ib_nl_process_ip_rsep(const struct nlmsghdr *nlh)
 {
 	struct nlattr *tb[LS_NLA_TYPE_MAX] = {};
+	union ib_gid gid;
+	struct addr_req *req;
+	int found = 0;
 	int ret;
 
 	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
-		return false;
+		return;
 
 	ret = nla_parse_deprecated(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
 				   nlmsg_len(nlh), ib_nl_addr_policy, NULL);
 	if (ret)
-		return false;
-
-	return true;
-}
-
-static void ib_nl_process_good_ip_rsep(const struct nlmsghdr *nlh)
-{
-	const struct nlattr *head, *curr;
-	union ib_gid gid;
-	struct addr_req *req;
-	int len, rem;
-	int found = 0;
-
-	head = (const struct nlattr *)nlmsg_data(nlh);
-	len = nlmsg_len(nlh);
+		return;
 
-	nla_for_each_attr(curr, head, len, rem) {
-		if (curr->nla_type == LS_NLA_TYPE_DGID)
-			memcpy(&gid, nla_data(curr), nla_len(curr));
-	}
+	if (!tb[LS_NLA_TYPE_DGID])
+		return;
+	memcpy(&gid, nla_data(tb[LS_NLA_TYPE_DGID]), sizeof(gid));
 
 	spin_lock_bh(&lock);
 	list_for_each_entry(req, &req_list, list) {
@@ -137,8 +125,7 @@ int ib_nl_handle_ip_res_resp(struct sk_b
 	    !(NETLINK_CB(skb).sk))
 		return -EPERM;
 
-	if (ib_nl_is_good_ip_resp(nlh))
-		ib_nl_process_good_ip_rsep(nlh);
+	ib_nl_process_ip_rsep(nlh);
 
 	return 0;
 }


