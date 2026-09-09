Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193056C624;
	Wed,  9 Sep 2026 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964750; cv=none; b=Q9caxmZBUxSaJEnpcEWhLKMA9avD1J+ThhAlivKjA+N7MVz1bC+QEkYz/sX20woNM5n+Sn7x+OG3f+RA6+dsRaE5Fvz4wtjTvLPF9CTVRxmM10tQDaHb/e9A+Azvpmuuig/YMZ5nw3hMhw7ChVbMuDtoK6sPHYIpPWPrZEbCsZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964750; c=relaxed/simple;
	bh=tHsSnKYjwj8k5qf6q53EpRtBveKlL5yxpY6fttopC+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDw5YFZs5+A7YinKIGfVTx8KD2vkn4uNVVPp6q1aBy9D3ZYqP0+X3YFk6rzmOplIMPeRNbQ3RQkvis+XAC2HUtyoKG6cVqjPHFC1mg0UMwEprSy6KSWtU2yMgPHuhgTWcDF+xmljkRCsrTyUjrBa/kn+jQNKs0YHYaTLk3uAOHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brbpVZtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brbpVZtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263A81F00A3D;
	Wed,  9 Sep 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964748;
	bh=B36tCG+HKtWTmvRgYVi6z8V660h21ZRdMpMO0RTb7TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brbpVZtJWWuGxIvIFRHOGRlq6lXBH1avGFZ2qr/l3HsTB26fG9oGA59bg/nNtktNX
	 rGgVdTAWJEPvHJwFL/McoBw027yy2Gh0jqtvO9EwOk/eX1vDLk8Qh631LDADJakj/0
	 TzHRU69bTDOf7Pjqi08OefcITrUsWEAbSryqRXS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 531/583] nfsd: fix clock domain mismatch in clients_still_reclaiming()
Date: Wed,  9 Sep 2026 15:43:36 +0200
Message-ID: <20260909134256.196081446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h     |    1 +
 fs/nfsd/nfs4state.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -69,6 +69,7 @@ struct nfsd_net {
 	bool grace_end_forced;
 	bool client_tracking_active;
 	time64_t boot_time;
+	time64_t boot_time_bt;	/* same instant in CLOCK_BOOTTIME */
 
 	struct dentry *nfsd_client_dir;
 
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6769,7 +6769,7 @@ bool nfsd4_force_end_grace(struct nfsd_n
  */
 static bool clients_still_reclaiming(struct nfsd_net *nn)
 {
-	time64_t double_grace_period_end = nn->boot_time +
+	time64_t double_grace_period_end = nn->boot_time_bt +
 					   2 * nn->nfsd4_lease;
 
 	if (READ_ONCE(nn->grace_end_forced))
@@ -9120,6 +9120,7 @@ static int nfs4_state_create_net(struct
 	nn->conf_name_tree = RB_ROOT;
 	nn->unconf_name_tree = RB_ROOT;
 	nn->boot_time = ktime_get_real_seconds();
+	nn->boot_time_bt = ktime_get_boottime_seconds();
 	nn->grace_ended = false;
 	nn->grace_end_forced = false;
 	nn->client_tracking_active = false;


