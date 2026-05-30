Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF9340293;
	Sat, 30 May 2026 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161649; cv=none; b=pADAw09TYAVY3WDk7SZlFDa9LCLgljZNhJXCUeLaLTRVRdfe5buz5MHVo1X23y62duP7Ues0nWVlmfTN9CdHAJFk7C572h1wBIeBxI1PDkuQeUpQjv7diMG/+LWWK4qByqpLhNmikpNhnTi1uPJl2QxSD1pSMD2RxXtGq+oH2Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161649; c=relaxed/simple;
	bh=6RjE1c2fYY8ewrMgxh/r63o/1z58OIpnwOAYIWXMU/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFsk/Rses4tz6kiDu3QPmMubviSSpwYJ2/M5rIDH3cvdym2lxdkEeGQ8vLa0B9eXLn0CFwYfWpSQKKCeg+0vfQEVZudq8vmTbz3GpPVaCYAO8/+S9Znujx+FH9KBHlKTTA3lT8fv3YkePiTWsYAXLofVQjgHlAFhnQyDg3S3r00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0pVlxuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0pVlxuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9487E1F00893;
	Sat, 30 May 2026 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161648;
	bh=ikGAWtpVvkVCx4k8BeokdLfQVF3j5chhMkSP0Jv2PUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0pVlxuhzwbnalFGZdtzAgpjgLA75VWGAXJeQ4NBZxh9MaJHJfH3lCs0oSm+ijDNK
	 fRMIKh8109wwNvp885EF/h6oERJBiuHG8Beeimx2/NuwrM18SiKcQ6Z8U1crYlVo6V
	 U6O3ioIzxGnehHQgcjWA9MzdssiY4De3GnM1YwD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 685/969] net/sched: taprio: fix use-after-free in advance_sched() on schedule switch
Date: Sat, 30 May 2026 18:03:29 +0200
Message-ID: <20260530160319.422949820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 105425b1969c5affe532713cfac1c0b320d7ac2b ]

In advance_sched(), when should_change_schedules() returns true,
switch_schedules() is called to promote the admin schedule to oper.
switch_schedules() queues the old oper schedule for RCU freeing via
call_rcu(), but 'next' still points into an entry of the old oper
schedule. The subsequent 'next->end_time = end_time' and
rcu_assign_pointer(q->current_entry, next) are use-after-free.

Fix this by selecting 'next' from the new oper schedule immediately
after switch_schedules(), and using its pre-calculated end_time.
setup_first_end_time() sets the first entry's end_time to
base_time + interval when the schedule is installed, so the value
is already correct.

The deleted 'end_time = sched_base_time(admin)' assignment was also
harmful independently: it would overwrite the new first entry's
pre-calculated end_time with just base_time.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Reported-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ce529b9448819..8da723f054f56 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -739,11 +739,12 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
 	if (should_change_schedules(admin, oper, end_time)) {
-		/* Set things so the next time this runs, the new
-		 * schedule runs.
-		 */
-		end_time = sched_base_time(admin);
 		switch_schedules(q, &admin, &oper);
+		/* After changing schedules, the next entry is the first one
+		 * in the new schedule, with a pre-calculated end_time.
+		 */
+		next = list_first_entry(&oper->entries, struct sched_entry, list);
+		end_time = next->end_time;
 	}
 
 	next->end_time = end_time;
-- 
2.53.0



