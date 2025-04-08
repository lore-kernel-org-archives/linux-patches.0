Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42969268C66;
	Tue,  8 Apr 2025 11:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113036; cv=none; b=L1j/91VfV7/meXWPoD//PsUTiNNcIhb3TZy3TkJ0udGkuZ9Qrjv9oRPZJveupFT+toBn5poojUVBte4W9hnsNdR4KPI9s0sha5eg583Px7i2C6G14IAyrINchXCypyoT/+91COlvPNzcnYS6YOl4RYl6jRPIL3Yk3KHhYvPqGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113036; c=relaxed/simple;
	bh=G/J3rCHE3LXa10/hv8YCUTq7XIlC5SpCtKZN4iUbSQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kptw3avTI2tQhisvPCQzP/7qG7ZFPjMfVDCi7uvPB7jks66SuJR/UIplaDarM3Wlhhba97NCf9BJN/+bFJmwiBOO0BkOZu04f42q+UmGjb9qvq5x3ZSSGe5eYo9AAHVQMOygaGHHIsy2VEspz9h0Npe8WyDHIOARAoQH2Kue2VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY0S2toD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY0S2toD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A73C4CEE5;
	Tue,  8 Apr 2025 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113036;
	bh=G/J3rCHE3LXa10/hv8YCUTq7XIlC5SpCtKZN4iUbSQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY0S2toDAEw2EXhJl7AAq0ILYGEpMz6t9mqYRO0HM4BhAUpzX9/eYZ+T95OzrXP9w
	 Gy+aHE/KOmmi9rfqsf7ZlqTWIqwqZP43OE6WkKSHx82crXA3LsH6KizttGSIoPJyXg
	 VOqaaA7AVisXLudxKN0NakXaoG2gizEtjJFrVLkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/268] lockdep/mm: Fix might_fault() lockdep check of current->mm->mmap_lock
Date: Tue,  8 Apr 2025 12:47:02 +0200
Message-ID: <20250408104828.814816979@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65f1865cb461e..c39a45481c443 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5945,10 +5945,8 @@ void __might_fault(const char *file, int line)
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



