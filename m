Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2885543F8AC;
	Tue, 21 Jul 2026 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674087; cv=none; b=fwsEAvagbYkuT7rtVHFPpSfF1dEzOFcYb+zO7S/GUVZm6vtPDmGWnGZmLWaHzI4UEr3I4YsguzNOGdUB5IwX8xyv3SE0oqBMv6ov2f4XXJ3wbxRsM/+V53DR2UHReA+C6pgZ2KDKULIXl5L+ANfboHnie41x4IGCSSLiYQ0Qt08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674087; c=relaxed/simple;
	bh=ynIgprqUzUOFkkJG5ZgFPPhqF+Mry0PH0QSlK8omUd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOPg9UqGpn5gLUVArUIS5FJZQOv2zhwWDZJVC2hsNvkWZkdP7AqFxOw4/VUAsrHfvvfuTVCI2e1buI7IDdOKvP9QwOJd80ZZIC8W9hzBiGyoVFa8rGU6+7tu8P7ls9+8YVH2cE7NabJJDH2qTK/qUm8DeFpqa3nNqTqO433io54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mXvPnfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mXvPnfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7F91F00A3E;
	Tue, 21 Jul 2026 22:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674083;
	bh=aw/nW63aSXimvQpZOUHrIynf1HesEBS2VAW/DC3eOIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mXvPnfO4wJ2bIh+1+uMXeW6EyWFcO4HBAKpqoGg2mzfZXUpjQ316ZBRLcpaD4WdQ
	 kz/kF7gGP+FRzuGWJfiqj8QCGBBUGzodjG4qAQJNPVjx8CesDTs/cdsxeSo6PUg45f
	 afS5pRHTV1n70aGAjva6JdEJRh8obdSdaUkx7qDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/699] ipv6: fix error handling in ignore_routes_with_linkdown sysctl
Date: Tue, 21 Jul 2026 17:22:03 +0200
Message-ID: <20260721152403.904275865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit cf4f2b14401f29ccac56393ca9e4b42a2505f540 ]

When writing to the ignore_routes_with_linkdown sysctl, if
proc_dointvec() fails to parse the input, it returns a negative error
code. The current implementation is overwriting that error for write
operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 35103d11173b ("net: ipv6 sysctl option to ignore routes when nexthop link is down")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-3-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c888471bf5d355..8c33e4cfa320e4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6489,6 +6489,8 @@ int addrconf_sysctl_ignore_routes_with_linkdown(struct ctl_table *ctl,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_linkdown(ctl, valp, val);
-- 
2.53.0



