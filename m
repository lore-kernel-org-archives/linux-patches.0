Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A7927979A;
	Wed,  8 Apr 2026 18:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673521; cv=none; b=EVRgNu84udx3SK3Xulphag936zlGPZ1csESMbgj8ks3NnBj/vNeboxXLKgRunq+GqCIMAetZ3oSGy/oZZ1LFjF25WIOBPqs8zxixD/+iJbS7enB+0yY/R/CiLBPsI+G91+7Ca9kUTkqMmBpDF+f+dLMdrYEVK/NGKDvAlCuZrO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673521; c=relaxed/simple;
	bh=NpdFBDcWyt068K1Srk6u/6qFgBpB1cSIuvvesyF/ptY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA+I+/Xg9kqc5D74cqdo4RoS3lcVDA064qNcbLnpvfha1s5OqN9ZbU5OD4lU7WTzQExCzRgn8+8+mhVBihPQ1z97ybU6PSOGIBwnBau911Bqc7MFSiICgMk3auZUwSi7DqwvK2UztW7JdxG7FRsQZPAR7wM6TslBrue5lfXNI3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJmrLyjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJmrLyjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0E3C19421;
	Wed,  8 Apr 2026 18:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673521;
	bh=NpdFBDcWyt068K1Srk6u/6qFgBpB1cSIuvvesyF/ptY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJmrLyjUbYL/rnVqXOFJi5VOLXQEwuAylPrNNE8x5cwCttzykTzsodttLSGofUdil
	 /Hjk+7vXA0VOkYo45cUsMmowSGEZKNtBAbgyOSYZ5cYIqJtN7dze5Qab/Jegc4d+0F
	 iRwyE9Dpuo4wdL3dcikhWlNbsmpvdKeZkXG55HIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
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
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 265/277] kallsyms: cleanup code for appending the module buildid
Date: Wed,  8 Apr 2026 20:04:10 +0200
Message-ID: <20260408175943.753478414@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.com>

commit 8e81dac4cd5477731169b92cff7c24f8f6635950 upstream.

Put the code for appending the optional "buildid" into a helper function,
It makes __sprint_symbol() better readable.

Also print a warning when the "modname" is set and the "buildid" isn't.
It might catch a situation when some lookup function in
kallsyms_lookup_buildid() does not handle the "buildid".

Use pr_*_once() to avoid an infinite recursion when the function is called
from printk().  The recursion is rather theoretical but better be on the
safe side.

Link: https://lkml.kernel.org/r/20251128135920.217303-5-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
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
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kallsyms.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -434,6 +434,37 @@ int lookup_symbol_name(unsigned long add
 	return lookup_module_symbol_name(addr, symname);
 }
 
+#ifdef CONFIG_STACKTRACE_BUILD_ID
+
+static int append_buildid(char *buffer,  const char *modname,
+			  const unsigned char *buildid)
+{
+	if (!modname)
+		return 0;
+
+	if (!buildid) {
+		pr_warn_once("Undefined buildid for the module %s\n", modname);
+		return 0;
+	}
+
+	/* build ID should match length of sprintf */
+#ifdef CONFIG_MODULES
+	static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
+#endif
+
+	return sprintf(buffer, " %20phN", buildid);
+}
+
+#else /* CONFIG_STACKTRACE_BUILD_ID */
+
+static int append_buildid(char *buffer,   const char *modname,
+			  const unsigned char *buildid)
+{
+	return 0;
+}
+
+#endif /* CONFIG_STACKTRACE_BUILD_ID */
+
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
 			   int symbol_offset, int add_offset, int add_buildid)
@@ -456,15 +487,8 @@ static int __sprint_symbol(char *buffer,
 
 	if (modname) {
 		len += sprintf(buffer + len, " [%s", modname);
-#if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
-		if (add_buildid && buildid) {
-			/* build ID should match length of sprintf */
-#if IS_ENABLED(CONFIG_MODULES)
-			static_assert(sizeof(typeof_member(struct module, build_id)) == 20);
-#endif
-			len += sprintf(buffer + len, " %20phN", buildid);
-		}
-#endif
+		if (add_buildid)
+			len += append_buildid(buffer + len, modname, buildid);
 		len += sprintf(buffer + len, "]");
 	}
 


