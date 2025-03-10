Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99054231A5F;
	Mon, 10 Mar 2025 17:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626882; cv=none; b=g/+nH4CnE+ECFJLx5fk9oYhC8JatbJmdgiWrVtrC8zlBXa8sxPFtMr+4GlJx4x5mPRKr+HgsUyPDl2lt6LBMD8ScHPFDtkHV49gny3AlxXr1mxSDplkRRa33oemPt/dqVl7POcfe31hq/nmrcjG9ty0jvdjnr5ZTS3yLRNXmkyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626882; c=relaxed/simple;
	bh=WQf/j+EigYYr+IYGz3qX4YGkg04WUFkg8EqkbtbHAzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR1pO17MyITTUxkPZp5xXPsMmjiMN5lYjFKHjPA1N5O6YRO+HB92J7we5aS46If73EuHMfYXZsXMWs7Xu752D2588wxgL8r34bpr9Pci7LJE/J6WoOAgUx2ZmC5UYk63vIPECVerNUDtSx3SZ0WtSbpIJ/XSnpq4vpHTZngebRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoEcP1/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoEcP1/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2057AC4CEE5;
	Mon, 10 Mar 2025 17:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626882;
	bh=WQf/j+EigYYr+IYGz3qX4YGkg04WUFkg8EqkbtbHAzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoEcP1/fl9XB/L0bJZdF/eHW24k6RNHGscsXqTpQVY0iVOi2gKVwLLrmkXnIfVmh2
	 nx8y70Oz8f5D84GDSijXmkVT/cdCFvlIFM/HsEFQm/NcqiskD3AEJf0qxgIugq4Twp
	 Hnxuy2U/jLhUmrGZ/d6z0fvZ1wwSJ7FhIbLBwSeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 103/207] tracing: fprobe-events: Log error for exceeding the number of entry args
Date: Mon, 10 Mar 2025 18:04:56 +0100
Message-ID: <20250310170451.859546701@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit db5e228611b118cf7b1f8084063feda5c037f4a7 ]

Add error message when the number of entry argument exceeds the
maximum size of entry data.
This is currently checked when registering fprobe, but in this case
no error message is shown in the error_log file.

Link: https://lore.kernel.org/all/174055074269.4079315.17809232650360988538.stgit@mhiramat.tok.corp.google.com/

Fixes: 25f00e40ce79 ("tracing/probes: Support $argN in return probe (kprobe and fprobe)")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_fprobe.c | 5 +++++
 kernel/trace/trace_probe.h  | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index d906baba2d40c..94fe261218771 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1242,6 +1242,11 @@ static int __trace_fprobe_create(int argc, const char *argv[])
 	if (is_return && tf->tp.entry_arg) {
 		tf->fp.entry_handler = trace_fprobe_entry_handler;
 		tf->fp.entry_data_size = traceprobe_get_entry_data_size(&tf->tp);
+		if (ALIGN(tf->fp.entry_data_size, sizeof(long)) > MAX_FPROBE_DATA_SIZE) {
+			trace_probe_log_set_index(2);
+			trace_probe_log_err(0, TOO_MANY_EARGS);
+			return -E2BIG;
+		}
 	}
 
 	ret = traceprobe_set_print_fmt(&tf->tp,
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index fba3ede870541..c47ca002347a7 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -545,7 +545,8 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(NO_BTF_FIELD,		"This field is not found."),	\
 	C(BAD_BTF_TID,		"Failed to get BTF type info."),\
 	C(BAD_TYPE4STR,		"This type does not fit for string."),\
-	C(NEED_STRING_TYPE,	"$comm and immediate-string only accepts string type"),
+	C(NEED_STRING_TYPE,	"$comm and immediate-string only accepts string type"),\
+	C(TOO_MANY_EARGS,	"Too many entry arguments specified"),
 
 #undef C
 #define C(a, b)		TP_ERR_##a
-- 
2.39.5



