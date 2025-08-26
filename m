Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C5823A984;
	Tue, 26 Aug 2025 13:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214588; cv=none; b=kcPJ7s7nni0Rmx+4AVS/RgVs8Qo9mj/zTohCImGqaRCK6swuI2k/cT9qEuJN2rMHTBwuwNBGNw4Oq2Z0qZBmDUSI6sHUhgh3TL6Td/LM6ezmvHgwubr3/0/GmloAnPKya02WvrufakTHX+lc22VLBr7ErB/a426BXn/3dWe2xsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214588; c=relaxed/simple;
	bh=ocVf39T4WNVtNjzeylVM7yEr7gaXgAo1TYhZbaOWIkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnSv5ufQ5wRmLYmqj++q/8Ka8f/phJHqMp1YEBAAuGS/L/H33QuFVRhkmzlB7DrLM7rxlmAug8kWuBmvIjnDZAvOSnlNISAHIu7c3jf0QtH/fRFnMdclPDbJwkXStQe1cAs0SAWlqtiOuYXSbr88uV/XsnEM/vxjyfFzxvZo124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWJnrVH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWJnrVH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D387CC4CEF1;
	Tue, 26 Aug 2025 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214588;
	bh=ocVf39T4WNVtNjzeylVM7yEr7gaXgAo1TYhZbaOWIkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWJnrVH2lTumtRPIy8/ir3UouJaP7yPrDNwcA1hh7oZpHh8xvj9uSqV7m3ONRu6nW
	 KXdmjZIIwhRGH662ZXoUHRZDAPvmBnZNq3dpogAcCTD/+0Gqiz7DI2UgMT8CdxS0gs
	 yo5WNyrLdD+ZbxM8tCwtYRrsSWAlmOkcz6G8WBqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/482] RDMA/core: reduce stack using in nldev_stat_get_doit()
Date: Tue, 26 Aug 2025 13:07:28 +0200
Message-ID: <20250826110935.616796749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1adf20198afd..7e08ce963125 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1400,10 +1400,11 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 
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
@@ -2129,10 +2130,10 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -2222,8 +2223,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
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



