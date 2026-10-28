Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210515;
	b=tVwyLKCDrNXRW3SSK/8hBGgSQkTD54S4ND+LTEq6gVXG4ct6F1NWUNyULEKys/be0fqa
	 OiW4cUG/y9B2paDRZq9dEtyX+UBNG0BUX05jWEivRsWPaPG2ngLWu4/ThSysyts3vW5tC
	 1KNh0Dhq32OkWUlpAQUhG2lP9ePvvphh1YI+6WEzS80MuULUehPYDZ02EHc2IINSErM/4
	 V6KbUsjExTtV67qJv+5ky8CFm/uXGDsvs/CgoqvI/TXm6wluuMAolfiaoGAV4mKyTGWjP
	 aYkiveRj0oxV79M6S6y4tr5dzTlGGoTCwvlyGrPlZPgLQsHwVhR63TGvmuadLvBNbAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vnxJ1wEcy+7s1w/TtdwRyJOeZe8hV7VccK11QMZfqsc=;
	b=3nTOOymFA3HHy4YftGH33Cehj0+vnIK4+j/umIYdREgW4RlVcX/JPzjiX/WG98RQqk68
	 HGmOH/sqeW3eapLbXtnF3S6PMmVteYZ4fb+YjpKiQkpp3HQsP9/xFmYRcbxR3X3UCPNZ6
	 han/qLm9YbgzGrJB+jdGatvLhwlF1GYjkyou6w+SS7BxIoAt6k6r30jGV21k7h5lnsUaN
	 FumVarpCZCJEUIxkwiQ6xlBuJNDVQYq5Avu1n6Yrd7I09X1hFltfM+BCISj4RunEfjcOr
	 jXRv31/J7IPxp35i5PdBF0yqdOQMJf4X/u+Xm+dCrELFKNaDMmrXQUVypQmHGEgyaXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyCD+917;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEA1606A31E;
	Wed, 28 Oct 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyCD+917
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3351F01825;
	Wed, 28 Oct 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210515;
	bh=vnxJ1wEcy+7s1w/TtdwRyJOeZe8hV7VccK11QMZfqsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyCD+917U+Zd2DP4yqhAtzGoBiHvl15A8m6vxyK/sVexqg/36GjvsUoGA2RF2TN38
	 X3qkE/tpXPPc913M7uItnz+mkQO98IjLLAWIQzkRkdCBas2d2ZRJhkN6RPWmtCCHab
	 MRdSXWwuOsTzSp2KuAah4LcgXfLu5TNLPcGKE1B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/571] nfsd: fix clock domain mismatch in clients_still_reclaiming()
Date: Wed, 28 Oct 2026 17:53:20 +0100
Message-ID: <20261028170009.286680369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 09ea3eb9a518565f5bca386e81b993ed8825f5e8 ]

clients_still_reclaiming() computes a deadline from nn->boot_time
(CLOCK_REALTIME, ~1.7 billion) but compares it against
ktime_get_boottime_seconds() (CLOCK_BOOTTIME, seconds since boot).
The comparison is always false — it would take ~54 years of uptime
for BOOTTIME to exceed the REALTIME-derived deadline.

This means any client can hold the server in grace indefinitely by
sending CLAIM_PREVIOUS OPEN requests, blocking all non-reclaim
operations for all other clients.

Add boot_time_bt (CLOCK_BOOTTIME) alongside the existing boot_time
and use it for the deadline computation. boot_time (CLOCK_REALTIME)
is preserved for its cl_boot clientid-nonce role.

Fixes: 20b7d86f29d3 ("nfsd: use boottime for lease expiry calculation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-12-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ preserved the branch’s boolean fields instead of the upstream flags bitmap ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h     | 1 +
 fs/nfsd/nfs4state.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index be0c8f1ce4e3e..b95ad49800533 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -67,6 +67,7 @@ struct nfsd_net {
 	bool grace_end_forced;
 	bool client_tracking_active;
 	time64_t boot_time;
+	time64_t boot_time_bt;	/* same instant in CLOCK_BOOTTIME */
 
 	struct dentry *nfsd_client_dir;
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 673c10c36ad61..0b7c70b27ab46 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6030,7 +6030,7 @@ bool nfsd4_force_end_grace(struct nfsd_net *nn)
  */
 static bool clients_still_reclaiming(struct nfsd_net *nn)
 {
-	time64_t double_grace_period_end = nn->boot_time +
+	time64_t double_grace_period_end = nn->boot_time_bt +
 					   2 * nn->nfsd4_lease;
 
 	if (READ_ONCE(nn->grace_end_forced))
@@ -8278,6 +8278,7 @@ static int nfs4_state_create_net(struct net *net)
 	nn->conf_name_tree = RB_ROOT;
 	nn->unconf_name_tree = RB_ROOT;
 	nn->boot_time = ktime_get_real_seconds();
+	nn->boot_time_bt = ktime_get_boottime_seconds();
 	nn->grace_ended = false;
 	nn->grace_end_forced = false;
 	nn->client_tracking_active = false;
-- 
2.53.0



