Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76CB39150B;
	Sat, 12 Sep 2026 19:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243176; cv=none; b=uniLYYyVCLLKpZIajXxcFKHX2Ie/rxVtsJaNoerF+AKCziEmYyivkgbIFvhV3473m+QrjN2HbO8cHyFPDpvSiaNFGHu4zshTxl5lDTg0CrEvymS4agbncPpcgridqPKECYKfUDR9Xxjjtk9vYYSKV4s34F8HFlIqlt8rUp1Nhz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243176; c=relaxed/simple;
	bh=mLa9rsl+CldoTv3WAxu5oWF3tqv9jXgEJZBEgENs5ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfJ7ji4ZtLp19RZZI94o0z5mSzNPBFClHoUxV4pFhl58kv+AmrKtGnNcwDRV7toP6NYzaKYhuV4qNrg2hrMetmsJAzuo72B6SdHYTcoFZN7tXtfF8e3DXObOuZE+hv3gs9y1RkVCLTsRctG7e4M6DllnDlqZN3uXENwUk2GGT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxwqhAlN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxwqhAlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0861F000FF;
	Sat, 12 Sep 2026 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243174;
	bh=G9SrazvcD0mTwHtPJL+tB0VXBx1AVxWqsFlInKF3q2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxwqhAlNO8WSdqBSYHUfL/x5Au/6OUYeKA5s7ffBWUDt7BF16f7D8D3GRqlTMJeOq
	 /PBQoUtzf6b6tjDvvFmsh7k5sJ+Ut9g3JhjP2yl/65ccLJlW096NT6aE2P6KYFyVp/
	 heKgcuaTmXKxozUHVq7WbQWj6EnIwuKqCOwns47U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 664/798] m68k: Fix backtraces for non-running tasks
Date: Sat, 12 Sep 2026 09:04:52 +0200
Message-ID: <20260912065532.327071394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 09f71dbeb287e367beea56d9ac8a3d356ef5e02a ]

When no stack pointer is supplied, show_stack() starts at thread.esp0.
This is the saved userspace register frame, not where a task was switched
out. For kernel threads it points to the zeroed frame created by
copy_thread(), so sched_show_task() prints no useful backtrace.

Use thread.ksp for non-current tasks. It is saved by switch_to() and is
already used by __get_wchan(). For current, start at the current stack
frame, as is already done when no task is supplied.

Tested on qemu-system-m68k -M virt using SysRq-t. All task dumps contained
resolved frames.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://patch.msgid.link/20260723041055.47289-1-kmehltretter@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/traps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index f6706ef6b195e..245690ac613ef 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -941,8 +941,8 @@ void show_stack(struct task_struct *task, unsigned long *stack,
 	int i;
 
 	if (!stack) {
-		if (task)
-			stack = (unsigned long *)task->thread.esp0;
+		if (task && task != current)
+			stack = (unsigned long *)task->thread.ksp;
 		else
 			stack = (unsigned long *)&stack;
 	}
-- 
2.53.0



