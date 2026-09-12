Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B13AAF53;
	Sat, 12 Sep 2026 18:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238993; cv=none; b=Nm/GS0jiCYPOa58WfEk+klOPts1qGZPcC2rdq6NtVgIVy28TadKpd8qKEjHn/n1dIXK9XoS2PCgaSU/arX+znBHTxWY24CnL1q1L+v5ANKVC6de2bqtPdLS4ryoumclTmZOyge6YXfdhRgmQ3l73fUgvEwya8mAvnwqSdrn00e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238993; c=relaxed/simple;
	bh=nQu+vkOp9g9xuWNfx3ppwoH6kP6UANQdQLcjaRYXXCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8LfQoAMkHFn0CaAd0aiFGZQ8TQwbBCp9KpSCwvYDDTC+HFWL04lMziILZI6y9y940rCQ7cELyV28DDepXaPCEFZ9Kq2irBt6I12d0vTTO8dHBBdBqSKRgps8IqwFSeKg92NKMWNfJOd9L435/mnqw6lrOQ5Hkdci4slpm4RewU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHSHbTa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHSHbTa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E421F000FF;
	Sat, 12 Sep 2026 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238991;
	bh=6tHwbDByFPkiZedQ5C4LDgmC3KI2VQ3azaevkdWh6qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHSHbTa7pwlownoTzLdnJYKG1FcKWqng3PQL5HdlwyRqbgCIrjlkrlFVC8omkSzs5
	 FO1Yyz/gw+r/Zkj7JfgihrC5LyqiQObMtYcNvu13G1mLGUVfZAVneQv0bbOHJ0yc1i
	 NmVs5yGkFNJ7mKiK/z2YeVFr1lqpRFbAt/JDJpUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 573/935] RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
Date: Sat, 12 Sep 2026 09:00:03 +0200
Message-ID: <20260912065539.983023044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit 822cf785ac6d9120386f59964d6d029f3f04a8e3 ]

In order to allow expansion of the set command with more set options, take
the set mode out of the main set function.

Link: https://lore.kernel.org/r/20211008122439.166063-9-markzhang@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 116 +++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 1bfa957b8775a..19dce093e4cb6 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1891,24 +1891,67 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int nldev_stat_set_mode_doit(struct sk_buff *msg,
+				    struct netlink_ext_ack *extack,
+				    struct nlattr *tb[],
+				    struct ib_device *device, u32 port)
+{
+	u32 mode, mask = 0, qpn, cntn = 0;
+	int ret;
+
+	/* Currently only counter for QP is supported */
+	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+		return -EINVAL;
+
+	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
+	if (mode == RDMA_COUNTER_MODE_AUTO) {
+		if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+			mask = nla_get_u32(
+				tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+		return rdma_counter_set_auto_mode(device, port, mask, extack);
+	}
+
+	if (!tb[RDMA_NLDEV_ATTR_RES_LQPN])
+		return -EINVAL;
+
+	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
+	if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
+		cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+		ret = rdma_counter_bind_qpn(device, port, qpn, cntn);
+		if (ret)
+			return ret;
+	} else {
+		ret = rdma_counter_bind_qpn_alloc(device, port, qpn, &cntn);
+		if (ret)
+			return ret;
+	}
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
+		ret = -EMSGSIZE;
+		goto err_fill;
+	}
+
+	return 0;
+
+err_fill:
+	rdma_counter_unbind_qpn(device, port, qpn, cntn);
+	return ret;
+}
+
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
-	u32 index, port, mode, mask = 0, qpn, cntn = 0;
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
 	struct ib_device *device;
 	struct sk_buff *msg;
+	u32 index, port;
 	int ret;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
-	/* Currently only counter for QP is supported */
-	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
-	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
-	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] || !tb[RDMA_NLDEV_ATTR_STAT_MODE])
-		return -EINVAL;
-
-	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1, nldev_policy,
+			  extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
 		return -EINVAL;
 
 	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
@@ -1919,59 +1962,40 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
 	if (!rdma_is_port_valid(device, port)) {
 		ret = -EINVAL;
-		goto err;
+		goto err_put_device;
+	}
+
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+		ret = -EINVAL;
+		goto err_put_device;
 	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
-		goto err;
+		goto err_put_device;
 	}
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_SET),
 			0, 0);
-
-	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
-	if (mode == RDMA_COUNTER_MODE_AUTO) {
-		if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
-			mask = nla_get_u32(
-				tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
-		ret = rdma_counter_set_auto_mode(device, port, mask, extack);
-		if (ret)
-			goto err_msg;
-	} else {
-		if (!tb[RDMA_NLDEV_ATTR_RES_LQPN])
-			goto err_msg;
-		qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
-		if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
-			cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
-			ret = rdma_counter_bind_qpn(device, port, qpn, cntn);
-		} else {
-			ret = rdma_counter_bind_qpn_alloc(device, port,
-							  qpn, &cntn);
-		}
-		if (ret)
-			goto err_msg;
-
-		if (fill_nldev_handle(msg, device) ||
-		    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
-		    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
-		    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
-			ret = -EMSGSIZE;
-			goto err_fill;
-		}
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
 	}
 
+	ret = nldev_stat_set_mode_doit(msg, extack, tb, device, port);
+	if (ret)
+		goto err_free_msg;
+
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 
-err_fill:
-	rdma_counter_unbind_qpn(device, port, qpn, cntn);
-err_msg:
+err_free_msg:
 	nlmsg_free(msg);
-err:
+err_put_device:
 	ib_device_put(device);
 	return ret;
 }
-- 
2.53.0



