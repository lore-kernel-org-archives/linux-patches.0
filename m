Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722A4FD263;
	Thu, 17 Sep 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667136; cv=none; b=qM8eok6zz0IPad+hpkZnmplU+J73LNxP+/Zm9TPFLa1KRHXGUatV+8VrIHjcUfd7qB9dk/BF2L//Bfybdf9yrFLbO8vtCuBTYI1lG4F05xn0oOHUW1s+f9GyRMTfteOGp+PvukzDtPbR3vii10OEUcnkle1OEvcx4YEDhNj4MzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667136; c=relaxed/simple;
	bh=bBcm7qJ2mi/fTt0GJv3FK21sJv5GXKCnYphWMIsKSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC2A9N4D72uHJNhjcQwEoBPFoNo10MtFcKOd32kQppgwUOvPiOX0jo5EB6ZSJxzFpCSkfo/m/erqGIkr9U0zPdDsw0F/xG/apK68xd+PXR7LRIYdqkyD7i1o1HL4d1XSMLoNSKME8KnJyG2wN3KBN7b9t3AmY/05EJcnFPnrGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njbhbaPb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njbhbaPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5062E1F00893;
	Thu, 17 Sep 2026 17:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667134;
	bh=OHP71/zsxEH4GrFUWiOpXOVVHceUhgU8XsU3Ynixcns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njbhbaPbFOENCYqEopEH7Doa66+OQvCeBgHIqiT1avLxTNCOxYRcz608CA+qlXWir
	 A/L7vgRfkP6VEY1ETAxmcmmBk6tVuxhsS2iHIXOyfShQpZ39vWoTf9MulHB82neY5k
	 agsgpv6gJ8gOdcNAW7lb5IJv8vFbre4XN7wORYZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1241/1250] mptcp: prevent race between disconnect() and rtx
Date: Thu, 17 Sep 2026 16:17:16 +0100
Message-ID: <20260917151625.930884299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3293,6 +3293,7 @@ static void mptcp_copy_inaddrs(struct so
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* We are on the fastopen error path. We can't call straight into the
@@ -3305,8 +3306,13 @@ static int mptcp_disconnect(struct sock
 	mptcp_check_listen_stop(sk);
 	mptcp_set_state(sk, TCP_CLOSE);
 
-	mptcp_stop_rtx_timer(sk);
-	mptcp_stop_tout_timer(sk);
+	/* The later subflow close can not kick again the tout timer,
+	 * as the msk is already in closed status.
+	 */
+	msk->timer_ival = icsk->icsk_rto_min;
+	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
+	icsk->icsk_mtup.probe_timestamp = 0;
+	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
 
 	mptcp_pm_connection_closed(msk);
 


