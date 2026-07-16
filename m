Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFF0220F3E;
	Thu, 16 Jul 2026 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210029; cv=none; b=K5gYGLsDmikV317LodOs6RbIB/sIBlAx7GfUhsSQs23wcjNXTBg4VO2fSAEGyJj0FLXWiPW050WDrTomb/UixmojBpB2dFbyiMi/7Nht5nTETRyzPj65tsCaC1CECRubDNTlOudTvHsCcFMpL3+85XPde/8B/rH/N5iHPBLN/Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210029; c=relaxed/simple;
	bh=bkuf6Yid6MDq5nisGurz8zhYXvJP055gcPlXPjAgR+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUWTg89yGrf8s1rbzkrNb5w3OmUSUhS7OE5YSqNTkw+805voIRddq0OinCh2bOoWwASiOO/O3iK7a1YJKTZUYGrXetgYZ3WPX+iR1l30RIqeozKyWPPPJL8JYEFYAh4zw0Ttam+OyYtK1s5FJsmOhfGZqcEmYnqFmP0ycqMP+vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzSYBOr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzSYBOr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CDD1F000E9;
	Thu, 16 Jul 2026 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210027;
	bh=mykUbkPnnIUHpBZLF+IqCATM2hf1zBI663XxYtoNCgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzSYBOr22F7v5uhiN2FkWBXi9EnmEGOl8ZaKAFMEuHNt0Eg45r1Jo/Vt6Zxd4YYIW
	 WdLfP068vQsv4aTAq/88PfDsWL5fcxBY5nJdYQ/96sulu/vRBBg48G02DuFDnB1/2Q
	 gukrYXVthTw09XRXP/z81AXxA7dpcwm8qTzefMJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Ren Wei <n05ec@lzu.edu.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 411/518] tracing: Prevent out-of-bounds read in glob matching
Date: Thu, 16 Jul 2026 15:31:19 +0200
Message-ID: <20260716133056.825778224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huihui Huang <hhhuang@smu.edu.sg>

commit 0a6070839b1ef276d5b05bedfb787743e140fb17 upstream.

String event fields are not necessarily NUL-terminated, so the filter
predicate functions (filter_pred_string(), filter_pred_strloc() and
filter_pred_strrelloc()) pass the field length to the regex match
callbacks, and the length-aware matchers honour it.

regex_match_glob() was the exception: it ignored the length and called
glob_match(), which scans the string until it hits a NUL byte. Some
string fields are not NUL-terminated. One example is the dynamic char
array of the xfs_* namespace tracepoints, which is copied without a
trailing NUL. For such a field, glob matching reads past the end of
the event field, causing a KASAN slab-out-of-bounds read in
glob_match(), reached via regex_match_glob() and filter_match_preds()
from the xfs_lookup tracepoint.

Add a length-bounded glob_match_len() and use it from regex_match_glob()
so glob matching always stops at the field boundary. The matching loop
is factored into a shared helper so glob_match() keeps its behaviour.

Fixes: 60f1d5e3bac4 ("ftrace: Support full glob matching")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/da1aaf125fc3b63320b0c540fd6afa7c3d5b4f1a.1782836943.git.hhhuang@smu.edu.sg
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/glob.h               |    1 +
 kernel/trace/trace_events_filter.c |    6 ++----
 lib/glob.c                         |   31 +++++++++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 6 deletions(-)

--- a/include/linux/glob.h
+++ b/include/linux/glob.h
@@ -6,5 +6,6 @@
 #include <linux/compiler.h>	/* For __pure */
 
 bool __pure glob_match(char const *pat, char const *str);
+bool __pure glob_match_len(char const *pat, char const *str, size_t len);
 
 #endif	/* _LINUX_GLOB_H */
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1056,11 +1056,9 @@ static int regex_match_end(char *str, st
 	return 0;
 }
 
-static int regex_match_glob(char *str, struct regex *r, int len __maybe_unused)
+static int regex_match_glob(char *str, struct regex *r, int len)
 {
-	if (glob_match(r->pattern, str))
-		return 1;
-	return 0;
+	return glob_match_len(r->pattern, str, len) ? 1 : 0;
 }
 
 /**
--- a/lib/glob.c
+++ b/lib/glob.c
@@ -11,6 +11,9 @@
 MODULE_DESCRIPTION("glob(7) matching");
 MODULE_LICENSE("Dual MIT/GPL");
 
+static bool __pure glob_match_str(char const *pat, char const *str,
+				  char const *str_end);
+
 /**
  * glob_match - Shell-style pattern matching, like !fnmatch(pat, str, 0)
  * @pat: Shell-style pattern to match, e.g. "*.[ch]".
@@ -41,6 +44,29 @@ MODULE_LICENSE("Dual MIT/GPL");
  */
 bool __pure glob_match(char const *pat, char const *str)
 {
+	return glob_match_str(pat, str, NULL);
+}
+EXPORT_SYMBOL(glob_match);
+
+/**
+ * glob_match_len - glob match against a length-bounded string
+ * @pat: Shell-style pattern to match.
+ * @str: String to match.  Need not be NUL-terminated.
+ * @len: Number of bytes of @str that may be read.
+ *
+ * Like glob_match(), but @str is only read up to @len bytes, so it can be
+ * used on buffers that are not NUL-terminated (e.g. trace event fields).
+ * A NUL byte within @len still terminates the string.
+ */
+bool __pure glob_match_len(char const *pat, char const *str, size_t len)
+{
+	return glob_match_str(pat, str, str + len);
+}
+EXPORT_SYMBOL(glob_match_len);
+
+static bool __pure glob_match_str(char const *pat, char const *str,
+				  char const *str_end)
+{
 	/*
 	 * Backtrack to previous * on mismatch and retry starting one
 	 * character later in the string.  Because * matches all characters
@@ -55,9 +81,11 @@ bool __pure glob_match(char const *pat,
 	 * on mismatch, or true after matching the trailing nul bytes.
 	 */
 	for (;;) {
-		unsigned char c = *str++;
+		unsigned char c = (str_end && str >= str_end) ? '\0' : *str;
 		unsigned char d = *pat++;
 
+		str++;
+
 		switch (d) {
 		case '?':	/* Wildcard: anything but nul */
 			if (c == '\0')
@@ -125,4 +153,3 @@ backtrack:
 		}
 	}
 }
-EXPORT_SYMBOL(glob_match);


