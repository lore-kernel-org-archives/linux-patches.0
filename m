Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7222594B6;
	Mon, 30 Dec 2024 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573628; cv=none; b=FosZgnMMqA+jXapn9QERau+qRaKIT5l/j+6+H31FLmENkOZrKNJvLj4oSkt+PGZdphwdznFBzIDlLAQ5wTDsM6vOxf0uuQ1IqzSrlT2gPNawAh92LVQPeXnvYwM6xkZiceHqekvhuICQhQAS4FtyxYg/gjnZ6GnXPy7pTll8RLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573628; c=relaxed/simple;
	bh=7kDBJvA6VlFbDWZx4Wddxkpea3xZ4uIUX9p+tKHGcyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mw+ZjHD39eFp42Va5s0PenupjnZK2RKl81gDqj72XwHMv/9yXVWPiv2pX+yZOxD41AqUAznugHY9sxO/5OwwBovi2c7QTT9hj3CE7giSw1rTsvjApOgbglDiHkM5ajDHngJS4zkc8gZN8LDBYZb7qPn+0Fpsy4T6Gv6hCcjG8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7DCJ+Mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7DCJ+Mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC411C4CED0;
	Mon, 30 Dec 2024 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573628;
	bh=7kDBJvA6VlFbDWZx4Wddxkpea3xZ4uIUX9p+tKHGcyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7DCJ+MirO1LPKhcYJYa1S3gx0Qo0sc45dgNUfNZFRgh/JrpZ7OX8QRfnLgbnDO0L
	 q4DHKIbMpf/Bn5G8KW1K2YmH3Q01F90C0yd9otQ9DqO0MJmoBOIkfCeXLK938CGqKN
	 dWfZq0UjSFx20Vh7Z2JhwjrXVhyZ8P/PrvW93MUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/60] sched/core: Report correct state for TASK_IDLE | TASK_FREEZABLE
Date: Mon, 30 Dec 2024 16:42:57 +0100
Message-ID: <20241230154209.060113582@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 0d6b35283bcf1a379cf20066544af8e6a6b16b46 ]

task_state_index() ignores uninteresting state flags (such as
TASK_FREEZABLE) for most states, but for TASK_IDLE and TASK_RTLOCK_WAIT
it does not.

So if a task is waiting TASK_IDLE|TASK_FREEZABLE it gets incorrectly
reported as TASK_UNINTERRUPTIBLE or "D".  (it is planned for nfsd to
change to use this state).

Fix this by only testing the interesting bits and not the irrelevant
bits in __task_state_index()

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/169335025927.5133.4781141800413736103@noble.neil.brown.name
Stable-dep-of: f718faf3940e ("freezer, sched: Report frozen tasks as 'D' instead of 'R'")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0cac69902ec5..205a00806835 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1663,7 +1663,7 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
 
 	BUILD_BUG_ON_NOT_POWER_OF_2(TASK_REPORT_MAX);
 
-	if (tsk_state == TASK_IDLE)
+	if ((tsk_state & TASK_IDLE) == TASK_IDLE)
 		state = TASK_REPORT_IDLE;
 
 	/*
@@ -1671,7 +1671,7 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
 	 * to userspace, we can make this appear as if the task has gone through
 	 * a regular rt_mutex_lock() call.
 	 */
-	if (tsk_state == TASK_RTLOCK_WAIT)
+	if (tsk_state & TASK_RTLOCK_WAIT)
 		state = TASK_UNINTERRUPTIBLE;
 
 	return fls(state);
-- 
2.39.5



