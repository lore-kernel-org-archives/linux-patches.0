Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9A22E3AF1;
	Sun,  7 Jun 2026 10:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827634; cv=none; b=ASBZ3NBT+xARKxvcgzBFlVTBVKxh1ZfuuIds88iHf0/OJoGyuWfVGh2/e0bRfsX5ALaOfOlWmyjb+KSMj39yhT7Ex6MzC/r8bcALTyPZsxIK7raSwMab7Yw6JPVZX+JJjCJBipSM6tdt8aD2mZd6pPYO6Cbd6+G8u/7Iyl6hTI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827634; c=relaxed/simple;
	bh=hfHIahQknxvoNgKWU0yHNjwlat6rsINFZpxq+WVplxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXKoEh+jdEpDbviXn5LyqvMLTjemfxDOCiT/Z0gMxyOEMPmwfFJNZfJdDfOGCX8xfpgmMDTnRPXZMzLEIzLXWXuliqtqRDT7h6+Tl5rskoK7KeDvArnogpq+B90O8NyBybBjWDm0B0JIcjm788my1uB70LXOEH0F6ZTumeFfKNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=td2+G2/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="td2+G2/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBBA1F00893;
	Sun,  7 Jun 2026 10:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827633;
	bh=NR9ZxvtbPQEmf9huFzxS1zhIJdc5IzErGXB473CW4Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=td2+G2/D7Y89xPlOp5k6305OrfuAooFRbzmhXezDwFOGjRbMEIgYA23Se28WfkcKm
	 RYbehq5bTcIGdoiyKXVcYhrcqXAb+pOb9o1bl8/z9pOrkmpkpI1z4KpQ72SQSJurpt
	 OblUPff2iHHkMSuWYi18xUoQQ+V1X7h/xmR8Y1QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 110/332] ipv6: fix possible infinite loop in rt6_fill_node()
Date: Sun,  7 Jun 2026 11:57:59 +0200
Message-ID: <20260607095732.158093455@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index cb521700cee7ed..398e873072bbfb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5891,6 +5891,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 
 				goto nla_put_failure;
 			}
+			if (!READ_ONCE(rt->fib6_nsiblings))
+				break;
 		}
 
 		rcu_read_unlock();
-- 
2.53.0



