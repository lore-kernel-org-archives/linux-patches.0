Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3E9173336;
	Wed,  3 Jul 2024 10:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004014; cv=none; b=Ymp+MwrouV0EpWE4u+9U4U61npxHnJLM4AG5Y1tCkWTmFSNDlkc5qfYxb5qFy1tQeiiRPMKY0VxrmkWwuMjFXiV8WIP8wjM68BxwbSVJsBO/G1x2yAT9F95fjPVM0RtCyLE6Zl6Fj4sKuMP0kboSyMlbvWldUiQJJ5RP2wZR59o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004014; c=relaxed/simple;
	bh=TT6/qj+gwZzg2nHSY043GNuQ56B1liCC8hESpi61oh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL8pianPsGAXtzrb/5NBi5N/3QGXQeevEDRdpUx3ODl0stWNawEkdji4LkcjUWTbTsgE/MUUaA80Yr/gcuUqI7+RA2SHYhwQymZbjG3tLpT0AJ+QUoOTCqhYUlDgnj5BIqv4uO9pKTc6YpGZemvcEGD+V5j8EeR3lB46OuseUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkx0ZJHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkx0ZJHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53399C2BD10;
	Wed,  3 Jul 2024 10:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004014;
	bh=TT6/qj+gwZzg2nHSY043GNuQ56B1liCC8hESpi61oh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkx0ZJHFVS5SO0vgog8rNcC0r6n62BVizmUlJRjUW616xotYQe4+LMuHPB2ZgpsGw
	 R+YdZtHm8E1sC69VNA4qv1lJ4BEr3ecVxkQZeFe/JimCbC8TIssSwC1ioBArcJeg8w
	 LwDaAZHGYgyWE6jJ71+myYRyQHNwv+QSl8e8nz+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/189] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed,  3 Jul 2024 12:38:45 +0200
Message-ID: <20240703102843.925031390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 65772800d0d33..08cdb38d41d86 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6142,12 +6142,12 @@ int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
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



