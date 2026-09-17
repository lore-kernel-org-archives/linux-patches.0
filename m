Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A652D4EB86C;
	Thu, 17 Sep 2026 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659100; cv=none; b=VX4QZ17Nb+w/1qBopYeWjfluVPxUYd/kr525vv1ruUc7x5vI/NUhHIWP9RbFNvlpp9Uoya+w9iIdmbQMcOsjXGkz9ClncesptuDKTSYQktoLyPucKbXFnlXF2eQs+QZXRFChu1M8PlAWR5uwdbXfUc8MH2PEgD6NJauxw5FgTFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659100; c=relaxed/simple;
	bh=98Ib58MRJPlsW/ushh91XHSQh4D5EK4UlYLxRB6dBVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+boC7O1SNttaoSNfTR6rgJZUivpm9eilpjcs5sDeixgrqyRDyh55NatrRSSOaPWL8PgVQsX0g4nzUve2Cx6Ro56o7lG2xsbl5Q0aogUTd7i+ft57S6A+iiWRHhJn0uFr2tyIDdQ9a5WpHjswNQFOj25GXA9fmN0jpoBZd9QhJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw4SjVlo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw4SjVlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA191F000FF;
	Thu, 17 Sep 2026 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659096;
	bh=GSn9NordhRAFJxSc4fm9GL33M/BZaX4BNm973O19QXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qw4SjVlo1vTWu+yAxpkutJAwWoNtI6PbuRYFEOleVrK0pH0TccCCXVHyw56Zj74fp
	 IeZDTZ120eBbAfq/vRaLZnmwAyweN+ibke5HgOdUoucX4U6RoHLOhXj9ufbr7LbZia
	 bgaxaHz2P0qJVYVfECL/9VveRmg7m1xXbets6nAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 142/733] ipv6: mcast: fix delay calculation in igmp6_join_group()
Date: Thu, 17 Sep 2026 16:07:30 +0100
Message-ID: <20260917151354.576411212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 75fa9caeb8aaba19c2463dee0b0a1e09d39c04af ]

When joining a multicast group, if a report work is already pending
(e.g. scheduled by a query or a previous join), igmp6_join_group()
cancels the delayed work and recalculates the delay:

	if (cancel_delayed_work(&ma->mca_work)) {
		refcount_dec(&ma->mca_refcnt);
		delay = ma->mca_work.timer.expires - jiffies;
	}

Unlike igmp6_group_queried(), igmp6_join_group() did not check
if delay >= interval. This leads to two issues:

1. If the timer has already expired (timer.expires <= jiffies), the
   stale expiry is reused by mod_delayed_work(), causing the second
   unsolicited report to fire on the very next tick without a
   randomized delay.
2. If the timer was originally armed by a query with a large
   maximum response delay, delay could exceed
   unsolicited_report_interval(ma->idev).

Fix this by initializing delay to unsolicited_report_interval(ma->idev)
and re-randomizing it with get_random_u32_below(interval) when
delay >= interval, mirroring the logic in igmp6_group_queried().

Fixes: 2d9a93b4902b ("mld: convert from timer to delayed work")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20260828084531.1826790-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 3ff7c1c1bf4f8..62c9a1c08b9a2 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2638,7 +2638,7 @@ static void ip6_mc_clear_src(struct ifmcaddr6 *pmc)
 
 static void igmp6_join_group(struct ifmcaddr6 *ma)
 {
-	unsigned long delay;
+	unsigned long delay, interval;
 
 	mc_assert_locked(ma->idev);
 
@@ -2647,13 +2647,17 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 
 	igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
 
-	delay = get_random_u32_below(unsolicited_report_interval(ma->idev));
+	interval = unsolicited_report_interval(ma->idev);
+	delay = interval;
 
 	if (cancel_delayed_work(&ma->mca_work)) {
 		refcount_dec(&ma->mca_refcnt);
 		delay = ma->mca_work.timer.expires - jiffies;
 	}
 
+	if (delay >= interval)
+		delay = get_random_u32_below(interval);
+
 	if (!mod_delayed_work(mld_wq, &ma->mca_work, delay))
 		refcount_inc(&ma->mca_refcnt);
 	WRITE_ONCE(ma->mca_flags, ma->mca_flags |
-- 
2.53.0



