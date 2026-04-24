Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1B723645D;
	Fri, 24 Apr 2026 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037824; cv=none; b=avZa1xbZ7apmB/Tqjq6rrORYcZbdjKxU7CGiz0vkWjK9ZYYZFItYjf9Iy4mkf58J6BeHz2UX3WYz8m/PjV7TLcpjPYNbVFyaTr7slL1h+RB7p8ed0d5iwMVMDvvFIZrDdrb2JBrPZPApx/Axzp8ib4Oa5qD40DFzDvOdVRi3jW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037824; c=relaxed/simple;
	bh=64UF9HTkhYKSOecvRhPWIiHV5sI5oZkWnbNfTOHXGts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C93RrLuu+sYIyBVj0O9iVklM3MM1rhxl6GmME7M44u8h2kbFJhtVV+SqbRqHhoFLC1wnH33WmWQ1TkZeVXaOoSb48P2edr/ndtMyfdEPp/GKSQ5rgogA1qMJToWABLIMC7YbrxexmIcWynlPUxOAmHhXf3FUjz0vnhELo5zjdyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6v9wGna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6v9wGna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86464C2BCB5;
	Fri, 24 Apr 2026 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037823;
	bh=64UF9HTkhYKSOecvRhPWIiHV5sI5oZkWnbNfTOHXGts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6v9wGnacgZ9GjsAxjWZKG1Xl4EDiZh/hUUz6doyuKhHFFekoFLt+rri1JDbqZhhK
	 vfLeWllMa8QDG435P0h91NT/8F/qSeyQ+iQF4yCo3TUf6AoIHGmgodqzT+FHZHOj1U
	 V+JC5g2CjO4LYtlhrZ+1WSxOx06fPxZ3bJa7CKjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/166] ipvs: fix NULL deref in ip_vs_add_service error path
Date: Fri, 24 Apr 2026 15:29:25 +0200
Message-ID: <20260424132543.512491838@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 9a91797e61d286805ae10a92cc48959c30800556 ]

When ip_vs_bind_scheduler() succeeds in ip_vs_add_service(), the local
variable sched is set to NULL.  If ip_vs_start_estimator() subsequently
fails, the out_err cleanup calls ip_vs_unbind_scheduler(svc, sched)
with sched == NULL.  ip_vs_unbind_scheduler() passes the cur_sched NULL
check (because svc->scheduler was set by the successful bind) but then
dereferences the NULL sched parameter at sched->done_service, causing a
kernel panic at offset 0x30 from NULL.

 Oops: general protection fault, [..] [#1] PREEMPT SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
 RIP: 0010:ip_vs_unbind_scheduler (net/netfilter/ipvs/ip_vs_sched.c:69)
 Call Trace:
  <TASK>
  ip_vs_add_service.isra.0 (net/netfilter/ipvs/ip_vs_ctl.c:1500)
  do_ip_vs_set_ctl (net/netfilter/ipvs/ip_vs_ctl.c:2809)
  nf_setsockopt (net/netfilter/nf_sockopt.c:102)
  [..]

Fix by simply not clearing the local sched variable after a successful
bind.  ip_vs_unbind_scheduler() already detects whether a scheduler is
installed via svc->scheduler, and keeping sched non-NULL ensures the
error path passes the correct pointer to both ip_vs_unbind_scheduler()
and ip_vs_scheduler_put().

While the bug is older, the problem popups in more recent kernels (6.2),
when the new error path is taken after the ip_vs_start_estimator() call.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Acked-by: Simon Horman <horms@kernel.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c82dcbb4dabce..25f586fab2bcc 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1452,7 +1452,6 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 		ret = ip_vs_bind_scheduler(svc, sched);
 		if (ret)
 			goto out_err;
-		sched = NULL;
 	}
 
 	ret = ip_vs_start_estimator(ipvs, &svc->stats);
-- 
2.53.0



