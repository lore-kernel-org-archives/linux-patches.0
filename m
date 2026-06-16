Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA3B44DB64;
	Tue, 16 Jun 2026 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625799; cv=none; b=nWa7HABthA31FAlE8UfIBLZjDG4nO8AY9DWTKGpG63AmUJqvm8Pw/hF96wuWTvjyvxLQmQZlaCMpM9lPY+K0nVVS8uTzRzo8PfHHkp1Y7yfBgnkRumPXw9Q1FobeJvqghkKqHNXZq9AI8VuZDkHQnxd/kKFpCNXnFV7BLTxc6WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625799; c=relaxed/simple;
	bh=zPrrq9nJOw3ISDPb60G7DSv29ASn9AbJgfMVH+Oy4J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8jQvnnqCA+gGTmOPizsvWrsfDPn6l2tTY5Uvslo2DbtvTtmt2Dnc/NfRTeBAV57GxKIa4XsX10e//hCi6sPbTFIdj4NY37frKxo5WUb+PbBCoyALGU/FVReqvOWpPpdLrHvEXJh7q7OKP6cFdSqQCk6Rp+EoR3CNJK38JADuos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9s1+Oib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9s1+Oib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907911F000E9;
	Tue, 16 Jun 2026 16:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625798;
	bh=ROF2QF1GLblR2aWrowt4NA8HbJEh0Vxz++bgBnzxLk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9s1+Oibe/GT78MlO/TVXiAXeMPEAdFt7yaqc+3K70BD8bQz16N94Q32I88Bfsohu
	 2gyZ5olM5tIHI+IjyUSM3PDaAnL85FLb0qjemntwcK6U1azyM+581PmUTW/usDDnHE
	 k5nRHTnTjKyLhtQ4bHpQt1llpW8giAFVjPWBqJQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Kariv <alonka@amazon.com>,
	Amit Matityahu <amitmat@amazon.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 208/325] timers/migration: Fix livelock in tmigr_handle_remote_up()
Date: Tue, 16 Jun 2026 20:30:04 +0530
Message-ID: <20260616145108.426066986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -946,8 +946,12 @@ static void tmigr_handle_remote_cpu(unsi
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


