Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F03315EB5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPjKftkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192E6C433C8;
	Mon, 23 Oct 2023 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061510;
	bh=8L9pNVjf5rLmWEohJqt3YyHAiHltP1wDtt+NoCI/uEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPjKftkNZ0pdcy4zeite4tsE/Tp4QXJxFx5aLgusz+Y2WHRlz7r3Bmd0u3tAqbs+0
	 OntrwQIRZ5VWO/sbhuHcbXazODvvSjIreZV57pad/J5AAJJfhe97YN/cEjc8urrhF8
	 PgTH0H19WLp4R4JqpQw4o2lMItNQsb83FiXdH0XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Amit Daniel Kachhap <amit.kachhap@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 064/202] arm64: die(): pass err as long
Date: Mon, 23 Oct 2023 12:56:11 +0200
Message-ID: <20231023104828.424950365@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 18906ff9af6517c20763ed63dab602a4150794f7 upstream.

Recently, we reworked a lot of code to consistentlt pass ESR_ELx as a
64-bit quantity. However, we missed that this can be passed into die()
and __die() as the 'err' parameter where it is truncated to a 32-bit
int.

As notify_die() already takes 'err' as a long, this patch changes die()
and __die() to also take 'err' as a long, ensuring that the full value
of ESR_ELx is retained.

At the same time, die() is updated to consistently log 'err' as a
zero-padded 64-bit quantity.

Subsequent patches will pass the ESR_ELx value to die() for a number of
exceptions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220913101732.3925290-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/system_misc.h |    2 +-
 arch/arm64/kernel/traps.c            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -18,7 +18,7 @@
 
 struct pt_regs;
 
-void die(const char *msg, struct pt_regs *regs, int err);
+void die(const char *msg, struct pt_regs *regs, long err);
 
 struct siginfo;
 void arm64_notify_die(const char *str, struct pt_regs *regs,
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -90,12 +90,12 @@ static void dump_kernel_instr(const char
 
 #define S_SMP " SMP"
 
-static int __die(const char *str, int err, struct pt_regs *regs)
+static int __die(const char *str, long err, struct pt_regs *regs)
 {
 	static int die_counter;
 	int ret;
 
-	pr_emerg("Internal error: %s: %x [#%d]" S_PREEMPT S_SMP "\n",
+	pr_emerg("Internal error: %s: %016lx [#%d]" S_PREEMPT S_SMP "\n",
 		 str, err, ++die_counter);
 
 	/* trap and error numbers are mostly meaningless on ARM */
@@ -116,7 +116,7 @@ static DEFINE_RAW_SPINLOCK(die_lock);
 /*
  * This function is protected against re-entrancy.
  */
-void die(const char *str, struct pt_regs *regs, int err)
+void die(const char *str, struct pt_regs *regs, long err)
 {
 	int ret;
 	unsigned long flags;


