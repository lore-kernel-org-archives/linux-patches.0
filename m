Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD82911718
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED20C433CB;
	Mon, 11 Sep 2023 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442684;
	bh=hlmszkVvPffITMF+gjbhDbfLFWLOCHtGWE76mD08iSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSv3HyyQQX99W88Ar6pAA6mFilNzeNNib2oC4uf/3uUzmYOuz0e92T/jX4gCK2X2O
	 kxo23P1F5dHCTxpd9/bNrr00H2O8xKv4mwbRPXNCpR0Y3lFMZtCnP6MgPrpaY+b70g
	 ImmVjRnevJ5VwR7f+sFu0vPMnlDssK6641chyt1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Feng Tang <feng.tang@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 111/737] clocksource: Handle negative skews in "skew is too large" messages
Date: Mon, 11 Sep 2023 15:39:30 +0200
Message-ID: <20230911134653.606695156@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit e40806e9bcf8aaa86dbf0d484e7cf3cfa09cb86c ]

The nanosecond-to-millisecond skew computation uses unsigned arithmetic,
which produces user-unfriendly large positive numbers for negative skews.
Therefore, use signed arithmetic for this computation in order to preserve
the negativity.

Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Reported-by: Feng Tang <feng.tang@intel.com>
Fixes: dd029269947a ("clocksource: Improve "skew is too large" messages")
Reviewed-by: Feng Tang <feng.tang@intel.com>
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 91836b727cef5..0600e16dbafef 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -473,8 +473,8 @@ static void clocksource_watchdog(struct timer_list *unused)
 		/* Check the deviation from the watchdog clocksource. */
 		md = cs->uncertainty_margin + watchdog->uncertainty_margin;
 		if (abs(cs_nsec - wd_nsec) > md) {
-			u64 cs_wd_msec;
-			u64 wd_msec;
+			s64 cs_wd_msec;
+			s64 wd_msec;
 			u32 wd_rem;
 
 			pr_warn("timekeeping watchdog on CPU%d: Marking clocksource '%s' as unstable because the skew is too large:\n",
@@ -483,8 +483,8 @@ static void clocksource_watchdog(struct timer_list *unused)
 				watchdog->name, wd_nsec, wdnow, wdlast, watchdog->mask);
 			pr_warn("                      '%s' cs_nsec: %lld cs_now: %llx cs_last: %llx mask: %llx\n",
 				cs->name, cs_nsec, csnow, cslast, cs->mask);
-			cs_wd_msec = div_u64_rem(cs_nsec - wd_nsec, 1000U * 1000U, &wd_rem);
-			wd_msec = div_u64_rem(wd_nsec, 1000U * 1000U, &wd_rem);
+			cs_wd_msec = div_s64_rem(cs_nsec - wd_nsec, 1000 * 1000, &wd_rem);
+			wd_msec = div_s64_rem(wd_nsec, 1000 * 1000, &wd_rem);
 			pr_warn("                      Clocksource '%s' skewed %lld ns (%lld ms) over watchdog '%s' interval of %lld ns (%lld ms)\n",
 				cs->name, cs_nsec - wd_nsec, cs_wd_msec, watchdog->name, wd_nsec, wd_msec);
 			if (curr_clocksource == cs)
-- 
2.40.1



