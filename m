Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DABBAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ECAC433F0;
	Wed,  4 Jan 2023 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849280;
	bh=nk6nCgwGF1vEsIkqS/S6w6IFykDogDFUH3eMqjT2yT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRlQCZhHIELODiYxiqt3kmUrNv8oFz4X7ud2S+fS36CdQdkQXEp0DH35c8rGYU/d7
	 xKYS7iuqHlGGvfKCo2nHRQkqG4TngtToaEHqdxZ3cyHtUquWvnxXQHsJ0UR6yYlYAz
	 JdVjfyZbsLqC3IZYnKuU2SgEeAnuT4EUzzxXKaA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 071/177] tracing/probes: Handle system names with hyphens
Date: Wed,  4 Jan 2023 17:06:02 +0100
Message-Id: <20230104160509.808601798@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 575b76cb885532aae13a9d979fd476bb2b156cb9 upstream.

When creating probe names, a check is done to make sure it matches basic C
standard variable naming standards. Basically, starts with alphabetic or
underline, and then the rest of the characters have alpha-numeric or
underline in them.

But system names do not have any true naming conventions, as they are
created by the TRACE_SYSTEM macro and nothing tests to see what they are.
The "xhci-hcd" trace events has a '-' in the system name. When trying to
attach a eprobe to one of these trace points, it fails because the system
name does not follow the variable naming convention because of the
hyphen, and the eprobe checks fail on this.

Allow hyphens in the system name so that eprobes can attach to the
"xhci-hcd" trace events.

Link: https://lore.kernel.org/all/Y3eJ8GiGnEvVd8%2FN@macondo/
Link: https://lore.kernel.org/linux-trace-kernel/20221122122345.160f5077@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 5b7a96220900e ("tracing/probe: Check event/group naming rule at parsing")
Reported-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h       |   19 ++++++++++++++++---
 kernel/trace/trace_probe.c |    2 +-
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1966,17 +1966,30 @@ static __always_inline void trace_iterat
 }
 
 /* Check the name is good for event/group/fields */
-static inline bool is_good_name(const char *name)
+static inline bool __is_good_name(const char *name, bool hash_ok)
 {
-	if (!isalpha(*name) && *name != '_')
+	if (!isalpha(*name) && *name != '_' && (!hash_ok || *name != '-'))
 		return false;
 	while (*++name != '\0') {
-		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_' &&
+		    (!hash_ok || *name != '-'))
 			return false;
 	}
 	return true;
 }
 
+/* Check the name is good for event/group/fields */
+static inline bool is_good_name(const char *name)
+{
+	return __is_good_name(name, false);
+}
+
+/* Check the name is good for system */
+static inline bool is_good_system_name(const char *name)
+{
+	return __is_good_name(name, true);
+}
+
 /* Convert certain expected symbols into '_' when generating event names */
 static inline void sanitize_event_name(char *name)
 {
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -246,7 +246,7 @@ int traceprobe_parse_event_name(const ch
 			return -EINVAL;
 		}
 		strlcpy(buf, event, slash - event + 1);
-		if (!is_good_name(buf)) {
+		if (!is_good_system_name(buf)) {
 			trace_probe_log_err(offset, BAD_GROUP_NAME);
 			return -EINVAL;
 		}


