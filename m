Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4A6340A73;
	Tue, 11 Nov 2025 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824039; cv=none; b=WixWrfdtP2DSl0obJMv5DhjtR391yfYwRo1/5sPwrov/rB7CY5FZS+Dinn5duPKhy7p3P/DL232mmBJswsl6ypeZpljnzY+C+GNgObv8efTgWCEhOq10KAEXGIChj1LdeOXotmjftPc1iHDG9DOfga4sH6dmsFowovE1rzbKvGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824039; c=relaxed/simple;
	bh=1FWX9gCbTK9ZC0kipTUF0pWrHarCpdFUyRYqth9gVvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5RF+9M+sXJx0I5SL2O5ROXzoo3SClEAqk6cVx3/tAstwgMxFxdmX81TneMfsxjJV/SPZnnakQxBh0K5pI7bDtSzpB0vviKBpe8V5CJajsqsF7F7AzqfiFl7oIwxEZxcQTolmrCTimti9DhNxqI/qzOVSWhlg0w3pLkxdO+D+/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbffjkuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbffjkuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DE8C113D0;
	Tue, 11 Nov 2025 01:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824038;
	bh=1FWX9gCbTK9ZC0kipTUF0pWrHarCpdFUyRYqth9gVvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbffjkuXnlqv4UPIkgdo0bi5w2aWQGd7vD+L61leeK3ZYvHG8uC9hjl46RfGI1hd3
	 6V0QWG3cxkP8mjGCxgIlALvnWp4TNtzOTwAI78Fy/73Fy24+PfHNJhPTwA2sJdjsin
	 rzva8IYMXcpnYqxZe0IUTo4rnCp50FtkDz9rfHBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 425/849] ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
Date: Tue, 11 Nov 2025 09:39:55 +0900
Message-ID: <20251111004546.713410515@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f17a5dd4789fb..40e9c336f6c55 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7238,7 +7238,9 @@ static const struct ctl_table addrconf_sysctl[] = {
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



