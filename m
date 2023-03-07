Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DDEBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5756CC4339B;
	Tue,  7 Mar 2023 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213514;
	bh=HnCjmypvKMF6e+p3h62DCRZRNvQl4nTWa8tOYy7k1yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DivdqGLfWNjkisxKKy0R4/MG/p4lYzxDZFdXYMDGZjSNSx0+HsdPxVcI+p8zhA6R9
	 KfN7fZwvXKCpqvplaqdDOSoExuDHVP+ZlWy8i9phoL4+WqX4S2YBtwug85pzz8C1nH
	 8Hya5MBykVckYGgwYQyK9BhJAZ1twdrfG5megFDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 530/885] context_tracking: Fix noinstr vs KASAN
Date: Tue,  7 Mar 2023 17:57:44 +0100
Message-Id: <20230307170025.505823648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 0e26e1de0032779e43929174339429c16307a299 ]

Low level noinstr context-tracking code is calling out to instrumented
code on KASAN:

  vmlinux.o: warning: objtool: __ct_user_enter+0x72: call to __kasan_check_write() leaves .noinstr.text section
  vmlinux.o: warning: objtool: __ct_user_exit+0x47: call to __kasan_check_write() leaves .noinstr.text section

Use even lower level atomic methods to avoid the instrumentation.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230112195542.458034262@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/context_tracking.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 77978e3723771..a09f1c19336ae 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -510,7 +510,7 @@ void noinstr __ct_user_enter(enum ctx_state state)
 			 * In this we case we don't care about any concurrency/ordering.
 			 */
 			if (!IS_ENABLED(CONFIG_CONTEXT_TRACKING_IDLE))
-				atomic_set(&ct->state, state);
+				arch_atomic_set(&ct->state, state);
 		} else {
 			/*
 			 * Even if context tracking is disabled on this CPU, because it's outside
@@ -527,7 +527,7 @@ void noinstr __ct_user_enter(enum ctx_state state)
 			 */
 			if (!IS_ENABLED(CONFIG_CONTEXT_TRACKING_IDLE)) {
 				/* Tracking for vtime only, no concurrent RCU EQS accounting */
-				atomic_set(&ct->state, state);
+				arch_atomic_set(&ct->state, state);
 			} else {
 				/*
 				 * Tracking for vtime and RCU EQS. Make sure we don't race
@@ -535,7 +535,7 @@ void noinstr __ct_user_enter(enum ctx_state state)
 				 * RCU only requires RCU_DYNTICKS_IDX increments to be fully
 				 * ordered.
 				 */
-				atomic_add(state, &ct->state);
+				arch_atomic_add(state, &ct->state);
 			}
 		}
 	}
@@ -630,12 +630,12 @@ void noinstr __ct_user_exit(enum ctx_state state)
 			 * In this we case we don't care about any concurrency/ordering.
 			 */
 			if (!IS_ENABLED(CONFIG_CONTEXT_TRACKING_IDLE))
-				atomic_set(&ct->state, CONTEXT_KERNEL);
+				arch_atomic_set(&ct->state, CONTEXT_KERNEL);
 
 		} else {
 			if (!IS_ENABLED(CONFIG_CONTEXT_TRACKING_IDLE)) {
 				/* Tracking for vtime only, no concurrent RCU EQS accounting */
-				atomic_set(&ct->state, CONTEXT_KERNEL);
+				arch_atomic_set(&ct->state, CONTEXT_KERNEL);
 			} else {
 				/*
 				 * Tracking for vtime and RCU EQS. Make sure we don't race
@@ -643,7 +643,7 @@ void noinstr __ct_user_exit(enum ctx_state state)
 				 * RCU only requires RCU_DYNTICKS_IDX increments to be fully
 				 * ordered.
 				 */
-				atomic_sub(state, &ct->state);
+				arch_atomic_sub(state, &ct->state);
 			}
 		}
 	}
-- 
2.39.2



