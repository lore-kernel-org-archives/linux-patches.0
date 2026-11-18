Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034410;
	b=05uGYvAOW7Y7TYBN0dXMbqExt+8hBj3eD6hgCNxqKsHd8+K+sMRctzzpLfsnMRjznZDX
	 /J52vhwchQe1iyhUhb0oLFQ18i45B59A6LMXS8GgaNDuSL4zPRcNCY3OWH7j3JZQMqKN9
	 mDxXOvVWCyL153FqlNQIyp4l1sOIDgZshWL3uKS7grc+OLG/FYQUzYRXgbQ8yVHlxLU2n
	 3IWrovOxbmUPl2OX+KdqqH/Rq1tJgX2Lyn2TsCbD/d7cFl976JatB0VAYpGzlDjGc0nF7
	 lRESoBfJMgACWHRXOVZ5Rf+ST1n8Z9GoNSf+4lkhhpyLVr1Ji6EKYp/jrmj+yaurmPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0zrYKSed7UQrUCgduGzTHuwwUFQhApyhWfzdklLRxt8=;
	b=I5wjsM8N699LUNSiYfDvOCX4HNfSf5VKnDjj+W8RmV+wm1pTQ70v8Vn6kaYp8X3uWAel
	 G4HcbUw2uOA2oMiYlYvULddrWas52D4H3dW23pn4bOpKx1GhxnK5D78OOPYfBQ+BzwviC
	 o0wCexWV1+rNsO0nhsVQForYJNLUdCpBXrRleLmtYIrOEHzUf3gCQ3w+gcYqxX/OFFA9b
	 VBx1Vw9BMOeuBs9JYPXTKVyInR2RXsgVujiuQreTy5HzMTWP3mBC56S/1ptACxFrbjYds
	 jr/hWiVuGwpy2PcX6XloYkT238lH4YwT7gyueUJpu7NDgjwYXhl3IE+Cip//pEOK/JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCS35FQQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136D4606A31C;
	Wed, 18 Nov 2026 20:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCS35FQQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBCF1F000C4;
	Wed, 18 Nov 2026 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034409;
	bh=0zrYKSed7UQrUCgduGzTHuwwUFQhApyhWfzdklLRxt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCS35FQQwbs4b+jvZ+bBn8OPdT2qvJz6+85tPlrUOiAOcaKQ2VtDS9u/EYfWv2ejF
	 gLZCU0Cdn3qbpqn3WHLQc+TtFskggmgG/h9Aks1yLqI1S4VKvhe+mEHEkQrWMYgY0K
	 v/oGkicaPO933+hWvXLtQ86JI0R0GCCV/7QbASdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH 6.6 0358/3318] kcsan: Avoid division by zero in kcsan_prandom_u32_max()
Date: Wed, 18 Nov 2026 15:16:20 +0100
Message-ID: <20261118150326.856648025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 99b6fcce87037cfb6b5e177848342e97f5141205 upstream.

KCSAN's skip_watch, udelay_task and udelay_interrupt parameters can be
changed at runtime through /sys/module/kcsan/parameters/, where 0 means
watching every access or not delaying at all. With the default
CONFIG_KCSAN_SKIP_WATCH_RANDOMIZE=y and CONFIG_KCSAN_DELAY_RANDOMIZE=y,
writing 0 to any of them makes the next watchpoint setup divide by zero:

  # echo 0 > /sys/module/kcsan/parameters/udelay_task
  Oops: divide error: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 93 Comm: sh Not tainted 7.3.0-rc5 #3 PREEMPT(lazy)
  RIP: 0010:kcsan_setup_watchpoint+0x1b5/0x410
  Code: ... 65 89 05 ad 8d 98 02 d3 ee <f7> f6 29 d7 e8 22 0e 0f 01 ...
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
  ...
   __show_trace_log_lvl+0x1bd/0x315
   __die_body.cold+0x19/0x2b
   die+0x34/0x50
  ...
  BUG: TASK stack guard page was hit at ffffd3ab001fbfe8 (...)

reset_kcsan_skip() and delay_access() pass these values unchecked to
kcsan_prandom_u32_max(), which returns "state % ep_ro". delay_access()
halves the delay for compound and assert accesses, so
udelay_interrupt=1 is enough there.

The oops path runs instrumented code, which faults again until the stack
overflows. With skip_watch=0 the guest hangs without printing anything.

The division came in with commit 71a076f4a61a ("kcsan: Rewrite
kcsan_prandom_u32_max() without prandom_u32_state()"). Before it, the
helper scaled the random value with a multiply-shift, which yields 0 for
ep_ro == 0. Go back to that via reciprocal_scale().

Tested in an x86-64 KCSAN guest with virtme-ng: after this patch,
writing 0 to each parameter, or 1 to udelay_interrupt, no longer
oopses. skip_watch=0 now watches every access, which is very slow with
the default delays but completes when they are set to 0.

Fixes: 71a076f4a61a ("kcsan: Rewrite kcsan_prandom_u32_max() without prandom_u32_state()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcsan/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -290,8 +290,9 @@ should_watch(struct kcsan_ctx *ctx, cons
 }
 
 /*
- * Returns a pseudo-random number in interval [0, ep_ro). Simple linear
- * congruential generator, using constants from "Numerical Recipes".
+ * Returns a pseudo-random number in interval [0, ep_ro), or 0 if ep_ro is 0,
+ * which the runtime-tunable callers may pass. Simple linear congruential
+ * generator, using constants from "Numerical Recipes".
  */
 static u32 kcsan_prandom_u32_max(u32 ep_ro)
 {
@@ -300,7 +301,7 @@ static u32 kcsan_prandom_u32_max(u32 ep_
 	state = 1664525 * state + 1013904223;
 	this_cpu_write(kcsan_rand_state, state);
 
-	return state % ep_ro;
+	return reciprocal_scale(state, ep_ro);
 }
 
 static inline void reset_kcsan_skip(void)


