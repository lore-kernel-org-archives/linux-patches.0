Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E070F33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301239; cv=none; b=ke7wvUNIfbt6XlIHwfZHRRMLQojxPT6JZjZQAznuQNdZ8+MgFasm/05QI4kYbUdlMQOrShrkcHkK4q/MmTerj17NqCA8Xyih2Hmu1DtIPyGCEhcE+deLGyHSANpwlIxM2gH/sjzB9lgRFv7UtIkmPrLJvAflwdUSByzkhE7EMlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301239; c=relaxed/simple;
	bh=7NrtJNVqrcPlxGX5e43eEuzM7iZ6fzLNN2QNSLUzPiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOhXEaYmnsdQOtI5EqJqc5wmviwmeXaAD4I6RobqxlifDHGI8PEfNzcku0rdwHP3kn9hXzgbdrc/G21Qmgc+QP4gKFJtpl2qraD1KPcoJ8PG4/7lbuZZ5IoD3I0/XMcBB+CMkY4xa4jS1pw+L1eevM8rkrzwMOoYLO5L1zQ/vmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p96togXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p96togXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F658C116D0;
	Sat, 28 Feb 2026 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301238;
	bh=7NrtJNVqrcPlxGX5e43eEuzM7iZ6fzLNN2QNSLUzPiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p96togXGyGGhLSbtpfsVHdIS17j1gDWQbKctc0SbqeH+9PWpsht9a/2X+Q4ehouFj
	 b90SKGHU8/lw1Osg88kJwwwvENpDg6lkdI8tocQ9gJhThyFbCSJ04EkTr2RCT3T6mi
	 fsXHGaCLE1ZyJB9MLXpexD97len1kBsJIvVxMHZngddx0UK3ZslUzmofuZM9M+o7EL
	 PrIww3hm/N4tKdBwt9xwRQMAawdqWX7prjAD7gRefyBnNKK0WDYiw8Ru4tt048auYt
	 mRn87HBEhfsSP2B+qa0zU4Z4BWzRH06PSVsLvCJDw6O9mLiyOggDtGCEyXwhe3yl1P
	 cxgF6Qhe0Jl6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jason Donenfeld <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 418/752] Remove WARN_ALL_UNSEEDED_RANDOM kernel config option
Date: Sat, 28 Feb 2026 12:42:09 -0500
Message-ID: <20260228174750.1542406-418-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 7dff99b354601dd01829e1511711846e04340a69 ]

This config option goes way back - it used to be an internal debug
option to random.c (at that point called DEBUG_RANDOM_BOOT), then was
renamed and exposed as a config option as CONFIG_WARN_UNSEEDED_RANDOM,
and then further renamed to the current CONFIG_WARN_ALL_UNSEEDED_RANDOM.

It was all done with the best of intentions: the more limited
rate-limited reports were reporting some cases, but if you wanted to see
all the gory details, you'd enable this "ALL" option.

However, it turns out - perhaps not surprisingly - that when people
don't care about and fix the first rate-limited cases, they most
certainly don't care about any others either, and so warning about all
of them isn't actually helping anything.

And the non-ratelimited reporting causes problems, where well-meaning
people enable debug options, but the excessive flood of messages that
nobody cares about will hide actual real information when things go
wrong.

I just got a kernel bug report (which had nothing to do with randomness)
where two thirds of the the truncated dmesg was just variations of

   random: get_random_u32 called from __get_random_u32_below+0x10/0x70 with crng_init=0

