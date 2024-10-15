Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8DC1DD0C9;
	Tue, 15 Oct 2024 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998327; cv=none; b=GHHRpzBUji942xPFgUT5cPi5Ex3KuQQPUjxk6VDdY4m+RUcdUlhTyarZFv6WG6br3xS9UhH76nGzr4nedhH2MTY8Gf1QKxpJgefdlsREKhKLqPF9wVagATbdSvpjB6rHZKie2B6sPfxrw5gBdu1lpcUG5b2PvgSCr5zZ/Zeei9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998327; c=relaxed/simple;
	bh=RJHbL4I9Ln4VD6cnyPCiOjWJ1t1Y3bTbhW9LyZAExsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tla0d41fy1Um/UDeXz7ferqSekMREhm4hmxif7F6jJgLRt/RrInobusDuHwjW19byZm+vlKZJtPVaH82Stw8TCg7WMrNJw7RdXoIxWJW7pAvSNS0pENoMXDxyyJEw9NAjOBC/qvA5lUVcWPWfvi1KcJXRaPIBiTJmN4RZIuJt38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+SlO9SK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+SlO9SK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD44C4CED2;
	Tue, 15 Oct 2024 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998327;
	bh=RJHbL4I9Ln4VD6cnyPCiOjWJ1t1Y3bTbhW9LyZAExsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+SlO9SK0PBdG8vRqMtUlHbOOndZJJ3haUfw1pTrllMaF+1Vdj0AceoSXx7YxS/v+
	 N1pzQv4N7HRjj6K0+lZGH6hNzoZ2q9cOdR5zzAhb9cFt9Mw5rY0qwVCBwSzB/QUqSf
	 nWlGz/t6mtTzxh3hAy8DEgidLUY5GfVEji6RuGUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Francis Laniel <flaniel@linux.microsoft.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 446/518] tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols
Date: Tue, 15 Oct 2024 14:45:50 +0200
Message-ID: <20241015123934.218620728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
[Sherry: 5.10.y added a new kselftest kprobe_non_uniq_symbol.tc by
backporting commit 09bcf9254838 ("selftests/ftrace: Add new test case which
checks non unique symbol"). However, 5.10.y didn't backport this commit which
provides unique symbol check suppport from kernel side. Minor conflicts due to
context change, ignore context change]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 74 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  1 +
 2 files changed, 75 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5453af26ff764..91dfe8cf1ce8b 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -715,6 +715,36 @@ static inline void sanitize_event_name(char *name)
 			*name = '_';
 }
 
+struct count_symbols_struct {
+	const char *func_name;
+	unsigned int count;
+};
+
+static int count_symbols(void *data, const char *name, struct module *unused0,
+			 unsigned long unused1)
+{
+	struct count_symbols_struct *args = data;
+
+	if (strcmp(args->func_name, name))
+		return 0;
+
+	args->count++;
+
+	return 0;
+}
+
+static unsigned int number_of_same_symbols(char *func_name)
+{
+	struct count_symbols_struct args = {
+		.func_name = func_name,
+		.count = 0,
+	};
+
+	kallsyms_on_each_symbol(count_symbols, &args);
+
+	return args.count;
+}
+
 static int trace_kprobe_create(int argc, const char *argv[])
 {
 	/*
@@ -842,6 +872,31 @@ static int trace_kprobe_create(int argc, const char *argv[])
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
 		ret = traceprobe_parse_event_name(&event, &group, buf,
@@ -1805,6 +1860,7 @@ static int unregister_kprobe_event(struct trace_kprobe *tk)
 }
 
 #ifdef CONFIG_PERF_EVENTS
+
 /* create a trace_kprobe, but don't add it to global lists */
 struct trace_event_call *
 create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
@@ -1814,6 +1870,24 @@ create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
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
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index d4a69b83902e1..22c05ca977587 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -390,6 +390,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(BAD_MAXACT,		"Invalid maxactive number"),		\
 	C(MAXACT_TOO_BIG,	"Maxactive is too big"),		\
 	C(BAD_PROBE_ADDR,	"Invalid probed address or symbol"),	\
+	C(NON_UNIQ_SYMBOL,	"The symbol is not unique"),		\
 	C(BAD_RETPROBE,		"Retprobe address must be an function entry"), \
 	C(BAD_ADDR_SUFFIX,	"Invalid probed address suffix"), \
 	C(NO_GROUP_NAME,	"Group name is not specified"),		\
-- 
2.43.0



