Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C3412B7A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="verOKHmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FD4C433C7;
	Mon, 23 Oct 2023 11:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059507;
	bh=EGysNac1veTBWzg0mbkcFV5L2Jg2iclnbt9hCC65PGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=verOKHmkQpCbu+0wwy0TA5dL4iaHRMnqt/KDjQfKvNJLwdBuX9IFX7o9Kx2aTr+DR
	 3Q7J5u8MIPU5EdxF9U7YbuUROZP5p8sqg2ZBnBH6yEDVpu9hCYmGbaRhAfLAVMmQSm
	 jqjfZivTAIJsJZEL0r32xrlotwEVnk5UXABf8X7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Francis Laniel <flaniel@linux.microsoft.com>
Subject: [PATCH 6.5 200/241] tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols
Date: Mon, 23 Oct 2023 12:56:26 +0200
Message-ID: <20231023104838.739282488@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francis Laniel <flaniel@linux.microsoft.com>

commit b022f0c7e404887a7c5229788fc99eff9f9a80d5 upstream.

When a kprobe is attached to a function that's name is not unique (is
static and shares the name with other functions in the kernel), the
kprobe is attached to the first function it finds. This is a bug as the
function that it is attaching to is not necessarily the one that the
user wants to attach to.

Instead of blindly picking a function to attach to what is ambiguous,
error with EADDRNOTAVAIL to let the user know that this function is not
unique, and that the user must use another unique function with an
address offset to get to the function they want to attach to.

Link: https://lore.kernel.org/all/20231020104250.9537-2-flaniel@linux.microsoft.com/

Cc: stable@vger.kernel.org
Fixes: 413d37d1eb69 ("tracing: Add kprobe-based event tracer")
Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
Link: https://lore.kernel.org/lkml/20230819101105.b0c104ae4494a7d1f2eea742@kernel.org/
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |   63 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |    1 
 2 files changed, 64 insertions(+)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -705,6 +705,25 @@ static struct notifier_block trace_kprob
 	.priority = 1	/* Invoked after kprobe module callback */
 };
 
+static int count_symbols(void *data, unsigned long unused)
+{
+	unsigned int *count = data;
+
+	(*count)++;
+
+	return 0;
+}
+
+static unsigned int number_of_same_symbols(char *func_name)
+{
+	unsigned int count;
+
+	count = 0;
+	kallsyms_on_each_match_symbol(count_symbols, func_name, &count);
+
+	return count;
+}
+
 static int __trace_kprobe_create(int argc, const char *argv[])
 {
 	/*
@@ -836,6 +855,31 @@ static int __trace_kprobe_create(int arg
 		}
 	}
 
+	if (symbol && !strchr(symbol, ':')) {
+		unsigned int count;
+
+		count = number_of_same_symbols(symbol);
+		if (count > 1) {
+			/*
+			 * Users should use ADDR to remove the ambiguity of
+			 * using KSYM only.
+			 */
+			trace_probe_log_err(0, NON_UNIQ_SYMBOL);
+			ret = -EADDRNOTAVAIL;
+
+			goto error;
+		} else if (count == 0) {
+			/*
+			 * We can return ENOENT earlier than when register the
+			 * kprobe.
+			 */
+			trace_probe_log_err(0, BAD_PROBE_ADDR);
+			ret = -ENOENT;
+
+			goto error;
+		}
+	}
+
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, gbuf,
@@ -1699,6 +1743,7 @@ static int unregister_kprobe_event(struc
 }
 
 #ifdef CONFIG_PERF_EVENTS
+
 /* create a trace_kprobe, but don't add it to global lists */
 struct trace_event_call *
 create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
@@ -1709,6 +1754,24 @@ create_local_trace_kprobe(char *func, vo
 	int ret;
 	char *event;
 
+	if (func) {
+		unsigned int count;
+
+		count = number_of_same_symbols(func);
+		if (count > 1)
+			/*
+			 * Users should use addr to remove the ambiguity of
+			 * using func only.
+			 */
+			return ERR_PTR(-EADDRNOTAVAIL);
+		else if (count == 0)
+			/*
+			 * We can return ENOENT earlier than when register the
+			 * kprobe.
+			 */
+			return ERR_PTR(-ENOENT);
+	}
+
 	/*
 	 * local trace_kprobes are not added to dyn_event, so they are never
 	 * searched in find_trace_kprobe(). Therefore, there is no concern of
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -438,6 +438,7 @@ extern int traceprobe_define_arg_fields(
 	C(BAD_MAXACT,		"Invalid maxactive number"),		\
 	C(MAXACT_TOO_BIG,	"Maxactive is too big"),		\
 	C(BAD_PROBE_ADDR,	"Invalid probed address or symbol"),	\
+	C(NON_UNIQ_SYMBOL,	"The symbol is not unique"),		\
 	C(BAD_RETPROBE,		"Retprobe address must be an function entry"), \
 	C(NO_TRACEPOINT,	"Tracepoint is not found"),		\
 	C(BAD_ADDR_SUFFIX,	"Invalid probed address suffix"), \


