Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B336C9F0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302374; cv=none; b=Z9sXBFLpWmVIQpoAe+nYeNHqFuTPJ/esbxQ5ofXqcWC/KU49RHldKhMOSH3wnyRzgHiR7WhdgjnCKdqGiCNlxGnyQZt2YuOBbHrvu22MZxmP7JpamG2PBw7z/pZq7sqHpZHIDuOxNwNVwN5VqS+fm9dxbBPlJ+X4QjxHI2+alL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302374; c=relaxed/simple;
	bh=QenyCUkpKrr9gtIuDh4lMhw+Ifj5bjb9GDb/SCw42PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2oaSP6B0/0ZyRYOuCArsOSTrIvOr9LrJH00wa91Qm4yW+bjmJpNJZ8iaymIwrFvbjcay0/Hi2E1Hsx7GVZnx3Y+H/2Svmd9Ym7M1yLfyBU3QRpsIGROp9dcLsQRnB+2Wh5jyznrJF7d2cog22cpcNqhIfzZBBQxqM8SFMfHKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WazDMw7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WazDMw7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99210C116D0;
	Sat, 28 Feb 2026 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302374;
	bh=QenyCUkpKrr9gtIuDh4lMhw+Ifj5bjb9GDb/SCw42PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WazDMw7k1GJYjf0onAVzkKT2JQP6DkvuB5Z+ALjiPid9aww7IRWJojGxDR0tcNtSb
	 WagIHrx3Hpf+xYACqjIVcTpGRDDarLdTtZP5N3FoT5XkB950krnIcaRpjQKx5V0UJp
	 /l/P0syCELxN7AaOLu8D6wLD9yT37+y73KQwcSYHfQRzNpKZRyJD7BMzAEN0UutQrY
	 uyHSnReJpitABpBosh+SroDNxTcmRtwz+9bWbm9DSzO4RM8Nf39H/aXgvln3ecFYv/
	 wPPkGBSGjbSmeRJWvOTiShCaMqm0Yq8Nsq6aELZEhJF2QlezewKtSc2tBNbMmZ51eD
	 H0CYqVCkJMBQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Mladek <pmladek@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkman <daniel@iogearbox.net>,
	Daniel Gomez <da.gomez@samsung.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/232] kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
Date: Sat, 28 Feb 2026 13:09:14 -0500
Message-ID: <20260228181127.1592657-101-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit e8a1e7eaa19d0b757b06a2f913e3eeb4b1c002c6 ]

__sprint_symbol() might access an invalid pointer when
kallsyms_lookup_buildid() returns a symbol found by
ftrace_mod_address_lookup().

The ftrace lookup function must set both @modname and @modbuildid the same
way as module_address_lookup().

Link: https://lkml.kernel.org/r/20251128135920.217303-7-pmladek@suse.com
Fixes: 9294523e3768 ("module: add printk formats to add module build ID to stacktraces")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace.h | 6 ++++--
 kernel/kallsyms.c      | 4 ++--
 kernel/trace/ftrace.c  | 5 ++++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8128059db5ed7..d29b74e4e7c3d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -75,11 +75,13 @@ struct ftrace_direct_func;
 	defined(CONFIG_DYNAMIC_FTRACE)
 const char *
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym);
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym);
 #else
 static inline const char *
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	return NULL;
 }
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 5e98cd80eed89..5a3ae3365049b 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -434,8 +434,8 @@ static const char *kallsyms_lookup_buildid(unsigned long addr,
 					 offset, modname, namebuf);
 
 	if (!ret)
-		ret = ftrace_mod_address_lookup(addr, symbolsize,
-						offset, modname, namebuf);
+		ret = ftrace_mod_address_lookup(addr, symbolsize, offset,
+						modname, modbuildid, namebuf);
 
 found:
 	cleanup_symbol_name(namebuf);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e24906e7fcc5d..7217b872ff4ff 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7230,7 +7230,8 @@ ftrace_func_address_lookup(struct ftrace_mod_map *mod_map,
 
 const char *
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	struct ftrace_mod_map *mod_map;
 	const char *ret = NULL;
@@ -7242,6 +7243,8 @@ ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
 		if (ret) {
 			if (modname)
 				*modname = mod_map->mod->name;
+			if (modbuildid)
+				*modbuildid = module_buildid(mod_map->mod);
 			break;
 		}
 	}
-- 
2.51.0

