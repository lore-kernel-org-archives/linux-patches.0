Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8912475F7;
	Thu, 16 Jul 2026 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209009; cv=none; b=AdDJiloHiToMijWD68OuvdQtQnVvobsZJLSeG/LY4qBNEAm56egvxf735TvOQuOPbMvtxqNYVyEyNAvyyJ2gCEqSx8c5NtJL2giRojQUoFgFann5klbMxbe9BeJlnqEN+yPLzMSaoEHOdkb62t/H9DO4gvdpFvCwY7RUksweI50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209009; c=relaxed/simple;
	bh=g4H5YZ7aWieY8haE5uFVQ7oY1kY/BBQDP51bsX0Ph3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIljizt/Xy2exoJVeAtlGaPMhMuOVBQ+JfD5g89f5QVQMNG7Z4sR29+IKoBAaF3xI9ZOdAQfzs8jEe33Ut6q1FQ4W+HPPcvrRDsrmufFjcy/jagaIyQ3OIqBPg81IcrvA/SVpMJUGQaT6K/fOPXYbvKklvUi6RYJS9KsZFD3lTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmuH7VZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmuH7VZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7620E1F000E9;
	Thu, 16 Jul 2026 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209008;
	bh=RfMMMV/0JsErtD7aomZ66IIY8zAdoOk+c37fuMLmtIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmuH7VZ0mEuQ6H+lny7JomTUAFB9pnQ1hyqFiBKgBCxU+G+cfOHH0ChNPJOHrim5g
	 q9HzY55+1ta+xel+B5/BaAltzQRBFx/VajZVDZW0Sh0WTgrCsuofKgxZCABl5AX8yd
	 Hb4V7+0QKQ4hfNnWwzuEZvUPe3PkC5vzA1FFdcAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 022/518] futex/requeue: Revert "Prevent NULL pointer dereference in remove_waiter() on self-deadlock""
Date: Thu, 16 Jul 2026 15:24:50 +0200
Message-ID: <20260716133048.262330070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 39def6d250d370298f86c116f4ac60093cefadaa upstream.

The commit cited below should not have been merged. It attemted to fix an
existing problem ansd thereby introduced new problems by keeping the
pi_state in state Q_REQUEUE_PI_IN_PROGRESS and leaking it.

Based on the commit description the intention was to handle the case
when task_blocks_on_rt_mutex() returns -EDEADLK and the following
remove_waiter() dereferences the NULL pointer in waiter->task.

That is already handled by Davidlohr in commit 40a25d59e85b3
("locking/rtmutex: Skip remove_waiter() when waiter is not enqueued") and
requires no further acting.

Revert the commit breaking the "waiter == owner" case again.

Fixes: 74e144274af39 ("futex/requeue: Prevent NULL pointer dereference in remove_waiter() on self-deadlock")
Reported-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260701131150.0Ijhq4Dw@linutronix.de
Closes: https://lore.kernel.org/all/20260629020049.2082397-1-michael.bommarito@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/requeue.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -643,12 +643,6 @@ retry_private:
 				continue;
 			}
 
-			/* Self-deadlock: non-top waiter already owns the PI futex. */
-			if (rt_mutex_owner(&pi_state->pi_mutex) == this->task) {
-				ret = -EDEADLK;
-				break;
-			}
-
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
 							this->task);


