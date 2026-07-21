Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749CE471250;
	Tue, 21 Jul 2026 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657858; cv=none; b=qv8JqY98HKSFoYfWJympsyi5NyXKkm8j90BEGorZ3M/i+9siYNzsqhvnKqmn/SEvRr/4Fc++fICYdaCLGc0p5DRyqDTB/TQ6xdxzKAxJdzk7C2aKUy5xgu7AxMd92d8eQPsVm9z8sLpZIaV3eEBgtiG5Ji0Mt4I48n/AP17KxoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657858; c=relaxed/simple;
	bh=ebrWFSnhh5YY/Fb/yoOKiEt6GgUfYUdlTAxNbelnxwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVkZeN+RKo2dSV8qlLf1zukge/u9WQLvv1AIPXJsPAxO2Zw+0OjxM2RlNBsXQFrjQ+9VjfhBzvtTh0c1yz0haTutf/0HU1Hbmk61fPptk9YYA+r5tcCyamFrwd7nqkp+qU3Ko+kGwYps/wBJP8e2ci6hlNQ7GFwThjSwDixvT6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OixnQlTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OixnQlTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E9C1F000E9;
	Tue, 21 Jul 2026 18:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657857;
	bh=oXg8FoOWEUsmyNGshvplPY6IWiRiFUPykXsZFryqrbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OixnQlTO/gAn9UPHz0UzoxwccXd8PlqMtGwf3a465F2X8k6J39l/OpM2lAsMRM94m
	 IfE1cbnsJYCZGUINp40Wa9LWzORM/kYzZHQOtochpMcp1wutw1R4NMDivgIGLKuH0I
	 iUx9s1hYs0uwnrXfqzaCQ53x0RxIpcDuzq3RdPSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0922/1611] ipv6: fix state corruption during proxy_ndp sysctl restart
Date: Tue, 21 Jul 2026 17:17:18 +0200
Message-ID: <20260721152536.125522311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 6a1b50e585f033f3e201f42a18b37f070095fb80 ]

When handling proxy_ndp, if rtnl_net_trylock() fails, the operation is
retried but as the value was already modified by the initial
proc_dointvec() call, the restarted syscall will read the newly modified
value as the 'old' state.

Fix this by taking the RTNL lock before parsing the input value if the
operation is a write.

Fixes: c92d5491a6d9 ("netconf: add support for IPv6 proxy_ndp")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-6-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b2a8a058f2d284..530c302beb4898 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6462,20 +6462,19 @@ static int addrconf_sysctl_disable(const struct ctl_table *ctl, int write,
 static int addrconf_sysctl_proxy_ndp(const struct ctl_table *ctl, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct net *net = ctl->extra2;
 	int *valp = ctl->data;
-	int ret;
 	int old, new;
+	int ret;
+
+	if (write && !rtnl_net_trylock(net))
+		return restart_syscall();
 
 	old = *valp;
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 	new = *valp;
 
 	if (write && old != new) {
-		struct net *net = ctl->extra2;
-
-		if (!rtnl_net_trylock(net))
-			return restart_syscall();
-
 		if (valp == &net->ipv6.devconf_dflt->proxy_ndp) {
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_PROXY_NEIGH,
@@ -6494,8 +6493,9 @@ static int addrconf_sysctl_proxy_ndp(const struct ctl_table *ctl, int write,
 						     idev->dev->ifindex,
 						     &idev->cnf);
 		}
-		rtnl_net_unlock(net);
 	}
+	if (write)
+		rtnl_net_unlock(net);
 
 	return ret;
 }
-- 
2.53.0



