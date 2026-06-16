Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD271A6803;
	Tue, 16 Jun 2026 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628355; cv=none; b=jnkTisdDsPSr1R4HuItmFX+AalO6cq89BYgi6CE2v5ex3NVFKQdDtgbKMEV9yDAnyTiADWClBPfjuVQBfs2/cXm5H7GGTmo0Qo1AQM7at3EkMZHrj1YJrfExr/JzSv3e3vZvOeS3xl//JgB/iva7u4a8n+YBrXfA7mdKmnSOVok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628355; c=relaxed/simple;
	bh=xP65VsI00YADUrgQDhy3X3Jm+YgPBt+ri5T5sjNqCCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abpFIJI3SqS7pAj2hfrITYjM3Ae/dyjBJC0xYrtmJpKqRul9I4xysizr7U8bx7Jvi856VU8pEZPkSqE1atl54wcnjo6toQDJ4Ttzr8sKSuxF+opiOPFgFDPm3guIQOLhhEEjIJ1Jkr28RHpXyaTQFAl/+gnHhU7NDT7GWP9exXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsbgBwwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsbgBwwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5641F000E9;
	Tue, 16 Jun 2026 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628354;
	bh=bH7C9KqTeLiUhoDVxk8n06zsxsQi+eMJWDsepaoJigc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsbgBwwc6I+MNB01kF83O/aNKhyVO2TjKpod+fS3uTJiO0hh3duVxIouMBR0dU7cY
	 hZq/AYID0Eko0nJQ8kKMHp4BaI7aYi+jQeohIVvKS/1WEtoSDOvkcoGIXmqCzJhnIt
	 fl31E+LxsyHabIqA5PeERygqcpGNL7BwhwiOGyQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/452] ipv6: fix possible infinite loop in rt6_fill_node()
Date: Tue, 16 Jun 2026 20:24:33 +0530
Message-ID: <20260616145120.354944538@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5b71baf95e7b3..69659f2a6aea96 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5797,6 +5797,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 
 				goto nla_put_failure;
 			}
+			if (!READ_ONCE(rt->fib6_nsiblings))
+				break;
 		}
 
 		rcu_read_unlock();
-- 
2.53.0



