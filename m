Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1953AE45
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E19FC4339B;
	Wed,  7 Jun 2023 20:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169700;
	bh=y08Qjppg5diCdsQMIFdSGOwlAxVj3Of7bhHffPpi7A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1jRQHoX8EbbVW8lpty0nB2JSecFQxd39876B1ZvpmfszrfsDB+9N+GtmgxOI2Son
	 6edyFvVTTPBnAL2rrlmRcX7Z6/6hF0/7ZiZszZDGgh+UnhH6vQ6ITsW1Vn5e3sQjmj
	 87p7dxNBduNjiqW75/axUvm2d4HCs0A1iZ+L9VUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 163/286] netfilter: conntrack: define variables exp_nat_nla_policy and any_addr with CONFIG_NF_NAT
Date: Wed,  7 Jun 2023 22:14:22 +0200
Message-ID: <20230607200928.445926496@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

[ Upstream commit 224a876e37543eee111bf9b6aa4935080e619335 ]

gcc with W=1 and ! CONFIG_NF_NAT
net/netfilter/nf_conntrack_netlink.c:3463:32: error:
  ‘exp_nat_nla_policy’ defined but not used [-Werror=unused-const-variable=]
 3463 | static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
      |                                ^~~~~~~~~~~~~~~~~~
net/netfilter/nf_conntrack_netlink.c:2979:33: error:
  ‘any_addr’ defined but not used [-Werror=unused-const-variable=]
 2979 | static const union nf_inet_addr any_addr;
      |                                 ^~~~~~~~

These variables use is controlled by CONFIG_NF_NAT, so should their definitions.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d40544cd61a6c..69c8c8c7e9b8e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2976,7 +2976,9 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 static const union nf_inet_addr any_addr;
+#endif
 
 static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
 {
@@ -3460,10 +3462,12 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
 	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
+#endif
 
 static int
 ctnetlink_parse_expect_nat(const struct nlattr *attr,
-- 
2.39.2



