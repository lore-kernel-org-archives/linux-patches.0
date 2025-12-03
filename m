Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF4134DB6F;
	Wed,  3 Dec 2025 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777796; cv=none; b=nlGa3awid31tKu+m88Q9QDCktUAcMWGBVg9zndJ0Q66PCWpDxrAi8//0FoZzV7erYpSVFysBXVdzawjeXEPrZQLfgmgs4/1qd6Zus0bY5MVr+qAxYfBAahvjWz+s5DfO2m2LBMP/IJqkSaeitfSiZ0lOYVw6GeqvIANV14X5tPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777796; c=relaxed/simple;
	bh=HCVI0LDa8fzHPbNHNXb9RZB/W8kdN6FhNk7SDx5Hr7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvGGku/AwuqV4hYwzZ8Qm1LJfRJE3rcgaxIODWS8pXxRX7hNLnoza6+wPk9RPh7Je7XSk/CzmZwX36mO0HvJ6SA4ziwIjg+N5RGOvT1WT52vK/EKceebc9r0/yx5uDG+SP0FwVpnZ7SUYqtznWMSb4xPHCNQIwL5FNiIrzy6hHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdgTihN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdgTihN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF65C4CEF5;
	Wed,  3 Dec 2025 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777796;
	bh=HCVI0LDa8fzHPbNHNXb9RZB/W8kdN6FhNk7SDx5Hr7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdgTihN4fw1oCDWKSsUZu8YLwFisULxvOte3bDKwVndtEnXCEmmFgUhl79/rsJ360
	 dBLW92kA6oAoYOs084qnj/XLv+fet8ubAOxA0s/PgFdPgwXkxdCGEKfvWhpDYFYJYw
	 HOk2UvRH9Wo154Ngx7czg0BjL3EF0cLdctIURKS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/392] ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
Date: Wed,  3 Dec 2025 16:24:42 +0100
Message-ID: <20251203152418.949215421@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 3d95261eeb74958cd496e1875684827dc5d028cc ]

In ipv6_rpl_srh_rcv() we use min(net->ipv6.devconf_all->rpl_seg_enabled,
idev->cnf.rpl_seg_enabled) is intended to return 0 when either value is
zero, but if one of the values is negative it will in fact return non-zero.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250901123726.1972881-3-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 43df9ad96e39d..68038aa522db0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7041,7 +7041,9 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.rpl_seg_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "ioam6_enabled",
-- 
2.51.0



