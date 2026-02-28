Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C525338D01D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302130; cv=none; b=ijFHtWh5Ob0fxpf7ICpwcgbOi+aOEaguGbfrVzoTnkOiLB3H2NUk5waZNpm4zAp6VskzwiaeaMfp+ITva1CwjT+LAxClv4l5Q/IZwjoTIeRcnPXuHK/+JN+0LAyqponm1eQ5yNX2EWCil59H2fosA5xgyHs8j28DmG16L7CLStk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302130; c=relaxed/simple;
	bh=PaUtHwlJmDhGtSLWELDjUxSLImKbD6wZMMeeY6Zmq6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI0U7iKOsIZFwgz9uGOTSBPEeJXePsRJoqbDPtjpcboMqLpOuX45SLnzCQ1I2jpZU4bnjCnJO8Qou6NHfLy0NsB22CsyNG3vS58QS6KL16rVb+83YjSLXDCWF5ebMk4ayEHeWzaHP6HJ0dQUKgRyKaW6V7hh/sQ2vKd5xuJO7zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSkR0IU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSkR0IU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274AFC19425;
	Sat, 28 Feb 2026 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302130;
	bh=PaUtHwlJmDhGtSLWELDjUxSLImKbD6wZMMeeY6Zmq6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSkR0IU5m04ifd/k/hpESJnjzwV5phV25LwM50cWFWgzRii9d5EUgnWiqBK1LDcB+
	 VH/ah2h5YRke3bpcfVAz0+yOYgGH4sFMpqBozBW7IV2gVFfixRt9MlFaMMC3BhyHTD
	 WKNNbLUMRCWYQK++KzT9zgtVWZEIuRV6UBOZ1vxDED0l646noyRWWlFcQ8u2j/gPE5
	 Fs/rgO0/iBInl+YkwLckL+4rUp3WylIISZIPDWTbI8AqWqPvoheR+6PqDSSLHZqEK+
	 WG3ZHqMbNIZzvnB07XyKJFg7NOxTWeOxTtLawHZrzQN8n0qbJHMUSQnYWQ21Sff5/U
	 e/fQY8Ll7LyUQ==
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
Subject: [PATCH 6.6 121/283] kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
Date: Sat, 28 Feb 2026 13:04:23 -0500
Message-ID: <20260228180709.1583486-121-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index e8921871ef9aa..5c3eaf9fc90c4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -89,11 +89,13 @@ struct ftrace_direct_func;
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
index 07f33601cac28..cd44e9c427533 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -431,8 +431,8 @@ static const char *kallsyms_lookup_buildid(unsigned long addr,
 					 offset, modname, namebuf);
 
 	if (!ret)
-		ret = ftrace_mod_address_lookup(addr, symbolsize,
-						offset, modname, namebuf);
+		ret = ftrace_mod_address_lookup(addr, symbolsize, offset,
+						modname, modbuildid, namebuf);
 
 found:
 	cleanup_symbol_name(namebuf);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8f2d44e741510..94f7ed57d43e5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7046,7 +7046,8 @@ ftrace_func_address_lookup(struct ftrace_mod_map *mod_map,
 
 const char *
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	struct ftrace_mod_map *mod_map;
 	const char *ret = NULL;
@@ -7058,6 +7059,8 @@ ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
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

