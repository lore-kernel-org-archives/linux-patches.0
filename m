Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A586611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63494C433EF;
	Sun, 28 May 2023 19:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301224;
	bh=QUCTBzOnd+PYrLHNFSvXd4hfpFxpRpbxuQrbB42Nxsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YupwyY+T1K1AaGfhhnzzc9YJSUDdeLEjBRO1Fxht5iFvY6tMFiUsDaJl5qamJkB8u
	 +xP+aengqF+Umw4eCbhUEdchvz9e0VgTUdV1H2d/BmJ2vOSvrcF4xilYvhxCXhkabn
	 POXcd8cWkiVFC51u6mQJ1fwacRq5uUEKyIbvwmJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/86] sched: Fix KCSAN noinstr violation
Date: Sun, 28 May 2023 20:10:06 +0100
Message-Id: <20230528190829.782473903@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e0b081d17a9f4e5c0cbb0e5fbeb1abe3de0f7e4e ]

With KCSAN enabled, end_of_stack() can get out-of-lined.  Force it
inline.

Fixes the following warnings:

  vmlinux.o: warning: objtool: check_stackleak_irqoff+0x2b: call to end_of_stack() leaves .noinstr.text section

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/cc1b4d73d3a428a00d206242a68fdf99a934ca7b.1681320026.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task_stack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 3461beb89b040..62d1cd4db27af 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -23,7 +23,7 @@ static inline void *task_stack_page(const struct task_struct *task)
 
 #define setup_thread_stack(new,old)	do { } while(0)
 
-static inline unsigned long *end_of_stack(const struct task_struct *task)
+static __always_inline unsigned long *end_of_stack(const struct task_struct *task)
 {
 #ifdef CONFIG_STACK_GROWSUP
 	return (unsigned long *)((unsigned long)task->stack + THREAD_SIZE) - 1;
-- 
2.39.2



