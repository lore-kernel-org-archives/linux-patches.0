Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228646088F;
	Mon,  6 Jan 2025 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178523; cv=none; b=oOZfwi/zR0c9/p/OKGhKKwSlzUqmeKVTUyjK9IucQ2YwDJI7VLptsX7kUVR2I6BxtNDsFTCiEp7A/8MmDRfPYdz9MZZJPie+qdw03Xp+az9W7amV2hcfi+ux8Ipn72Kj787E1UjcSymEGs+7FKwytiLT93D+FZIIbLeGzCVrRAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178523; c=relaxed/simple;
	bh=6dKG0xDnt/3oJmsuzrc9KkasIRhMPLLznf7Mh5Fv/4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FejTiL5vHwupeAVztmH0hmseClhxVNf1YaOErGtZTu2xVW3kIO7Ohdujy8ycVGAQg7xn9qW3gx0BkSNcnLJeZtymM8jfwqGc1Eiw/8FtkgQbH2J4IuHcjHbCCnsonzVFaJ+CCD+oJSZWkh9feX6YReeG1dwxU84dNU0gq2y1SqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2NDDzCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2NDDzCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45884C4CED2;
	Mon,  6 Jan 2025 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178522;
	bh=6dKG0xDnt/3oJmsuzrc9KkasIRhMPLLznf7Mh5Fv/4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2NDDzCUCGPdb0dUcMgAizpdFUISWm+E3eEucsWl2bk2WG9x5QF+kNGkHSPMLo/D8
	 fSe/pyrz5LHey4hffZVplaCyu53s7NTxYF31NEgFvt6XhyBOKZzxNMXQhvhRy/Tm67
	 JjpWh7TSwYmudMp0/cbCK+8S5KlZLE3QwifzIoCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/138] kernel: Initialize cpumask before parsing
Date: Mon,  6 Jan 2025 16:17:24 +0100
Message-ID: <20250106151137.773276374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit c5e3a41187ac01425f5ad1abce927905e4ac44e4 ]

KMSAN complains that new_value at cpumask_parse_user() from
write_irq_affinity() from irq_affinity_proc_write() is uninitialized.

  [  148.133411][ T5509] =====================================================
  [  148.135383][ T5509] BUG: KMSAN: uninit-value in find_next_bit+0x325/0x340
  [  148.137819][ T5509]
  [  148.138448][ T5509] Local variable ----new_value.i@irq_affinity_proc_write created at:
  [  148.140768][ T5509]  irq_affinity_proc_write+0xc3/0x3d0
  [  148.142298][ T5509]  irq_affinity_proc_write+0xc3/0x3d0
  [  148.143823][ T5509] =====================================================

Since bitmap_parse() from cpumask_parse_user() calls find_next_bit(),
any alloc_cpumask_var() + cpumask_parse_user() sequence has possibility
that find_next_bit() accesses uninitialized cpu mask variable. Fix this
problem by replacing alloc_cpumask_var() with zalloc_cpumask_var().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20210401055823.3929-1-penguin-kernel@I-love.SAKURA.ne.jp
Stable-dep-of: 98feccbf32cf ("tracing: Prevent bad count for tracing_cpumask_write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/proc.c    | 4 ++--
 kernel/profile.c     | 2 +-
 kernel/trace/trace.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 72513ed2a5fc..0df62a3a1f37 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -144,7 +144,7 @@ static ssize_t write_irq_affinity(int type, struct file *file,
 	if (!irq_can_set_affinity_usr(irq) || no_irq_affinity)
 		return -EIO;
 
-	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
 	if (type)
@@ -238,7 +238,7 @@ static ssize_t default_affinity_write(struct file *file,
 	cpumask_var_t new_value;
 	int err;
 
-	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
 	err = cpumask_parse_user(buffer, count, new_value);
diff --git a/kernel/profile.c b/kernel/profile.c
index 737b1c704aa8..0db1122855c0 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -438,7 +438,7 @@ static ssize_t prof_cpu_mask_proc_write(struct file *file,
 	cpumask_var_t new_value;
 	int err;
 
-	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
 	err = cpumask_parse_user(buffer, count, new_value);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9f5b9036f001..3ecd7c700579 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4910,7 +4910,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	cpumask_var_t tracing_cpumask_new;
 	int err;
 
-	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
 
 	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
-- 
2.39.5



