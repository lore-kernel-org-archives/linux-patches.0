Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E023D26B08C;
	Tue,  8 Apr 2025 12:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114197; cv=none; b=KAHQl2teO0RIui0Cw/+438T0ylIDSczdeUGSGyT1gxViQbiGzKPwFd0jJ6vhCJh1A2yvKT6Cb93ZGIryPxgGtINUA6npvqjYbJtfzTRvuizEqFxDhZpyCUejHSO8KBo/eTPEZweP+aLKWa4Kjj/tU5uhaU2XEAt5iB+Jd3Q8EDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114197; c=relaxed/simple;
	bh=9jHgB7muoX2CsyB3tuSuvt1UJQIzyFRvo+zQ4CtdIT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZtlzEA5qB/36JRR6w5Ljk7A2jeZG9i3feO6fllCA9NIXLBwa9E0rI+ndnUrzS/Q7NhlhU20kn0j6cwB2okK5PVEb0gu3RudCkrCgaq6zHBdo1GzrZPYju4dZ4jQ5n5fy47tdUQJG/hEibN9FoMkkFxWsCjH1S+XaYp2SyVE1QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzSH8GQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzSH8GQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5F0C4CEEA;
	Tue,  8 Apr 2025 12:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114196;
	bh=9jHgB7muoX2CsyB3tuSuvt1UJQIzyFRvo+zQ4CtdIT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzSH8GQ6GRJ9YFBeEq/SSTdUmxvDS64j4ILH4EIr4YbZ0I+Wz8gb/EblW+FBYfJ7z
	 Ew6O66DzppSxnSwYDUSCuUCdPuM/h0TFNf+460uYYCqsdJTUtaOg6HSupp2zRuR+Mh
	 5TxoIHRqsH+xUaxxDJtG48KaMVf6YVg3HSg6icqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 018/499] lockdep/mm: Fix might_fault() lockdep check of current->mm->mmap_lock
Date: Tue,  8 Apr 2025 12:43:50 +0200
Message-ID: <20250408104851.707331956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit a1b65f3f7c6f7f0a08a7dba8be458c6415236487 ]

Turns out that this commit, about 10 years ago:

  9ec23531fd48 ("sched/preempt, mm/fault: Trigger might_sleep() in might_fault() with disabled pagefaults")

... accidentally (and unnessecarily) put the lockdep part of
__might_fault() under CONFIG_DEBUG_ATOMIC_SLEEP=y.

This is potentially notable because large distributions such as
Ubuntu are running with !CONFIG_DEBUG_ATOMIC_SLEEP.

Restore the debug check.

[ mingo: Update changelog. ]

Fixes: 9ec23531fd48 ("sched/preempt, mm/fault: Trigger might_sleep() in might_fault() with disabled pagefaults")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/20241104135517.536628371@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b6015e2308222..5fdfdbc65e58d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6753,10 +6753,8 @@ void __might_fault(const char *file, int line)
 	if (pagefault_disabled())
 		return;
 	__might_sleep(file, line);
-#if defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 	if (current->mm)
 		might_lock_read(&current->mm->mmap_lock);
-#endif
 }
 EXPORT_SYMBOL(__might_fault);
 #endif
-- 
2.39.5



