Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09720269AF8;
	Tue,  8 Apr 2025 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115531; cv=none; b=HUkn0QyUpf0xNqyBBvJcRMsaWoYwmqVdFFgSv4F4kbzF7NLshh1zlC9makwTOqYMixq7MPONnard3vgT7b2lx9h19KZBplIWUFm0FU3zdOO0zljX3g8nKn6HBU5MgkhGh2iN/r6SMX/AOFmj2R6wRh/AlqeCzV2ptvBB9tdeJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115531; c=relaxed/simple;
	bh=lgWD/X6g+N6Bisvf4ZeaWhb/5vdUfy8KcP+qjmwiJg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2HkKoi/frbHAzg0pSw73PPS9uclf0d+XVzIOGfxcUns/LHVbr3HNJdPiqKp2sCpvwArr3CVUkW4pIHsuf4z69oOSBSrZB+pxnd3WR9KEhITlO9+T9JvH5H7MXSBznVmRb0ZJw9nUD+zCni7Vi67VfZLQbAs8oy2kNqz1Q1Qe/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPNUbrtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPNUbrtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679DAC4CEE5;
	Tue,  8 Apr 2025 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115530;
	bh=lgWD/X6g+N6Bisvf4ZeaWhb/5vdUfy8KcP+qjmwiJg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPNUbrtgGOljJqqS1mXEQdEwuf/tOVRktpsHGgksBK1GyxnWkzF5B5BOhKtGUdtU8
	 h+gX4KUvJDRebgJptwDdJnixw5lqP2fsHS10xigf+iUsKKHpEvXzZfbKwuYUUQSmoF
	 ft0wdOSuWv+olAzEYbAkm8V8v9H+sA79JTeXMRKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/204] lockdep/mm: Fix might_fault() lockdep check of current->mm->mmap_lock
Date: Tue,  8 Apr 2025 12:49:00 +0200
Message-ID: <20250408104820.605280663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd874df17b365..2e776ea38348a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5848,10 +5848,8 @@ void __might_fault(const char *file, int line)
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



