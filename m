Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5B182871;
	Wed, 19 Jun 2024 13:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802347; cv=none; b=pMHzR1EyiXDA+URQl7mU9poCCnjkwRWJXqIvWkDzVOkkpLSSgOkhjC7Y50ETFbs1U1LYnEZoF2y8BoNMeU4RQohVm4N9NqNhT4/WARz05xOw2RnXQNyIeAUGrLHy7ruNtXuolsAwAEaIvGALDgwFHBS6JqKATxrwjBXWctR9ls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802347; c=relaxed/simple;
	bh=92CTZqfDb8HnWLpZ2oonnKRt+1ZjnYTY/c/u5t3seHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzTEU3pCTBsgBdy4oP+JGDubn9F465L92I2Ksl+IAwvd9gxCM4eNDp5nuqfbtCfzI+AMdxOzA1AZ69HADDNEKigoYsRNeCJFeC+DT4Nl+hNcxotX6hjxDJPwzZOePPSCCO4fzEZ7IwWSKU9scqeIrNgydpbSTZgNZ5+yo2z/4Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ/yEmgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ/yEmgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DEDC2BBFC;
	Wed, 19 Jun 2024 13:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802346;
	bh=92CTZqfDb8HnWLpZ2oonnKRt+1ZjnYTY/c/u5t3seHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ/yEmgrhXr1Tf0rTC20Bm2c1ZleELIRY5gnjgwXIgwh0N09RM7bEtb35Dy9WSxSY
	 N37ItMbiPtA0kVzmmuJfoqI7avBDgzGJphI2GqJZHCTSN8r8GlKlCamtKH84qa+eae
	 Rkd9cUn2NuDVNzqanyiQP1kQYU1WQTSL0PE2UMDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/267] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed, 19 Jun 2024 14:55:17 +0200
Message-ID: <20240619125612.715596793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0a37f04177337..29fa2ca07b46a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6332,12 +6332,12 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
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



