Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1862D73A6;
	Sat, 17 Oct 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256821; cv=none; b=tkIsNRuMt/+eRxB2I9Xx60D0Jbnv7GGWssMWhYXugVuxRTuway/8p/t5d6DaU8iOvk6J4TqHmkZtjt8AfUVo61E/Hq2v+HxS5HEcK6+7yOw7n0dR5YRZskx4pimZ7FDcqu7DN8UMyGTvnNcXuYWAosYYhlvpe7apEV0XaAWpkbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256821; c=relaxed/simple;
	bh=UzFos+T7fpTjQ2PjBf7wF5tqojno6RDYsFnKb312i5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otVbBxnQfE8vPdxLPexlDwoSqslQAShjyQ1RQ4F97b4AXBsFQQXESBA3UOFHhYriHFbTy7VWG65LJMB6s8/bN52p4JrT+KKvpsja3I6xGHuS8qbxll/6yPa5ZdIE5m7jC5d2WXhsEJjYs7XR+AaDx9AWR+Su5XuYjtR+dUP4b60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKfrCjGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKfrCjGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C881F000C4;
	Sat, 17 Oct 2026 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256820;
	bh=lxFldnnjcZOv1p07WEmUZNGIjrvS8mfL+gE8UPNKvoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKfrCjGDWL5fjvgQPkCO5KOZCQ0Gkjbkp5UukaukDWrsQKCom+3q/NChHOSDoLtiq
	 tCALT+b4jSgTim3HsxA6NjE5WuqvAAAwYX9jNeMGqcapa5q4S/WJVNkai2gw2WQ/h1
	 ctZAfZDxJMargNJdGDbGk1BIb4tt0x3JJgfcH9pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0362/1674] mptcp: prevent race between disconnect() and rtx
Date: Sat, 17 Oct 2026 17:43:54 +0200
Message-ID: <20261017160440.412524687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
[ sashal: Use TCP_RTO_MIN for msk->timer_ival instead of
  icsk->icsk_rto_min, as ea4eb2adb0d3 ("mptcp: honour configured
  min/max RTO in retransmit paths") is not in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fe7c70ea929a5..3e8e5aae4dc4f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3309,6 +3309,7 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* We are on the fastopen error path. We can't call straight into the
@@ -3321,8 +3322,13 @@ static int mptcp_disconnect(struct sock *sk, int flags)
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
 
 	mptcp_pm_connection_closed(msk);
 
-- 
2.53.0



