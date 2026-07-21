Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8069046D2B3;
	Tue, 21 Jul 2026 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653598; cv=none; b=FrxfP6mSI8AflvQpYcFtVSHVK+XS0ws+emy7TWxMSIfBl8knJq96AJoK7vCG0y8CL04ZeNhqqCX5l8ea1CIBEjWoWcK38AMKIXmNO9aIolp/wBJKi5kDyj6UdJJnKp/Ul9WNP0Wjbxb78qFyO0hAltCKrfmmW634/oTbigc021s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653598; c=relaxed/simple;
	bh=UnNJ4su69xzvnzHGEw4sQhHZpkR1MkHKjtc9MJXnsxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGCYvoTKhxfRXJ73KIoJsfeDN+46gyDCQ2IOwPkM67uyQMQjzN2UJ/9jadqPW1Cc1LMxUa/hJc9pun4TVz3U3G1ynykrMXzmzJY7kBPUlIc0N8FTYLWVH++rPUt5kWhPvvmY6KVO8Sl6Au4I6sOi2gytvsq6+HczjdyKY0dcsII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGsiMcHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGsiMcHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A311F000E9;
	Tue, 21 Jul 2026 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653597;
	bh=RthEJSL86JyxzAf234ooC8Rtd1fAAQk5leXQ9tQPazE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGsiMcHkTwwA3ZwIf7vhzLrnALcTrWMxJzIW/9r3CKg5px9a4dGwrxZduuLlqqNkO
	 hfZkaj0A5fXJxTnp71i4HK8uAx5bD6WA6moR7WhkFpSnvnH2/TIbxX60pjCUPEhzU1
	 MjgqXSEi4VI8yaiAe47mNX9WDBy4ENXr8tYzLbqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Karunika Choo <karunika.choo@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1344/2077] drm/panthor: Dont overrule pending immediate ticks in sched_resume_tick()
Date: Tue, 21 Jul 2026 17:16:57 +0200
Message-ID: <20260721152624.518877819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 608264031f50af..e347e15349db59 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2666,7 +2666,14 @@ static void sched_resume_tick(struct panthor_device *ptdev)
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



