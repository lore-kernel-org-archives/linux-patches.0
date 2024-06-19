Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E413F428;
	Wed, 19 Jun 2024 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803935; cv=none; b=ndQyVglC1FCJJ/A2inXsSdftk3Qvkk7gEwqQBpTHIOJziGZGBw93SvhE8ASBhtzkiZ++NdTU+UTRyU1RVJSAzV74ig5lSrQVrcEC40qH62PLmbTWJmgg0ZIzp9Eo64gbGJcQUJKNeyK5SJG/EGoqqW7Wxs4GbH8M88n/OUfUVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803935; c=relaxed/simple;
	bh=uo3MoFD06EnBIuw7DHXkZ9wHw7eGv1AEjxi38Pb0JYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSWbG6+e0NzxwWlFslspLed4rXnqA4vr7h+ZddoyQoj/SUYRA6PjPHrkhewgarivaEla3SjPHB5dEfAHazetyeVNorkXaoI6tlw+/VAThLFYiWIYLSKAvBSQbXjtPkIeeWpnM7w5olQCyNENvFGMgasW9DaAmX6gu/1YdZfsCM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmJuOkMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmJuOkMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45508C2BBFC;
	Wed, 19 Jun 2024 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803935;
	bh=uo3MoFD06EnBIuw7DHXkZ9wHw7eGv1AEjxi38Pb0JYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmJuOkMvses5mRogx2h/fAp+iUqQZQ8t7c4gW8bzz8vhUm0gUOTXG6UdHbreFY7Wq
	 hpA9TTcLliIXwvEfcR9Fuj3hW2mAlelJtfCwMGnWbPPBWfsx0ucH6lLEnt32pmeXXj
	 1O8g+UWFk/sVn0u5lOg0vSGPGOvDQuAsJb8aOBJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/217] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed, 19 Jun 2024 14:56:36 +0200
Message-ID: <20240619125602.593818076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 14a20e5b4ad998793c5f43b0330d9e1388446cf3 ]

The net.ipv6.route.flush system parameter takes a value which specifies
a delay used during the flush operation for aging exception routes. The
written value is however not used in the currently requested flush and
instead utilized only in the next one.

A problem is that ipv6_sysctl_rtcache_flush() first reads the old value
of net->ipv6.sysctl.flush_delay into a local delay variable and then
calls proc_dointvec() which actually updates the sysctl based on the
provided input.

Fix the problem by switching the order of the two operations.

Fixes: 4990509f19e8 ("[NETNS][IPV6]: Make sysctls route per namespace.")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240607112828.30285-1-petr.pavlu@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 627431722f9d6..d305051e8ab5f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6335,12 +6335,12 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
 	if (!write)
 		return -EINVAL;
 
-	net = (struct net *)ctl->extra1;
-	delay = net->ipv6.sysctl.flush_delay;
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 	if (ret)
 		return ret;
 
+	net = (struct net *)ctl->extra1;
+	delay = net->ipv6.sysctl.flush_delay;
 	fib6_run_gc(delay <= 0 ? 0 : (unsigned long)delay, net, delay > 0);
 	return 0;
 }
-- 
2.43.0



