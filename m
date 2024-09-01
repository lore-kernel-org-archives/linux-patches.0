Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DE71DFD1;
	Sun,  1 Sep 2024 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209667; cv=none; b=Ux5rFIk+87aiFhNWpOifDjmoyH+rOqhSnqgdZ568r+FkL7U3ntnHaf3tegQD/xqGdLRgnUvUilid4ES8l1atAzyAyqfJBKOr8ggKrj6y26uqmevvjRghbTDNcopggGnjWIqX0YUkrY/Lc8+NAjWMXjS/LOlhFY9pwLvTmNHsSGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209667; c=relaxed/simple;
	bh=D4D89SaCKtIiNdKhkNTfEQ9XPI3UrI+egc+qT368TMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5TN898YXMpq7nLqsdx8MJYW9NswfJibnVv6YBWQM98jkLkVYHv/Q1+DPbGFWjJgRIeLUAzfuz5HwhFhsy/XpvUkPiV1csOIc7MSMLAFRumjW/xjsQ4v1p0xvegYoYziqRe9btgsFzaxbEWNHFdahDUBKthmsCILIUeHAGYBvvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgukZ1V8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgukZ1V8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C1DC4CEC3;
	Sun,  1 Sep 2024 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209667;
	bh=D4D89SaCKtIiNdKhkNTfEQ9XPI3UrI+egc+qT368TMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgukZ1V8jZFoysJDASoTr/rSQoutxPodWi+NPBsbQf0mLXU9KfeHShFhCE5GDCBJb
	 xZ2ac1hofE89RmrkDoYyb/8lkO68OLu/AqYuoGNOjhGf+Or9Z3N4kMcZMagjGKAXQ6
	 dC4oAg5zWbUyGA10Wfsa4n6S575r+4EeYGaWxlKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	YunQiang Su <ysu@wavecomp.com>,
	Helge Deller <deller@gmx.de>,
	Thorsten Glaser <tg@debian.org>
Subject: [PATCH 5.10 108/151] binfmt_misc: pass binfmt_misc flags to the interpreter
Date: Sun,  1 Sep 2024 18:17:48 +0200
Message-ID: <20240901160818.172244371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Laurent Vivier <laurent@vivier.eu>

commit 2347961b11d4079deace3c81dceed460c08a8fc1 upstream.

It can be useful to the interpreter to know which flags are in use.

For instance, knowing if the preserve-argv[0] is in use would
allow to skip the pathname argument.

This patch uses an unused auxiliary vector, AT_FLAGS, to add a
flag to inform interpreter if the preserve-argv[0] is enabled.

Note by Helge Deller:
The real-world user of this patch is qemu-user, which needs to know
if it has to preserve the argv[0]. See Debian bug #970460.

Signed-off-by: Laurent Vivier <laurent@vivier.eu>
Reviewed-by: YunQiang Su <ysu@wavecomp.com>
URL: http://bugs.debian.org/970460
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Thorsten Glaser <tg@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c              |    5 ++++-
 fs/binfmt_elf_fdpic.c        |    5 ++++-
 fs/binfmt_misc.c             |    4 +++-
 include/linux/binfmts.h      |    4 ++++
 include/uapi/linux/binfmts.h |    4 ++++
 5 files changed, 19 insertions(+), 3 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -186,6 +186,7 @@ create_elf_tables(struct linux_binprm *b
 	unsigned char k_rand_bytes[16];
 	int items;
 	elf_addr_t *elf_info;
+	elf_addr_t flags = 0;
 	int ei_index;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
@@ -260,7 +261,9 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
-	NEW_AUX_ENT(AT_FLAGS, 0);
+	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
+		flags |= AT_FLAGS_PRESERVE_ARGV0;
+	NEW_AUX_ENT(AT_FLAGS, flags);
 	NEW_AUX_ENT(AT_ENTRY, e_entry);
 	NEW_AUX_ENT(AT_UID, from_kuid_munged(cred->user_ns, cred->uid));
 	NEW_AUX_ENT(AT_EUID, from_kuid_munged(cred->user_ns, cred->euid));
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -506,6 +506,7 @@ static int create_elf_fdpic_tables(struc
 	char __user *u_platform, *u_base_platform, *p;
 	int loop;
 	int nr;	/* reset for each csp adjustment */
+	unsigned long flags = 0;
 
 #ifdef CONFIG_MMU
 	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
@@ -648,7 +649,9 @@ static int create_elf_fdpic_tables(struc
 	NEW_AUX_ENT(AT_PHENT,	sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM,	exec_params->hdr.e_phnum);
 	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
-	NEW_AUX_ENT(AT_FLAGS,	0);
+	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
+		flags |= AT_FLAGS_PRESERVE_ARGV0;
+	NEW_AUX_ENT(AT_FLAGS,	flags);
 	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
 	NEW_AUX_ENT(AT_UID,	(elf_addr_t) from_kuid_munged(cred->user_ns, cred->uid));
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) from_kuid_munged(cred->user_ns, cred->euid));
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -191,7 +191,9 @@ static int load_misc_binary(struct linux
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
 		goto ret;
 
-	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
+	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
+		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
+	} else {
 		retval = remove_arg_zero(bprm);
 		if (retval)
 			goto ret;
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -73,6 +73,10 @@ struct linux_binprm {
 #define BINPRM_FLAGS_PATH_INACCESSIBLE_BIT 2
 #define BINPRM_FLAGS_PATH_INACCESSIBLE (1 << BINPRM_FLAGS_PATH_INACCESSIBLE_BIT)
 
+/* preserve argv0 for the interpreter  */
+#define BINPRM_FLAGS_PRESERVE_ARGV0_BIT 3
+#define BINPRM_FLAGS_PRESERVE_ARGV0 (1 << BINPRM_FLAGS_PRESERVE_ARGV0_BIT)
+
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	const kernel_siginfo_t *siginfo;
--- a/include/uapi/linux/binfmts.h
+++ b/include/uapi/linux/binfmts.h
@@ -18,4 +18,8 @@ struct pt_regs;
 /* sizeof(linux_binprm->buf) */
 #define BINPRM_BUF_SIZE 256
 
+/* preserve argv0 for the interpreter  */
+#define AT_FLAGS_PRESERVE_ARGV0_BIT 0
+#define AT_FLAGS_PRESERVE_ARGV0 (1 << AT_FLAGS_PRESERVE_ARGV0_BIT)
+
 #endif /* _UAPI_LINUX_BINFMTS_H */


