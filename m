Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DFB2676E1;
	Tue,  8 Apr 2025 12:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113704; cv=none; b=AIgJMA+9EILFMfheY8Newln3NdN7aEPIVVnPy3g0y2uA8aV6d6KQt0+ghPcW/O1Tqc1nG9sSKdYMDXBMsiETNa+7bdkrCDHWc0v6QlKsB3uKgBkmwpmsEKayE6EowVmYKdjxENI16bd8rlAoeq8NlKygdzJLSQXRBZYHA83E2xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113704; c=relaxed/simple;
	bh=X83oP+qq8vZ3elJyhKTpdhTKGjmCP8+o0BjkVe2kq6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOcoCbRDu5LClM/VTccOqd7swgKss3GbxmgCHIWN57H4FoeS3FMlF87+h7Hk2agzoiaA6zZt2TMN8XAdQHn3o88dgTGWLSJK8APjnlxl59t89Oio4gMdXzYG6Dl7ZxhGLBGo7IJmsJO7s9exuKR3GzwbHAHpdUkx5TsdClxPejw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rl6VL0RC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rl6VL0RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41804C4CEE5;
	Tue,  8 Apr 2025 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113703;
	bh=X83oP+qq8vZ3elJyhKTpdhTKGjmCP8+o0BjkVe2kq6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rl6VL0RCJH9xAk1ABi4FLv2ngRtGPFxKDMHIZchOpnZZSjhuSAkuY+1m+6ttMPi2V
	 C6r0BiwrGPYamRrfgsGb1d5XzLAWIu+LTcNjTWO9pb3j2CFr7vvsd4KZ5I6Fy8VTqY
	 kzYIDV7yKyWjVMIFu+FTRHu8HwnqW50M7ROmaNHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 258/268] tracing: Fix synth event printk format for str fields
Date: Tue,  8 Apr 2025 12:51:09 +0200
Message-ID: <20250408104835.539704325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Raillard <douglas.raillard@arm.com>

commit 4d38328eb442dc06aec4350fd9594ffa6488af02 upstream.

The printk format for synth event uses "%.*s" to print string fields,
but then only passes the pointer part as var arg.

Replace %.*s with %s as the C string is guaranteed to be null-terminated.

The output in print fmt should never have been updated as __get_str()
handles the string limit because it can access the length of the string in
the string meta data that is saved in the ring buffer.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 8db4d6bfbbf92 ("tracing: Change synthetic event string format to limit printed length")
Link: https://lore.kernel.org/20250325165202.541088-1-douglas.raillard@arm.com
Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -312,7 +312,7 @@ static const char *synth_field_fmt(char
 	else if (strcmp(type, "gfp_t") == 0)
 		fmt = "%x";
 	else if (synth_field_is_string(type))
-		fmt = "%.*s";
+		fmt = "%s";
 	else if (synth_field_is_stack(type))
 		fmt = "%s";
 


