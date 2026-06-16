Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376683DA5A8;
	Tue, 16 Jun 2026 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636625; cv=none; b=ExgsJRoYAJKGJ8roH4LmyERJByUaDVplC5EQfJrQ21oGGzPEW1G9gkizZQtmCQ2bb+MxfHY4IBRa6kQUeK4p5RodxW4mnJkRu/tCfOeu5DTEFPFHb6TE2ZCSYu6l32G8PBXzutLlmcfKvmDGEPUfSuG1N+gYvjVhuV4Nmr7w5Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636625; c=relaxed/simple;
	bh=aZQqabOqN93zbIizO4iGaeDpn63GMe/eSrsJWTpZrqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0Nn+MPnr1hfXwKNS4JJ0dRF9RKjrFzlvNzVD0YbDTUskYL0RmCYFPa6agl998Ouo8epfW6YdVubDUm1PLfATng7uskptaAE6nBBxBciE7iJOBPGNCzem39ETVHYf5WZF3/VeOXNj0czXl0fbk389J9E05mNlqhJlujZHroQGYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPpdSxl2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPpdSxl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0677F1F00A3A;
	Tue, 16 Jun 2026 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636623;
	bh=acsP8i+OUH2lg3jAdL3Xt8UfB6/qBSGtybCVAWQo7qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPpdSxl2et5dQvRRRzjBVLJePfoHpVWbOT9q+vZu0qe81u+4LmgHoDHWkRWiBSGMV
	 NgghG+a1cNiXufK7SWZSVvbzEKicVnbj257wtTlOB0+2mKlR2n8jHXZcZRk4zqyA3d
	 ROXXhutVvcv4iXA81b2KPWa+K1sD+8+NtTkTF7P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/342] mptcp: pm: ADD_ADDR rtx: fix potential data-race
Date: Tue, 16 Jun 2026 20:29:30 +0530
Message-ID: <20260616145101.115492808@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
[ relocated change from net/mptcp/pm.c to net/mptcp/pm_netlink.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -226,6 +226,13 @@ static void mptcp_pm_add_timer(struct ti
 	if (!entry->addr.id)
 		return;
 
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Try again later. */
+		sk_reset_timer(sk, timer, jiffies + HZ / 20);
+		goto out;
+	}
+
 	if (mptcp_pm_should_add_signal(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;
@@ -245,6 +252,7 @@ static void mptcp_pm_add_timer(struct ti
 	spin_unlock_bh(&msk->pm.lock);
 
 out:
+	bh_unlock_sock(sk);
 	__sock_put(sk);
 }
 


