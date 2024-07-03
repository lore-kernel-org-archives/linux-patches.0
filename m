Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DEE1849EE;
	Wed,  3 Jul 2024 11:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005647; cv=none; b=t0FZAVvPGox8Do5vZr2hubpusnkBfE9vppA5tCguKEEFJh0EeFLtTDC2EYtKmHc9IzNJvPus8AaXP/ju+7G1vLhkMYVRVA7PRE4ygvjGpKpyXKufcJKylppKzDqY9tjrOrSkH9txDor8pZ2eTf+j7NTn9pJrS9DytKvdRFzk1vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005647; c=relaxed/simple;
	bh=RwxZS8c5yOuJ2qG3MOF4twBNNFjkrz/yLIyYYfUFts8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kg7zs17o1cVchreKgXhAJvpMzUuXjZ38UqLuHXBlqDhfNUa6ZXAyyEDsM85FPxFlZojjDjuLf/fFNnMofe1iBbX/TgRVQakwdkHGLkB7FZ3/JjC+ldDmkozzo8vqPrFZowLfQc3e91d0fQ7Q5i1IsD8SURoOR+zE3jgkV3TEobw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZF5PERyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF5PERyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD607C2BD10;
	Wed,  3 Jul 2024 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005647;
	bh=RwxZS8c5yOuJ2qG3MOF4twBNNFjkrz/yLIyYYfUFts8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF5PERyIJTf9sjRV+jbnxanGQTUNx4CPk1O7D+7dKpLGbKMKAg/yhNWj29eiQBced
	 gOJzuraGVkS6jaUc0qtU/fBgo5TeEI3sGbFYfz/E6gEpKyirxT9pnWMO6gJERL78sT
	 8FXay7RmqUENOWXQpEVTBFBBxwTvHymkvcYEYC7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/356] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed,  3 Jul 2024 12:37:24 +0200
Message-ID: <20240703102917.186084544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 2c60270c5798b..0ca3da0999c6a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6346,12 +6346,12 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
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



