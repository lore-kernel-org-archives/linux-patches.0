Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2821714A1;
	Thu, 15 Aug 2024 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730250; cv=none; b=X1j2bGgQKINd6shNv3D1HDBU90IOuMli8ypa7HStR/t9ynMswnPDRLFHbF1qBRVQI6W+5iKGIPiZwgX61MFiQ+RglJpSNWGH7kAWLRq4hGaocpmrdyC6b+4FqZ/OqtVBm0BWe+0BGfI7vwXGlhbgjQ1ayJFO+43fw9wXjqx7oyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730250; c=relaxed/simple;
	bh=HrtKBLFzwdAchFyUPYndErfFSxj8Dhh+qfsIALUhPyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR2/6ksxbd39Ok4rl04plhNrU+yi5K1GjQjoQOD7cEDuW7FP84tEyNChyEGI3JfWJd/DAyQbLRXkLeM+LZ/B2/thCg2kNG7wLvSwAW/Bxhj8V5ZQ0353QhwBM+MZNgvr5ci+vA5WchCYqXxc4sQAP/69ruDd7XF7ODErOpo4AMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVyIfiCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVyIfiCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6C1C4AF0C;
	Thu, 15 Aug 2024 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730250;
	bh=HrtKBLFzwdAchFyUPYndErfFSxj8Dhh+qfsIALUhPyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVyIfiCfHDuyLFIkiL/DCEh0JOaMYgzp50y4GREs5XxlFOSdJAOy4KICJEZKSR5Eo
	 qXI2XlIY+bcygu3fEbyn/cOdz4JSuWzrtqVm+hjPHyaWEJl0qzXTmQYwtNZK3P/jas
	 RzyMk2SfzL0rTdWxNhzH8FMFpgnbVQ8NZ7u7d3Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/484] rtnetlink: Dont ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().
Date: Thu, 15 Aug 2024 15:23:11 +0200
Message-ID: <20240815131954.273504926@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4284406740932..eca7f6f4a52f5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3115,7 +3115,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
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



