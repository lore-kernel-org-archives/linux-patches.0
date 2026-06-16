Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857CB3CBE8B;
	Tue, 16 Jun 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623944; cv=none; b=cI88aQnME2h/ZEcDzv3crsr4Gonl/Ht+KsegLuFKuWdOdgbmA+YgxZICxLfUfB8U01OV8ALjgc5p152LxqVCaVmjCBvKywFBI+EKR80tC/dvBDshmJfHhFv9BeuRk9OtYe3oTTqozmmSd8JtE50y6XaJ78WqaOo+ivQCpzBHqww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623944; c=relaxed/simple;
	bh=1dn7goatkd57Q7ZNlvyw43OT2VjFSJnYo0IyExMbxIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJn2A28PEf8FkJK3mewpCJBs8WUgFDKO7Up2NCB7eRQj6LInX041wCwA4qWW7QiuDKnCMVTJTvTgOZHkKSIJTU4sf6ZOgfpxm8Q3XCjdHhIA8iTsQAx63vd75RnNLz/QDnYQvGMcwjfvJhE8xB4L5A6UQoDHwvNxDBapcGUTMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7ipg/E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7ipg/E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802961F000E9;
	Tue, 16 Jun 2026 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623943;
	bh=9Y5Ia5sOuSgd+ReKcdOP3PhJKfSRSdikqAmz/VAptEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7ipg/E3AzqQVtReETUyNRjbTmZr6qZJ3bGGtns9FclRGfcHNmG3dy8vt+BJmGz7h
	 kronimTcs2tjKCDHh+z9ZkpuNOGVlbKphZqo7tT+skWbeEadc2mnrRgQaz6uT3OPwX
	 jWWk8+KbEAslKGWkrZvwPiJ5GcR+2N3S4kTHVa6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Kariv <alonka@amazon.com>,
	Amit Matityahu <amitmat@amazon.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.0 245/378] timers/migration: Fix livelock in tmigr_handle_remote_up()
Date: Tue, 16 Jun 2026 20:27:56 +0530
Message-ID: <20260616145123.089070104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Matityahu <amitmat@amazon.com>

commit d486b4934a8e504376b85cdb3766f306d57aff5b upstream.

tmigr_handle_remote_cpu() skips timer_expire_remote() when cpu ==
smp_processor_id(), assuming the local softirq path already handled this
CPU's timers.

This assumption is wrong because jiffies can advance after the handling of
the CPU's global timers in run_timer_base(BASE_GLOBAL) and before
tmigr_handle_remote() evaluates the expiry times.

As a consequence a timer which expires after the CPU local timer wheel
advanced and becomes expired in the remote handling is ignored and the
callback is never invoked and removed from the timer wheel.

What's worse is that fetch_next_timer_interrupt_remote() keeps reporting it
as expired, and the event is re-queued with expires == now on each
iteration.  The goto-again loop spins indefinitely.

Fix this by calling timer_expire_remote() unconditionally. That's minimal
overhead for the common case as __run_timer_base() returns immediately if
there is nothing to expire in the local wheel.

[ tglx: Amend change log and add a comment ]

Fixes: 7ee988770326 ("timers: Implement the hierarchical pull model")
Reported-by: Alon Kariv <alonka@amazon.com>
Signed-off-by: Amit Matityahu <amitmat@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260603170139.33628-1-amitmat@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer_migration.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -978,8 +978,12 @@ static void tmigr_handle_remote_cpu(unsi
 	/* Drop the lock to allow the remote CPU to exit idle */
 	raw_spin_unlock_irq(&tmc->lock);
 
-	if (cpu != smp_processor_id())
-		timer_expire_remote(cpu);
+	/*
+	 * This can't exclude the local CPU because jiffies might have advanced
+	 * after the timer softirq invoked run_timer_base(BASE_GLOBAL) and the
+	 * point where the jiffies snapshot @jif was taken in tmigr_handle_remote().
+	 */
+	timer_expire_remote(cpu);
 
 	/*
 	 * Lock ordering needs to be preserved - timer_base locks before tmigr


