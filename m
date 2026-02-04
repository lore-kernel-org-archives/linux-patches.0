Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877E271A9A;
	Wed,  4 Feb 2026 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216342; cv=none; b=m94ljsiV40miTqn/h3Yl1L1H0dH9MtlzsZtPv0ELEv1zCDcP0DzH4uQTdpY8nwkJ61f6NAZv5hjchZOmLGlMeO3tCWTIii4ATp4wPbrNT3pvzlJXocVwvtBqRDrZmQ9FGB/ScsZWU2AlKwV8tVreNaEoodgRFaBXirUvsBBH2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216342; c=relaxed/simple;
	bh=dUerOMR+XPRNLwL8sBHi9AgnAS6e4XddExsTVseAYAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASrYnWQQyzefbgCYKJyXjAVF0Tpedvpj1cTtEiCSsefEAISlPycNcohyrDCLxn8B/M/9sDoPeTjiyVmepMYDUNIzRQgfiP7n5X/YrCI4mvmM0Zkfziv77X4whEW41KpYG479e2BMIkGiMnRr8OsNLiNJgl+lt3+RPfVsU29vCAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiNlrSLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiNlrSLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F908C4CEF7;
	Wed,  4 Feb 2026 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216341;
	bh=dUerOMR+XPRNLwL8sBHi9AgnAS6e4XddExsTVseAYAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fiNlrSLO9+8RQX++/tuNZxOpb3Uxl8fX5twuD++fdi6wk6pkyvEhRqCjlzi+tKctl
	 AMCT7FXM+V098172X6mC8kpjA6H1NJZpBdfLJEiLRnrrFYA6eFB8KEemE6w7CCxTzh
	 VlS0+WGr9+lg8L2nJ6F9qf0z86nB3wlb3BMT2q9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/161] net: fou: use policy and operation tables generated from the spec
Date: Wed,  4 Feb 2026 15:38:41 +0100
Message-ID: <20260204143853.848939961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1d562c32e4392cc091c940918ee1ffd7bfcb9e96 ]

Generate and plug in the spec-based tables.

A little bit of renaming is needed in the FOU code.

Acked-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 7a9bc9e3f423 ("fou: Don't allow 0 for FOU_ATTR_IPPROTO.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/Makefile   |  2 +-
 net/ipv4/fou_core.c | 47 +++++++-------------------------------------
 net/ipv4/fou_nl.c   | 48 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/fou_nl.h   | 25 +++++++++++++++++++++++
 4 files changed, 81 insertions(+), 41 deletions(-)
 create mode 100644 net/ipv4/fou_nl.c
 create mode 100644 net/ipv4/fou_nl.h

diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index e694a5e5b0302..d1c8d4beb77d4 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_IP_MROUTE) += ipmr.o
 obj-$(CONFIG_IP_MROUTE_COMMON) += ipmr_base.o
 obj-$(CONFIG_NET_IPIP) += ipip.o
 gre-y := gre_demux.o
-fou-y := fou_core.o
+fou-y := fou_core.o fou_nl.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index e63aa6b52460c..118b48279da32 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -19,6 +19,8 @@
 #include <uapi/linux/fou.h>
 #include <uapi/linux/genetlink.h>
 
