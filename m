Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1620F391E4C;
	Tue, 25 Aug 2026 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665544; cv=none; b=FugeOzwdEj+rxkWs6JoAiWK/EJ82StGVUjAnIee4p+nkplxTY6q1g2cHvqeZn9W7MDmvjwYMgeMwnzmUwOcdv7PDlgGFVuctr2Y3dEa4QzYWK7HWnUm7la6PCaqgWpyD/jyciNKwa8bECUOkbKUvCvbvAnJjW57qXShTAh7n1uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665544; c=relaxed/simple;
	bh=EZV4uF70DdRUR+OcdYyKI57ZAhwjaiqr/JJXUaw0oa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOKDmic0zmMDjPZRSQNU72uXyvcBuF/kanPM9nkkVQy16WKqIlChzXZRrfl93x7fPhtyZY1JKtZdG0T2VrTBb4t/63w398N3DEJSH5ZjI0jMN3kNvdgqcZTYDUmuYMfh/KE/+OX3YmBcuD2YMhnibRng8hkNeBZA3dNEGsPRDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8Lq1Uas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8Lq1Uas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF31F000E9;
	Tue, 25 Aug 2026 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665543;
	bh=oMlwInF9OjpZuK5EiGzmek0Eno+sDG9Idbm7DM1Q7es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8Lq1UasvsGEM33tVGEKx05JeaZfLLYjliuwE+jiATp2JkjcrlMw5AC3NtA98/BfR
	 8VhdfsYtVUNwJta7bk6GoWHMgkUIYme48UYfZqqyhPmQRq8y1vO15uUw8aOCTngID5
	 NoDqDFEnJcq3OT3HB+zPFVifDsRsQqpB/ku9/ybM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 54/77] mptcp: pm: fix data race in add_addr timer callback
Date: Tue, 25 Aug 2026 15:26:16 +0200
Message-ID: <20260825132543.686343874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ applied to mptcp_pm_add_timer() in pm_netlink.c instead of pm.c and collapsed the adaptive backoff branch to `if (!retransmit) timeout = 0;` since the tree lacks exponential ADD_ADDR retransmission timeouts ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -296,6 +296,7 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
 	unsigned int timeout = 0;
+	bool retransmit;
 
 	pr_debug("msk=%p\n", msk);
 
@@ -333,12 +334,13 @@ static void mptcp_pm_add_timer(struct ti
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


