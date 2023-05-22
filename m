Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A74171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED73C433EF;
	Mon, 22 May 2023 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783006;
	bh=46JPQgvY8+GKyx9vRVyNC8gdIQAMIF+CJMkb8ogRUug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTJYmkfvzEDoN8UrdVIpIV5BqqnI5Wl+b37lMysvugnGa7ksNGnLXPD1GyU9FaZhb
	 m10bIT6SKu0E4+CQyemKVj347y1WP9qcoR1qK+Z7bMPolEPMgvdil5uTtLJwEEjJ5F
	 5jj88OcORAz7k3LkBUG0D7OtA8wZkb7C06bXSrrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/203] xfrm: dont check the default policy if the policy allows the packet
Date: Mon, 22 May 2023 20:08:51 +0100
Message-Id: <20230522190357.946001747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 430cac487400494c19a8b85299e979bb07b4671f ]

The current code doesn't let a simple "allow" policy counteract a
default policy blocking all incoming packets:

    ip x p setdefault in block
    ip x p a src 192.168.2.1/32 dst 192.168.2.2/32 dir in action allow

At this stage, we have an allow policy (with or without transforms)
for this packet. It doesn't matter what the default policy says, since
the policy we looked up lets the packet through. The case of a
blocking policy is already handled separately, so we can remove this
check.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 0540e9f72b2fe..37eeda0f123cd 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3636,12 +3636,6 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 		xfrm_nr = ti;
 
-		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK &&
-		    !xfrm_nr) {
-			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
-			goto reject;
-		}
-
 		if (npols > 1) {
 			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family);
 			tpp = stp;
-- 
2.39.2



