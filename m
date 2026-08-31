Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158BD51E43C;
	Mon, 31 Aug 2026 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183829; cv=none; b=EIqn/FuTN58z1twtspIn/hdQLQ1LRTLZO6qfEnwOm7CTNIgrrNzY6w0tp3NzeVOqWA5O7wIxh5kBIHe8WEvGgsoJ9mdvVlOyMlPAyJ2pDWXtwvJ7rU5lMlpLzTIVyW1OAS5UqWQ6Nyu1CQkS7lH3ZT3d/QVO5UaysHCEaK0XZzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183829; c=relaxed/simple;
	bh=0YB707UxztxsX/xkAzuDdGmYNJHFkL2UvxORduJb4Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoH1jTeZkexnKpKEVbJxbhXp8HfLAv+yUnb3IvnArJHjiSZlP8kgi/1AxRB5GR8Q++tERnaBkDsHoOjPqbSM5n+S/JFtR//6pDCuXTrlGOrsJIQByE8hkBgmozn9IajdxoQR5gbZ9BU+9p+eOkCH2tVfMlYB9MO8lckPz7BAufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whPp72XO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whPp72XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6244A1F00ADB;
	Mon, 31 Aug 2026 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183827;
	bh=Car5vW+6pLAj9Er86RnIfM+CPFztrLXhnb9DT2b/DYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whPp72XOYIFe7JcOlBksw3fijHN3TZP2aE+FKC1J+/xAdfmRc0mtRvw5kQahcgioc
	 5pYRjNuTWx7vKxX+Rdr0TtYal0X0I6QHjycK70kOqA0k+sNslDdz6M70awqBgl6chQ
	 uMRCSCTP2DVNUIA9aM4UwfY4duWMLK0K0Ixt4P3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.1 55/76] kunit: irq: Continue increasing hrtimer interval for longer
Date: Mon, 31 Aug 2026 15:34:27 +0200
Message-ID: <20260831133402.279591337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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