+#include "fou_nl.h"
+
 struct fou {
 	struct socket *sock;
 	u8 protocol;
@@ -665,20 +667,6 @@ static int fou_destroy(struct net *net, struct fou_cfg *cfg)
 
 static struct genl_family fou_nl_family;
 
-static const struct nla_policy fou_nl_policy[FOU_ATTR_MAX + 1] = {
-	[FOU_ATTR_PORT]			= { .type = NLA_U16, },
-	[FOU_ATTR_AF]			= { .type = NLA_U8, },
-	[FOU_ATTR_IPPROTO]		= { .type = NLA_U8, },
-	[FOU_ATTR_TYPE]			= { .type = NLA_U8, },
-	[FOU_ATTR_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG, },
-	[FOU_ATTR_LOCAL_V4]		= { .type = NLA_U32, },
-	[FOU_ATTR_PEER_V4]		= { .type = NLA_U32, },
-	[FOU_ATTR_LOCAL_V6]		= { .len = sizeof(struct in6_addr), },
-	[FOU_ATTR_PEER_V6]		= { .len = sizeof(struct in6_addr), },
-	[FOU_ATTR_PEER_PORT]		= { .type = NLA_U16, },
-	[FOU_ATTR_IFINDEX]		= { .type = NLA_S32, },
-};
-
 static int parse_nl_config(struct genl_info *info,
 			   struct fou_cfg *cfg)
 {
@@ -770,7 +758,7 @@ static int parse_nl_config(struct genl_info *info,
 	return 0;
 }
 
-static int fou_nl_cmd_add_port(struct sk_buff *skb, struct genl_info *info)
+int fou_nl_add_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
 	struct fou_cfg cfg;
@@ -783,7 +771,7 @@ static int fou_nl_cmd_add_port(struct sk_buff *skb, struct genl_info *info)
 	return fou_create(net, &cfg, NULL);
 }
 
-static int fou_nl_cmd_rm_port(struct sk_buff *skb, struct genl_info *info)
+int fou_nl_del_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
 	struct fou_cfg cfg;
@@ -852,7 +840,7 @@ static int fou_dump_info(struct fou *fou, u32 portid, u32 seq,
 	return -EMSGSIZE;
 }
 
-static int fou_nl_cmd_get_port(struct sk_buff *skb, struct genl_info *info)
+int fou_nl_get_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
 	struct fou_net *fn = net_generic(net, fou_net_id);
@@ -899,7 +887,7 @@ static int fou_nl_cmd_get_port(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int fou_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
+int fou_nl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct fou_net *fn = net_generic(net, fou_net_id);
@@ -922,33 +910,12 @@ static int fou_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static const struct genl_small_ops fou_nl_ops[] = {
-	{
-		.cmd = FOU_CMD_ADD,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.doit = fou_nl_cmd_add_port,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = FOU_CMD_DEL,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.doit = fou_nl_cmd_rm_port,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = FOU_CMD_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.doit = fou_nl_cmd_get_port,
-		.dumpit = fou_nl_dump,
-	},
-};
-
 static struct genl_family fou_nl_family __ro_after_init = {
 	.hdrsize	= 0,
 	.name		= FOU_GENL_NAME,
 	.version	= FOU_GENL_VERSION,
 	.maxattr	= FOU_ATTR_MAX,
-	.policy = fou_nl_policy,
+	.policy		= fou_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
 	.small_ops	= fou_nl_ops,
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
new file mode 100644
index 0000000000000..6c3820f41dd5d
--- /dev/null
+++ b/net/ipv4/fou_nl.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/fou.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "fou_nl.h"
+
+#include <linux/fou.h>
+
+/* Global operation policy for fou */
+const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
+	[FOU_ATTR_PORT] = { .type = NLA_U16, },
+	[FOU_ATTR_AF] = { .type = NLA_U8, },
+	[FOU_ATTR_IPPROTO] = { .type = NLA_U8, },
+	[FOU_ATTR_TYPE] = { .type = NLA_U8, },
+	[FOU_ATTR_REMCSUM_NOPARTIAL] = { .type = NLA_FLAG, },
+	[FOU_ATTR_LOCAL_V4] = { .type = NLA_U32, },
+	[FOU_ATTR_LOCAL_V6] = { .len = 16, },
+	[FOU_ATTR_PEER_V4] = { .type = NLA_U32, },
+	[FOU_ATTR_PEER_V6] = { .len = 16, },
+	[FOU_ATTR_PEER_PORT] = { .type = NLA_U16, },
+	[FOU_ATTR_IFINDEX] = { .type = NLA_S32, },
+};
+
+/* Ops table for fou */
+const struct genl_small_ops fou_nl_ops[3] = {
+	{
+		.cmd		= FOU_CMD_ADD,
+		.validate	= GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit		= fou_nl_add_doit,
+		.flags		= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd		= FOU_CMD_DEL,
+		.validate	= GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit		= fou_nl_del_doit,
+		.flags		= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd		= FOU_CMD_GET,
+		.validate	= GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit		= fou_nl_get_doit,
+		.dumpit		= fou_nl_get_dumpit,
+	},
+};
diff --git a/net/ipv4/fou_nl.h b/net/ipv4/fou_nl.h
new file mode 100644
index 0000000000000..b7a68121ce6f7
--- /dev/null
+++ b/net/ipv4/fou_nl.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/fou.yaml */
+/* YNL-GEN kernel header */
+
+#ifndef _LINUX_FOU_GEN_H
+#define _LINUX_FOU_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <linux/fou.h>
+
+/* Global operation policy for fou */
+extern const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1];
+
+/* Ops table for fou */
+extern const struct genl_small_ops fou_nl_ops[3];
+
+int fou_nl_add_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_del_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_get_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+
+#endif /* _LINUX_FOU_GEN_H */
-- 
2.51.0



