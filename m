Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF3F85260;
	Tue, 26 Aug 2025 12:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213166; cv=none; b=fwElU2l+Qr9KKRCTSnFfLi7wFjGunwx84UxmNLt9cqcmUl1b9G8wIrpff3XTUrPsdWomiJaOvdvHruVQhR3f9EXisLxBvIZhQR5BMpHPZFK7gZU2QVcoA1HMxb0x4Kx7HRLUchYY4v0bhcC9VP+v34Os9+gyxsQ7jPpy9832fhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213166; c=relaxed/simple;
	bh=/LEUUyG9Aw+jaeEh8ALoeceBmPZ6h2xPmAGsSUVkACI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUXWL2FXUy1BXnb3RoR9vt5+WMYgZPLlW24ATvjx+GGfULIayqiL6bLAdsduS+deyWu1WtiP7I6FJxODl3k9Pv5iJYS+xbjTG8uPLN5jxOz4t9yYARcbxlLrc4MDn/ueLSBngiXNIXDviOAx52hIO1ZfbZHaDlCVlvIngQPaBhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG7uVjW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG7uVjW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE41EC4CEF1;
	Tue, 26 Aug 2025 12:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213166;
	bh=/LEUUyG9Aw+jaeEh8ALoeceBmPZ6h2xPmAGsSUVkACI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG7uVjW+pwSMsuNcrSZNOlV5zRH4uwg+QUUEdCetxPHHDqVi0+Nw9aiovmF/KRjt1
	 n0JrBxB4IgOrV0b7QO7jsCsZKrCRl0vLa+i/YCArVBcnMzDp578qGL7xHOsDaQIcbQ
	 VT328zzMzgNtbtncULnTat8HyaKftwkZRDbpK0Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/587] RDMA/core: reduce stack using in nldev_stat_get_doit()
Date: Tue, 26 Aug 2025 13:06:34 +0200
Message-ID: <20250826110959.163683953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 43163f4c30f94d2103c948a247cdf2cda5068ca7 ]

In the s390 defconfig, gcc-10 and earlier end up inlining three functions
into nldev_stat_get_doit(), and each of them uses some 600 bytes of stack.

The result is a function with an overly large stack frame and a warning:

drivers/infiniband/core/nldev.c:2466:1: error: the frame size of 1720 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Mark the three functions noinline_for_stack to prevent this, ensuring
that only one copy of the nlattr array is on the stack of each function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250620113335.3776965-1-arnd@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 6d1dbc978759..a94723a12bb4 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1412,10 +1412,11 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 
 };
 
-static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
-			       struct netlink_ext_ack *extack,
-			       enum rdma_restrack_type res_type,
-			       res_fill_func_t fill_func)
+static noinline_for_stack int
+res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+		    struct netlink_ext_ack *extack,
+		    enum rdma_restrack_type res_type,
+		    res_fill_func_t fill_func)
 {
 	const struct nldev_fill_res_entry *fe = &fill_entries[res_type];
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
@@ -2153,10 +2154,10 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
-static int stat_get_doit_default_counter(struct sk_buff *skb,
-					 struct nlmsghdr *nlh,
-					 struct netlink_ext_ack *extack,
-					 struct nlattr *tb[])
+static noinline_for_stack int
+stat_get_doit_default_counter(struct sk_buff *skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack,
+			      struct nlattr *tb[])
 {
 	struct rdma_hw_stats *stats;
 	struct nlattr *table_attr;
@@ -2246,8 +2247,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 	return ret;
 }
 
-static int stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct netlink_ext_ack *extack, struct nlattr *tb[])
+static noinline_for_stack int
+stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
+		 struct netlink_ext_ack *extack, struct nlattr *tb[])
 
 {
 	static enum rdma_nl_counter_mode mode;
-- 
2.39.5



