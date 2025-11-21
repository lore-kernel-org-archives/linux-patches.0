Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F85535958;
	Fri, 21 Nov 2025 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732618; cv=none; b=sUKHxkXuqnl2t62k3AHFEwQKNBlUUneQC4sY9VZAzoVYWPAlCel2qi0AYIKwckqF5bl7DUYd9AwQ4cbP83MmQaoRKWZFgoAB51gO/G8mplSZbu25rLEM6PG+S8ITlRCbY56x5PVRE4i3zMiyuPYfkuXs7QYA4LbPUsHAgMmoCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732618; c=relaxed/simple;
	bh=Sw3cWt8I709S5BFFh64U/ZRmobWCbxDcdQb6azYS8XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUT9oIw992O+dJs6G5f6jNE5D/a9h77A9SBcqck4XWt1oUEkl1I+25OjdVNSSsvKS8GmCR0Dd5u4p5RtXnuVURXosJnnX0pf3Mdu67raLdPh0aFF0QveD+8lP2UqVOP1NflEP8tzHVmBy0+7gLv2NFw1Cx5cIdpkdaNBoLIIJUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVVwuObs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVVwuObs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179DCC4CEF1;
	Fri, 21 Nov 2025 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732618;
	bh=Sw3cWt8I709S5BFFh64U/ZRmobWCbxDcdQb6azYS8XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVVwuObsVrXcalSCuvVboAyjyODs+sefrDRqV3F2JcWvs+/NEmJ7ujAArZ7qNZOab
	 P1TRzXzuvbBe9WrjLQ2RbJZeQNQ1mnhFSbzGuy+LFLnUhdL4ndlIoI/SMqcLLo2HUT
	 j+eUN96z5Z8L+yWlQ6hEUmHNCC5Y1kQ50jkHjbwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/529] ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
Date: Fri, 21 Nov 2025 14:08:04 +0100
Message-ID: <20251121130237.602339555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c3b0ba289fbd..0e49ee83533b5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7102,7 +7102,9 @@ static const struct ctl_table addrconf_sysctl[] = {
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



