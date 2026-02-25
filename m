Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7E818B0A;
	Wed, 25 Feb 2026 01:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983243; cv=none; b=VQ7llwPgqjINi3EU8QLmEMcaq31L0vNU74Z7kjaEDFxYQ8xhCp1F6CAc0l6ZKfVfrfWtPBZiYc1AEKziGxEppKxysrVGKk4u1wbdqHwvXE5Uymtz9PcNBVJpjWGlYUTLnMIwHKat+gk6s1c7LUNLg5hPsEgs37jdSAbURSLSquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983243; c=relaxed/simple;
	bh=jCcJYW5Bs/3O5DELYJRoJu64KK3YwU5oeK8hwEFv5vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkwD1ECsSl2v5dc0m0WbbnwQGb3yTLMBuKH0PG7Vz2pSciGlplFfXh/jmM3Mec92+QNsbbMKsAe/LvltkO6VOgj9gXl+z17wvhTboeCR8zhCeSa6WtKEAwNteU8LsJe4f8oB30QL+P9esB+tkOV3WFlgkCpGQeCxK5KIu03KkWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6cmeQP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6cmeQP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96692C116D0;
	Wed, 25 Feb 2026 01:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983243;
	bh=jCcJYW5Bs/3O5DELYJRoJu64KK3YwU5oeK8hwEFv5vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6cmeQP5mznMfdzXqW1lmB9MVy/FfGziQV+k9MbZGiMdZYneelmqp05uP2RD9lvb5
	 nBIIgY3+0+efhya313x3iKxY/Wvoi+1FlcYhzZ48tIEYJfDukrfLJV+JGCDxwFa25k
	 aYBxZB1GlJJlzPcJ4SFqNU9uJwBZpY2KX0Wyx6fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Daniel Borkman <daniel@iogearbox.net>,
	Daniel Gomez <da.gomez@samsung.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 349/781] kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
Date: Tue, 24 Feb 2026 17:17:38 -0800
Message-ID: <20260225012408.250748798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit cd6735896d0343942cf3dafb48ce32eb79341990 ]

bpf_address_lookup() has been used only in kallsyms_lookup_buildid().  It
was supposed to set @modname and @modbuildid when the symbol was in a
module.

But it always just cleared @modname because BPF symbols were never in a
module.  And it did not clear @modbuildid because the pointer was not
passed.

The wrapper is no longer needed.  Both @modname and @modbuildid are now
always initialized to NULL in kallsyms_lookup_buildid().

Remove the wrapper and rename __bpf_address_lookup() to
bpf_address_lookup() because this variant is used everywhere.

[akpm@linux-foundation.org: fix loongarch]
Link: https://lkml.kernel.org/r/20251128135920.217303-6-pmladek@suse.com
Fixes: 9294523e3768 ("module: add printk formats to add module build ID to stacktraces")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c   |  2 +-
 arch/loongarch/net/bpf_jit.c    |  2 +-
 arch/powerpc/net/bpf_jit_comp.c |  2 +-
 include/linux/filter.h          | 26 ++++----------------------
 kernel/bpf/core.c               |  4 ++--
 kernel/kallsyms.c               |  5 ++---
 6 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index b6eb7a465ad24..1d657bd3ce655 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2951,7 +2951,7 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
 	u64 plt_target = 0ULL;
 	bool poking_bpf_entry;
 
-	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		/* Only poking bpf text is supported. Since kernel function
 		 * entry is set up by ftrace, we reply on ftrace to poke kernel
 		 * functions.
diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index d1d5a65308b9e..3b63bc5b99d9a 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1319,7 +1319,7 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
 	/* Only poking bpf text is supported. Since kernel function entry
 	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
 	 */
-	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
+	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		return -ENOTSUPP;
 
 	image = ip - offset;
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 5e976730b2f5f..e199976e410a1 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -1122,7 +1122,7 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
 	bpf_func = (unsigned long)ip;
 
 	/* We currently only support poking bpf programs */
-	if (!__bpf_address_lookup(bpf_func, &size, &offset, name)) {
+	if (!bpf_address_lookup(bpf_func, &size, &offset, name)) {
 		pr_err("%s (0x%lx): kernel/modules are not supported\n", __func__, bpf_func);
 		return -EOPNOTSUPP;
 	}
diff --git a/include/linux/filter.h b/include/linux/filter.h
index fd54fed8f95f3..7452817d707d1 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1375,24 +1375,13 @@ static inline bool bpf_jit_kallsyms_enabled(void)
 	return false;
 }
 
-int __bpf_address_lookup(unsigned long addr, unsigned long *size,
-				 unsigned long *off, char *sym);
+int bpf_address_lookup(unsigned long addr, unsigned long *size,
+		       unsigned long *off, char *sym);
 bool is_bpf_text_address(unsigned long addr);
 int bpf_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		    char *sym);
 struct bpf_prog *bpf_prog_ksym_find(unsigned long addr);
 
-static inline int
-bpf_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
-{
-	int ret = __bpf_address_lookup(addr, size, off, sym);
-
-	if (ret && modname)
-		*modname = NULL;
-	return ret;
-}
-
 void bpf_prog_kallsyms_add(struct bpf_prog *fp);
 void bpf_prog_kallsyms_del(struct bpf_prog *fp);
 
@@ -1431,8 +1420,8 @@ static inline bool bpf_jit_kallsyms_enabled(void)
 }
 
 static inline int
-__bpf_address_lookup(unsigned long addr, unsigned long *size,
-		     unsigned long *off, char *sym)
+bpf_address_lookup(unsigned long addr, unsigned long *size,
+		   unsigned long *off, char *sym)
 {
 	return 0;
 }
@@ -1453,13 +1442,6 @@ static inline struct bpf_prog *bpf_prog_ksym_find(unsigned long addr)
 	return NULL;
 }
 
-static inline int
-bpf_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
-{
-	return 0;
-}
-
 static inline void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
 }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 1b9b18e5b03cb..85c0feaae0d3c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -713,8 +713,8 @@ static struct bpf_ksym *bpf_ksym_find(unsigned long addr)
 	return n ? container_of(n, struct bpf_ksym, tnode) : NULL;
 }
 
-int __bpf_address_lookup(unsigned long addr, unsigned long *size,
-				 unsigned long *off, char *sym)
+int bpf_address_lookup(unsigned long addr, unsigned long *size,
+		       unsigned long *off, char *sym)
 {
 	struct bpf_ksym *ksym;
 	int ret = 0;
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 049e296f586cc..7417dd5f8a796 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -345,7 +345,7 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 		return 1;
 	}
 	return !!module_address_lookup(addr, symbolsize, offset, NULL, NULL, namebuf) ||
-	       !!__bpf_address_lookup(addr, symbolsize, offset, namebuf);
+	       !!bpf_address_lookup(addr, symbolsize, offset, namebuf);
 }
 
 static int kallsyms_lookup_buildid(unsigned long addr,
@@ -377,8 +377,7 @@ static int kallsyms_lookup_buildid(unsigned long addr,
 	ret = module_address_lookup(addr, symbolsize, offset,
 				    modname, modbuildid, namebuf);
 	if (!ret)
-		ret = bpf_address_lookup(addr, symbolsize,
-					 offset, modname, namebuf);
+		ret = bpf_address_lookup(addr, symbolsize, offset, namebuf);
 
 	if (!ret)
 		ret = ftrace_mod_address_lookup(addr, symbolsize,
-- 
2.51.0



