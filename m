Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FFB4D4878;
	Thu, 17 Sep 2026 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659111; cv=none; b=UcfAgtlPddvGS1zZQvG98xEmJ754AVDykQcGGGgHZwAhIoGDshTqRRj0cEn8j9g5hwl8gdrkDQjqzzWXnCWjXjWFZhJ7ac0X5FwjsqIXQMF4PUjsUA+3BjoN9jEOOL3rnb5pf8CVuT2A4f4HlCMsxXR7lbtnDPZ08Fg36OFrBaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659111; c=relaxed/simple;
	bh=rl32tq+KGvLralFry+T5viiTgBrjMQWWvz3jLYgyers=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEdiAYfcVGsrkxuCF4lPQ9vwKHy/o3mWSvihGR4GKnz9hZoBdW9LwUsrOoWAeLP9pcFZ/cKXwXXhU6dTtOjpHXQ3Ot5C8tO3tjkdTMbGQC0t9mqzayXLoQ2rtSlotPfnc2JQ7gNf1QUQn25Pha4hmh6YznkR9fF3ufIu4WU2fIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcJFEUlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcJFEUlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DCB1F000FF;
	Thu, 17 Sep 2026 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659102;
	bh=zPXNOk+Q/KB3a18ji6i6jFvagJoXEFx+g3U0WOZVLxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcJFEUlbsG36pWp8/7bnd2tEo4I+sFmVNaCKm2rV/6PQtJqRWLiV+7cdB90k5D9oo
	 B/iq7zZozcp5F8gMaLSvw3t4hNSuTMg79oWKYk0jSOnnkzk+f4a/to3oS/k1nXZldH
	 pQ/O0idTNds8skVcwYGwAMb1AGW5SLAY880gpH18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 144/733] ipv6: mcast: use jiffies_delta_to_clock_t() in igmp6_mc_seq_show()
Date: Thu, 17 Sep 2026 16:07:32 +0100
Message-ID: <20260917151354.630356272@linuxfoundation.org>
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

[ Upstream commit b4cf4a092a7bdaa62acca39c28f386b6d1674968 ]

If a multicast group timer has expired but the delayed work has
not yet run to clear MAF_TIMER_RUNNING, expires - jiffies produces
a negative value.

Because unsigned arithmetic was used with jiffies_to_clock_t(),
expires - jiffies underflows to a huge value and reports invalid
timer durations in /proc/net/igmp6.

Use jiffies_delta_to_clock_t() with a signed long delta to properly
cap expired deltas to 0, matching IPv4 igmp_mc_seq_show() and commit
a399a8053164 ("time: jiffies_delta_to_clock_t() helper to the rescue").

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828084531.1826790-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d5db3b449cd08..fad53a5cdfffb 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -3028,7 +3028,7 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 	struct ifmcaddr6 *im = (struct ifmcaddr6 *)v;
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 	unsigned int mca_flags = READ_ONCE(im->mca_flags);
-	unsigned long expires = READ_ONCE(im->mca_work.timer.expires);
+	long delta = READ_ONCE(im->mca_work.timer.expires) - jiffies;
 
 	seq_printf(seq,
 		   "%-4d %-15s %pi6 %5d %08X %ld\n",
@@ -3036,7 +3036,7 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 		   &im->mca_addr,
 		   READ_ONCE(im->mca_users), mca_flags,
 		   (mca_flags & MAF_TIMER_RUNNING) ?
-		   jiffies_to_clock_t(expires - jiffies) : 0);
+		   jiffies_delta_to_clock_t(delta) : 0);
 	return 0;
 }
 
-- 
2.53.0



