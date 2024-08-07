Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF0C374CC;
	Wed,  7 Aug 2024 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043653; cv=none; b=RjlbK6i1VT/NLsG3ynSmWhsTfpjp2GX+gq/R5C16OvvX629RjJ6mTlCQk107CtZZ/iwu1f2cN5KraqVbuJmYKmqa8FK80sBA0InbIMCGlBSCPQGCHsy867rlw4IxihhW1Yk2uslzM6I+/fI7qxFlZ3tSEjDGUg1SB1l5LuVkIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043653; c=relaxed/simple;
	bh=s1HFp56bQChysUG9yaQnLqwI6V7qwCIuabG5qWVBslc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfmhvWc0sLtdkCtke3+ZigsiAsIRIl+RVp6/YPw92ArFYY7E1FdExkYApr/dvQlkjaYb5v0d2AohsXdizLAYL+RaYJ/O0KGfC+p3jr4QhVGAyl0AGEX1YGG4TTj4Rl8EDngl0lmFO3XKPh4xzH+2IQC5QKSWgOcLZOYVcMiGH38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhfgkW2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhfgkW2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751CC32781;
	Wed,  7 Aug 2024 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043653;
	bh=s1HFp56bQChysUG9yaQnLqwI6V7qwCIuabG5qWVBslc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhfgkW2fVGRfIEjpiWBafdqZ+6FxZem+OUHCfydOf+0vyL8LBAsGsMjupRHquDNFi
	 kSzahm2V3hoVZ3A52IIollVPxuxgq8+eSp/dFQi/d2pVplp7VYry55hEOFsXi4BuKr
	 8uGSxMs/Hx0XtIT5xoqE+aSd9PXpvzb32XjvGJwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/86] rtnetlink: Dont ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().
Date: Wed,  7 Aug 2024 17:00:28 +0200
Message-ID: <20240807150040.861687087@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9415d375d8520e0ed55f0c0b058928da9a5b5b3d ]

The cited commit accidentally replaced tgt_net with net in rtnl_dellink().

As a result, IFLA_TARGET_NETNSID is ignored if the interface is specified
with IFLA_IFNAME or IFLA_ALT_IFNAME.

Let's pass tgt_net to rtnl_dev_get().

Fixes: cc6090e985d7 ("net: rtnetlink: introduce helper to get net_device instance by ifname")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1163226c025c1..be663a7382ce9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3178,7 +3178,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(net, tb);
+		dev = rtnl_dev_get(tgt_net, tb);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
 	else
-- 
2.43.0



