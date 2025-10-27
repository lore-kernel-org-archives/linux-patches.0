Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688C231CA72;
	Mon, 27 Oct 2025 19:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591930; cv=none; b=YPmRqoh+c0/K21cRAebapSS4DW+cbqCFv2EHX1o63ni/vughyFCDIuZQGzm6RlFPH12K+YeA+1AlXQZil5D8A/FavWx9637g9kvhNm/+KgvJSI3jNN9MKZ9ZWuTHu7IsvQK29LNv+yOpuptibnFEC1cm6NMw8A6fFRSM9fuYnNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591930; c=relaxed/simple;
	bh=KZB96dmoK0PqbciWCg/LuQTuDHQyr4eM/B0fj5TvnTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8ppO2531pwMwm6NURIAPqqMMa4Tp81rq6pAbVUMwPCwxrsRUpCYuEJulu44VwV1k8uIHkP9+0SDhIZvvJZ0N/RKgznnllhHYRRPIdhDpPpTfdnQsBVwfu3uyM+pa4f62aMFUIcdlpFXyUXzdjeVqs/z+4hW9YVg2RotA7m7ig8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHJtvWh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHJtvWh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3CDC4CEF1;
	Mon, 27 Oct 2025 19:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591930;
	bh=KZB96dmoK0PqbciWCg/LuQTuDHQyr4eM/B0fj5TvnTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHJtvWh9HupYR0awVB9B3zwuYR9cykqex8z43YzhqFdvWGxHYstI0bSHZFXzRbd/S
	 4o3NEq556niXBBm2YxFKcPzjTafAt3RKIGky9JPRM+tcJQxy5DUGSdWymKV+XUtAui
	 Rb+b5yqLiE9N921zrd0JX3dtLaA7Y1LKXzQu7dB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/123] net: rtnetlink: add helper to extract msg types kind
Date: Mon, 27 Oct 2025 19:35:32 +0100
Message-ID: <20251027183447.789942480@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 2e9ea3e30f696fd438319c07836422bb0bbb4608 ]

Add a helper which extracts the msg type's kind using the kind mask (0x3).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 6 ++++++
 net/core/rtnetlink.c    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index dcb1c92e69879..d2961e2ed30bd 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -19,6 +19,12 @@ enum rtnl_kinds {
 	RTNL_KIND_GET,
 	RTNL_KIND_SET
 };
+#define RTNL_KIND_MASK 0x3
+
+static inline enum rtnl_kinds rtnl_msgtype_kind(int msgtype)
+{
+	return msgtype & RTNL_KIND_MASK;
+}
 
 struct rtnl_msg_handler {
 	struct module *owner;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e8e67429e437f..79fb6d74e6dab 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5572,7 +5572,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return 0;
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
-	kind = type&3;
+	kind = rtnl_msgtype_kind(type);
 
 	if (kind != RTNL_KIND_GET && !netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
-- 
2.51.0



