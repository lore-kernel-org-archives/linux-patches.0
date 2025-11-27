Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3266F33345E;
	Thu, 27 Nov 2025 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255515; cv=none; b=bN+megBD8wyhx+JekIfb2OuuRZW13A1GeqkeH9lostnPLXSGbM+aJt1Q1TFvQK+9FyZq+PgnC+RAoPZkwv/D5g+roVw5TJJfh3YFIjS+oWZkjtCGvi3N3rQd8YdrunrPV9Bjro6czHtHJz6fHM3Xq/28JzQPQMnYw9U66xDM4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255515; c=relaxed/simple;
	bh=Fyp63ZkMQXVD6S6NaOX+XBUq++UzxZLAlggp7RGdJqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx6hYBwEq6RcTIZ2vXA4VFgGbpBPB00Abh+id+H347gZG4gFbGZ/68NE5ue4R9KjXBWWgf9NPATk9d5lzMBanb4NRg8HUWOdWk2EPf8q91qjfvFj42EoZibjd35oKeljZSjzvtC7IlNG52xkpLXdNRsGP4a6n01zGluypNouFLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRQj0aWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRQj0aWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD8C4CEF8;
	Thu, 27 Nov 2025 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255514;
	bh=Fyp63ZkMQXVD6S6NaOX+XBUq++UzxZLAlggp7RGdJqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRQj0aWefLc6zl14fC7EJhnr/4RRDfokvKTQRA5AMYGgOatnaqRVh3dV3D2CqVRpb
	 JpyMUVGw14Jo1iDHS5aq4yprpIfu5T8y96AtuSjXs0R/YjRZKTBO3mFQ1j6ZD6RSxE
	 +zjftetXhNV57fMpv1eyCliMypNNUqr7lXS3gqDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yipeng Zou <zouyipeng@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.17 002/175] timers: Fix NULL function pointer race in timer_shutdown_sync()
Date: Thu, 27 Nov 2025 15:44:15 +0100
Message-ID: <20251127144043.039059802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yipeng Zou <zouyipeng@huawei.com>

commit 20739af07383e6eb1ec59dcd70b72ebfa9ac362c upstream.

There is a race condition between timer_shutdown_sync() and timer
expiration that can lead to hitting a WARN_ON in expire_timers().

The issue occurs when timer_shutdown_sync() clears the timer function
to NULL while the timer is still running on another CPU. The race
scenario looks like this:

CPU0					CPU1
					<SOFTIRQ>
					lock_timer_base()
					expire_timers()
					base->running_timer = timer;
					unlock_timer_base()
					[call_timer_fn enter]
					mod_timer()
					...
timer_shutdown_sync()
lock_timer_base()
// For now, will not detach the timer but only clear its function to NULL
if (base->running_timer != timer)
	ret = detach_if_pending(timer, base, true);
if (shutdown)
	timer->function = NULL;
unlock_timer_base()
					[call_timer_fn exit]
					lock_timer_base()
					base->running_timer = NULL;
					unlock_timer_base()
					...
					// Now timer is pending while its function set to NULL.
					// next timer trigger
					<SOFTIRQ>
					expire_timers()
					WARN_ON_ONCE(!fn) // hit
					...
lock_timer_base()
// Now timer will detach
if (base->running_timer != timer)
	ret = detach_if_pending(timer, base, true);
if (shutdown)
	timer->function = NULL;
unlock_timer_base()

The problem is that timer_shutdown_sync() clears the timer function
regardless of whether the timer is currently running. This can leave a
pending timer with a NULL function pointer, which triggers the
WARN_ON_ONCE(!fn) check in expire_timers().

Fix this by only clearing the timer function when actually detaching the
timer. If the timer is running, leave the function pointer intact, which is
safe because the timer will be properly detached when it finishes running.

Fixes: 0cc04e80458a ("timers: Add shutdown mechanism to the internal functions")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251122093942.301559-1-zouyipeng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1458,10 +1458,11 @@ static int __try_to_del_timer_sync(struc
 
 	base = lock_timer_base(timer, &flags);
 
-	if (base->running_timer != timer)
+	if (base->running_timer != timer) {
 		ret = detach_if_pending(timer, base, true);
-	if (shutdown)
-		timer->function = NULL;
+		if (shutdown)
+			timer->function = NULL;
+	}
 
 	raw_spin_unlock_irqrestore(&base->lock, flags);
 


