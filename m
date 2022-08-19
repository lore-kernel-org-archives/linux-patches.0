Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E64A09
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0622DC43470
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1660933458;
	bh=/c3ugNtpww14BQAlMeQSms1tu7vT6xq3Hbk1rHDk68E=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=jGTtlcUe8Scu6A/QMZoUJlF49qLbazq+3MXjtC/Vj3mIOq9Mh4vgePChwuUksO2QD
	 zxyHk5AjkZkerr7nbax3vdgvhdYJjWHpWYYXBDv7fXPOtMKJa07nzKK2VQ0eQz/vz5
	 /z11m87FJKupaBAOWTLf9b8q+7S1eevC3fEECNRo=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 19 Aug 2022 14:24:14 -0400
Subject: [PATCH RESEND v1 5/9] mm/debug: Provide VM_WARN_ON_IRQS_ENABLED()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-5-dfdb252f35f4@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-dfdb252f35f4@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-dfdb252f35f4@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1731;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=gGYe98gaSycwEFwudmylG/gEWjXi8D0tDeTB80EzydI=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X/V7f6Ov9P2VV7VLLrM/738T3Lv8wwuRZrEug0WOZ8+K
 iHKEdZSyMIhxMciKKbKU7YvdFFT40EMuvccUZg4rE8gQBi5OAZjImqOMDAdjW9y+9x456Jf497VkWV
 g736La31qKCbMqn3dIy9ee+c7wz4RJJWdd4eXW5Jke/FOX2ZTxMQmkXQw3Dfoh8EYqnesPHwA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

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

