Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B06AEEDE;
	Tue, 20 May 2025 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749651; cv=none; b=LDAtAOD8niwhw9nFGs94Y8OEtB0v/OII79MRB3MqEgH1ebC12+k9WsM5rxvC7lmenaVzU6SaBThdvVgpPlexCXfef0i26Wd98h+m/CpqeL2KtwMGNLXGx1AfY6kzf4RuE9jfbR4S1SljN9pUANOEiW8dLIIJtxJBsxcRR6kwTRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749651; c=relaxed/simple;
	bh=UQH9IA7j4AJYoVY/ucL8zJCMKEDCLRm3wTAJKuKAX8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IUiL8lBZ0gpnDK1PIoZyEecw+DyV2HS0/oJtCq9vskEWUY+KlYtvVFH52n6j4wgWNcUswT9baswDuVlXYC6aGMuZxtHB9WfucLb5ERQc39SKELxXDKea3DVoGNiUl23YdjIXDwJe2zJWTmzgeci/P17sDn3T0J/fN8hddcGvO/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgsZ+9q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgsZ+9q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5875CC4CEEB;
	Tue, 20 May 2025 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749650;
	bh=UQH9IA7j4AJYoVY/ucL8zJCMKEDCLRm3wTAJKuKAX8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgsZ+9q/1rzEygVl46LzdjRrThuVmoa6r9g7B29c8J/bmhvCJ3D1Aay4WT4sVJMsj
	 xu1dGlHiILl7/114WL+pnLXxof3urRiwtZwPdTv68lpieSdITcmM0dmnZ6gHcbbRj3
	 JjMh+HDUTnQPSqwh6ioOsR0xXMmEecXxSzqPeLoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/117] binfmt_elf: Support segments with 0 filesz and misaligned starts
Date: Tue, 20 May 2025 15:49:27 +0200
Message-ID: <20250520125804.089226152@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 585a018627b4d7ed37387211f667916840b5c5ea ]

Implement a helper elf_load() that wraps elf_map() and performs all
of the necessary work to ensure that when "memsz > filesz" the bytes
described by "memsz > filesz" are zeroed.

An outstanding issue is if the first segment has filesz 0, and has a
randomized location. But that is the same as today.

In this change I replaced an open coded padzero() that did not clear
all of the way to the end of the page, with padzero() that does.

I also stopped checking the return of padzero() as there is at least
one known case where testing for failure is the wrong thing to do.
It looks like binfmt_elf_fdpic may have the proper set of tests
for when error handling can be safely completed.

I found a couple of commits in the old history
https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git,
that look very interesting in understanding this code.

commit 39b56d902bf3 ("[PATCH] binfmt_elf: clearing bss may fail")
commit c6e2227e4a3e ("[SPARC64]: Missing user access return value checks in fs/binfmt_elf.c and fs/compat.c")
commit 5bf3be033f50 ("v2.4.10.1 -> v2.4.10.2")

Looking at commit 39b56d902bf3 ("[PATCH] binfmt_elf: clearing bss may fail"):
>  commit 39b56d902bf35241e7cba6cc30b828ed937175ad
>  Author: Pavel Machek <pavel@ucw.cz>
>  Date:   Wed Feb 9 22:40:30 2005 -0800
>
>     [PATCH] binfmt_elf: clearing bss may fail
>
>     So we discover that Borland's Kylix application builder emits weird elf
>     files which describe a non-writeable bss segment.
>
>     So remove the clear_user() check at the place where we zero out the bss.  I
>     don't _think_ there are any security implications here (plus we've never
>     checked that clear_user() return value, so whoops if it is a problem).
>
>     Signed-off-by: Pavel Machek <pavel@suse.cz>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>

It seems pretty clear that binfmt_elf_fdpic with skipping clear_user() for
non-writable segments and otherwise calling clear_user(), aka padzero(),
and checking it's return code is the right thing to do.

I just skipped the error checking as that avoids breaking things.

And notably, it looks like Borland's Kylix died in 2005 so it might be
safe to just consider read-only segments with memsz > filesz an error.

Reported-by: Sebastian Ott <sebott@redhat.com>
Reported-by: Thomas Weißschuh <linux@weissschuh.net>
Closes: https://lkml.kernel.org/r/20230914-bss-alloc-v1-1-78de67d2c6dd@weissschuh.net
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/r/87sf71f123.fsf@email.froward.int.ebiederm.org
Tested-by: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Link: https://lore.kernel.org/r/20230929032435.2391507-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 11854fe263eb ("binfmt_elf: Move brk for static PIE even if ASLR disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 111 +++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 63 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fb2c8d14327ae..d59bca23c4bd9 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -110,25 +110,6 @@ static struct linux_binfmt elf_format = {
 
 #define BAD_ADDR(x) (unlikely((unsigned long)(x) >= TASK_SIZE))
 
