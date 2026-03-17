Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F802DECC6;
	Tue, 17 Mar 2026 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768222; cv=none; b=vBYeY+jPtxGALxWXQyklav5exsPsITRw3aFrI6+yjsLVYDw+fKmGSKn7bwPuKeWi3irw4FOco1Iv/BLPdgxqIdePjFdBGeFbjzU+EXUuNQ0TH0BmqTO7Ro9sM+MpOkM9GxkvrO61m7l3/TX6C3n6MN9Gy7P2VzpoDsBUm5Ir3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768222; c=relaxed/simple;
	bh=sinkKH5kMEc/NP4LhgbP45TeW6ldarB3rNqLPxCMHak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X46OAPkDeFjv61Y1vIDDONw3kCBemUKzy2TsggycloER/n/RGmXA1AtCZrr8HSMJoleqRj1nkLJHbQWvBaIPDxxJhC7AjBWzd4VonUgFBEcAr3XOazEyONPKQ1LsNwXVG0ZHVGzvj/We3HBFSFnbEjE086BkqsVLUQPz8V7Y1Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZscHh7W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZscHh7W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DB6C4CEF7;
	Tue, 17 Mar 2026 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768221;
	bh=sinkKH5kMEc/NP4LhgbP45TeW6ldarB3rNqLPxCMHak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZscHh7W1hlXDv+7j3g6r/ce7gQW2DBlsLxRkbNTG0wXyAFICtz3XrIZHSQPQupB8C
	 iBu4pBLcqCGCcNSfoTNBGMnTxVVfdyqFuV8pMJQxsGf0mRctpUYOaP5RPI5wcaUJq2
	 wiRH1vly06oAVhmee8zmgZTtZZH3aHDdOHWROZB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrei-Alexandru Tachici <andrei-alexandru.tachici@oss.qualcomm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.18 261/333] tracing: Fix enabling multiple events on the kernel command line and bootconfig
Date: Tue, 17 Mar 2026 17:34:50 +0100
Message-ID: <20260317163009.048168259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Andrei-Alexandru Tachici <andrei-alexandru.tachici@oss.qualcomm.com>

commit 3b1679e086bb869ca02722f6bd29b3573a6a0e7e upstream.

Multiple events can be enabled on the kernel command line via a comma
separator. But if the are specified one at a time, then only the last
event is enabled. This is because the event names are saved in a temporary
buffer, and each call by the init cmdline code will reset that buffer.

This also affects names in the boot config file, as it may call the
callback multiple times with an example of:

  kernel.trace_event = ":mod:rproc_qcom_common", ":mod:qrtr", ":mod:qcom_aoss"

Change the cmdline callback function to append a comma and the next value
if the temporary buffer already has content.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260302-trace-events-allow-multiple-modules-v1-1-ce4436e37fb8@oss.qualcomm.com
Signed-off-by: Andrei-Alexandru Tachici <andrei-alexandru.tachici@oss.qualcomm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -4342,7 +4342,11 @@ static char bootup_event_buf[COMMAND_LIN
 
 static __init int setup_trace_event(char *str)
 {
-	strscpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
+	if (bootup_event_buf[0] != '\0')
+		strlcat(bootup_event_buf, ",", COMMAND_LINE_SIZE);
+
+	strlcat(bootup_event_buf, str, COMMAND_LINE_SIZE);
+
 	trace_set_ring_buffer_expanded(NULL);
 	disable_tracing_selftest("running event tracing");
 


