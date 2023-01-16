Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7F146B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126BAC433D2;
	Mon, 16 Jan 2023 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886591;
	bh=HBblJMX1O8MutcaqclW47FkdZYxlqKeTzNPMyWJ01OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGydK7o7vDllFtB5m6A/1mIzWCZNFj7Y/sbTwcL4GdZQH3B0+Rn3RnmPgHELjbaFP
	 P0UJvzwUWv8gzBfLLYU1NkXrdL3ilzPNZ3j6E8RPXzILSqsFqgPOAdTbj6bw+nn6wZ
	 LCfNEut6t2DgTgxi80pt9ghbqhcDIKxyedkdX7tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ungerer <gerg@linux-m68k.org>,
	Kees Cook <keescook@chromium.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 489/658] binfmt: Move install_exec_creds after setup_new_exec to match binfmt_elf
Date: Mon, 16 Jan 2023 16:49:37 +0100
Message-Id: <20230116154931.900823330@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit e7f7785449a1f459a4a3ca92f82f56fb054dd2b9 ]

In 2016 Linus moved install_exec_creds immediately after
setup_new_exec, in binfmt_elf as a cleanup and as part of closing a
potential information leak.

Perform the same cleanup for the other binary formats.

Different binary formats doing the same things the same way makes exec
easier to reason about and easier to maintain.

Greg Ungerer reports:
> I tested the the whole series on non-MMU m68k and non-MMU arm
> (exercising binfmt_flat) and it all tested out with no problems,
> so for the binfmt_flat changes:
Tested-by: Greg Ungerer <gerg@linux-m68k.org>

Ref: 9f834ec18def ("binfmt_elf: switch to new creds when switching to new mm")
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Stable-dep-of: e7f703ff2507 ("binfmt: Fix error return code in load_elf_fdpic_binary()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/ia32/ia32_aout.c | 3 +--
 fs/binfmt_aout.c          | 2 +-
 fs/binfmt_elf_fdpic.c     | 2 +-
 fs/binfmt_flat.c          | 3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 9bb71abd66bd..37b36a8ce5fa 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -140,6 +140,7 @@ static int load_aout_binary(struct linux_binprm *bprm)
 	set_personality_ia32(false);
 
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
 
 	regs->cs = __USER32_CS;
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
@@ -156,8 +157,6 @@ static int load_aout_binary(struct linux_binprm *bprm)
 	if (retval < 0)
 		return retval;
 
-	install_exec_creds(bprm);
-
 	if (N_MAGIC(ex) == OMAGIC) {
 		unsigned long text_addr, map_size;
 
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 8e8346a81723..ace587b66904 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -162,6 +162,7 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	set_personality(PER_LINUX);
 #endif
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
 
 	current->mm->end_code = ex.a_text +
 		(current->mm->start_code = N_TXTADDR(ex));
@@ -174,7 +175,6 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	if (retval < 0)
 		return retval;
 
-	install_exec_creds(bprm);
 
 	if (N_MAGIC(ex) == OMAGIC) {
 		unsigned long text_addr, map_size;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d86ebd0dcc3d..9f785627009c 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -353,6 +353,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 		current->personality |= READ_IMPLIES_EXEC;
 
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
 
 	set_binfmt(&elf_fdpic_format);
 
@@ -434,7 +435,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	install_exec_creds(bprm);
 	if (create_elf_fdpic_tables(bprm, current->mm,
 				    &exec_params, &interp_params) < 0)
 		goto error;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index c999bc0c0691..22a7d7547a91 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -565,6 +565,7 @@ static int load_flat_file(struct linux_binprm *bprm,
 		/* OK, This is the point of no return */
 		set_personality(PER_LINUX_32BIT);
 		setup_new_exec(bprm);
+		install_exec_creds(bprm);
 	}
 
 	/*
@@ -992,8 +993,6 @@ static int load_flat_binary(struct linux_binprm *bprm)
 		}
 	}
 
-	install_exec_creds(bprm);
-
 	set_binfmt(&flat_format);
 
 #ifdef CONFIG_MMU
-- 
2.35.1



