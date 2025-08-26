Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF81352FFA;
	Tue, 26 Aug 2025 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217947; cv=none; b=t72Tg4Za/fUU9N9vEyzwDxzw8o9uNMN7FmDVpBFeJSRs8uoYAdzp8yUTGjA3mfuqC08Gta/2NJKVkTWARbf408zy5fW6CJ9G7eDM1SkPAEK82z7aiG3VsDyRKkJHNvyDbaD6YxmrwLXMvcQ6PJzO2mWN6C8msUNLTPpxPeNnV7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217947; c=relaxed/simple;
	bh=w/90j2oxKqdPJAN2ZDfffp1ZyMYlD8WgfaenWo/qVa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAOx0yj+EWbLI1wLPOJ7x3wcfbKpnLlcRSZf2f9+nvEUNjWDPHAGu+Hpr1Wx8DE+ykNOp+Ym8L+2PeyHObqzSbhdOTz7P5z56iFzZlYtg2yBhRMWOCgtOaiZTNmmof+wBvIOVc09lGWhsn1EhkwLo40Byg7oVWVCeTshxiknJlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mCDIB8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mCDIB8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15D8C4CEF1;
	Tue, 26 Aug 2025 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217947;
	bh=w/90j2oxKqdPJAN2ZDfffp1ZyMYlD8WgfaenWo/qVa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mCDIB8BNUH0YmVAt/asEHmt/KlpY1mIK3ueedyhr1d+bnJIaUGwesxjsScorkNzg
	 xmPd8CWXr+RG7GISRlXpfLGnk0tgRV+33kp2S6Aco4GUkKXGASj2jEumI5PjXEmuND
	 vp05bXioHtKjTYik0nhd2GoRiMngl786z3uX9px4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/523] RDMA/core: reduce stack using in nldev_stat_get_doit()
Date: Tue, 26 Aug 2025 13:08:34 +0200
Message-ID: <20250826110931.953809994@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f8dfec7ad7cc..1475069aa428 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1240,10 +1240,11 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 	},
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
@@ -1877,10 +1878,10 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -1970,8 +1971,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
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



