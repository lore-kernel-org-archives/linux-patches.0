Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9768554769;
	Wed,  4 Jun 2025 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998397; cv=none; b=i9kXla6TnIgB7kbu9QrcWdrd6sowSrRBgMuJ8LEPjeiKoYqaM828NYTERplHe8niZ1fIGalxv9Omhl1NGLC2pPRlXKDPsoWq27TfT0ID/gIaVp7rKcqqu0cbus+yjX/TnOlQmPuqvRj6GsLm7yL8a7WaLZ/bKMw+9X7ufVKUF7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998397; c=relaxed/simple;
	bh=axkEuClrDEyDL+B3BjOzjzBjrVkp3Y8nU8mEnJirXmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+ShlDs6JOq/QdYUF/O000O5PWxt+QY7AsC6+n1TIUFn/j8XN5mpQiRYsLLR29mLB/SEvCBaYxQok8i6tYxAEP/bU+eIMAX2q0C9h54X13qwMTh3XLs/fJc89STYqMRGfWs5PU+YzZMpBv6xc5h4UjJ/ShYN4SOPPpcWbGYS8ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+fl/g+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+fl/g+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CC0C4CEEF;
	Wed,  4 Jun 2025 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998397;
	bh=axkEuClrDEyDL+B3BjOzjzBjrVkp3Y8nU8mEnJirXmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+fl/g+OwSiSnp3HUOdQmPRFDVurc3lxZIu5yZIIuijqWWRJNdJaE7SJbuvMToNNO
	 n5Xdst1dAwZv52ZoLkiYhHcxRGwrvbZDzgzg24E21hTEnO/qf2mP7nHrVvzqlNBjH5
	 qfOg2pnCp6FubLzEZ6sgO84KL0jXwRNBqiGlLHVOUVpNrLObpClmpyREhSb6df7scQ
	 3tN79Hd6bBP5PmLQecRMIPJLcGPvOTaR307V7dgnaPRVnBoL6J47JlLQ9SjIFbUvwu
	 dGU7dunyAYTZT8g/1cmML/y+kv0vDOtmLWmwXQh6RnNxtxjwIPaAmnToqPP6vmylR9
	 yqGy4PFExUuBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Corey Minyard <corey@minyard.net>,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.15 063/118] ipmi:ssif: Fix a shutdown race
Date: Tue,  3 Jun 2025 20:49:54 -0400
Message-Id: <20250604005049.4147522-63-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Corey Minyard <corey@minyard.net>

[ Upstream commit 6bd0eb6d759b9a22c5509ea04e19c2e8407ba418 ]

It was possible for the SSIF thread to stop and quit before the
kthread_stop() call because ssif->stopping was set before the
stop.  So only exit the SSIF thread is kthread_should_stop()
returns true.

There is no need to wake the thread, as the wait will be interrupted
by kthread_stop().

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the current kernel code, here's
my assessment: **YES** This commit should be backported to stable kernel
trees. ## Detailed Analysis: ### Nature of the Bug Fix: The commit fixes
a **race condition during shutdown** in the IPMI SSIF driver. This is a
critical synchronization bug that can lead to system instability during
driver cleanup. ### Specific Race Condition: Looking at the code
changes, the race occurs between: 1. **Thread termination logic**: In
`ipmi_ssif_thread()` at line 484, there was a check for
`ssif_info->stopping` that would break out of the thread loop 2.
**Shutdown sequence**: In `shutdown_ssif()` at line 1270,
`ssif_info->stopping` is set to `true`, followed by
`complete(&ssif_info->wake_thread)` and then `kthread_stop()` ### The
Race Window: The problematic sequence was: 1. `shutdown_ssif()` sets
`ssif_info->stopping = true` (line 1270) 2. `shutdown_ssif()` calls
`complete(&ssif_info->wake_thread)` (line 1274) 3. The thread wakes up,
sees `stopping = true`, and exits the loop (line 484-485) 4. The thread
function returns and the thread terminates 5. `shutdown_ssif()` calls
`kthread_stop()` (line 1275) on an already-dead thread ### The Fix: The
commit removes the `ssif_info->stopping` check from the thread loop
(lines 484-485 removed) and the unnecessary
`complete(&ssif_info->wake_thread)` call from shutdown (line 1274
removed). Now: 1. The thread **only** exits when `kthread_should_stop()`
returns true (line 478) 2. `kthread_stop()` will properly signal the
thread to stop and wait for it 3. The
`wait_for_completion_interruptible()` call will be interrupted by
`kthread_stop()` ### Why This Should Be Backported: 1. **Critical Bug**:
Race conditions during shutdown can lead to kernel crashes, memory
corruption, or system hangs during reboot/module unload 2. **Minimal
Risk**: The changes are very small and surgical: - Removes 2 lines from
thread logic - Removes 1 line from shutdown logic - No new functionality
introduced - No architectural changes 3. **Follows Stable Tree
Criteria**: - Important bugfix (race condition) - Small, contained
change - Low regression risk - Affects critical kernel subsystem (IPMI)
4. **Similar Pattern**: Looking at the historical commits, commit #4
("Remove rtc_us_timer") and commit #5 ("Rename idle state and check")
both had `Cc: stable@vger.kernel.org` tags and were marked as
backportable, showing this maintainer's pattern of marking important
SSIF fixes for stable backporting 5. **Production Impact**: IPMI is
commonly used in server environments where system stability during
shutdown/reboot is critical 6. **Clean Fix**: The fix aligns with proper
kernel thread management practices - relying on the standard
`kthread_should_stop()` mechanism rather than custom stopping flags The
commit addresses a real concurrency bug with a clean, minimal fix that
follows kernel best practices for thread management. The risk of
regression is extremely low while the benefit of preventing shutdown
races is significant.

 drivers/char/ipmi/ipmi_ssif.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 0b45b07dec22c..5bf038e620c75 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -481,8 +481,6 @@ static int ipmi_ssif_thread(void *data)
 		/* Wait for something to do */
 		result = wait_for_completion_interruptible(
 						&ssif_info->wake_thread);
-		if (ssif_info->stopping)
-			break;
 		if (result == -ERESTARTSYS)
 			continue;
 		init_completion(&ssif_info->wake_thread);
@@ -1270,10 +1268,8 @@ static void shutdown_ssif(void *send_info)
 	ssif_info->stopping = true;
 	timer_delete_sync(&ssif_info->watch_timer);
 	timer_delete_sync(&ssif_info->retry_timer);
-	if (ssif_info->thread) {
-		complete(&ssif_info->wake_thread);
+	if (ssif_info->thread)
 		kthread_stop(ssif_info->thread);
-	}
 }
 
 static void ssif_remove(struct i2c_client *client)
-- 
2.39.5

