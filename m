Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A446E288B9;
	Sat, 12 Sep 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231191; cv=none; b=SoYuHg/bWSt4MOyat8IInnPxe0DGwdbhJukS7wVW//u2TVxp8UT87hKV6RxGXx4PVmwDcemA9HpjAH0M2rp7QGa0gVPGWZP7dR/CHue8Af2Q6YcpphPVk1J1GAMZ0JKTLld+LG6bsFsCTAIlpQneLmt+JrZHh7Gi+2X+g2jXMTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231191; c=relaxed/simple;
	bh=aqwhirrihBVXDdmBmOa91fmiq7itogvBl3ZyEMsKq0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zm5bo2HdYNn6JHZ6mz93rFxdreQjLSdKTS/kl5heXgOeHHIDy6ssrlgn5QgIuKmqM7EtPQ2D9A+RaI8O/wqQhF9e+dCMPImc5z5CZnQVlSIJYFtpmw3Blsq87+9evw2cYukbcybP7uQbNPG7yRlMbBw+drkNQStA6brLQbtiB5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4Zgh/Ml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4Zgh/Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A6B1F000FF;
	Sat, 12 Sep 2026 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231190;
	bh=WeiqdBbRV0Ozcu97jkcJlfc1yrBbJKPZ+D8WDFFpgLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4Zgh/MlU6dDYv67bELxnKsHiEjmAE0DJJtVOEBXTDJK8g3sZfJHB3VZWiSBB3Gho
	 2VPakY13rSnewF7RER9ZiztNpDAbkk8UGk88Qxa3mwXevvF7tF469FZ/WDy/cJkNvT
	 VNK3Xe720TeJgxx8fflss4pPjBD74JGq6+xjOT4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0948/1191] m68k: Fix backtraces for non-running tasks
Date: Sat, 12 Sep 2026 09:01:16 +0200
Message-ID: <20260912065609.515398461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a700807c9b6d9..aaea713210ed9 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -937,8 +937,8 @@ void show_stack(struct task_struct *task, unsigned long *stack,
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



