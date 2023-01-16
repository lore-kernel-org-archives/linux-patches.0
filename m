Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB986FA3
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB64C433F0;
	Mon, 16 Jan 2023 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888050;
	bh=pSTMmCY512i5KazpdWzGhtaZtUMVV5FzXku661DshPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfFEJyhoKkcKiFTCAsNCI+ejWImRhGDu4KJVyGnsTnr/0PaoMzTZxI28aGLW8CMgQ
	 h64eb0wlskISmkeUlDRlVAo+DJm2LtiZDDp0unGEqscHMx0mmsKXvhRKO2fmF2CezP
	 nBJzmPqS2ztr8OusLPZq7ySWRuqqE1L/AXgQDsqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Ungerer <gerg@linux-m68k.org>,
	Kees Cook <keescook@chromium.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 381/521] binfmt: Move install_exec_creds after setup_new_exec to match binfmt_elf
Date: Mon, 16 Jan 2023 16:50:43 +0100
Message-Id: <20230116154904.164206203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 3ebd77770f98..4cfda3cfae7f 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -298,6 +298,7 @@ static int load_aout_binary(struct linux_binprm *bprm)
 	set_personality_ia32(false);
 
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
 
 	regs->cs = __USER32_CS;
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
@@ -314,8 +315,6 @@ static int load_aout_binary(struct linux_binprm *bprm)
 	if (retval < 0)
 		return retval;
 
-	install_exec_creds(bprm);
-
 	if (N_MAGIC(ex) == OMAGIC) {
 		unsigned long text_addr, map_size;
 
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index c3deb2e35f20..e7a9e8b56e71 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -244,6 +244,7 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	set_personality(PER_LINUX);
 #endif
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
 
 	current->mm->end_code = ex.a_text +
 		(current->mm->start_code = N_TXTADDR(ex));
@@ -256,7 +257,6 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	if (retval < 0)
 		return retval;
 
-	install_exec_creds(bprm);
 
 	if (N_MAGIC(ex) == OMAGIC) {
 		unsigned long text_addr, map_size;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index b53bb3729ac1..60896c16f103 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -357,6 +357,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 		current->personality |= READ_IMPLIES_EXEC;
 
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
 
 	set_binfmt(&elf_fdpic_format);
 
@@ -438,7 +439,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	install_exec_creds(bprm);
 	if (create_elf_fdpic_tables(bprm, current->mm,
 				    &exec_params, &interp_params) < 0)
 		goto error;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index a6f97d86fb80..a909743b1a0e 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -541,6 +541,7 @@ static int load_flat_file(struct linux_binprm *bprm,
 		/* OK, This is the point of no return */
 		set_personality(PER_LINUX_32BIT);
 		setup_new_exec(bprm);
+		install_exec_creds(bprm);
 	}
 
 	/*
@@ -965,8 +966,6 @@ static int load_flat_binary(struct linux_binprm *bprm)
 		}
 	}
 
-	install_exec_creds(bprm);
-
 	set_binfmt(&flat_format);
 
 #ifdef CONFIG_MMU
-- 
2.35.1



