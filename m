Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9391AA1F4;
	Fri,  4 Sep 2026 05:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498883; cv=none; b=LL1glFHf3HHSbE0Gg45dWJ+oJlNVMC8Hin61Kp8r5u+SDsiGswGUGBN6JBeo9ZT7X9NeqNMWC2mgEyrnvymy3W3sQSaRFfkqx07/5WMhaMDShx5vDg6zGVk31CciHcbihpXg8hRwim9JvZzbdlpSEI/8jdjTDp6YCRzW3iHHPCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498883; c=relaxed/simple;
	bh=IqhqHS8/zSkav8Nq0NvprO3FVAxQIKo3gsaH+F07uJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DU/K3vc1GbmgyNbPlEoawgNypwsCRF0gsQnz9/nzvUPLRqVRgLG9cxVEDuIN1ekh0+U0WuS9FCS61SD+NApBMsNtu9gUXLQgC6ECNDn646r8YNBScDPpNQ4DOIHruPq1Ud55eYhzl1sgr3jivl2TvTH4l0HwFCyQ0uloh6T+idA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljtGoddV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljtGoddV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EEA1F00A3D;
	Fri,  4 Sep 2026 05:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498882;
	bh=lJuikMHRNacijVqn0UVhrj7uubvkFc8X39CdmFSC/AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljtGoddVjOm96OuXgOySktxiP4gJDAm5pUe5lQj79ByLYQ1Tc8EI+4fd4/08Lg2p/
	 Vhv95z5leICbjvuWysryoe32XTXk12/uqh2dKHJ84KuWlNE+oQV3Lh9mq5zuPZdYd4
	 58VWkULIWZp4lzNXKkj7y+Ii7Vps37ugvIgcSdhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 177/713] nfsd: fix clock domain mismatch in clients_still_reclaiming()
Date: Fri,  4 Sep 2026 06:52:25 +0200
Message-ID: <20260904045807.785950090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 09ea3eb9a518565f5bca386e81b993ed8825f5e8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h     |    1 +
 fs/nfsd/nfs4state.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -78,6 +78,7 @@ struct nfsd_net {
 	struct lock_manager nfsd4_manager;
 	unsigned long flags;
 	time64_t boot_time;
+	time64_t boot_time_bt;	/* same instant in CLOCK_BOOTTIME */
 
 	struct dentry *nfsd_client_dir;
 
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6823,7 +6823,7 @@ bool nfsd4_force_end_grace(struct nfsd_n
  */
 static bool clients_still_reclaiming(struct nfsd_net *nn)
 {
-	time64_t double_grace_period_end = nn->boot_time +
+	time64_t double_grace_period_end = nn->boot_time_bt +
 					   2 * nn->nfsd4_lease;
 
 	if (test_bit(NFSD_NET_GRACE_END_FORCED, &nn->flags))
@@ -9207,6 +9207,7 @@ static int nfs4_state_create_net(struct
 	nn->conf_name_tree = RB_ROOT;
 	nn->unconf_name_tree = RB_ROOT;
 	nn->boot_time = ktime_get_real_seconds();
+	nn->boot_time_bt = ktime_get_boottime_seconds();
 	clear_bit(NFSD_NET_GRACE_ENDED, &nn->flags);
 	clear_bit(NFSD_NET_GRACE_END_FORCED, &nn->flags);
 	nn->nfsd4_manager.block_opens = true;


