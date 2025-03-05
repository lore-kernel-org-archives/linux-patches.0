Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337DC481DD;
	Wed,  5 Mar 2025 17:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197341; cv=none; b=ho5hATwAE+TZfgVgczMfP1lzcqxhjdbgCoYNddNocj/mXO4rszLFrm90n4guPkJNGe8aze7RyoHpCcmgIfqidtF2xjcMdZ0SHwtph0ZOj3y8xg2N24G+ddkMrtx74BqxEzVEuCTMxz06xTeBR+HsZChzNML8wz0G/CLLlQNRhcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197341; c=relaxed/simple;
	bh=RU2RJZa2QTMPpyOOUxq92edxMxTwHQkygTGY4Dd4AY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjtLEz/VaZ1gU2/c651vbGnZAu72F0i7C5wodczw100tW24E7rcOrQT/7adVkiXULTE5CZL2P/LRjJn9bKQjqOEWMOpdoj7khFGlqFrQFqo8Fcm16PdTKmzFwud93MNgFTXxGLzvmeKeSgtSif8OUAxv1jLkmOTyxfkYC1l8zgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Okr0PrXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Okr0PrXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A8C4CED1;
	Wed,  5 Mar 2025 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197341;
	bh=RU2RJZa2QTMPpyOOUxq92edxMxTwHQkygTGY4Dd4AY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Okr0PrXO+5vjCwtHEONK6R5zPS6MWjTeThLeanFYs0z4VyFny/sYgdmNVB1VQMvRx
	 j6OyDmrpXipMg5Ny3LS6f1OSZi7jJy46R18IqBwRmRp3Tqwyy5VEtI44fjjd5t60Uv
	 0CA+sBv5CPqY3Zx2Y9JscFcDsdpeEh7qLxY8KzI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Dmitry Yakunin <zeil@yandex-team.ru>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/176] net: set the minimum for net_hotdata.netdev_budget_usecs
Date: Wed,  5 Mar 2025 18:48:11 +0100
Message-ID: <20250305174510.353427165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 47ca6d3ddbb56..75efc712bb9bc 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -30,6 +30,7 @@ static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
 static int min_mem_pcpu_rsv = SK_MEMORY_PCPU_RESERVE;
+static int netdev_budget_usecs_min = 2 * USEC_PER_SEC / HZ;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -554,7 +555,7 @@ static struct ctl_table net_core_table[] = {
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



