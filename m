Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF54834752E;
	Sat, 12 Sep 2026 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210647; cv=none; b=NmnF2iKkIGR+RVYYOm+8E5ZaL01+Jm3k3N9XE0INTkZg5gotjmyYY22sfkM6fCJpVI2M4kDsENTI54Rd6SeY+p12+qPqWCQudlRX7U1+7qQbjxsTFN4BKTQiSQ3rGm40pi3giWXV7rZQXUhHOwheWLaHP7gIKfXzqFEX4yBP0Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210647; c=relaxed/simple;
	bh=2m571Zjj4rDSBh/lGEGs0emOkcWV6HVCuai31bS9gBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOf9WqFWpTn/rK8r1tEKJCRyo8IM/EpyqTGXJG8wx9XX6RzVYgVL/pW9wz29otmkjW5t35nqaddHEmYhqf0tMFxnL8t9dm7lLs38+NtERhF+CriamQXhsFLcpXOkI91bZbeQmIKn2qvkVUd1qqumGBJspgOmPWB8PSCYnUvmBbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9jp3fFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9jp3fFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B336D1F000FF;
	Sat, 12 Sep 2026 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210645;
	bh=4Y1DksFamWuWIpyhTakMZvrzFQ22CJTJWvRsP929dog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9jp3fFQbyfIXSVMApZQzGwJfoIqdELM6ANi1Di851X7I1bgXeYEuqM+fMOg9Ecg3
	 w0IYRgWIGTJorqg7Ma1AiMI9STA+1jW+xwPA7txAbMGXqq6in/U+k+FI2n5+hYbHmt
	 psrc/IIEI0u/7DBD4q0T1Dv1KwutC0FQbx3t/tvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1070/1518] m68k: Fix backtraces for non-running tasks
Date: Sat, 12 Sep 2026 08:53:59 +0200
Message-ID: <20260912065647.653928340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d2f25e8895e5a..60759ba3cbd45 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -936,8 +936,8 @@ void show_stack(struct task_struct *task, unsigned long *stack,
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



