Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26A1B413F;
	Mon, 23 Dec 2024 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970864; cv=none; b=M7ayAwRf3KDuTiuE/DpYY5XMKiAvE5PI17QI4HkRaIJjI6adBf4OhmvCM1NbPYl6K9mdZPLC421t5uo1BiyKn+UoA1DqUxR7YHH4LPGZxhY8zkojK6lQSnAZZSYcxEfo4wVaULADCjrQ3EM/5Y0glX+oPsdR70FBYvz8/BCrQJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970864; c=relaxed/simple;
	bh=sU/hGM0VSC5OfwWsy+XbMQPlzwK1h240p6tMGWY545k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYLj8CYfvJW/O+E5S1MlM/zqDCf+FwPNdI+1/1xBg+jlMJiDuHmgkqiw5lx4Q3tSR+/C5SRZYDNYQphLC7DJz/YH1n0wFTvUeKVbBGLRiaeKXU9w/BHtAtwfvtfawj6QJ3LgM9IjZle27dwDNXq1wxIoKKd5ZK9oDGvYyLyW9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iZn6ALU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iZn6ALU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0859BC4CED4;
	Mon, 23 Dec 2024 16:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970864;
	bh=sU/hGM0VSC5OfwWsy+XbMQPlzwK1h240p6tMGWY545k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iZn6ALUH8f3/RMrZnl5jx27vyAu6wLpwIeFL2mOVI7CDZTw+nC8q+w1jNgqtKjb6
	 rwyIQk29GTCoxQ+KeM4KUbVIoDZ49LW/LWPdv5TPbVutAVR41Dm0/uRRnA1/8zoRoz
	 Nhgux3lzOcoqMRXcm+LfChkIG03GNVGoM28TvgFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 63/83] tracing: Add missing helper functions in event pointer dereference check
Date: Mon, 23 Dec 2024 16:59:42 +0100
Message-ID: <20241223155356.067401314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 917110481f6bc1c96b1e54b62bb114137fbc6d17 upstream.

The process_pointer() helper function looks to see if various trace event
macros are used. These macros are for storing data in the event. This
makes it safe to dereference as the dereference will then point into the
event on the ring buffer where the content of the data stays with the
event itself.

A few helper functions were missing. Those were:

  __get_rel_dynamic_array()
  __get_dynamic_array_len()
  __get_rel_dynamic_array_len()
  __get_rel_sockaddr()

Also add a helper function find_print_string() to not need to use a middle
man variable to test if the string exists.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/20241217024720.521836792@goodmis.org
Fixes: 5013f454a352c ("tracing: Add check of trace event print fmts for dereferencing pointers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -272,6 +272,15 @@ static bool test_field(const char *fmt,
 	return false;
 }
 
+/* Look for a string within an argument */
+static bool find_print_string(const char *arg, const char *str, const char *end)
+{
+	const char *r;
+
+	r = strstr(arg, str);
+	return r && r < end;
+}
+
 /* Return true if the argument pointer is safe */
 static bool process_pointer(const char *fmt, int len, struct trace_event_call *call)
 {
@@ -290,9 +299,17 @@ static bool process_pointer(const char *
 		a = strchr(fmt, '&');
 		if ((a && (a < r)) || test_field(r, call))
 			return true;
-	} else if ((r = strstr(fmt, "__get_dynamic_array(")) && r < e) {
+	} else if (find_print_string(fmt, "__get_dynamic_array(", e)) {
+		return true;
+	} else if (find_print_string(fmt, "__get_rel_dynamic_array(", e)) {
+		return true;
+	} else if (find_print_string(fmt, "__get_dynamic_array_len(", e)) {
+		return true;
+	} else if (find_print_string(fmt, "__get_rel_dynamic_array_len(", e)) {
+		return true;
+	} else if (find_print_string(fmt, "__get_sockaddr(", e)) {
 		return true;
-	} else if ((r = strstr(fmt, "__get_sockaddr(")) && r < e) {
+	} else if (find_print_string(fmt, "__get_rel_sockaddr(", e)) {
 		return true;
 	}
 	return false;


