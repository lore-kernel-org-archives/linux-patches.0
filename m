Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C098F78C67;
	Wed,  7 Aug 2024 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043040; cv=none; b=Gi745lMsdukYhfHnibaGpm1HX+ebQ0PzBjHmFt0gdDdcy5SP2NOAtH59jLTctV1iXGTHxO0AlZHEkOM/4pOlCcA4ncxtr9FnjJxBjRsjVQsw6Sn865HtqqdN1gJTaJUOohp7yB6+UJXwUnAVjh/J0k0HAaEq28A2A7bWZiBUjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043040; c=relaxed/simple;
	bh=RmvtXaU0R1jnu15JODOIbTUOldm/QYr4DbnSZx7+LsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd5tUluhcjezPAcZRbWCCqu4brIWzJIqV7A3VhXU8pP52KMUey0/WUuLTTeJzOKbY4kM/kZUgvtA+f/6lFQ4mZptx0wwD/Rcgssd5bzltQ/Qpii9I2e+fawnP7zx/DxA1g7UhysfHgZ1ZcsfJQ9TowvaRixvxxRJVfEnsw8BMyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrktD4Tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrktD4Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527F3C32781;
	Wed,  7 Aug 2024 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043040;
	bh=RmvtXaU0R1jnu15JODOIbTUOldm/QYr4DbnSZx7+LsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrktD4TgXCuEhlyZrUEJJ41mZ51WR6SWev0p6iOvYhHxSqkEOXADMLnBR8X98zy4e
	 10mGLnTffY/BEXd0D3jypcUhO3HfIQQ7TiWgVOdFZuLgQXotpLym23SAqywSouYJUX
	 NbUp9PhINlRwpENUn/27sovdFlt4jZCF2SKzBSr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 039/123] rtnetlink: Dont ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().
Date: Wed,  7 Aug 2024 16:59:18 +0200
Message-ID: <20240807150022.105765682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4668d67180407..5e589f0a62bc5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3288,7 +3288,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
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



