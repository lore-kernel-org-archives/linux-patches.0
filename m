Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8800246EC9B;
	Tue, 21 Jul 2026 19:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661186; cv=none; b=cgWU0Ta+Uxv2oJSzeLnSeWqv3CRaOMRqS/SHYrNfPmBaYqF9fbEa3mWpP4Pb2Kvib6v08ZyQ8v7GvGE830o15Axo7fwCB7Z8lHan0IuUddTUpvl8BSsct4UM9DcCx1r1EOzeDA1G52udB54u+vAtHgKgYpE09l/PTI3Nh3YQVdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661186; c=relaxed/simple;
	bh=Nvul/FHXREduTHrEtnyQHiYi5aJoimh3DD9qdesrz0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRYTAhApgiPCcEMjXgtJ+WcmJP+TrYNaRzWSpjNMbFvMaWDOpu2nLp4Y7j1VYzYlIAvbhe+irubmTB+Ld9Or3Q5QYVMmpBB9Hzhc45/xJphi/8aOtB7YePrYyVn77VffXy0u1ySn+bg7tLiQ2khm6TkqrI3Ypo7HDJaxucEISv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6Kg/Gjm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6Kg/Gjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E1F1F000E9;
	Tue, 21 Jul 2026 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661185;
	bh=6kFuxvbp/kFsMapUCA6lOmJiMUUilJ03OnM2QEHohwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6Kg/Gjml1u2e49cdfEWAey2VJeGtJXpqN9UZd7vNWaBVEI/6Q2Fsuvu6+gEVeT7n
	 rWR5XSzdM4LoZZ8o8ihx/pyF2XlaEeMSvuCxbc7c3rf7IMWfslJxZfLOlh9hVlKVH2
	 c7oP1iTjBs+buZITTHk/VIJf12LMTZoFhx2/p0I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1263/2077] ipv6: fix state corruption during proxy_ndp sysctl restart
Date: Tue, 21 Jul 2026 17:15:36 +0200
Message-ID: <20260721152622.604948705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8268f36c7ed2..400cde904737cb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6474,20 +6474,19 @@ static int addrconf_sysctl_disable(const struct ctl_table *ctl, int write,
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
@@ -6506,8 +6505,9 @@ static int addrconf_sysctl_proxy_ndp(const struct ctl_table *ctl, int write,
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



