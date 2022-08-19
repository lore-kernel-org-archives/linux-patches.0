Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F424A08
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E790C43470
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933041;
	bh=/c3ugNtpww14BQAlMeQSms1tu7vT6xq3Hbk1rHDk68E=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=oQ8T9iNOFtMQKnyn/LndrDNpTixUTmZSBtNYRwU6iIxRbzwUvQuoNz8KgIm+ir8Il
	 U92ZgiMfhE8mSn2LcfhyndFQxqF7JQjQOtMMueqt6gQkkvwLnUUe3q8BDsukXAbqtA
	 ReSUI7QQwM34j0CtQBYaW1lLPYf5w7xjD8slUuVXFN5UQEvoIWNJ4YE0Ml/+ZkFOXp
	 hVKFZZgJtpIOwhB+KlKay7PLjaP2AAREzbHBkUY+POVED3ctHT0EUOzuYeqGZ2QzAV
	 WFYZ2/5Q5unqliZs90rwuwVE7ZR26tgaU+UgwlJ3wq5dyd83SCsgC0NPck4+I008fl
	 z2UMg3slhvkIQ==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:19 -0400
Subject: [PATCH v1 5/9] mm/debug: Provide VM_WARN_ON_IRQS_ENABLED()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-5-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1731;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=gGYe98gaSycwEFwudmylG/gEWjXi8D0tDeTB80EzydI=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X16XyNgl8OdpxbM9VdMb11w+HtT6mFuReY3rq63p9Vy8
 j2bxd5SyMIhxMciKKbKU7YvdFFT40EMuvccUZg4rE8gQBi5OAZhI5TFGhm+c61yFy5oeu12UOZNp83
 b27lzujg1sW3N6eEqb+AxagxkZjngruTRa7DupG8Nqu2T/1EP7u4TX1gYn9C1S4e2avEaSHwA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

Some places in the VM code expect interrupts disabled, which is a valid
expectation on non-PREEMPT_RT kernels, but does not hold on RT kernels in
some places because the RT spinlock substitution does not disable
interrupts.

To avoid sprinkling CONFIG_PREEMPT_RT conditionals into those places,
provide VM_WARN_ON_IRQS_ENABLED() which is only enabled when VM_DEBUG=y and
PREEMPT_RT=n.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 15ae78cd2853..b8728d11c949 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -94,6 +94,12 @@ void dump_mm(const struct mm_struct *mm);
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
 
+#ifdef CONFIG_DEBUG_VM_IRQSOFF
+#define VM_WARN_ON_IRQS_ENABLED() WARN_ON_ONCE(!irqs_disabled())
+#else
+#define VM_WARN_ON_IRQS_ENABLED() do { } while (0)
+#endif
+
 #ifdef CONFIG_DEBUG_VIRTUAL
 #define VIRTUAL_BUG_ON(cond) BUG_ON(cond)
 #else
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 072e4b289c13..c96fc6820544 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -803,6 +803,9 @@ config ARCH_HAS_DEBUG_VM_PGTABLE
 	  An architecture should select this when it can successfully
 	  build and run DEBUG_VM_PGTABLE.
 
+config DEBUG_VM_IRQSOFF
+	def_bool DEBUG_VM && !PREEMPT_RT
+
 config DEBUG_VM
 	bool "Debug VM"
 	depends on DEBUG_KERNEL

-- 
b4 0.10.0-dev-c53d8