-static int set_brk(unsigned long start, unsigned long end, int prot)
-{
-	start = ELF_PAGEALIGN(start);
-	end = ELF_PAGEALIGN(end);
-	if (end > start) {
-		/*
-		 * Map the last of the bss segment.
-		 * If the header is requesting these pages to be
-		 * executable, honour that (ppc32 needs this).
-		 */
-		int error = vm_brk_flags(start, end - start,
-				prot & PROT_EXEC ? VM_EXEC : 0);
-		if (error)
-			return error;
-	}
-	current->mm->start_brk = current->mm->brk = end;
-	return 0;
-}
-
 /* We need to explicitly zero any fractional pages
    after the data section (i.e. bss).  This would
    contain the junk from the file that should not
@@ -406,6 +387,51 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	return(map_addr);
 }
 
+static unsigned long elf_load(struct file *filep, unsigned long addr,
+		const struct elf_phdr *eppnt, int prot, int type,
+		unsigned long total_size)
+{
+	unsigned long zero_start, zero_end;
+	unsigned long map_addr;
+
+	if (eppnt->p_filesz) {
+		map_addr = elf_map(filep, addr, eppnt, prot, type, total_size);
+		if (BAD_ADDR(map_addr))
+			return map_addr;
+		if (eppnt->p_memsz > eppnt->p_filesz) {
+			zero_start = map_addr + ELF_PAGEOFFSET(eppnt->p_vaddr) +
+				eppnt->p_filesz;
+			zero_end = map_addr + ELF_PAGEOFFSET(eppnt->p_vaddr) +
+				eppnt->p_memsz;
+
+			/* Zero the end of the last mapped page */
+			padzero(zero_start);
+		}
+	} else {
+		map_addr = zero_start = ELF_PAGESTART(addr);
+		zero_end = zero_start + ELF_PAGEOFFSET(eppnt->p_vaddr) +
+			eppnt->p_memsz;
+	}
+	if (eppnt->p_memsz > eppnt->p_filesz) {
+		/*
+		 * Map the last of the segment.
+		 * If the header is requesting these pages to be
+		 * executable, honour that (ppc32 needs this).
+		 */
+		int error;
+
+		zero_start = ELF_PAGEALIGN(zero_start);
+		zero_end = ELF_PAGEALIGN(zero_end);
+
+		error = vm_brk_flags(zero_start, zero_end - zero_start,
+				     prot & PROT_EXEC ? VM_EXEC : 0);
+		if (error)
+			map_addr = error;
+	}
+	return map_addr;
+}
+
+
 static unsigned long total_mapping_size(const struct elf_phdr *phdr, int nr)
 {
 	elf_addr_t min_addr = -1;
@@ -829,7 +855,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
 	struct elf_phdr *elf_property_phdata = NULL;
 	unsigned long elf_bss, elf_brk;
-	int bss_prot = 0;
 	int retval, i;
 	unsigned long elf_entry;
 	unsigned long e_entry;
@@ -1041,33 +1066,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (elf_ppnt->p_type != PT_LOAD)
 			continue;
 
-		if (unlikely (elf_brk > elf_bss)) {
-			unsigned long nbyte;
-
-			/* There was a PT_LOAD segment with p_memsz > p_filesz
-			   before this one. Map anonymous pages, if needed,
-			   and clear the area.  */
-			retval = set_brk(elf_bss + load_bias,
-					 elf_brk + load_bias,
-					 bss_prot);
-			if (retval)
-				goto out_free_dentry;
-			nbyte = ELF_PAGEOFFSET(elf_bss);
-			if (nbyte) {
-				nbyte = ELF_MIN_ALIGN - nbyte;
-				if (nbyte > elf_brk - elf_bss)
-					nbyte = elf_brk - elf_bss;
-				if (clear_user((void __user *)elf_bss +
-							load_bias, nbyte)) {
-					/*
-					 * This bss-zeroing can fail if the ELF
-					 * file specifies odd protections. So
-					 * we don't check the return value
-					 */
-				}
-			}
-		}
-
 		elf_prot = make_prot(elf_ppnt->p_flags, &arch_state,
 				     !!interpreter, false);
 
@@ -1163,7 +1161,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			}
 		}
 
-		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
+		error = elf_load(bprm->file, load_bias + vaddr, elf_ppnt,
 				elf_prot, elf_flags, total_size);
 		if (BAD_ADDR(error)) {
 			retval = IS_ERR_VALUE(error) ?
@@ -1218,10 +1216,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (end_data < k)
 			end_data = k;
 		k = elf_ppnt->p_vaddr + elf_ppnt->p_memsz;
-		if (k > elf_brk) {
-			bss_prot = elf_prot;
+		if (k > elf_brk)
 			elf_brk = k;
-		}
 	}
 
 	e_entry = elf_ex->e_entry + load_bias;
@@ -1233,18 +1229,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	start_data += load_bias;
 	end_data += load_bias;
 
-	/* Calling set_brk effectively mmaps the pages that we need
-	 * for the bss and break sections.  We must do this before
-	 * mapping in the interpreter, to make sure it doesn't wind
-	 * up getting placed where the bss needs to go.
-	 */
-	retval = set_brk(elf_bss, elf_brk, bss_prot);
-	if (retval)
-		goto out_free_dentry;
-	if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
-		retval = -EFAULT; /* Nobody gets to see this, but.. */
-		goto out_free_dentry;
-	}
+	current->mm->start_brk = current->mm->brk = ELF_PAGEALIGN(elf_brk);
 
 	if (interpreter) {
 		elf_entry = load_elf_interp(interp_elf_ex,
-- 
2.39.5



