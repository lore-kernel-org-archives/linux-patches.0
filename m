Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F93F0A83;
	Wed, 20 May 2026 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299277; cv=none; b=ZzuV/zg5E6pwhOZYN9eKV4fxIoBDMCMu5GFBAkbYlMXua6WiXWBH9PFrOOMbdE2VVXsaJE8sWXpsHbcVA/JnCdh8YpZA7DEkUyjVooiU5MiN3avbbsuMyFBD/QJlNvxAjbhcuf6KiIhBadM0mefn+trUFP5puIC/Ao1dvHqwDqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299277; c=relaxed/simple;
	bh=JjttOUUAVmgQqUbkyHC200kWHZbnVrAuTKPde/Yoywk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Luj7K5d4UDyuCMhtTyI+i1haB744+lfofekJXaGTqdjtUo0HCYeGopuQWjC8aXVTGl0gclSq3yu+U8TZ8G34s6uODOme5nujzqf7PTh/uHYKSJIci1Jq2n11qVwIAWztoI3nDEVwjmPEz5Ci/S0RWrpW6TYzMJaT6dSHUt1iMeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6YJOf8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6YJOf8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3601F000E9;
	Wed, 20 May 2026 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299276;
	bh=8LQUw3TM1w9LgtdRzcWDR1LQ0SemB1E73B13w0fRG3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6YJOf8barkP1fOlgmlAdtXtfn1JkPm2Z6d9HQNnallE9NnCjwmb4KAIwNuRsGB+S
	 9oLrV1FvSQ9HqvaHTEVgZ8B0DOY8xB8Nq4zYC5DmNPLlU/lRheKlRS23GOUUT58MW4
	 AJJInDOfkBgLCT9Za1LXaU4zYQnh82QoXQm7HOcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/508] mptcp: pm: ADD_ADDR rtx: fix potential data-race
Date: Wed, 20 May 2026 18:25:30 +0200
Message-ID: <20260520162109.587719059@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 5cd6e0ad79d2615264f63929f8b457ad97ae550d ]

This mptcp_pm_add_timer() helper is executed as a timer callback in
softirq context. To avoid any data races, the socket lock needs to be
held with bh_lock_sock().

If the socket is in use, retry again soon after, similar to what is done
with the keepalive timer.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-3-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied hunk to `net/mptcp/pm_netlink.c` instead of `net/mptcp/pm.c` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -308,6 +308,13 @@ static void mptcp_pm_add_timer(struct ti
 	if (!entry->addr.id)
 		return;
 
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Try again later. */
+		sk_reset_timer(sk, timer, jiffies + HZ / 20);
+		goto out;
+	}
+
 	if (mptcp_pm_should_add_signal_addr(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;
@@ -336,6 +343,7 @@ static void mptcp_pm_add_timer(struct ti
 		mptcp_pm_subflow_established(msk);
 
 out:
+	bh_unlock_sock(sk);
 	__sock_put(sk);
 }
 


