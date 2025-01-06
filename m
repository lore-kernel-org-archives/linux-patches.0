Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284EEBA34;
	Mon,  6 Jan 2025 15:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178644; cv=none; b=iQBqkClTAuJ0I36eS9QhzP3xK5HfLQ/CiuxVEfHn7HZzv6/sGzDtD+HcvjySa0hLfwQaBPi7hZeJDsPa8F0bUTsEbuusCO1ZVbgB770PqtVFOQEGYoFMkViRVHnlxsasXisTj+dBUi6b07zjSnBBqg2wWjuUmsGWNvR3JPeRIdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178644; c=relaxed/simple;
	bh=zWrTSvVs4g7yFzS2EJ+x6UtGCP6lrCMvIxltpiAVCgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aivAwNYwFJ4UHzgS21IpR4l9Gq5cmZWylyPoO0kasoxVvgSb+tb5wO5XTPOmiIEH1uSIu1wjNibvgJi1uMNpac2NGfcKbIGNgcNcLYz7JQDccTYpd9fD8NfX/XzF2ouSOiEXm4ES8hke5xmJkGN9khFWmo5tDe/auA/aBnsZzLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPH5Rang; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPH5Rang"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37035C4CED2;
	Mon,  6 Jan 2025 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178643;
	bh=zWrTSvVs4g7yFzS2EJ+x6UtGCP6lrCMvIxltpiAVCgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPH5RangiPb1V6ytF66/TdHMn0nd8bC8LceagGSnlGJe/MFXNg+3FCk8xMMiCB23m
	 mPe6jF3mK0XcTF5UgrJgcpCaaFRNS0Ucr2EGEvVO1zaOkQsGDM4YlC9gb1/zSpvFk8
	 CrHEzrn0dWN/6VbVhNIDDbKyJ559UpeHwr2fv4+M=
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
Subject: [PATCH 5.15 046/168] tracing: Add missing helper functions in event pointer dereference check
Date: Mon,  6 Jan 2025 16:15:54 +0100
Message-ID: <20250106151140.202990461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,6 +257,15 @@ static bool test_field(const char *fmt,
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
@@ -275,9 +284,17 @@ static bool process_pointer(const char *
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


