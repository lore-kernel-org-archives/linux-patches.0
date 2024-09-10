Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D811172BAE;
	Tue, 10 Sep 2024 09:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961914; cv=none; b=mxQp2jmpfAPgBV4Dt74NmwfgMhRuFT2Os9Tz6XkYfZUj1Fq6ycr3YlXiIiBbGD7kHvmsxvndkSSUSwgPhTT6b2LMUJAZN6vrq2WuOrjbOpXJ79HcUR+em4CfJVo9dHUz6YhxLlcIan8lUOswZ7gFxV4sce8H8tNNW/Wkprb+F10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961914; c=relaxed/simple;
	bh=5i+9K0JmCjrLFkSWOoaITAtd5gHygbWP4HoROczZ64g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYif//NpvpRTGIdV8is+umubAfqUzMkkPNXZJKnisbFeMMIJtcNzHXB7RSDV9/iaP3xC4A/azliCZnsTZdYXj1EZsYEQyCCEdGllAIOFxAWhdy2vpcTJepzLWX780ONIgjzLh5sPRKV+kQ+9N56jEHiGoGHCfcZSmv3lEUKdqOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nai9pjjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nai9pjjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3309C4CEC3;
	Tue, 10 Sep 2024 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961914;
	bh=5i+9K0JmCjrLFkSWOoaITAtd5gHygbWP4HoROczZ64g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nai9pjjpG1a7+H8hPJogbxLZYaJzitcGHUnrpJ8a7/5H8wdVodnaCDu49f9F8yO7g
	 B6TVaQJztyQ1tJ3WxqjWuYoo71h6XgOgPQ61I84fC4CDNqE9e8j5dLebvIMJexGyOQ
	 xW7U4PfwxHPYJ1iP0kpiXz27XfG/ch2E+ZEZgpKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 232/375] staging: vchiq_core: Bubble up wait_event_interruptible() return value
Date: Tue, 10 Sep 2024 11:30:29 +0200
Message-ID: <20240910092630.336054248@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit c22502cb84d4c963f754e6d943d3133cfa80ba97 ]

wait_event_interruptible() returns if the condition evaluates to true
it receives a signal. However, the current code always assume that the
wait_event_interruptible() returns only when the event is fired.
This should not be the case as wait_event_interruptible() can
return on receiving a signal (with -ERESTARTSYS as return value).

We should consider this and bubble up the return value of
wait_event_interruptible() to exactly know if the wait has failed
and error out. This will also help to properly stop kthreads in the
subsequent patch.

Meanwhile at it, remote_wait_event() is modified to return 0 on success,
and an error code (from wait_event_interruptible()) on failure. The
return value is now checked for remote_wait_event() calls.

Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Tested-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20240703131052.597443-2-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../interface/vchiq_arm/vchiq_core.c          | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index df3af821f218..fb1907414cc1 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -501,16 +501,21 @@ remote_event_create(wait_queue_head_t *wq, struct remote_event *event)
  * routines where switched to the "interruptible" family of functions, as the
  * former was deemed unjustified and the use "killable" set all VCHIQ's
  * threads in D state.
+ *
+ * Returns: 0 on success, a negative error code on failure
  */
 static inline int
 remote_event_wait(wait_queue_head_t *wq, struct remote_event *event)
 {
+	int ret = 0;
+
 	if (!event->fired) {
 		event->armed = 1;
 		dsb(sy);
-		if (wait_event_interruptible(*wq, event->fired)) {
+		ret = wait_event_interruptible(*wq, event->fired);
+		if (ret) {
 			event->armed = 0;
-			return 0;
+			return ret;
 		}
 		event->armed = 0;
 		/* Ensure that the peer sees that we are not waiting (armed == 0). */
@@ -518,7 +523,7 @@ remote_event_wait(wait_queue_head_t *wq, struct remote_event *event)
 	}
 
 	event->fired = 0;
-	return 1;
+	return ret;
 }
 
 /*
@@ -1140,6 +1145,7 @@ queue_message_sync(struct vchiq_state *state, struct vchiq_service *service,
 	struct vchiq_header *header;
 	ssize_t callback_result;
 	int svc_fourcc;
+	int ret;
 
 	local = state->local;
 
@@ -1147,7 +1153,9 @@ queue_message_sync(struct vchiq_state *state, struct vchiq_service *service,
 	    mutex_lock_killable(&state->sync_mutex))
 		return -EAGAIN;
 
-	remote_event_wait(&state->sync_release_event, &local->sync_release);
+	ret = remote_event_wait(&state->sync_release_event, &local->sync_release);
+	if (ret)
+		return ret;
 
 	/* Ensure that reads don't overtake the remote_event_wait. */
 	rmb();
@@ -1929,13 +1937,16 @@ slot_handler_func(void *v)
 {
 	struct vchiq_state *state = v;
 	struct vchiq_shared_state *local = state->local;
+	int ret;
 
 	DEBUG_INITIALISE(local);
 
 	while (1) {
 		DEBUG_COUNT(SLOT_HANDLER_COUNT);
 		DEBUG_TRACE(SLOT_HANDLER_LINE);
-		remote_event_wait(&state->trigger_event, &local->trigger);
+		ret = remote_event_wait(&state->trigger_event, &local->trigger);
+		if (ret)
+			return ret;
 
 		/* Ensure that reads don't overtake the remote_event_wait. */
 		rmb();
@@ -1966,6 +1977,7 @@ recycle_func(void *v)
 	struct vchiq_shared_state *local = state->local;
 	u32 *found;
 	size_t length;
+	int ret;
 
 	length = sizeof(*found) * BITSET_SIZE(VCHIQ_MAX_SERVICES);
 
@@ -1975,7 +1987,9 @@ recycle_func(void *v)
 		return -ENOMEM;
 
 	while (1) {
-		remote_event_wait(&state->recycle_event, &local->recycle);
+		ret = remote_event_wait(&state->recycle_event, &local->recycle);
+		if (ret)
+			return ret;
 
 		process_free_queue(state, found, length);
 	}
@@ -1992,6 +2006,7 @@ sync_func(void *v)
 		(struct vchiq_header *)SLOT_DATA_FROM_INDEX(state,
 			state->remote->slot_sync);
 	int svc_fourcc;
+	int ret;
 
 	while (1) {
 		struct vchiq_service *service;
@@ -1999,7 +2014,9 @@ sync_func(void *v)
 		int type;
 		unsigned int localport, remoteport;
 
-		remote_event_wait(&state->sync_trigger_event, &local->sync_trigger);
+		ret = remote_event_wait(&state->sync_trigger_event, &local->sync_trigger);
+		if (ret)
+			return ret;
 
 		/* Ensure that reads don't overtake the remote_event_wait. */
 		rmb();
-- 
2.43.0



