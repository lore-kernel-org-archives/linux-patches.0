Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19E3EDAC6;
	Wed, 20 May 2026 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301727; cv=none; b=VmR9hYoMc8/THRycjniQtrYbxTi5uh15Gm+9v4Tsm83FaHiZ9JWn2ciPGCQVUkWAKuXnXYHp9kf+WJU4sDis6ZNRgvx2ZLuZY3ep7T7Rc3Rew3UbQ87H/hDMIA1PdRFnxA0o8Lx+zJEQ35atkKfIY6mwwJ8Z4al8VTckOuECazg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301727; c=relaxed/simple;
	bh=KI5CUuBJAZw26WADwYDdlNwNQ0LOWmnTgX2JdqxdDOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7KfMa7J17EQi5CZUcNSN4y7aUKLpYAbrQIIHMjRimKAOhTaiJ9qIO9gibbXwIA5fkVS+FqM3ce2EzAOQxkXbVvofLu5qEfk5XAlM6McSbK925Fsj29VdQcLYvx6/OdBNCeIGXsJjj0gm3EDjLMBeFT4xb97ct5thtqYrHSol3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHAzbiQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHAzbiQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8317E1F000E9;
	Wed, 20 May 2026 18:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301726;
	bh=mSiMvyfU08Now1JhGlMFJwIc7IS7xE2ho9c6HMZjEeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHAzbiQIyaDaNyYoTtPQVsjvAvXReagdKwD1eB3vqvO5wRIJobjDODYen1L8SYgSo
	 v5Z79AebrOzhXJh7wob3/5csDmWKcQDd+NTvLTTG4surpc5T5dNSAZjWctDC//vxam
	 Gm/RkfLzZDLeuYmlDV0rI3lLybIml44bDZRQivRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 665/666] mptcp: pm: ADD_ADDR rtx: fix potential data-race
Date: Wed, 20 May 2026 18:24:36 +0200
Message-ID: <20260520162125.705066292@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
@@ -307,6 +307,13 @@ static void mptcp_pm_add_timer(struct ti
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
@@ -335,6 +342,7 @@ static void mptcp_pm_add_timer(struct ti
 		mptcp_pm_subflow_established(msk);
 
 out:
+	bh_unlock_sock(sk);
 	__sock_put(sk);
 }
 


