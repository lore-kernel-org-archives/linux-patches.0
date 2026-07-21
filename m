Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF8D356746;
	Tue, 21 Jul 2026 19:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663143; cv=none; b=MZzVABIZ9EAXIkKBeK6e2qo925V4Qb4IEmIIC4az+zfbWtsmMr/zYlmSj2qPudDUKXR2S3a3bnweXwg5fd32X3hSSA4czf4b0JGpNg9rzbFsHlO9gpvSEJ43BvYYD7WhihH4+J+pXIqcKknwmpoExHaRs1sk3FXlkYJDv7LNlHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663143; c=relaxed/simple;
	bh=rUXkiV1zeQB8oIfXuKxuAYS30jAu5lLPl21luq5S5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKo/6B4B/bJaCEVCtI6QSYqnlZvSyvfFO6QVwKru2w8wV3U+75mGXVnpxDgJNWo9DQoCLaFZmaoa6JL01ueBzAy1KPmdMTE14SmFKhFaMjTQJQdahGsIxDg65+mPsxGTZqLTTJg4CEElDGF3prrseBGCXskJRLBvS97alkwmbwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sfb3O+ch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfb3O+ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB291F000E9;
	Tue, 21 Jul 2026 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663141;
	bh=FsMsoXGz5Yw3IuPvlLuMQrAlG3aV/H2+LSSyUilwf7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sfb3O+chSpb8Gd9HrX2z5qThMNCVK2Sa1+z1Xda8/fFwdpu+iU/uPzNoZrhtoUTAz
	 M5aUE0/P8Fs3PSx8t1id2CwatDqJo81N0p3xoxeyO0Q8THGO01J0wxxd47GWPgodjc
	 KfLnii9zzpQvaxBm3NTj5ijaPICevRt7iOojLjTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Karunika Choo <karunika.choo@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0711/1276] drm/panthor: Dont overrule pending immediate ticks in sched_resume_tick()
Date: Tue, 21 Jul 2026 17:19:14 +0200
Message-ID: <20260721152502.006392076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6fec8b473497b7f32e604a6dd92b32b0889af3e8 ]

We schedule immediate ticks when we need to process events on CSGs,
but those immediate ticks don't change the resched_target because we
want the other groups to stay scheduled for the remaining of the GPU
timeslot they were given. Make sure these immediate ticks don't get
overruled by a sched_queue_delayed_work() that would delay the tick
execution.

Fixes: 99820b4b7e50 ("drm/panthor: Make sure we resume the tick when new jobs are submitted")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v4-0-3d2908912afa@collabora.com?part=9
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Karunika Choo <karunika.choo@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-6-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 3e7799dd00679b..0173f27b1a9261 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2535,7 +2535,14 @@ static void sched_resume_tick(struct panthor_device *ptdev)
 	else
 		delay_jiffies = 0;
 
-	sched_queue_delayed_work(sched, tick, delay_jiffies);
+	/* We schedule immediate ticks when we need to process events on CSGs,
+	 * but those don't change the resched_target because we want the other
+	 * groups to stay scheduled for the remaining of the GPU timeslot they
+	 * were given. Make sure those immediate ticks don't get overruled by
+	 * a sched_queue_delayed_work() that would delay the tick execution.
+	 */
+	if (!delayed_work_pending(&sched->tick_work))
+		sched_queue_delayed_work(sched, tick, delay_jiffies);
 }
 
 static void group_schedule_locked(struct panthor_group *group, u32 queue_mask)
-- 
2.53.0



