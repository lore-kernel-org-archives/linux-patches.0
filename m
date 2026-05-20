Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CEE369D67;
	Wed, 20 May 2026 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299086; cv=none; b=KE326BiYKQ6Jv3ZZBoXX1Gqz5L+7MRiRdlj4q9p3fGeL3ncPmvQoWPvfdi9K1YFUFcC//oSjgMMoxTYUAoMjX6tO/QrtFTT7fEcNqTvQhuPhr/MeIKUbQxacQtU861lC4AE4AUfH8/K9iipE60WSyRXKB7UU8zfX0K3hWcmnIIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299086; c=relaxed/simple;
	bh=2esuF5Ehx7XD8w64SlUEjhlTAtQ2CLwt9SA1Pv0dLq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdGasusl07JSM5G3duMvmLHf9ZWTm7/yqeRDhBAayd7JiS8WKb454wpreFLj32J7NMVTkiUNGIqE6lW2C4WSL82GwpP11TkDw82MCohdcbRbvHp6++ASDw3gSpmSJxvtoAx/6dj79GJldm/FS2J63nYRoBg/Ba6exsFstYdXMlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bca6WkwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bca6WkwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A301F000E9;
	Wed, 20 May 2026 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299085;
	bh=VJHFlvBQUoKsRDQ7PQqksov//dvyTdQjZ7gMpWKbBwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bca6WkwLvUZWjQJIWtNq3sDBxFvZ7GwE44TmW5uiZRLcUX27dna0fp+1aTJ5RF3Us
	 cond1/VXNrANFDTUvPvu9PSapzsaa+WGGItLl6eCBfxr7sgnUVHeAFFhMxV7Jk7pz/
	 j6EIwd4xB1+7Wf3cHX7QUmAvC83aDAGTjkH3HS70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 620/957] net/sched: taprio: fix use-after-free in advance_sched() on schedule switch
Date: Wed, 20 May 2026 18:18:23 +0200
Message-ID: <20260520162147.978156321@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 39b735386996e..91b85360f8091 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -971,11 +971,12 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
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



