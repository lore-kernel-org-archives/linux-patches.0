Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F58286881;
	Tue, 26 Aug 2025 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216507; cv=none; b=tq4Czf6Oug/zxb5D2DD852N2WMP8CzpHOVvbYi2ibD8I25RMmLjewA5WgNT9zssxAtgLrfKEMgl5QHCEbjCJEF5CafRGuP6rxwI70EeaYbtUtjk4sPUrj34Uv1FG/v6SnOjOd5WYCUvHVWH9KEbmoN7iZXng3NomDCyVLkxCJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216507; c=relaxed/simple;
	bh=Hxrv10zO2ASsDsUIfyi/BcFUc2HFUNrN71TI2lC8PPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgssvkSJ5hHSWEjUURfiazquByIGi3fzSQcgMsAl7y9QkTSKknyhPucOZU15NWYB79tBRmTntEcL5ZjQe4PHsbLtAKSSVEgyub4SOwwVO7mK3bANOuD2AvNqSJTK7W52+80MWeOFA1EH5fINenH/kKJUZH1a8xgaibIC7Qt1Xwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCkWSHJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCkWSHJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B1CC4CEF1;
	Tue, 26 Aug 2025 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216507;
	bh=Hxrv10zO2ASsDsUIfyi/BcFUc2HFUNrN71TI2lC8PPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCkWSHJf3cGWZgYrmcJSNwYEwN7XB9ue/uVWKuiXuPT+8ulcHsMKSerB9Z+QhlBVq
	 0GzIln6lf7eKaeayt+wmKCegm/rO1205uv2cz6LhaXFpJWOwOQb7TJKjKPUV0Gq3F6
	 lM/Pi8XZbXo5/n0Hcls1rGp/ILksnhrt+mzGo2p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/644] RDMA/core: reduce stack using in nldev_stat_get_doit()
Date: Tue, 26 Aug 2025 13:08:11 +0200
Message-ID: <20250826110956.363379434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 050bafc7c52d..1bfa957b8775 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1391,10 +1391,11 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 
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
@@ -2041,10 +2042,10 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -2130,8 +2131,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
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



