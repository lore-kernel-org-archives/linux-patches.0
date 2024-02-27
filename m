Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25727145359;
	Tue, 27 Feb 2024 13:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042048; cv=none; b=CV1O0qctkynhm8tWLvBnxAkCsEjHMxVTEvMt3SGWDiXAemTgrCSIEWejBUCLNIWvHHtbwuPC4tK0ZLiDy54w1m/yHEEQA7LiLZAWTFAftWeJeJIxjCcU0nYll0xDvoQjJaYsC22sAimdvwy344HaS/TImttnvMa4b8dGPagEFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042048; c=relaxed/simple;
	bh=itlp+QNSdkX2dQVwl/8xJEv+wpYOMG8KONbpoCTOOag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiYk/eR+x1GucrBSq0H6jqvUaknkLJY4lgo/6Zu49I/IJ8GdXbkpU8KJYka2v8e+6GGEE1F4itrp7TfAdxjBZs1jnCXNqkEHW6xgWbpB3gE0AMsy5MvxgxCRrcQN3c1x+BjVd2b3rD/Fs2z3haGKqAL1SPCOYu1IbaQuGO7B9/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMMdIngS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMMdIngS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C65C433C7;
	Tue, 27 Feb 2024 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042046;
	bh=itlp+QNSdkX2dQVwl/8xJEv+wpYOMG8KONbpoCTOOag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMMdIngSkn4IRQXr+hqghz0vD1Ljy6EXZyskIWRz4gnYF/ec9hajoaGC87kcWxO1i
	 Llt86FuEK5MhNvhDUX/yCcKU1naQhFbtZlSY9sGI1bBDXgcGnYeGzKNVQamqFqh7Sm
	 8imTx/6fp/D9kMum7YnoNdpvUz0nN2BBZC0XAydQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/299] mptcp: fix more tx path fields initialization
Date: Tue, 27 Feb 2024 14:23:53 +0100
Message-ID: <20240227131629.792021370@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2f794924ae5d4..55a90a7b7b517 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3525,10 +3525,8 @@ void mptcp_finish_connect(struct sock *ssk)
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
index 15f456fb28977..ba739e7009221 100644
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



