Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D847E0FF;
	Mon, 23 Dec 2024 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970475; cv=none; b=ktY7/Gb/2I16WW9U5/msQnjhAQTVe4J3gqlWW9My2iMPmHUeEouOtkfA1sgcY9XdH9c7Ic6HLjkJ3FCfWHfAum+ThhtknXt66YhhntJBShcOm89dFJtfucPwQwMXjAtteiNuduGH8GJEW/1n+9aR6dmynq/j8RtA2MA5Th6kOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970475; c=relaxed/simple;
	bh=JL7wiYyfLt60GWvEHjuiynmvzZYTnPeGzSdWIIq+wGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATvekxaRkS5RT0br7mJNrtG0WCz3+btDKVvb6A1vFxc42yi+9UZ4O456yOgzeLZ18xKZOQjj2CGu9AU++RbJyAW5mPgklE+gPNlZ9/zV0W8ZmeVl62G20V8nw3TwKtF27sJkHIqJWHsooYCKeFh/jNXW1enbqVQjjt1594Wcbbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrFuh2WX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrFuh2WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F2C4CED3;
	Mon, 23 Dec 2024 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970475;
	bh=JL7wiYyfLt60GWvEHjuiynmvzZYTnPeGzSdWIIq+wGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrFuh2WX4U0ShT/91TDUa79xuVPKocYgveoUVvldsGV+wjHwEb0/THil7pBrlynqT
	 SwuUkDZtU5rzagUHaRmilCTIilGOJICdLuwlfOyBBhLYHAlbMinG6X8EfE6nwZ2KQ1
	 zIW7KLxwQQ3U2OWo99qwYiXp3iXWiAli5yIFvE3w=
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
Subject: [PATCH 6.6 093/116] tracing: Add missing helper functions in event pointer dereference check
Date: Mon, 23 Dec 2024 16:59:23 +0100
Message-ID: <20241223155403.178997458@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
@@ -274,6 +274,15 @@ static bool test_field(const char *fmt,
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
@@ -292,9 +301,17 @@ static bool process_pointer(const char *
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


