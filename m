Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4D14F5DF5;
	Tue, 13 Oct 2026 12:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895407; cv=none; b=dL/Zsp2cAfGuuFQscc6Xu6q9O9XJfabEE2RRBXDvRsyHXhvLVaHnD6day7726QrHlVWLfagbslKt8PG7NbsSzqKh29I26atmjzb32apWpJP4AR9Cm1ZiWv4T0jJS0lhQyyIm+GuJ23Zy0gpmplewJzC1qyfLFFtQJsS8mmpioqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895407; c=relaxed/simple;
	bh=YXS93u2QhVsF2xNylai0iFIWhy3ULjdCWjO5SI+br8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcBHfeKfoyLksDhrBOedQcVEftIol0yaVQ+zeiaxd+yagoHl0NGoqZ9n356/zvsi/LzLvkdmyySlVdRPcufRNxAYntg+sigyQAKsbx2DsPDW9nk2mNv+ibH8ovKa7tmssbXq1r4PbKddCPV19w1XKRDWsx0AvL2o1gHmm2vPWT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDns92di; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDns92di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252EE1F000FF;
	Tue, 13 Oct 2026 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895405;
	bh=GhiF6K4odJ6ELKsMdX6+Yj3OR3g52aREUNJJBqBc3WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDns92diuVnojcgnKED8oSklvyzMnjo/WOqSKoZKf4FZgqal4/2BzMuKfjo/PI7II
	 TxpRGoukj7GaHzcj+XTfRKr15FUXRYwjwLIvk1iBw14hU8Sf/0O2ZmnpcpkMpN7OhO
	 5SYf7EPU7hLmIdadPFjltun9wyJPgJ6XY0MHwGZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/497] mptcp: prevent race between disconnect() and rtx
Date: Tue, 13 Oct 2026 13:37:10 +0200
Message-ID: <20261013112914.133288636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 85c580b0d8590520ae00a15c29e9fb9c99427a3e ]

Sashiko noted that the two event can race, leading to inconsistent
status. Prevent the race using the synchronous timer stop operation.

Cc: stable@vger.kernel.org
Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-6-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ No conflicts, but reset msk->timer_ival to TCP_RTO_MIN: in this kernel
  version, icsk->icsk_rto_min is not initialised, because this version
  doesn't contain commit ea4eb2adb0d3 ("mptcp: honour configured min/max
  RTO in retransmit paths"). Use TCP_RTO_MIN, similar to how
  msk->timer_ival is reset in __mptcp_init_sock() in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7a64223c38847..da774b1a94607 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3367,6 +3367,7 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* We are on the fastopen error path. We can't call straight into the
@@ -3379,8 +3380,13 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	mptcp_check_listen_stop(sk);
 	mptcp_set_state(sk, TCP_CLOSE);
 
-	mptcp_stop_rtx_timer(sk);
-	mptcp_stop_tout_timer(sk);
+	/* The later subflow close can not kick again the tout timer,
+	 * as the msk is already in closed status.
+	 */
+	msk->timer_ival = TCP_RTO_MIN;
+	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
+	icsk->icsk_mtup.probe_timestamp = 0;
+	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
 
 	if (msk->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, msk, NULL, GFP_KERNEL);
-- 
2.53.0



