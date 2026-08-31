Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A255F983;
	Mon, 31 Aug 2026 13:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184078; cv=none; b=fAw3am6+nkR1VrrYorIvEHi4PcFPjzFrZN9FAcp1rNX29scFfUV4bYprAUuCp1c73ZlrPMnSmlflP6ay9nEfZ7SdSSAp0OqiAgtL4C0fW+5fGHysxtyyclk3kdG/hmVvz9QeMXW4SCa7aQ+yPhzlaoRtveLkXVaVqMixhQkHiDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184078; c=relaxed/simple;
	bh=OtFGvhaj5CcsfmkSqF3suFDrpVxBZolIhAVTQ+h2mlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVd82E3BrXbPNunpKYXc1gU+rLn1yoqSiTB/m8MNLAq7bfwUGbl2wnJKFjjayrE5tU7JHsXUakLA/zAxWd4X5XgPnmH2V1bEK5/ENHVio7M3XYyQUdB7cwyVJXlm9mCKOW2dBRT9FsOyH8CSWFHzOGy4GDQg05wx8EYK4g6YKaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRABw7np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRABw7np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BD61F00A3F;
	Mon, 31 Aug 2026 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184076;
	bh=x2lZK2Cfk+Yu4IZXUJK9LWW5wWGa1yurwWaSdaxom9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRABw7np6rXVe0MXRt1DQUnDsICJ/jvnuanGoh4L8mV1sy0w1/mzkmfq/meMvrx9v
	 F1QgMBzEKrdSPeycG4L60P5vcHKt7WQqwfy4U6WVcPCmjuWzekjpev/y7YtB1qoSgL
	 naAGHxI8yCNttnLZwDsZk29nq6adv2Ss7YA4kDYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 64/83] kunit: irq: Continue increasing hrtimer interval for longer
Date: Mon, 31 Aug 2026 15:34:40 +0200
Message-ID: <20260831133402.771782573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit faa6c4c4e4ac69926564688a926105621295d613 upstream.

Currently, kunit_irq_test_timer_func() stops increasing the hrtimer
interval as soon as some forward progress is made in each of softirq and
task context.  Update it to use a more aggressive strategy: increase the
interval as long as the hrtimer is running significantly faster than
either context.

This resolves an occasional hang in the CRC and crypto library tests
under qemu-system-s390x.  It was exposed by the change in the default
preemption model on s390 from NONE to LAZY.  That seems to have exposed
the issue by allowing some forward progress to be made while the actual
system timer tick is still starved, preventing jiffies from increasing
or the task context from making much progress towards max_iterations.

Fixes: 201ceb94aa1d ("kunit: irq: Ensure timer doesn't fire too frequently")
Cc: stable@vger.kernel.org
Reviewed-by: David Gow <david@davidgow.net>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20260803181842.44648-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/kunit/run-in-irq-context.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/include/kunit/run-in-irq-context.h
+++ b/include/kunit/run-in-irq-context.h
@@ -38,11 +38,13 @@ static enum hrtimer_restart kunit_irq_te
 	softirq_calls = atomic_read(&state->softirq_func_calls);
 
 	/*
-	 * If the timer is firing too often for the softirq or task to ever have
-	 * a chance to run, increase the timer interval.  This is needed on very
-	 * slow systems.
+	 * If the hrtimer is running much faster than the bh_work or the task,
+	 * then it is firing too fast and might be starving those contexts as
+	 * well as the actual system timer tick.  Increase the interval.
 	 */
-	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
+	if (hardirq_calls >= 20 &&
+	    (hardirq_calls / 2 > softirq_calls ||
+	     hardirq_calls / 2 > task_calls))
 		state->interval = ktime_add_ns(state->interval, 250);
 
 	if (!state->func(state->test_specific_state))


