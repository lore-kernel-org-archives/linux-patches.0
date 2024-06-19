Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD4C82495;
	Wed, 19 Jun 2024 13:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803190; cv=none; b=ViFA3bviVg2Ebj7L6juVrw4WokuLyYfZ6sBlPkrcagYyNEtVAzAQyMUTzA85uuxoKtrkTFLvjSEw6z2RJ2MZciGxU3WALUauPhBSnDNTdINlSom8JP4FDzcp1KRq4SqYb86gNgoHOR4Vic6iImtbM0NhjMzMBcH6HzRWhuAtiqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803190; c=relaxed/simple;
	bh=oI84tCHi6gqdJQK0UOOtRmo/4oc9u3jyGVTuAcWWSx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a74Q5rd0fqFgQVDFj2HtSAiJb/FLvmxAPPkiQFIQ3vjxKcj0g4NdvQ+OM0tNLSB3CduuDUEmDtf+KjP69TAOkAFFfVwp5sLr52Q8UJGosrQXh4Z0w8B4rk8am++lyDEgqnMCY5KUqdG28JPQ+2cwwN+e/KPT9pe0su9k02IMnyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bycgJWeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bycgJWeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F232C2BBFC;
	Wed, 19 Jun 2024 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803190;
	bh=oI84tCHi6gqdJQK0UOOtRmo/4oc9u3jyGVTuAcWWSx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bycgJWeuzQjT4skZfYKbovdrNP/d36Md5pqV9OSl2DVSqkuzTPuR2nHkD5PgvXAkH
	 E7veLW2BrOzlnv7gIhmCEhuVnmja+VEejmZKZW723bun1aw+2exnOxZfsRbu6sfNOT
	 0V1GDucjDF4ikPzkqi0uEtdNB+PEWszCbYxP1wig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 176/281] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed, 19 Jun 2024 14:55:35 +0200
Message-ID: <20240619125616.607530655@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index bca6f33c7bb9e..8f8c8fcfd1c21 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6343,12 +6343,12 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
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



