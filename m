Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5348F27FB37;
	Sat, 12 Sep 2026 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229896; cv=none; b=bIjmvTHZw2Nqd15mUo5jfbiFVfq8ocg7ifOriSIJUo93kG2Nvtx1pKyeNB00hlkYSF5yuHaAbJu2m04wOXpUYTktOrqK/LXjNjWaKvmOTkifrH8Uc890GigKtOSiTv+ZXaPSejPBjXugQwnd2JNxxmKlLTsKxKlUdBsQUZp13B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229896; c=relaxed/simple;
	bh=oEspvDMSiZGN5KzKkmAIYN6kq7qujxB/WFZx/OFwY2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyZXjwCR09xG4SOucf8Vjk15TYFJCw8u74l8T3erVMjNTMKpaK716r3+cNgvBWrNpGVCGQoYzuuwhP8Y6hz9qVLOUPBg5Ot/Gm/TNklNsIybYLa4eRgfefIrM4RzLBCbhHD2TUnA69BDO0dzEsyf1ab82o6yj5j0jeGt2ac1kNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jc2r9RKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jc2r9RKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490661F000FF;
	Sat, 12 Sep 2026 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229895;
	bh=EwKJpQn9IRI/sBfEL/GKH1qbvMDaN0KSHZqDfnsLh4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jc2r9RKykYs0NIKbqS/J8l1t+ekHSMXT7yUI82BVf70fVnmBIKI5CuGRQAAX8A06v
	 lTSw2B/yv92xsba7EJN7ubQSe1J9B3UXKOi7XiHY+RTKMdahMe3ghgQ+CZzOU4lGLZ
	 D9u+H/mK8yBaINmr9h9xk2dyFjwOCaiZruXG8eg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0682/1191] RDMA/nldev: Add NULL check to silence false warnings
Date: Sat, 12 Sep 2026 08:56:50 +0200
Message-ID: <20260912065603.575891964@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 67e6272d53386f9708f91c4d0015c4a1c470eef5 ]

Using nlmsg_put causes static analysis tools to many
false positives of not checking the return value of nlmsg_put.

In all uses in nldev.c, payload parameter is 0 so NULL will never
be returned. So let's add useless checks to silence the warnings.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/bd924da89d5b4f5291a4a01d9b5ae47c0a9b6a3f.1669636336.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 44 +++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 353ba8f68dedf..5aff8e284db2e 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1043,6 +1043,10 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto err_free;
+	}
 
 	err = fill_dev_info(msg, device);
 	if (err)
@@ -1128,7 +1132,7 @@ static int _nldev_get_dumpit(struct ib_device *device,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, NLM_F_MULTI);
 
-	if (fill_dev_info(skb, device)) {
+	if (!nlh || fill_dev_info(skb, device)) {
 		nlmsg_cancel(skb, nlh);
 		goto out;
 	}
@@ -1187,6 +1191,10 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
 			0, 0);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto err_free;
+	}
 
 	err = fill_port_info(msg, device, port, sock_net(skb->sk));
 	if (err)
@@ -1248,7 +1256,7 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 						 RDMA_NLDEV_CMD_PORT_GET),
 				0, NLM_F_MULTI);
 
-		if (fill_port_info(skb, device, p, sock_net(skb->sk))) {
+		if (!nlh || fill_port_info(skb, device, p, sock_net(skb->sk))) {
 			nlmsg_cancel(skb, nlh);
 			goto out;
 		}
@@ -1290,6 +1298,10 @@ static int nldev_res_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
 			0, 0);
+	if (!nlh) {
+		ret = -EMSGSIZE;
+		goto err_free;
+	}
 
 	ret = fill_res_info(msg, device);
 	if (ret)
@@ -1321,7 +1333,7 @@ static int _nldev_res_get_dumpit(struct ib_device *device,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_GET),
 			0, NLM_F_MULTI);
 
-	if (fill_res_info(skb, device)) {
+	if (!nlh || fill_res_info(skb, device)) {
 		nlmsg_cancel(skb, nlh);
 		goto out;
 	}
@@ -1457,7 +1469,7 @@ res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 					 RDMA_NL_GET_OP(nlh->nlmsg_type)),
 			0, 0);
 
-	if (fill_nldev_handle(msg, device)) {
+	if (!nlh || fill_nldev_handle(msg, device)) {
 		ret = -EMSGSIZE;
 		goto err_free;
 	}
@@ -1536,7 +1548,7 @@ static int res_get_common_dumpit(struct sk_buff *skb,
 					 RDMA_NL_GET_OP(cb->nlh->nlmsg_type)),
 			0, NLM_F_MULTI);
 
-	if (fill_nldev_handle(skb, device)) {
+	if (!nlh || fill_nldev_handle(skb, device)) {
 		ret = -EMSGSIZE;
 		goto err;
 	}
@@ -1798,6 +1810,10 @@ static int nldev_get_chardev(struct sk_buff *skb, struct nlmsghdr *nlh,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_GET_CHARDEV),
 			0, 0);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto out_nlmsg;
+	}
 
 	data.nl_msg = msg;
 	err = ib_get_client_nl_info(ibdev, client_name, &data);
@@ -1855,6 +1871,10 @@ static int nldev_sys_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_SYS_GET),
 			0, 0);
+	if (!nlh) {
+		nlmsg_free(msg);
+		return -EMSGSIZE;
+	}
 
 	err = nla_put_u8(msg, RDMA_NLDEV_SYS_ATTR_NETNS_MODE,
 			 (u8)ib_devices_shared_netns);
@@ -2040,7 +2060,7 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_SET),
 			0, 0);
-	if (fill_nldev_handle(msg, device) ||
+	if (!nlh || fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
 		ret = -EMSGSIZE;
 		goto err_free_msg;
@@ -2109,6 +2129,10 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_SET),
 			0, 0);
+	if (!nlh) {
+		ret = -EMSGSIZE;
+		goto err_fill;
+	}
 
 	cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
 	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
@@ -2179,7 +2203,7 @@ stat_get_doit_default_counter(struct sk_buff *skb, struct nlmsghdr *nlh,
 					 RDMA_NLDEV_CMD_STAT_GET),
 			0, 0);
 
-	if (fill_nldev_handle(msg, device) ||
+	if (!nlh || fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
 		ret = -EMSGSIZE;
 		goto err_msg;
@@ -2268,6 +2292,10 @@ stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_GET),
 			0, 0);
+	if (!nlh) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
 
 	ret = rdma_counter_get_mode(device, port, &mode, &mask);
 	if (ret)
@@ -2400,7 +2428,7 @@ static int nldev_stat_get_counter_status_doit(struct sk_buff *skb,
 		0, 0);
 
 	ret = -EMSGSIZE;
-	if (fill_nldev_handle(msg, device) ||
+	if (!nlh || fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
 		goto err_msg;
 
-- 
2.53.0



