Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E63AEF2D;
	Thu, 17 Sep 2026 18:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671594; cv=none; b=kOzT0dCPSPxHLwiKcYG+g5BrTAtXXgx4Jv2BXWTDtzeTJY3SQTJxCPxYoBogQqBM26MzwKAzTUhNXCfHS4QDJmy8nUt9At9tu0lzB9j10W7iG9pzqoYa1NA7/rzHRt/WSv789Vzq5bLCpbblo7Y3GPlhBuDjppu31dZ+WG6Qh/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671594; c=relaxed/simple;
	bh=gxcmB8CBC8gze2Z925c3gIpdTtqezX+kOxhCOa8zRMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inj65nL0rwmKZ6S+iKE5+DiouslBUdqwB1tAT6IdJYyVU3nIOt8JCzkyudMs9ox0kjaodrwAhk70p6z4dKByJpE6Gzf0ggIIAn+dYJ7tTJlJA5k32DT2L+hv602iox9L12fodCJOVyZfUr9i4cYTE7wry1rEnoJzgsftMxM/LHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI1oWWXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI1oWWXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199091F000FF;
	Thu, 17 Sep 2026 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671592;
	bh=GkSTqFcifmT1nBp6EmJOOobw+et3DOr/2qR8LI9Da/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LI1oWWXeYkAPs56g1HxCHfpk9/IxReKL7oqG/dvuZeZKIRoh9EuQYSkw8h2BoTuEc
	 9CPdwKovgTa37CU+Z4Hkuz434VTvXLWoMCWCNJs60LB2OmyS8qLsBlpZNlnOVnQkvb
	 A7S7G3dt8QP0XInyDPBoie07ihCtpRnenMMWSiDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1027/1102] nfsd: fix clock domain mismatch in clients_still_reclaiming()
Date: Thu, 17 Sep 2026 16:16:10 +0100
Message-ID: <20260917151606.552361979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6469,7 +6469,7 @@ bool nfsd4_force_end_grace(struct nfsd_n
  */
 static bool clients_still_reclaiming(struct nfsd_net *nn)
 {
-	time64_t double_grace_period_end = nn->boot_time +
+	time64_t double_grace_period_end = nn->boot_time_bt +
 					   2 * nn->nfsd4_lease;
 
 	if (READ_ONCE(nn->grace_end_forced))
@@ -8877,6 +8877,7 @@ static int nfs4_state_create_net(struct
 	nn->conf_name_tree = RB_ROOT;
 	nn->unconf_name_tree = RB_ROOT;
 	nn->boot_time = ktime_get_real_seconds();
+	nn->boot_time_bt = ktime_get_boottime_seconds();
 	nn->grace_ended = false;
 	nn->grace_end_forced = false;
 	nn->client_tracking_active = false;


