Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E98F17838B;
	Wed,  3 Jul 2024 11:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004530; cv=none; b=PLMspckHkPrJoFt8XpnlUQJXs0L9r4jhtrtXD0S+iQEtTzay781ozruIG4ylU6Pva4y0YRBMfHhlJBHPKmXKRj1/+y0IgwZHfqUy/EuY1WCshRsjc6rDZkQLxxq3bq7bC4FEoYm2OAv3ghHEUbZKE+SY+0WPdcqf/aBXgnWKNpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004530; c=relaxed/simple;
	bh=cB2Htv1kNxlziT6qZzxCkoIQ7t7hU28q9jbnn8WzV/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jC1cYI5LnEh8k2yBW/fsddaVEEWGrzb0hAUP5OmKWp4m35C22KEdpTav4AJsg3NhOM+qbnoBmJrSYN/mKrTHcjXeVC6LRtYQno3uOuzBJWHyJXJ396UfH5fT2UFAFq4udGSGocSl5Syr5jOuvA5ijsaGdjp9AmeI5W5VXggl8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zb40VYr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zb40VYr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E5FC2BD10;
	Wed,  3 Jul 2024 11:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004530;
	bh=cB2Htv1kNxlziT6qZzxCkoIQ7t7hU28q9jbnn8WzV/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zb40VYr6QYwAXNrAig5onG4VowGDwC5ktKElmHxOXmCdunKECNvk8C2kob8NuLfje
	 0Rna1BRAp2fISzkU66adbRBsD8YzMOQH2utVVSWpzGKGfv3oLGBNLNH0OgN1qOhY9N
	 0WZrFTdutXbNiZBPKGRLgpJS6zWux97x26SnXuwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/290] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed,  3 Jul 2024 12:37:33 +0200
Message-ID: <20240703102906.919380587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62eaaf9532e1c..00e3daaafed82 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6181,12 +6181,12 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
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



