Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B842918C6;
	Wed, 23 Apr 2025 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420777; cv=none; b=PO2yMYuZBWv1K8Wy+FuK2erYLxDM32JgNR520pOGgwK1qapuLzDL9aZ8DwwAES8rRJDa26CEffaEeRpOwpUuWp4ueBudLARDRCFN0fwT0jfVeVqoXIFAYuyitrcjaK/hpwq/iY97MxbNVsDFHREOTxZ1Pb49S57bPuHfziFAs8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420777; c=relaxed/simple;
	bh=3J36967YIlkAq9gZJdd2bhTBZbAWBgCEo5HifbdAPDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMT9v3AdV1KzbwklWCxSWWw/ISG5dk4nXiNZgmI3giaAuj8QGxy0amus13NlgixyIX7Mh0XDEJcvAs8RVEYEwMoo3444gZh4eHvQfBUeFjgAkSx8oM2FnmEmpI+q9OEMeH7es2bxzANFVauJ/0DePxlMFDjDTFk9I7Mhe+SYN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4hZLMzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4hZLMzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43155C4CEF8;
	Wed, 23 Apr 2025 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420777;
	bh=3J36967YIlkAq9gZJdd2bhTBZbAWBgCEo5HifbdAPDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4hZLMzMbJU8TgARRm6Ow48Zy6JE1WUBMut3jXT6FlZn5NjZjKW1+tNJtlpUMQya9
	 qdjgZsCGqkxxlsxk/1DwMzTFI50e9KTA5ItouXJtvQviB2N8bqI1Pwr4aIRsPK2/6x
	 saycueI0BwTEjWXyb4GuHm0FEON45hjdjR+ZE0sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 121/241] eventpoll: Set epoll timeout if its in the future
Date: Wed, 23 Apr 2025 16:43:05 +0200
Message-ID: <20250423142625.524368814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 0a65bc27bd645894175c059397b4916e31955fb2 ]

Avoid an edge case where epoll_wait arms a timer and calls schedule()
even if the timer will expire immediately.

For example: if the user has specified an epoll busy poll usecs which is
equal or larger than the epoll_wait/epoll_pwait2 timeout, it is
unnecessary to call schedule_hrtimeout_range; the busy poll usecs have
consumed the entire timeout duration so it is unnecessary to induce
scheduling latency by calling schedule() (via schedule_hrtimeout_range).

This can be measured using a simple bpftrace script:

tracepoint:sched:sched_switch
/ args->prev_pid == $1 /
{
  print(kstack());
  print(ustack());
}

Before this patch is applied:

  Testing an epoll_wait app with busy poll usecs set to 1000, and
  epoll_wait timeout set to 1ms using the script above shows:

     __traceiter_sched_switch+69
     __schedule+1495
     schedule+32
     schedule_hrtimeout_range+159
     do_epoll_wait+1424
     __x64_sys_epoll_wait+97
     do_syscall_64+95
     entry_SYSCALL_64_after_hwframe+118

     epoll_wait+82

  Which is unexpected; the busy poll usecs should have consumed the
  entire timeout and there should be no reason to arm a timer.

After this patch is applied: the same test scenario does not generate a
call to schedule() in the above edge case. If the busy poll usecs are
reduced (for example usecs: 100, epoll_wait timeout 1ms) the timer is
armed as expected.

Fixes: bf3b9f6372c4 ("epoll: Add busy poll support to epoll with socket fds.")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Link: https://lore.kernel.org/20250416185826.26375-1-jdamato@fastly.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 67d1808fda0e5..c01234bbac498 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1996,6 +1996,14 @@ static int ep_try_send_events(struct eventpoll *ep,
 	return res;
 }
 
+static int ep_schedule_timeout(ktime_t *to)
+{
+	if (to)
+		return ktime_after(*to, ktime_get());
+	else
+		return 1;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -2103,7 +2111,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 		write_unlock_irq(&ep->lock);
 
-		if (!eavail)
+		if (!eavail && ep_schedule_timeout(to))
 			timed_out = !schedule_hrtimeout_range(to, slack,
 							      HRTIMER_MODE_ABS);
 		__set_current_state(TASK_RUNNING);
-- 
2.39.5



