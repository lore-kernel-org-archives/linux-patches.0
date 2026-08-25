Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765D44749C1;
	Tue, 25 Aug 2026 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666038; cv=none; b=Ozd1eJcT+LRlmy8eDHZmfhHZ2mWKV/JEt1Ahc/EFbDDVOxo8P2PsmOuLjdPezE394wzi2q3MT0Tq+fvLWGQdyv6+rxMHJORQqgaW6yWg5HTyQPp543RefSop1PD7dgJs6mykH6KSHX6jsC//6q6Or3H2LfwdhfpE9l6nQjyL1y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666038; c=relaxed/simple;
	bh=gyiBHTdoPA5c39moWFd2m6krXydAO6tL+NnIfcB+pns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xwe8OZaDvIl/FJJpxliDNnm8U4ngq552zuUNigUgQRRcLHlqDo/k90xGyv+Ke/hzRI0ga39HSpBpB83LItc3I1zZpBFzu7s4zNzMCHiIQ9kptpqq8zAjw/SPrcu8gJ0vDPkYu2kBTDyGsDgVI+wyJS29WqPm3sJfpwh/Ton5tK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6EpsciM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6EpsciM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97291F000E9;
	Tue, 25 Aug 2026 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666037;
	bh=2Van1XJl219z0fUB/+gajt6+FfYvwdtvvpr0cr+IxgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6EpsciMji63p8HD9YU20EShBsKIa5pUexDXglSaOiE21bBqyc3OKrk6At9QP3DmE
	 JGbFOsRuraLPK27kW5xBEBScKPqlg5yjYNbQMK5j8fD3jBZvUTDy+KbCaQgWTVeICz
	 GMZBnWD/uNLxg/hmglwm7ynkZInv+Ys5xUYYCzr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/79] mptcp: pm: fix data race in add_addr timer callback
Date: Tue, 25 Aug 2026 15:26:44 +0200
Message-ID: <20260825132544.182222589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit a7aad5b69d3bdaec20a3ed9284e184502450c0cd ]

The timer callback reads entry->retrans_times outside pm.lock to decide
whether to call mptcp_pm_subflow_established(). Since
mptcp_pm_announced_del_timer() can concurrently set retrans_times =
ADD_ADDR_RETRANS_MAX under pm.lock, a race condition exists.

I discovered this issue while studying the code. AI tools helped me to
verify the issue can potentially happen under race conditions.

Use a local 'retransmit' flag set inside pm.lock to capture whether
retransmission is still possible when the lock is taken. This allows to
call mptcp_pm_subflow_established() accordingly, and not depending on
the situation that can be different when checked outside the pm.lock.

Fixes: 348d5c1dec60 ("mptcp: move to next addr when timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-4-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -307,6 +307,7 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
 	unsigned int timeout = 0;
+	bool retransmit;
 
 	pr_debug("msk=%p\n", msk);
 
@@ -344,12 +345,13 @@ static void mptcp_pm_add_timer(struct ti
 		entry->retrans_times++;
 	}
 
-	if (entry->retrans_times >= ADD_ADDR_RETRANS_MAX)
+	retransmit = entry->retrans_times < ADD_ADDR_RETRANS_MAX;
+	if (!retransmit)
 		timeout = 0;
 
 	spin_unlock_bh(&msk->pm.lock);
 
-	if (entry->retrans_times == ADD_ADDR_RETRANS_MAX)
+	if (!retransmit)
 		mptcp_pm_subflow_established(msk);
 
 out:


