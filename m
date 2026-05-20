Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BD43FC5BE;
	Wed, 20 May 2026 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302560; cv=none; b=FiifppDfmMLzTgBIDcZWb66miU6QxDW7RItFcAtUbqEdGsN7os7Q8usNpe2Ogkb7tuv9h+TyHVVUccSbUL8hPiyfvxELQdo3/P4H/icKBhUCJR1DPDrrYgJGZY4dfzTz1prvc6zz/Vwo3aCmxfKhhOpf7d7WkQsQb1/Z8XJQI5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302560; c=relaxed/simple;
	bh=3UqiF+gvtv97WaQUSKIjraXslN70XUXBEtrx8P6vtAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGjV/AaOzpq8RP5JPBS2XDdVWJ+0X4U7qLKhHXbwjQK+PmTczbsi5e52XGNcj/tmukuY+pTVRfqOSnUZ4T4gthAGAfVoazHloO5pg2ImFI5PQp3pY7kYUPQqouaMoKomRYaUXSjabtcm8rtLMu9igqUMyISzpeknVZ+TI/d7qJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAOF2J2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAOF2J2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A381F000E9;
	Wed, 20 May 2026 18:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302559;
	bh=AO/grFLjKmW8rz/nCuxAlDqSRdE/Cg39UuG/cdHXM3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAOF2J2IN1PAjtyEzUDCbJJb8N2n/6hj0ksvCtRZmVeGXgYlPdtZ8hNQ2HY17fvvI
	 nDwGKrE4vo9rD5Px57dOatj9Io5v9yOYhPsXBC9tCblWFb79zIfPkVsu4n3seIRGmW
	 YRPfNSjbrQWjWsWJKJNpC1Y9A13J5TwfZSo1HRCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 314/508] net/sched: taprio: fix use-after-free in advance_sched() on schedule switch
Date: Wed, 20 May 2026 18:22:17 +0200
Message-ID: <20260520162105.441444850@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a01d17d03bf57..6df93d5c2e9d9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -982,11 +982,12 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	}
 
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



