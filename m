Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8EB3AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D617C433EF;
	Wed,  7 Jun 2023 20:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169442;
	bh=pRuUT8l33xf/lwI51e+HyJvYU/GOYNqqvxXyETJ17OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAmjqfYZHbMEPOLBogjUZo71drOivnSsjFpVFcR9dOgKyT95Rb55Q1oAAPeXGnbCz
	 /qkuO4k4ExiJUg4TDJa+kCt8DoZpyq7UOJaKtXT7q5Rfsp9g41kRwb75l4puoQIDcL
	 l8nm4HOx2etHtOBPgDCdh9UgDiSKMezYxmSyT2kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 083/286] mptcp: fix data race around msk->first access
Date: Wed,  7 Jun 2023 22:13:02 +0200
Message-ID: <20230607200925.785587503@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 1b1b43ee7a208096ecd79e626f2fc90d4a321111 ]

The first subflow socket is accessed outside the msk socket lock
by mptcp_subflow_fail(), we need to annotate each write access
with WRITE_ONCE, but a few spots still lacks it.

Fixes: 76a13b315709 ("mptcp: invoke MP_FAIL response when needed")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8d0c03091c409..64d4910e337ea 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -102,7 +102,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	if (err)
 		return err;
 
-	msk->first = ssock->sk;
+	WRITE_ONCE(msk->first, ssock->sk);
 	WRITE_ONCE(msk->subflow, ssock);
 	subflow = mptcp_subflow_ctx(ssock->sk);
 	list_add(&subflow->node, &msk->conn_list);
@@ -2391,7 +2391,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	sock_put(ssk);
 
 	if (ssk == msk->first)
-		msk->first = NULL;
+		WRITE_ONCE(msk->first, NULL);
 
 out:
 	if (ssk == msk->last_snd)
@@ -2692,7 +2692,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	WRITE_ONCE(msk->rmem_released, 0);
 	msk->timer_ival = TCP_RTO_MIN;
 
-	msk->first = NULL;
+	WRITE_ONCE(msk->first, NULL);
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
 	WRITE_ONCE(msk->allow_infinite_fallback, true);
-- 
2.39.2



