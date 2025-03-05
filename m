Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C25F250C07;
	Wed,  5 Mar 2025 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197566; cv=none; b=A8/uWRkqH2b+1Y0LaQNssFOGTXH0V+zFcDXEC9Mz932F3/943zed2JH3/cOmHrrNV67eSNa2Fh3DzA/TnXbBWZ7jV+acH6CoxK3xY9ktOuOcbvomdZeJ/4+h/6YO4iDxBxPkuuSd3JzGPTRbExH9riwHwPEONs5sDWyD/bDLjLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197566; c=relaxed/simple;
	bh=1/oJhL4/I03XHQsLdHEqMWlTQzMuQxF7C/rxP70EcpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/cYpGHnrLgEBHe/Svub6rcIJ3BSJqxBFl1zyRVRk0rV5GLv6e9YJAzeFlfCXpIhAdYcrt3tcWOHRtSRzNNc2Iz9HF0UF57fJYT2i4lt1vCThBaSq0wdDsfA2g+xz3Tr0v+7lNSmBTSVJcxZedk23J2D8yn7orBmUmb0LcddiM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dg/I5mes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dg/I5mes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A644EC4CED1;
	Wed,  5 Mar 2025 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197566;
	bh=1/oJhL4/I03XHQsLdHEqMWlTQzMuQxF7C/rxP70EcpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dg/I5mes58LZ3pMWl0XaWwbc/mNddAFAXpH5SxhHabn6z9jtjFuHkxDrrE6mwDteH
	 3UoDA/3azjRAWEjoi5BKetUo8usS5Jomd5LslCMR0NwhWbQsgJfJf+10/9WFt+dsGn
	 iiR7FIcEBamiJdYMw01xmGS2Z270w4mIGGjk6Tss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Dmitry Yakunin <zeil@yandex-team.ru>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/142] net: set the minimum for net_hotdata.netdev_budget_usecs
Date: Wed,  5 Mar 2025 18:47:22 +0100
Message-ID: <20250305174501.273764151@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit c180188ec02281126045414e90d08422a80f75b4 ]

Commit 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs
to enable softirq tuning") added a possibility to set
net_hotdata.netdev_budget_usecs, but added no lower bound checking.

Commit a4837980fd9f ("net: revert default NAPI poll timeout to 2 jiffies")
made the *initial* value HZ-dependent, so the initial value is at least
2 jiffies even for lower HZ values (2 ms for 1000 Hz, 8ms for 250 Hz, 20
ms for 100 Hz).

But a user still can set improper values by a sysctl. Set .extra1
(the lower bound) for net_hotdata.netdev_budget_usecs to the same value
as in the latter commit. That is to 2 jiffies.

Fixes: a4837980fd9f ("net: revert default NAPI poll timeout to 2 jiffies")
Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Link: https://patch.msgid.link/20250220110752.137639-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sysctl_net_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 0b15272dd2d35..a7fa17b6a1297 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -31,6 +31,7 @@ static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
 static int min_mem_pcpu_rsv = SK_MEMORY_PCPU_RESERVE;
+static int netdev_budget_usecs_min = 2 * USEC_PER_SEC / HZ;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -613,7 +614,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
+		.extra1		= &netdev_budget_usecs_min,
 	},
 	{
 		.procname	= "fb_tunnels_only_for_init_net",
-- 
2.39.5



