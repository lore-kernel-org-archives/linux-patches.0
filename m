Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E7A3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B57C433D2;
	Mon, 30 Jan 2023 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088727;
	bh=AYdwVu5GAZ9kZl2G/mEIGIQh6Nq87wW3U5lnf9D/edM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgLYKTBV9o8m3skT81I80dFd2h89Sn2PkvBacou651zv3DDZ4S20GW+IltcP+Qp68
	 rHb28c3Fm7S75HkxdSWYs2DZ2hD8zp8I/FGCjZZaasT5r+htIk7IgRRGhDeJ4QXx9+
	 6MgMlzC5t+GPT4y7EttUHbR2JVEkV9PKwSaMIalA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/143] h8300: Fix build errors from do_exit() to make_task_dead() transition
Date: Mon, 30 Jan 2023 14:52:24 +0100
Message-Id: <20230130134310.484989595@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit ab4ababdf77ccc56c7301c751dff49c79709c51c upstream.

When building ARCH=h8300 defconfig:

arch/h8300/kernel/traps.c: In function 'die':
arch/h8300/kernel/traps.c:109:2: error: implicit declaration of function
'make_dead_task' [-Werror=implicit-function-declaration]
  109 |  make_dead_task(SIGSEGV);
      |  ^~~~~~~~~~~~~~

arch/h8300/mm/fault.c: In function 'do_page_fault':
arch/h8300/mm/fault.c:54:2: error: implicit declaration of function
'make_dead_task' [-Werror=implicit-function-declaration]
   54 |  make_dead_task(SIGKILL);
      |  ^~~~~~~~~~~~~~

The function's name is make_task_dead(), change it so there is no more
build error.

Additionally, include linux/sched/task.h in arch/h8300/kernel/traps.c
to avoid the same error because do_exit()'s declaration is in kernel.h
but make_task_dead()'s is in task.h, which is not included in traps.c.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-3-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/h8300/kernel/traps.c | 3 ++-
 arch/h8300/mm/fault.c     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 2b1366c958e3..cf23ccb50c17 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/task.h>
 #include <linux/mm_types.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -110,7 +111,7 @@ void die(const char *str, struct pt_regs *fp, unsigned long err)
 	dump(fp);
 
 	spin_unlock_irq(&die_lock);
-	make_dead_task(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 static int kstack_depth_to_print = 24;
diff --git a/arch/h8300/mm/fault.c b/arch/h8300/mm/fault.c
index 0223528565dd..b465441f490d 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -51,7 +51,7 @@ asmlinkage int do_page_fault(struct pt_regs *regs, unsigned long address,
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	make_dead_task(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	return 1;
 }
-- 
2.39.0



