Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B4913B2AC;
	Tue, 27 Feb 2024 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040860; cv=none; b=U5l9WE1CcMsfc082Xvst7wIsCLgbDagBDTtvYteJEW8b80H/TnZ3Ma30EE97deJCByxMhh6+D7HdYz/bcAu1VgEccDQ5+2FX68H7WYHGmJhJzSW+Hq+JEpu/iDToEMbhRdbAwXeSqbwC+M5Fce+OCaCiQJVYIQmnDJvJLKqf790=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040860; c=relaxed/simple;
	bh=L5DWfXcOe+MDU6OTa+FoP2nTp/EQKjs4kiYH2Xj5AUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMFAnCQ+ncCAgFV7b3t617lGH3yudDJVkQnQ88E8svqwe/vrVJ/mx4p/D0tz+eMc6qqT8vocvck/elF6yJ30lHIfHimPZWtwgwdG0+YygamN9Z5DAsnzlV+4s2dpBazx6Vq2LeThDed6D2JyOK/u4sxg9q5rOEkOYZxLBfL0uUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShJBePnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShJBePnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9291AC433C7;
	Tue, 27 Feb 2024 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040860;
	bh=L5DWfXcOe+MDU6OTa+FoP2nTp/EQKjs4kiYH2Xj5AUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShJBePnxyuRsPS41aPIRr4ysxnze+u5MBi4eMGNdoyq0RTQYww4awxY3DTuFGulc3
	 ZNUsyOFAoA28YRk9olQNCyDCBiZrmR6eW191qj/GMmoFdQ0noxJlEnfVbPvxXiycnO
	 XeZYiyxWrlv43vTCq+iyf4Oa2rjHxWfePp+O0Am8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 135/334] mptcp: fix more tx path fields initialization
Date: Tue, 27 Feb 2024 14:19:53 +0100
Message-ID: <20240227131634.821803518@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 3f83d8a77eeeb47011b990fd766a421ee64f1d73 ]

The 'msk->write_seq' and 'msk->snd_nxt' are always updated under
the msk socket lock, except at MPC handshake completiont time.

Builds-up on the previous commit to move such init under the relevant
lock.

There are no known problems caused by the potential race, the
primary goal is consistency.

Fixes: 6d0060f600ad ("mptcp: Write MPTCP DSS headers to outgoing data packets")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e4a0fa47e816 ("mptcp: corner case locking for rx path fields initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c |  6 ++----
 net/mptcp/subflow.c  | 13 +++++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0acb1881e0b5e..436a6164b2724 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3530,10 +3530,8 @@ void mptcp_finish_connect(struct sock *ssk)
 	 * accessing the field below
 	 */
 	WRITE_ONCE(msk->local_key, subflow->local_key);
-	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
-	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
-	WRITE_ONCE(msk->snd_una, msk->write_seq);
-	WRITE_ONCE(msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
+	WRITE_ONCE(msk->snd_una, subflow->idsn + 1);
+	WRITE_ONCE(msk->wnd_end, subflow->idsn + 1 + tcp_sk(ssk)->snd_wnd);
 
 	mptcp_pm_new_connection(msk, ssk, 0);
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 56b2ac2f2f22d..c2df34ebcf284 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -421,12 +421,21 @@ static bool subflow_use_different_dport(struct mptcp_sock *msk, const struct soc
 
 void __mptcp_sync_state(struct sock *sk, int state)
 {
+	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sock *ssk = msk->first;
 
-	__mptcp_propagate_sndbuf(sk, msk->first);
+	subflow = mptcp_subflow_ctx(ssk);
+	__mptcp_propagate_sndbuf(sk, ssk);
 	if (!msk->rcvspace_init)
-		mptcp_rcv_space_init(msk, msk->first);
+		mptcp_rcv_space_init(msk, ssk);
+
 	if (sk->sk_state == TCP_SYN_SENT) {
+		/* subflow->idsn is always available is TCP_SYN_SENT state,
+		 * even for the FASTOPEN scenarios
+		 */
+		WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
+		WRITE_ONCE(msk->snd_nxt, msk->write_seq);
 		mptcp_set_state(sk, state);
 		sk->sk_state_change(sk);
 	}
-- 
2.43.0



