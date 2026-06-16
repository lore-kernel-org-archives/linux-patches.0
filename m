Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C701247A0DE;
	Tue, 16 Jun 2026 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630486; cv=none; b=EGITMZhADD5UEq5WlGFfL5qyPCmuzaPuT8uqSQPJMYR6YRNWtE+VdZ3E9VOvw2NMqB4bdotKSDHkyXzQkTWkPav7c0YwcjQAX5Io9OpZfp0J1vy/vJZJKbMYAfLhbpXAjLEoijpRYiEG4f/lPww4c4So770ZxGyjca+Ud4MiZm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630486; c=relaxed/simple;
	bh=bIrgoazoYpgmE8teszy3L0jcAxzl65Vam5aW7SMIu+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKfc3OlUUszFJTtuZqQy7CTp/0S6jZnQT389u9MEBddELi/iNZFH8lvop9J5FqQOItjCcetGPuoc/BHZw6lSRh8zZBZSwfD5ZtJ7cdiQpGAJxp/TjT1yhcAL4L446Wj3wAIOMFK36wX/Zw6dRDCaezjm5Expx0Z+3AwLWi6vfMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKvsq0oM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKvsq0oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28E91F00A3F;
	Tue, 16 Jun 2026 17:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630484;
	bh=523v0AEOwk5dURIjmmCwE2j3YGbLWt2WOuCMhOQCHco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKvsq0oM1NSo78v1ZitBdK8gnov6D1+6Rzjs/TIvvvX2nXZXzmcJM7iyhl9AwJb9g
	 f7LDqM59U/G7cqg8y8B2sDcBUVgTUajmk8obRW3z92l1iMWTKBkjYBBFBNFnQPwo3Z
	 5IJeF/9YA7vntINpHornIXpZcKxndXc2+vk8I0Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/522] ipv6: fix possible infinite loop in rt6_fill_node()
Date: Tue, 16 Jun 2026 20:23:06 +0530
Message-ID: <20260616145127.521883701@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 9f72412bcf60144f252b0d6205106abf14344abc ]

Sashiko reported this issue [1]. Apply the same fix as
commit f8d8ce1b515a ("ipv6: fix possible infinite loop in fib6_info_uses_dev()").

Writers holding tb6_lock can list_del_rcu(&rt->fib6_siblings)
without waiting for RCU readers; rt->fib6_siblings.next then still
points into the old ring and this softirq-side walker never reaches
&rt->fib6_siblings, causing a CPU stall. fib6_del_route() always
WRITE_ONCE()s rt->fib6_nsiblings to 0 before list_del_rcu(), so an
inside-loop check is a reliable detach signal.

[1] https://sashiko.dev/#/patchset/20260526020227.4857-1-jiayuan.chen%40linux.dev

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260527053133.180695-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 987ef0954e2ea2..0e96f7cb21a297 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5790,6 +5790,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 
 				goto nla_put_failure;
 			}
+			if (!READ_ONCE(rt->fib6_nsiblings))
+				break;
 		}
 
 		rcu_read_unlock();
-- 
2.53.0



