Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7AF148316;
	Mon,  6 Jan 2025 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177373; cv=none; b=fYMs/VjRBTIpXZtctV32nQ0kHtTJQqWS0WwwbqvHV77gA5dSLn/+5KUvbGI3a3xtjdRDno6Pw7PKn38HB8o2wqQISI589SeqGD5y2F0PHig8hRSuYnKrvD/KkvozwCWBFJaw6gg/sqJ/3Ee/OvFqCdt/uifUobb8LjIzpNLCKKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177373; c=relaxed/simple;
	bh=qhqQgIEDGW6HjSl/vgG0c+xZaXjXbCmAAsyRPfppGIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdHmjOMAoKBuJKLuTc/bhFVOwqty2EjRCyNYhbNpfMctx/1YaDKY06h6KBPuKGrSDWEd2dYry5VeSnLup4mtL5biNPeWaxbEEK8/0StIa2R+rSS4yYvXTp7FRNfv1KJnjSZuumVrANkJvZQaqjKzQYi41xP+/pP7FOTDfzWPdJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQOoPLvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQOoPLvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15767C4CED6;
	Mon,  6 Jan 2025 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177373;
	bh=qhqQgIEDGW6HjSl/vgG0c+xZaXjXbCmAAsyRPfppGIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQOoPLviUGpOjj6xwSnX+jDr8BSDlLiR6X7zLTU8ckulRJAADWw1pBd01L1fQlETS
	 rUP3+cNFBWfbwvhvGo0ImKqrZi5BEx7lz+e5VZ8H77043BtOfRNwvWdlc26pIo2s9s
	 HQ1hwp44RwCSYVORbV5A8w6HHsJuM2QVDZHD/Xf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/222] tracing: Fix trace_check_vprintf() when tp_printk is used
Date: Mon,  6 Jan 2025 16:15:29 +0100
Message-ID: <20250106151155.340825943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 50a3242d84ee1625b0bfef29b95f935958dccfbe ]

When the tp_printk kernel command line is used, the trace events go
directly to printk(). It is still checked via the trace_check_vprintf()
function to make sure the pointers of the trace event are legit.

The addition of reading buffers from previous boots required adding a
delta between the addresses of the previous boot and the current boot so
that the pointers in the old buffer can still be used. But this required
adding a trace_array pointer to acquire the delta offsets.

The tp_printk code does not provide a trace_array (tr) pointer, so when
the offsets were examined, a NULL pointer dereference happened and the
kernel crashed.

If the trace_array does not exist, just default the delta offsets to zero,
as that also means the trace event is not being read from a previous boot.

Link: https://lore.kernel.org/all/Zv3z5UsG_jsO9_Tb@aschofie-mobl2.lan/

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241003104925.4e1b1fd9@gandalf.local.home
Fixes: 07714b4bb3f98 ("tracing: Handle old buffer mappings for event strings and functions")
Reported-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: afd2627f727b ("tracing: Check "%s" dereference via the field and not the TP_printk format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a45efc4e417..addc1b326c79 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3858,8 +3858,8 @@ static void test_can_verify(void)
 void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 			 va_list ap)
 {
-	long text_delta = iter->tr->text_delta;
-	long data_delta = iter->tr->data_delta;
+	long text_delta = 0;
+	long data_delta = 0;
 	const char *p = fmt;
 	const char *str;
 	bool good;
@@ -3871,6 +3871,17 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 	if (static_branch_unlikely(&trace_no_verify))
 		goto print;
 
+	/*
+	 * When the kernel is booted with the tp_printk command line
+	 * parameter, trace events go directly through to printk().
+	 * It also is checked by this function, but it does not
+	 * have an associated trace_array (tr) for it.
+	 */
+	if (iter->tr) {
+		text_delta = iter->tr->text_delta;
+		data_delta = iter->tr->data_delta;
+	}
+
 	/* Don't bother checking when doing a ftrace_dump() */
 	if (iter->fmt == static_fmt_buf)
 		goto print;
-- 
2.39.5