and in the process early boot messages had been lost (in addition to
making the messages that _hadn't_ been lost harder to read).

The proper way to find these things for the hypothetical developer that
cares - if such a person exists - is almost certainly with boot time
tracing.  That gives you the option to get call graphs etc too, which is
likely a requirement for fixing any problems anyway.

See Documentation/trace/boottime-trace.rst for that option.

And if we for some reason do want to re-introduce actual printing of
these things, it will need to have some uniqueness filtering rather than
this "just print it all" model.

Fixes: cc1e127bfa95 ("random: remove ratelimiting for in-kernel unseeded randomness")
Acked-by: Jason Donenfeld <Jason@zx2c4.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c       | 12 +-----------
 kernel/configs/debug.config |  1 -
 lib/Kconfig.debug           | 27 ---------------------------
 3 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4ba5f0c4c8b24..f344f67c83f4e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -96,8 +96,7 @@ static ATOMIC_NOTIFIER_HEAD(random_ready_notifier);
 /* Control how we warn userspace. */
 static struct ratelimit_state urandom_warning =
 	RATELIMIT_STATE_INIT_FLAGS("urandom_warning", HZ, 3, RATELIMIT_MSG_ON_RELEASE);
-static int ratelimit_disable __read_mostly =
-	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
+static int ratelimit_disable __read_mostly = 0;
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
 MODULE_PARM_DESC(ratelimit_disable, "Disable random ratelimit suppression");
 
@@ -168,12 +167,6 @@ int __cold execute_with_initialized_rng(struct notifier_block *nb)
 	return ret;
 }
 
-#define warn_unseeded_randomness() \
-	if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
-		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n", \
-				__func__, (void *)_RET_IP_, crng_init)
-
-
 /*********************************************************************
  *
  * Fast key erasure RNG, the "crng".
@@ -434,7 +427,6 @@ static void _get_random_bytes(void *buf, size_t len)
  */
 void get_random_bytes(void *buf, size_t len)
 {
-	warn_unseeded_randomness();
 	_get_random_bytes(buf, len);
 }
 EXPORT_SYMBOL(get_random_bytes);
@@ -523,8 +515,6 @@ type get_random_ ##type(void)							\
 	struct batch_ ##type *batch;						\
 	unsigned long next_gen;							\
 										\
-	warn_unseeded_randomness();						\
-										\
 	if  (!crng_ready()) {							\
 		_get_random_bytes(&ret, sizeof(ret));				\
 		return ret;							\
diff --git a/kernel/configs/debug.config b/kernel/configs/debug.config
index e81327d2cd639..1d5d8b0396e95 100644
--- a/kernel/configs/debug.config
+++ b/kernel/configs/debug.config
@@ -29,7 +29,6 @@ CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 # CONFIG_UBSAN_ALIGNMENT is not set
 # CONFIG_UBSAN_DIV_ZERO is not set
 # CONFIG_UBSAN_TRAP is not set
-# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_FS_ALLOW_ALL=y
 CONFIG_DEBUG_IRQFLAGS=y
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 713cc94caa02e..88fa610e83840 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1684,33 +1684,6 @@ config STACKTRACE
 	  It is also used by various kernel debugging features that require
 	  stack trace generation.
 
-config WARN_ALL_UNSEEDED_RANDOM
-	bool "Warn for all uses of unseeded randomness"
-	default n
-	help
-	  Some parts of the kernel contain bugs relating to their use of
-	  cryptographically secure random numbers before it's actually possible
-	  to generate those numbers securely. This setting ensures that these
-	  flaws don't go unnoticed, by enabling a message, should this ever
-	  occur. This will allow people with obscure setups to know when things
-	  are going wrong, so that they might contact developers about fixing
-	  it.
-
-	  Unfortunately, on some models of some architectures getting
-	  a fully seeded CRNG is extremely difficult, and so this can
-	  result in dmesg getting spammed for a surprisingly long
-	  time.  This is really bad from a security perspective, and
-	  so architecture maintainers really need to do what they can
-	  to get the CRNG seeded sooner after the system is booted.
-	  However, since users cannot do anything actionable to
-	  address this, by default this option is disabled.
-
-	  Say Y here if you want to receive warnings for all uses of
-	  unseeded randomness.  This will be of use primarily for
-	  those developers interested in improving the security of
-	  Linux kernels running on their architecture (or
-	  subarchitecture).
-
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
-- 
2.51.0

