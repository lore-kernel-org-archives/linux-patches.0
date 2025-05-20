Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6855127B517;
	Tue, 20 May 2025 14:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750616; cv=none; b=KNrA82Frzf3TJOVoQ+B0CbcLW6T09Y9KGKE9xNGcDN0gAwGXU2f4RqVeJ+PnNo9jS7Rtr6zhAsYGqLhp0Ahh+GbQ/HK1mNFmyKpC2nwCKMeEKma4zYisyUL4nXdCr3Qk0ucgG04Ujz/mGgTSBbPlg0EsJXuW8zCVBYCrnRnRg3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750616; c=relaxed/simple;
	bh=1jo7NQuKJFTM/O1aQvw592jRPVnk3N1vfeSEgQz+nWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StLuY2iMVIMILHC2O9ioeeCaZRtYiIEOEAuuMVX6+FcGq8OY1T7kBIuKkn0rhI3pWiB7WLMuFpe6dEmqTfELZnLg24zcaqvuPuO/x2jFzo0uEZeOONy2+P4q/qRAlSDRRS6rnOQwkssS8T0nQUwSCGOeLJ6wzWIXXiz2wTM6WR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgw7EJoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgw7EJoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5636AC4CEEF;
	Tue, 20 May 2025 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750615;
	bh=1jo7NQuKJFTM/O1aQvw592jRPVnk3N1vfeSEgQz+nWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgw7EJoKvcECWj/qjHe4r4dyuwhgVvjxdmJPRPcvnFQVAVS4eFNxeEzhuBidEzXNQ
	 r3HujEhT5fbkn4vkOQZYa0xbJ/N7nG58Eklh0uEts4X5B2oDncC9KnR3d1Yivuw2BF
	 drl1eDTzQsPXo9GMOqYC4GJ3BwjZKtNLZx8jxZSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.14 066/145] fs/eventpoll: fix endless busy loop after timeout has expired
Date: Tue, 20 May 2025 15:50:36 +0200
Message-ID: <20250520125813.166667247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

commit d9ec73301099ec5975505e1c3effbe768bab9490 upstream.

After commit 0a65bc27bd64 ("eventpoll: Set epoll timeout if it's in
the future"), the following program would immediately enter a busy
loop in the kernel:

```
int main() {
  int e = epoll_create1(0);
  struct epoll_event event = {.events = EPOLLIN};
  epoll_ctl(e, EPOLL_CTL_ADD, 0, &event);
  const struct timespec timeout = {.tv_nsec = 1};
  epoll_pwait2(e, &event, 1, &timeout, 0);
}
```

This happens because the given (non-zero) timeout of 1 nanosecond
usually expires before ep_poll() is entered and then
ep_schedule_timeout() returns false, but `timed_out` is never set
because the code line that sets it is skipped.  This quickly turns
into a soft lockup, RCU stalls and deadlocks, inflicting severe
headaches to the whole system.

When the timeout has expired, we don't need to schedule a hrtimer, but
we should set the `timed_out` variable.  Therefore, I suggest moving
the ep_schedule_timeout() check into the `timed_out` expression
instead of skipping it.

brauner: Note that there was an earlier fix by Joe Damato in response to
my bug report in [1].

Fixes: 0a65bc27bd64 ("eventpoll: Set epoll timeout if it's in the future")
Cc: Joe Damato <jdamato@fastly.com>
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250429153419.94723-1-jdamato@fastly.com [1]
Link: https://lore.kernel.org/20250429185827.3564438-1-max.kellermann@ionos.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2111,9 +2111,10 @@ static int ep_poll(struct eventpoll *ep,
 
 		write_unlock_irq(&ep->lock);
 
-		if (!eavail && ep_schedule_timeout(to))
-			timed_out = !schedule_hrtimeout_range(to, slack,
-							      HRTIMER_MODE_ABS);
+		if (!eavail)
+			timed_out = !ep_schedule_timeout(to) ||
+				!schedule_hrtimeout_range(to, slack,
+							  HRTIMER_MODE_ABS);
 		__set_current_state(TASK_RUNNING);
 
 		/*


