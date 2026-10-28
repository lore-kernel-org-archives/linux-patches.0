Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208389;
	b=cemrPGYTCGGyMA/s06UxnkOZ0IgkAOyEQI159sa5vV+OvjcyOub/zyVEmwGs5AqLwVDn
	 C0SUk8cpzOcCXl4yCmXHE1+KYF7wa+uzugS587UfHj+Jc66xJzsTLXrbwWwVUplaCe+St
	 Ze+mLBJI8dgXxmIxtks9d7JBEP/+ZPbWwTbQirjY35ZHgu/mIYgOCYAFfhS29dNm0fWTD
	 fWj4a+M6GhHjtB8U/xPRN4YGgdGAzFbQhAs3P/xyor0DBGbcM/zt0rDghhuKcPxy4dddD
	 Osj0/+Nkof2CVyPKHnA+2R/Gs8ZV2yeNCaYfDk978EYiWKQmUIQOc6DRng9qvKNfEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8RoDt3mDBo3vA+65SAWobLXfuoHoualfbd68gHPGEtA=;
	b=PBJQ9aMRVX/5MKkeMCf2CJZOX/jW8o+YPFp6wdfgiXkWcyS1VhDGLV1hdarYunRq0H1h
	 A+wZKkJGUavUSesLrQi8i8TTLop8QPFiJvRT1EjsAOmW7ZBt+JEocT1x3JuAnhllrk05z
	 x5mgjUx8OB7T7oIYJ30V/dA0JIyLgDyPMG9z1hG89+KY4YSWSnPubeDIGL1gs00MvdyRf
	 tYqZDOJqtQ0afWFoCR3vY7KIN6l//nqiXdnTnUXdl8Y6S5MALOsu6815gujw+KwcHsN1K
	 9pCu1qHBS2yRoyQPrV/PVTS5ZrcrK8xtTvp/Jm2qX6a1QCumtuUBNZa9z4HeY9mN/5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8PNOFz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D5E606A31A;
	Wed, 28 Oct 2026 17:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8PNOFz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F311F01825;
	Wed, 28 Oct 2026 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208388;
	bh=8RoDt3mDBo3vA+65SAWobLXfuoHoualfbd68gHPGEtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8PNOFz8LmSVsfPs23EhcfC3O6Xn0RNibMCmOGGRuoSDWAPAEyFPg0253YQCosLzo
	 18Jb1oduAz1AunAndq8tC2VIUscuyUxpFcNzRjK6r7WcvRtZMQv8640L7RhT0RXpv/
	 tGMfc95o2psxFhN4hg93DzQ5517WQdOk8+hi1QRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/516] nfsd: fix clock domain mismatch in clients_still_reclaiming()
Date: Wed, 28 Oct 2026 17:53:21 +0100
Message-ID: <20261028170004.693715556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9219171653004..91d17c948fb1f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6026,7 +6026,7 @@ bool nfsd4_force_end_grace(struct nfsd_net *nn)
  */
 static bool clients_still_reclaiming(struct nfsd_net *nn)
 {
-	time64_t double_grace_period_end = nn->boot_time +
+	time64_t double_grace_period_end = nn->boot_time_bt +
 					   2 * nn->nfsd4_lease;
 
 	if (READ_ONCE(nn->grace_end_forced))
@@ -8287,6 +8287,7 @@ static int nfs4_state_create_net(struct net *net)
 	nn->conf_name_tree = RB_ROOT;
 	nn->unconf_name_tree = RB_ROOT;
 	nn->boot_time = ktime_get_real_seconds();
+	nn->boot_time_bt = ktime_get_boottime_seconds();
 	nn->grace_ended = false;
 	nn->grace_end_forced = false;
 	nn->client_tracking_active = false;
-- 
2.53.0



