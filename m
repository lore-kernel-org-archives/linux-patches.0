Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8FB51D53E;
	Wed, 30 Sep 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790285; cv=none; b=pwrEbIq8LTVJrtr+2QyvA+3HQpJ94i20wEozXmglNTQ56WU0BDmxr2MyXq7YuO00XCsQaaOBSM1wXSfjrYCZrGE5hvV9VaGrWPQxBjVeOLc68eifgMywKPRzzRD979yYrNc9iMRitg6MfYNcNuIjuoE0UmPOHucglsMuQHpYuHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790285; c=relaxed/simple;
	bh=QRpkGjyeRZ/AR3w6aIi+0K6dA/yBwJ2H7Pxdz27lqIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HovsQJomhIM1MPeP4f2XvTs6SMkKpHnb0yZeS+M1pyw9Clv3SXSFoqlabe6CV1tEVQv+7kfWiwV0eqjbqRIJndeYncV7MEUA6EJRYaZ8YDjyjil4PMPVyB0W7H6znD5gXRlJv2SoN55GeFbGcRhlC0lCOBPHYeM73gw+77YEP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUaSKNj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUaSKNj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0BB1F000FF;
	Wed, 30 Sep 2026 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790284;
	bh=MovbtiRQ0c7p40Z1nQXjtRC5AeiqCWNhox8sY18wQfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUaSKNj8p/1z5bjcS8atFT33IYr7ok6SChnrY65eKYKTFD+bLXBND+yMg5xZiVoxt
	 SPDa2BuwPUtgaV1KzaZU1xOrhG+67rAPFU1NEetpuq9Leha3IQezFB7onssvo5RL/e
	 4j0L08GSdptSvsQgS+1Jdj+ZXYrY9Bn261ar6RJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 773/877] mptcp: prevent race between disconnect() and rtx
Date: Wed, 30 Sep 2026 17:28:04 +0200
Message-ID: <20260930152431.395456304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3367,6 +3367,7 @@ static void mptcp_copy_inaddrs(struct so
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* We are on the fastopen error path. We can't call straight into the
@@ -3379,8 +3380,13 @@ static int mptcp_disconnect(struct sock
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
 
 	if (msk->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, msk, NULL, GFP_KERNEL);


