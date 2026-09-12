Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6225C202F71;
	Sat, 12 Sep 2026 16:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229901; cv=none; b=dYrseqLgeUmavwyi4R82O6/Yv0EoSVRs/1x62V6vmYJFdnKDPNdlT1BSVohCw7naO23lbcQ5f54R9hUFuU2L7cOKG2JI9nIJSI+UQ5hl3WZMkU5F5Asf/YF/XBv93lYwQukpKTUwKaFd3D6DGW3lKsBcMLYAWFw+n4dTX6K8/Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229901; c=relaxed/simple;
	bh=R3pY2DDWeFeqJU+zWbM9OCnwnvtM5cnbp0XfDXOtuJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa5shd92YkBGnZDQ5dRUsm0lORKfoHghQ72nog1+LMPAYtx1zBQx/gW09SF/oPRi2ddojhIm2+6qlo4PK1DRFHRBKZDRgAuhPuZ6KDHpsxwykXbEvb6Xax4ejbLekSAX8Q3IVWYNAGoOUJ4UabPrJz5lsyVFeS7pQ+CnWVVHNYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM2lXxoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM2lXxoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBA91F000FF;
	Sat, 12 Sep 2026 16:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229900;
	bh=GFNdzOTaa428b2IQzAjjEbST0rKB/5I/K39o5YaPhGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GM2lXxoZI0+mJVMSjgWhmNYVT89YbMoJ0E9Fhnl5oN7vj26RSsDzYk8kAtq5ek5/w
	 AIdpQZmyUTLBRleW2HYhntAFmIDwaSk6IvK1PTsUlnMg6MLVgmX8rqmTZN+A1w36n5
	 84Iyu+WN2lnj2+wfhajMoxzNcy8dVWOqDZR/TrZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0683/1191] RDMA/core: Add support to set privileged QKEY parameter
Date: Sat, 12 Sep 2026 08:56:51 +0200
Message-ID: <20260912065603.600105528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 465d6b42f1a3b855c06da1d4d3b09907d261af69 ]

Add netlink command that enables/disables privileged QKEY by default.

It is disabled by default, since according to IB spec only privileged
users are allowed to use privileged QKEY.
According to the IB specification rel-1.6, section 3.5.3:
"QKEYs with the most significant bit set are considered controlled
QKEYs, and a HCA does not allow a consumer to arbitrarily specify a
controlled QKEY."

Using rdma tool,
$rdma system set privileged-qkey on

When enabled non-privileged users would be able to use
controlled QKEYs which are considered privileged.

Using rdma tool,
$rdma system set privileged-qkey off

When disabled only privileged users would be able to use
controlled QKEYs.

You can also use the command below to check the parameter state:
$rdma system show
netns shared privileged-qkey off copy-on-fork on

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/90398be70a9d23d2aa9d0f9fd11d2c264c1be534.1696848201.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/core_priv.h  |  1 +
 drivers/infiniband/core/nldev.c      | 63 ++++++++++++++++++++++++----
 drivers/infiniband/core/uverbs_cmd.c |  3 +-
 include/uapi/rdma/rdma_netlink.h     |  2 +
 4 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 149dacf5b64d8..a7bcf13ada64a 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -376,4 +376,5 @@ void rdma_umap_priv_init(struct rdma_umap_priv *priv,
 
 void ib_cq_pool_cleanup(struct ib_device *dev);
 
+bool rdma_nl_get_privileged_qkey(void);
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5aff8e284db2e..b010f78ed808b 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -43,6 +43,13 @@
 #include "restrack.h"
 #include "uverbs.h"
 
+/*
+ * This determines whether a non-privileged user is allowed to specify a
+ * controlled QKEY or not, when true non-privileged user is allowed to specify
+ * a controlled QKEY.
+ */
+static bool privileged_qkey;
+
 typedef int (*res_fill_func_t)(struct sk_buff*, bool,
 			       struct rdma_restrack_entry*, uint32_t);
 
@@ -156,6 +163,7 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]	= { .type = NLA_U8 },
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX]	= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC] = { .type = NLA_U8 },
+	[RDMA_NLDEV_SYS_ATTR_PRIVILEGED_QKEY_MODE] = { .type = NLA_U8 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -237,6 +245,12 @@ int rdma_nl_put_driver_u64_hex(struct sk_buff *msg, const char *name, u64 value)
 }
 EXPORT_SYMBOL(rdma_nl_put_driver_u64_hex);
 
+bool rdma_nl_get_privileged_qkey(void)
+{
+	return privileged_qkey || capable(CAP_NET_RAW);
+}
+EXPORT_SYMBOL(rdma_nl_get_privileged_qkey);
+
 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
 {
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_DEV_INDEX, device->index))
@@ -1883,6 +1897,12 @@ static int nldev_sys_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 	}
 
+	err = nla_put_u8(msg, RDMA_NLDEV_SYS_ATTR_PRIVILEGED_QKEY_MODE,
+			 (u8)privileged_qkey);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
 	/*
 	 * Copy-on-fork is supported.
 	 * See commits:
@@ -1899,18 +1919,11 @@ static int nldev_sys_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 }
 
-static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
-				  struct netlink_ext_ack *extack)
+static int nldev_set_sys_set_netns_doit(struct nlattr *tb[])
 {
-	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
 	u8 enable;
 	int err;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
-	if (err || !tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE])
-		return -EINVAL;
-
 	enable = nla_get_u8(tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]);
 	/* Only 0 and 1 are supported */
 	if (enable > 1)
@@ -1920,6 +1933,40 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int nldev_set_sys_set_pqkey_doit(struct nlattr *tb[])
+{
+	u8 enable;
+
+	enable = nla_get_u8(tb[RDMA_NLDEV_SYS_ATTR_PRIVILEGED_QKEY_MODE]);
+	/* Only 0 and 1 are supported */
+	if (enable > 1)
+		return -EINVAL;
+
+	privileged_qkey = enable;
+	return 0;
+}
+
+static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+				  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	int err;
+
+	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (err)
+		return -EINVAL;
+
+	if (tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE])
+		return nldev_set_sys_set_netns_doit(tb);
+
+	if (tb[RDMA_NLDEV_SYS_ATTR_PRIVILEGED_QKEY_MODE])
+		return nldev_set_sys_set_pqkey_doit(tb);
+
+	return -EINVAL;
+}
+
+
 static int nldev_stat_set_mode_doit(struct sk_buff *msg,
 				    struct netlink_ext_ack *extack,
 				    struct nlattr *tb[],
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2e4265ba35b7f..0890f56c0ec48 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1859,7 +1859,8 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
 	if (cmd->base.attr_mask & IB_QP_PATH_MIG_STATE)
 		attr->path_mig_state = cmd->base.path_mig_state;
 	if (cmd->base.attr_mask & IB_QP_QKEY) {
-		if (cmd->base.qkey & IB_QP_SET_QKEY && !capable(CAP_NET_RAW)) {
+		if (cmd->base.qkey & IB_QP_SET_QKEY &&
+		    !rdma_nl_get_privileged_qkey()) {
 			ret = -EPERM;
 			goto release_qp;
 		}
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index e50c357367db0..6e05b8ecb8a91 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -554,6 +554,8 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,	/* u32 */
 	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, /* u8 */
 
+	RDMA_NLDEV_SYS_ATTR_PRIVILEGED_QKEY_MODE, /* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.53.0



