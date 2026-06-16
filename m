Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30164534B9;
	Tue, 16 Jun 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627379; cv=none; b=FbV4fH1i/5Stge/Tf6bRtoqIDpbuljESjqlo6j0PyFKCrrceMGGKO/CJ90fId17ziv+LJEN5iXYx6xUhUMkR5o45aG89f+MNO/OQjh0hTOFoaNH3s1mJw/5ituhn4q8ggbvwZMtAXUJOpfGpD+s/b3ZkSzBeDo4yfiAxazVBo7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627379; c=relaxed/simple;
	bh=zwBuQHcn9Xe6FfiDAIduVlOuDIE7hKjJqZ/cXCPkSDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz3Dbys8BQlnao7Zmbg6Fs9xAMXkyhkGxbjTRoLvpj1bM/pfZS/Y5LaTGstqOkjRpwvoVGYvZbUWAK0nqfaLVUzBzgcdIy6lD4Cu8I68WW8KpZTiKc9WRirx+tl6p9ARmvR7Aj5XOdB6qAu6xpJzn5fe/gLLL0VbWmQwaYX90CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAl6VybA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAl6VybA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9292D1F000E9;
	Tue, 16 Jun 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627378;
	bh=NwOlaPCrHiipU6YoHpRAB1p/5bKT/qoDuTotWpwcDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAl6VybAmvUybl0/J06gQRoXsDvCQfvzoa+DF/PUE+zSq5jDKbpuGd9hVMJeBEU5Z
	 7SlGKHFRqIHTQFf93Vv2Xt5ObuZZ1Hk9qYsvGwyCgE8cwFDLgDfxwG1ayhsff5vzXf
	 OAFZnWHQ+wVjBBkwVaxFUqgdHmaKppN4PEuwnMk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Kariv <alonka@amazon.com>,
	Amit Matityahu <amitmat@amazon.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 164/261] timers/migration: Fix livelock in tmigr_handle_remote_up()
Date: Tue, 16 Jun 2026 20:30:02 +0530
Message-ID: <20260616145052.672081984@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -931,8 +931,12 @@ static void tmigr_handle_remote_cpu(unsi
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


