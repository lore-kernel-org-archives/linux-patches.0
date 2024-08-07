Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70F78563E;
	Wed,  7 Aug 2024 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043442; cv=none; b=ul7+pKVkjRjYUbXLDcUpQiBV2jceu7Y0YsFzxgQq4z8huYlhNKfEVVBm7G8N7mSncjsvn1cQh3ufqNJdj5zez7VxwPabNmiDzb6iH4DCqHuYh7NR9BF4HUi9mif5V5q7gToTf2NvEnX89IJ8f00EJ+jd5oicA3du+zfLyOBSCIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043442; c=relaxed/simple;
	bh=/pl9rpMCZEqZ+k2lohQX9cbasWdtDjadwcLjX4T3xws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNZg6ITRUo8OXeiURIy3Aky5SCN9KUpBiSrTGYxFu+E4tSGahl2Sk6NUqLlf6V5SleM6p+TuhomMVRPEM0+4iFuCYJd3fw/V69SMoItMlAbhpixrS+xHV5nBKrwYmdlaKsDoY7EnHuHpdBQTo9fbEP2kmAJRDji0HEP2WQw74yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JJbkZbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JJbkZbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BDCC4AF0F;
	Wed,  7 Aug 2024 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043442;
	bh=/pl9rpMCZEqZ+k2lohQX9cbasWdtDjadwcLjX4T3xws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JJbkZbYI9udCwt91KaHk8p4h8moDcDWzS4O48F0ovCRHdwqnoUV1KD79oCx3TsQq
	 1K8RPmRTJc+lKu54hZiogwaiy2lFjP5kwcQYSZHxs6QLZ67xWDAoxtDQ4S7WCqiL9r
	 voZTi8tlZQcm+oGTBMfcbBvdc09w4D/0KVIaZ2IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/121] arm64: jump_label: Ensure patched jump_labels are visible to all CPUs
Date: Wed,  7 Aug 2024 17:00:25 +0200
Message-ID: <20240807150022.440203811@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit cfb00a35786414e7c0e6226b277d9f09657eae74 ]

Although the Arm architecture permits concurrent modification and
execution of NOP and branch instructions, it still requires some
synchronisation to ensure that other CPUs consistently execute the newly
written instruction:

 >  When the modified instructions are observable, each PE that is
 >  executing the modified instructions must execute an ISB or perform a
 >  context synchronizing event to ensure execution of the modified
 >  instructions

Prior to commit f6cc0c501649 ("arm64: Avoid calling stop_machine() when
patching jump labels"), the arm64 jump_label patching machinery
performed synchronisation using stop_machine() after each modification,
however this was problematic when flipping static keys from atomic
contexts (namely, the arm_arch_timer CPU hotplug startup notifier) and
so we switched to the _nosync() patching routines to avoid "scheduling
while atomic" BUG()s during boot.

In hindsight, the analysis of the issue in f6cc0c501649 isn't quite
right: it cites the use of IPIs in the default patching routines as the
cause of the lockup, whereas stop_machine() does not rely on IPIs and
the I-cache invalidation is performed using __flush_icache_range(),
which elides the call to kick_all_cpus_sync(). In fact, the blocking
wait for other CPUs is what triggers the BUG() and the problem remains
even after f6cc0c501649, for example because we could block on the
jump_label_mutex. Eventually, the arm_arch_timer driver was fixed to
avoid the static key entirely in commit a862fc2254bd
("clocksource/arm_arch_timer: Remove use of workaround static key").

This all leaves the jump_label patching code in a funny situation on
arm64 as we do not synchronise with other CPUs to reduce the likelihood
of a bug which no longer exists. Consequently, toggling a static key on
one CPU cannot be assumed to take effect on other CPUs, leading to
potential issues, for example with missing preempt notifiers.

Rather than revert f6cc0c501649 and go back to stop_machine() for each
patch site, implement arch_jump_label_transform_apply() and kick all
the other CPUs with an IPI at the end of patching.

Cc: Alexander Potapenko <glider@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Fixes: f6cc0c501649 ("arm64: Avoid calling stop_machine() when patching jump labels")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240731133601.3073-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/jump_label.h |  1 +
 arch/arm64/kernel/jump_label.c      | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
index 6aafbb7899916..4b99159150829 100644
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <asm/insn.h>
 
+#define HAVE_JUMP_LABEL_BATCH
 #define JUMP_LABEL_NOP_SIZE		AARCH64_INSN_SIZE
 
 static __always_inline bool arch_static_branch(struct static_key * const key,
diff --git a/arch/arm64/kernel/jump_label.c b/arch/arm64/kernel/jump_label.c
index faf88ec9c48e8..f63ea915d6ad2 100644
--- a/arch/arm64/kernel/jump_label.c
+++ b/arch/arm64/kernel/jump_label.c
@@ -7,11 +7,12 @@
  */
 #include <linux/kernel.h>
 #include <linux/jump_label.h>
+#include <linux/smp.h>
 #include <asm/insn.h>
 #include <asm/patching.h>
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+bool arch_jump_label_transform_queue(struct jump_entry *entry,
+				     enum jump_label_type type)
 {
 	void *addr = (void *)jump_entry_code(entry);
 	u32 insn;
@@ -25,4 +26,10 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	}
 
 	aarch64_insn_patch_text_nosync(addr, insn);
+	return true;
+}
+
+void arch_jump_label_transform_apply(void)
+{
+	kick_all_cpus_sync();
 }
-- 
2.43.0



