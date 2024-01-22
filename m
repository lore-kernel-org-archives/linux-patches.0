Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963912A17F;
	Tue, 23 Jan 2024 00:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968805; cv=none; b=mManFyyrPE/Ua5mXuFMLnhaqvIfPTMN3Qbydpis55jYVVoQqkvq4yhQEd0t49eT6ZkrlzK/lxH08TE0UKjj+4VnThBXPhio0hsMHe6SWEeOmQXXakx62WSEImuGRTp8xF1iO2apOuscuHb9+T1fwkW0sYA0/K6fab7AoQAOFwY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968805; c=relaxed/simple;
	bh=T8td0OHLE/VaJn+tWYOMCV2MmNzVMkwEIANbgGCWDNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzFfbvYzzZQoALllMdR3TtrHymwOfVzB4GlDiPdxTnLH1JVcCbL9EJAjHRshTAhh3lGox6ON8Nfd/uYqWokMW7dJw3mnY9vgUjgdzgq1TSuZfVjFI36kkrhOvkvvM9FDjp0yH6GFXf0wzOp63a8DsB0Zr5c7noyUe7XpSIOVe+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ET2PS0Bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ET2PS0Bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E228C433C7;
	Tue, 23 Jan 2024 00:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968804;
	bh=T8td0OHLE/VaJn+tWYOMCV2MmNzVMkwEIANbgGCWDNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ET2PS0Bmzcc4VUZ9H8dgqOg8ihnsBGl5smL6l90g63pzGZRczJOHq+dRiC/ngViDf
	 +7zh7WBeZIwLy6zdzv/z5bcYchRZkpEvikIxSJareWCkP0PLavpV6fWUhW7SosV0ek
	 5dezfe5yTaa5vP1cq3Fz012b+JYyNBl+2dmhvJ2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/194] calipso: fix memory leak in netlbl_calipso_add_pass()
Date: Mon, 22 Jan 2024 15:56:26 -0800
Message-ID: <20240122235721.603324878@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit ec4e9d630a64df500641892f4e259e8149594a99 ]

If IPv6 support is disabled at boot (ipv6.disable=1),
the calipso_init() -> netlbl_calipso_ops_register() function isn't called,
and the netlbl_calipso_ops_get() function always returns NULL.
In this case, the netlbl_calipso_add_pass() function allocates memory
for the doi_def variable but doesn't free it with the calipso_doi_free().

BUG: memory leak
unreferenced object 0xffff888011d68180 (size 64):
  comm "syz-executor.1", pid 10746, jiffies 4295410986 (age 17.928s)
  hex dump (first 32 bytes):
    00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<...>] kmalloc include/linux/slab.h:552 [inline]
    [<...>] netlbl_calipso_add_pass net/netlabel/netlabel_calipso.c:76 [inline]
    [<...>] netlbl_calipso_add+0x22e/0x4f0 net/netlabel/netlabel_calipso.c:111
    [<...>] genl_family_rcv_msg_doit+0x22f/0x330 net/netlink/genetlink.c:739
    [<...>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
    [<...>] genl_rcv_msg+0x341/0x5a0 net/netlink/genetlink.c:800
    [<...>] netlink_rcv_skb+0x14d/0x440 net/netlink/af_netlink.c:2515
    [<...>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:811
    [<...>] netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
    [<...>] netlink_unicast+0x54b/0x800 net/netlink/af_netlink.c:1339
    [<...>] netlink_sendmsg+0x90a/0xdf0 net/netlink/af_netlink.c:1934
    [<...>] sock_sendmsg_nosec net/socket.c:651 [inline]
    [<...>] sock_sendmsg+0x157/0x190 net/socket.c:671
    [<...>] ____sys_sendmsg+0x712/0x870 net/socket.c:2342
    [<...>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2396
    [<...>] __sys_sendmsg+0xea/0x1b0 net/socket.c:2429
    [<...>] do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
    [<...>] entry_SYSCALL_64_after_hwframe+0x61/0xc6

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with Syzkaller

Fixes: cb72d38211ea ("netlabel: Initial support for the CALIPSO netlink protocol.")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
[PM: merged via the LSM tree at Jakub Kicinski request]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_calipso.c | 49 +++++++++++++++++----------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 33502b1f07c0..1bb2a7404dc4 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -54,6 +54,28 @@ static const struct nla_policy calipso_genl_policy[NLBL_CALIPSO_A_MAX + 1] = {
 	[NLBL_CALIPSO_A_MTYPE] = { .type = NLA_U32 },
 };
 
+static const struct netlbl_calipso_ops *calipso_ops;
+
+/**
+ * netlbl_calipso_ops_register - Register the CALIPSO operations
+ * @ops: ops to register
+ *
+ * Description:
+ * Register the CALIPSO packet engine operations.
+ *
+ */
+const struct netlbl_calipso_ops *
+netlbl_calipso_ops_register(const struct netlbl_calipso_ops *ops)
+{
+	return xchg(&calipso_ops, ops);
+}
+EXPORT_SYMBOL(netlbl_calipso_ops_register);
+
+static const struct netlbl_calipso_ops *netlbl_calipso_ops_get(void)
+{
+	return READ_ONCE(calipso_ops);
+}
+
 /* NetLabel Command Handlers
  */
 /**
@@ -96,15 +118,18 @@ static int netlbl_calipso_add_pass(struct genl_info *info,
  *
  */
 static int netlbl_calipso_add(struct sk_buff *skb, struct genl_info *info)
-
 {
 	int ret_val = -EINVAL;
 	struct netlbl_audit audit_info;
+	const struct netlbl_calipso_ops *ops = netlbl_calipso_ops_get();
 
 	if (!info->attrs[NLBL_CALIPSO_A_DOI] ||
 	    !info->attrs[NLBL_CALIPSO_A_MTYPE])
 		return -EINVAL;
 
+	if (!ops)
+		return -EOPNOTSUPP;
+
 	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CALIPSO_A_MTYPE])) {
 	case CALIPSO_MAP_PASS:
@@ -362,28 +387,6 @@ int __init netlbl_calipso_genl_init(void)
 	return genl_register_family(&netlbl_calipso_gnl_family);
 }
 
-static const struct netlbl_calipso_ops *calipso_ops;
-
-/**
- * netlbl_calipso_ops_register - Register the CALIPSO operations
- * @ops: ops to register
- *
- * Description:
- * Register the CALIPSO packet engine operations.
- *
- */
-const struct netlbl_calipso_ops *
-netlbl_calipso_ops_register(const struct netlbl_calipso_ops *ops)
-{
-	return xchg(&calipso_ops, ops);
-}
-EXPORT_SYMBOL(netlbl_calipso_ops_register);
-
-static const struct netlbl_calipso_ops *netlbl_calipso_ops_get(void)
-{
-	return READ_ONCE(calipso_ops);
-}
-
 /**
  * calipso_doi_add - Add a new DOI to the CALIPSO protocol engine
  * @doi_def: the DOI structure
-- 
2.43.0



