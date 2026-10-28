Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212318;
	b=BDDUnD7LyQpuvCSXBDIJaOMHVrtx2Dio3KGV41dHAS7dnPHTnn/UO1y1vtxDW29kaeLD
	 W4I76za1T6OucaOkOTHjl2tTlJZO5uQJuXBaYdo+qKS5CyBT/B8zcq0IqCpChQtApohwS
	 vIh9xCckOpof+JALoqZoQARseat1HtKEgdBITWuw+ai9UroAuutmW/qBbuW7vAs+Ui7hK
	 0kd0b0wHcvdvBkalxpPOV922LUm42SZ10kr3dIrH5sNymDTBDnZqQXlKqjtbh/dXNZUAD
	 EsJLKkigm+ynogD1a181ilcLdsqcQGeWD5fFSNedP0DP9TI58Px/fideL6sbBvkzkwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/iJmKqDmEQwPpxzw9ijKODS/XAivehbIYesZxLiTUEc=;
	b=xzOZI2dZXgt0zbU2L11avcLm5oaiEWQNmOMGcuZI3N59OxCtnJS96cEYDFoEBZ79pF/9
	 boMUkT6FRFpL6tCG3tKP7cEfc1fUfSOe0kwz6PYQHlk6wOCCxhVi/CdKhpKmcEPfYdwpF
	 GXgxJNB+yIwvk0TiJAB1nqIDuYD60XywkYdtgE4ilJaes0mf3y660Z0DHb16tHCghonbC
	 28yfLv2V8u1K8nV1O91WKSCTR6GxBbN1Kvc9gCEauzfqqJpVPyBawvTI0GSI7A0cV3uoz
	 SObzicy5BDzVeOxAozuDDdBeN5nm9x+OkRE2Ite4plHTTvSRG1dRHu5vtq6fKtNExOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXWhWM1M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7B606A31A;
	Wed, 28 Oct 2026 18:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXWhWM1M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00651F01825;
	Wed, 28 Oct 2026 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212317;
	bh=/iJmKqDmEQwPpxzw9ijKODS/XAivehbIYesZxLiTUEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXWhWM1M8uCnGESEEHKGKKpoGOUwQUxRzApIQdMOTJOCiWxkG66yX4dAUIyECrpIW
	 cJPhuxIt3+i+BuaR+Lkd2AjZnZU/QSf+pjX6fRBo/40SPxzfKUbfE7C7CP+CUvbBqK
	 RV11jBUjwr6WidtB9zT7wT+D2TKa8aJzTX5lJffg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0068/1887] nfsd: fix clock domain mismatch in clients_still_reclaiming()
Date: Wed, 28 Oct 2026 17:36:04 +0100
Message-ID: <20261028170500.780258865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07c739f5f08d3..a342f6398e55e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6029,7 +6029,7 @@ bool nfsd4_force_end_grace(struct nfsd_net *nn)
  */
 static bool clients_still_reclaiming(struct nfsd_net *nn)
 {
-	time64_t double_grace_period_end = nn->boot_time +
+	time64_t double_grace_period_end = nn->boot_time_bt +
 					   2 * nn->nfsd4_lease;
 
 	if (READ_ONCE(nn->grace_end_forced))
@@ -8277,6 +8277,7 @@ static int nfs4_state_create_net(struct net *net)
 	nn->conf_name_tree = RB_ROOT;
 	nn->unconf_name_tree = RB_ROOT;
 	nn->boot_time = ktime_get_real_seconds();
+	nn->boot_time_bt = ktime_get_boottime_seconds();
 	nn->grace_ended = false;
 	nn->grace_end_forced = false;
 	nn->client_tracking_active = false;
-- 
2.53.0



