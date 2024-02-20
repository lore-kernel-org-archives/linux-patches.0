Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDAA151CCC;
	Tue, 20 Feb 2024 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464966; cv=none; b=C3paK/I6nQWgmVl2GH/sepbXjYt8sEgeZMIXxluTOrIdvXen6ALANRFDFZPkfQEUksv4JfmFEgxIbwflhN/uS4miNa85pqq5YECF5VzAEHnkfh0ry1a7e37dXokfWV/UnEqiTLC5s2Fgi78a5CFz7eaVUnCAU6Lkm7fQHFhqaVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464966; c=relaxed/simple;
	bh=eycE76pBycTlbN2Rpb8wixBHc0CV27Dj3XKzxvCN/GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEEUKphZ+uz4qqNMnAghrirQVT4+POYz/KMXel1LRlTreMX8lqedMd0Slfasw5nTTwhb3KMMIFQW8J8BHNugTZLZVnqm8Fo/eCUh6R1MUZYgikH7YNZg+jfocWaWgwycSrWkIiAiXemkOJRWXy87CoZZJWT7UJVvNnXDD7KskC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQECfiVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQECfiVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917A5C433C7;
	Tue, 20 Feb 2024 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464966;
	bh=eycE76pBycTlbN2Rpb8wixBHc0CV27Dj3XKzxvCN/GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQECfiVjAGkSvkk5ieQILwcm7xXdTUrVmwjpknLAzUIUJloFhZ4ktMYBx9uICyyI0
	 LygkwwYrCjt8+wLhT/nAPNMTQgvvLmr1DRYEgzX+GP6bnwcY6aZMZAqy9PXPZXSfg/
	 h0fA98ENNAsODxNIlX8CZinBzTbeDxNpKnHzGtx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.7 164/309] tracing/probes: Fix to show a parse error for bad type for $comm
Date: Tue, 20 Feb 2024 21:55:23 +0100
Message-ID: <20240220205638.289396666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 8c427cc2fa73684ea140999e121b7b6c1c717632 upstream.

Fix to show a parse error for bad type (non-string) for $comm/$COMM and
immediate-string. With this fix, error_log file shows appropriate error
message as below.

 /sys/kernel/tracing # echo 'p vfs_read $comm:u32' >> kprobe_events
sh: write error: Invalid argument
 /sys/kernel/tracing # echo 'p vfs_read \"hoge":u32' >> kprobe_events
sh: write error: Invalid argument
 /sys/kernel/tracing # cat error_log

[   30.144183] trace_kprobe: error: $comm and immediate-string only accepts string type
  Command: p vfs_read $comm:u32
                            ^
[   62.618500] trace_kprobe: error: $comm and immediate-string only accepts string type
  Command: p vfs_read \"hoge":u32
                              ^
Link: https://lore.kernel.org/all/170602215411.215583.2238016352271091852.stgit@devnote2/

Fixes: 3dd1f7f24f8c ("tracing: probeevent: Fix to make the type of $comm string")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    7 +++++--
 kernel/trace/trace_probe.h |    3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1159,9 +1159,12 @@ static int traceprobe_parse_probe_arg_bo
 	if (!(ctx->flags & TPARG_FL_TEVENT) &&
 	    (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0 ||
 	     strncmp(arg, "\\\"", 2) == 0)) {
-		/* The type of $comm must be "string", and not an array. */
-		if (parg->count || (t && strcmp(t, "string")))
+		/* The type of $comm must be "string", and not an array type. */
+		if (parg->count || (t && strcmp(t, "string"))) {
+			trace_probe_log_err(ctx->offset + (t ? (t - arg) : 0),
+					NEED_STRING_TYPE);
 			goto out;
+		}
 		parg->type = find_fetch_type("string", ctx->flags);
 	} else
 		parg->type = find_fetch_type(t, ctx->flags);
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -515,7 +515,8 @@ extern int traceprobe_define_arg_fields(
 	C(BAD_HYPHEN,		"Failed to parse single hyphen. Forgot '>'?"),	\
 	C(NO_BTF_FIELD,		"This field is not found."),	\
 	C(BAD_BTF_TID,		"Failed to get BTF type info."),\
-	C(BAD_TYPE4STR,		"This type does not fit for string."),
+	C(BAD_TYPE4STR,		"This type does not fit for string."),\
+	C(NEED_STRING_TYPE,	"$comm and immediate-string only accepts string type"),
 
 #undef C
 #define C(a, b)		TP_ERR_##a


