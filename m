Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D3428505E;
	Thu, 16 Jul 2026 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211342; cv=none; b=Wr7X4wKQgcVmmmSMO6rojbtUVJUU0w4Ek77z3guzdsozbqiY3sH//NPHfovNSdNB5HuIG51yrkBiCAfaPAw0Ij56ilvRG4InBISV+AdSw4mRiVbUYE5DWJsQkQlYk4MN8DpXTidMuO/ANM+7ZKe6mjZ+k5LO9hegSh/M0DC51b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211342; c=relaxed/simple;
	bh=QszJepSuE55AUYiMzJOO7ncelMe7DDknL1oS5Lb+QjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZybKvd+ETyOwWjnyJI3vISKgLig+CsoGW7F0vcRvTF0QIbifULhHFOu/I/Xdm7FkSlbiFIhf/NQe3LGlDLfMe9ksqhcGgiDFfh6Pw1rwF5mafojRhL+ALE0+a7TFWYe6tB/Z+YqOxd3m+27CCpB4gCyppAnofgqsq0UZULSwH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDG54pDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDG54pDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B998F1F000E9;
	Thu, 16 Jul 2026 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211341;
	bh=SstOT6DkhdQcj4+JDDGnHbQuiFhycafoP9hiVyK1Z0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDG54pDLiM5n6l517I75ZmNIgIwWm7VS+MmpLStePATXR0qoIMN6jKFVxT2gp5XQG
	 hZetnS7a+Sj1AI/KinB6BK12kMbdB4gWHgQEFbKaz5rnknNy29705sjGf/Ueo2fPqB
	 56FEqofvuSuiTf9+zf6DaVtbK4vzGSd6onpkEtl4=
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
Subject: [PATCH 6.18 391/480] tracing: Prevent out-of-bounds read in glob matching
Date: Thu, 16 Jul 2026 15:32:18 +0200
Message-ID: <20260716133053.257739557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -9,6 +9,9 @@
 MODULE_DESCRIPTION("glob(7) matching");
 MODULE_LICENSE("Dual MIT/GPL");
 
+static bool __pure glob_match_str(char const *pat, char const *str,
+				  char const *str_end);
+
 /**
  * glob_match - Shell-style pattern matching, like !fnmatch(pat, str, 0)
  * @pat: Shell-style pattern to match, e.g. "*.[ch]".
@@ -39,6 +42,29 @@ MODULE_LICENSE("Dual MIT/GPL");
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
@@ -53,9 +79,11 @@ bool __pure glob_match(char const *pat,
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
@@ -122,4 +150,3 @@ backtrack:
 		}
 	}
 }
-EXPORT_SYMBOL(glob_match);


