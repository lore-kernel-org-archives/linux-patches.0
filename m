Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12536367B9F;
	Thu, 20 Aug 2026 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238681; cv=none; b=Gnm/Qu0BqTtI86U+CbYXQw7vzbhptLVdT0F2I5+IpIIENv3fVv+GUzqnLYpY0MjP7VlQUEjhh6ERfANcbCJDjqtcL/U7Fn+VOCubjn4+cWlE+CrfSnEKGncUsTirn+jeX3hdK2qdIigGMPrx3RmwtiFU2O/qG1fJBGu4zEy0na0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238681; c=relaxed/simple;
	bh=Klqit2bJsePazrVh0LqWXTpvMGWjPGwNpmKb8mZKnWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foBoNfYMUTLcXhJ9rdX+Jtu4qAC1miXlWnI3JAdMemzUwaBX4OIIF8Gd2cjNS/qbFnZYx2B69pLGDK4rPrAGwOW0sVvsPulHL0E60fk0+2+lypXIhFDSfTnlpBW952FDDaOwZKQcbaI/2VtS810a8jThLYWabbbqkeDHNqZ4Glg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z13ayB+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z13ayB+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB591F00A3A;
	Thu, 20 Aug 2026 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238680;
	bh=uOpgvvzTno965EXD0OnQ2918wQq2Ts2O9qN8GSmdAC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z13ayB+g2pmR6hw6d0KU9riGwiVOp9BPWKt/0cFqZnC7+agd1ORTSv8dGxpG9Ka22
	 ujVtob9wBIWE60f3ezDl/S94+LLMhyYeynSc88JcgKHlhNJd1QrnJoPRwB4bJFA+Sv
	 lWKqWIBxMQ2j73F1FwXg16fT3WGfnMAMHBRHINbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels Pressel <npressel@ethz.ch>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 183/228] rseq: Prevent hard lockup on granted time slice extension
Date: Thu, 20 Aug 2026 16:55:25 +0200
Message-ID: <20260820145250.252186545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Niels Pressel <npressel@ethz.ch>

[ Upstream commit ada54c2ba652348c590d1ace6a2f4ff77cbbf809 ]

__exit_to_user_mode_loop() invokes rseq_grant_timeslice_extension() with
interrupts enabled. If the extension is granted it invokes
hrtimer_rearm_deferred_tif() to ensure that a pending deferred hrtimer
rearm is handled before exiting to user space.

Though this invokes __hrtimer_rearm_deferred() which expects to be invoked
with interrupts disabled as it takes hrtimer_cpu_base::lock with
raw_spin_lock(). That's a livelock waiting to happen and caught by lockdep:

    WARNING: ./include/linux/hrtimer_rearm.h:17 at irqentry_exit, CPU#1: slice_test
    WARNING: inconsistent lock state
    inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.

Prevent this by disabling interrupts around the invocation of
hrtimer_rearm_deferred_tif() in rseq_grant_timeslice_extension().

[ tglx: Massaged change log ]

Fixes: 15dd3a948855 ("hrtimer: Push reprogramming timers into the interrupt return path")
Signed-off-by: Niels Pressel <npressel@ethz.ch>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260802124423.51616-1-npressel@ethz.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rseq_entry.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/rseq_entry.h b/include/linux/rseq_entry.h
index ed9da6e41a2aa..31ce349ed42ce 100644
--- a/include/linux/rseq_entry.h
+++ b/include/linux/rseq_entry.h
@@ -233,6 +233,7 @@ static __always_inline bool __rseq_grant_slice_extension(bool work_pending)
 static __always_inline bool rseq_grant_slice_extension(unsigned long ti_work, unsigned long mask)
 {
 	if (unlikely(__rseq_grant_slice_extension(ti_work & mask))) {
+		guard(irq)();
 		hrtimer_rearm_deferred_tif(ti_work);
 		return true;
 	}
-- 
2.53.0



