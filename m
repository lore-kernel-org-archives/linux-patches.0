Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B83C9886;
	Thu, 17 Sep 2026 19:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671749; cv=none; b=JtlP8SchEopj0NnA9Im9mNtSnQYtCizT9buqx3NPwBhLenDvwO5N7nLsiaPp1EVqQxuGiKqZsH4RvL+iHvJoYQmA3XsRbphOSSYbG0ZNbr46sunoBwvQcgTjAYZJPN/0s62Q/yW4lvawfjziRhHbw2+5/tNoF5XxuDjDcHyQmw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671749; c=relaxed/simple;
	bh=spY6eGfeIzAueaZaPzwtXvS5F+yHATe5b8hLOOLAjGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fufxjl6KMMXIPz0NU42IXT+GMkQ5MU2O8lRpvQErARKMPBlrSWQOq0snTpbAYoVvItTJN2qMFUm5uIEo/Gav0j/B2FrE/oexGnW1EfaD9C6R2pjz7W9YLBC3T6cF25TvRnHf93kih1OTJRijkowZft/wbf+pTuhaQz1A4DVLcOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cd2BzWUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cd2BzWUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87FB1F000FF;
	Thu, 17 Sep 2026 19:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671748;
	bh=go5owtcR50KfsOJO3lBqVFKHO3guPcKCK4T92tQJsYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cd2BzWUaoqb5KFBzJ7q0c8GbCmrWdeu6UcZKPnU0RKXriDitHFOo42/ThbWWiyUsG
	 W6MdkUUaConnj6UL3X9n7oido89DqClnXTPlukGsToVY9WAhqMWgm4g1+H7rGONx9n
	 rpdqytryn2YLrLBYtluEmdIO3OQ8cFRqndCLS9rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1076/1102] ipv6: annotate data-races around devconf->rpl_seg_enabled
Date: Thu, 17 Sep 2026 16:16:59 +0100
Message-ID: <20260917151607.851212032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 3a5f55500f3e93cf4d62351c753452279b088b4b ]

devconf->rpl_seg_enabled can be changed concurrently from
/proc/sys/net/ipv6/conf, annotate lockless reads on it.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250901123726.1972881-2-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f826df95332c ("ipv6: rpl: fix NULL dereference of idev in ipv6_rpl_srh_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -504,10 +504,8 @@ static int ipv6_rpl_srh_rcv(struct sk_bu
 
 	idev = __in6_dev_get(skb->dev);
 
-	accept_rpl_seg = net->ipv6.devconf_all->rpl_seg_enabled;
-	if (accept_rpl_seg > idev->cnf.rpl_seg_enabled)
-		accept_rpl_seg = idev->cnf.rpl_seg_enabled;
-
+	accept_rpl_seg = min(READ_ONCE(net->ipv6.devconf_all->rpl_seg_enabled),
+			     READ_ONCE(idev->cnf.rpl_seg_enabled));
 	if (!accept_rpl_seg) {
 		kfree_skb(skb);
 		return -1;


