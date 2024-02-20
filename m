Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC4A612D7;
	Tue, 20 Feb 2024 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463872; cv=none; b=h+fdr3Xc8VPCFwjuh0Q97O8+FQZFFeGz8hzMq1/gZZ8e0oKF/K9oMgiGpuwUj962UxvVaVU8x1pfzAO12KQNAwJ+fLGNHCZIeOIc6tzeVs8Ysl38hBpIvJeRz5MN24MDG1i1ebMkeVJG3cj1lgp0TFuo27Q08RqcQe3htu/cELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463872; c=relaxed/simple;
	bh=PPZFln0CZL1SdS7OpZT846ps0/1gmJQXo+l7ke+ujoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTA1lho9ZwrlJN8BRB4tZIcomrrdqUB4LTl1giMvzMAeXKp5TNme6skdHgMp46hibH4KKYXTTyjdiZ/jrgka1R50AR5mehM3hWr3/vjc2HW+JkgYIueSwQUYSayU1UGG1NbfJF8VDDK8Lb8f/lCfwjrhgs/obGF1xNjfxJVdVBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUItbYob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUItbYob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8CBC433C7;
	Tue, 20 Feb 2024 21:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463871;
	bh=PPZFln0CZL1SdS7OpZT846ps0/1gmJQXo+l7ke+ujoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUItbYobtEGW5GYBawQZZtiDtgeQZec976yJsp1uHjZAInmrDNBD0hiXCdfjoHA8a
	 KmgEoogJUq1YczYISIcfS59SoPyrXzDnfzwXhJjtKr+e7UUa4wpDXpKOQLGYhufZce
	 RzaNf5pYS1sEgA7iNxtKscP2/pyvq4TmQpcwopqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 151/331] tracing/probes: Fix to show a parse error for bad type for $comm
Date: Tue, 20 Feb 2024 21:54:27 +0100
Message-ID: <20240220205642.286514762@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


