Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFC2DF71;
	Mon,  6 Jan 2025 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178923; cv=none; b=TdPEm1EVOsUsPvcDQuMx9t9FbqEinZE+8tUBUuE1ZGZgNQ2OJWy6oyT9+Sh9qpi7qMaUw6cIC6hGDodHSqW7MUfiPLVHCh+kZcZdXAGbNNd0DEAP2zo5HWRrbQIUAix3c6cRdE5NhxBHNmHx9X0nEkdwSk7rKdoVRSntszCLDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178923; c=relaxed/simple;
	bh=CCzfWJHzhCbY459WQGJy20IryTDHQwWnrY86r+qfPMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2PeEw30kkGwr/YiU3G5i5RbC6dyeMjggG2IgSni6h83tC32SVfJH6DWe593FP35Yku6rsl+psverfiXPxzFiG1QQ9ekLUHwvJvY52lmk97Qoemvmrj7deA3naLeW013oz6OmxsgIzUAr5g7d0HFeYiy2NR0fB/Vj1rnBq3yYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCyvedRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCyvedRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D02C4CED2;
	Mon,  6 Jan 2025 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178923;
	bh=CCzfWJHzhCbY459WQGJy20IryTDHQwWnrY86r+qfPMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCyvedReK08spgA3zae7LRuwwf7sft0azlmVRQcCTlMd0dIQ5NWgC6qUJbPpi/Ew/
	 WNJa2W6vSpmss27mqrIRbQ8C714CWgtzDd2r5K8fiiJKcQPN/ilSPvpWj7RdMQzAaF
	 XLtKAwhtQ6Kiu7EPFr2iNyYsZUh5SwDDiTM+23LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Genes Lists <lists@sapience.com>,
	Gene C <arch@sapience.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 106/168] tracing: Have process_string() also allow arrays
Date: Mon,  6 Jan 2025 16:16:54 +0100
Message-ID: <20250106151142.463396393@linuxfoundation.org>
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

commit afc6717628f959941d7b33728570568b4af1c4b8 upstream.

In order to catch a common bug where a TRACE_EVENT() TP_fast_assign()
assigns an address of an allocated string to the ring buffer and then
references it in TP_printk(), which can be executed hours later when the
string is free, the function test_event_printk() runs on all events as
they are registered to make sure there's no unwanted dereferencing.

It calls process_string() to handle cases in TP_printk() format that has
"%s". It returns whether or not the string is safe. But it can have some
false positives.

For instance, xe_bo_move() has:

 TP_printk("move_lacks_source:%s, migrate object %p [size %zu] from %s to %s device_id:%s",
            __entry->move_lacks_source ? "yes" : "no", __entry->bo, __entry->size,
            xe_mem_type_to_name[__entry->old_placement],
            xe_mem_type_to_name[__entry->new_placement], __get_str(device_id))

Where the "%s" references into xe_mem_type_to_name[]. This is an array of
pointers that should be safe for the event to access. Instead of flagging
this as a bad reference, if a reference points to an array, where the
record field is the index, consider it safe.

Link: https://lore.kernel.org/all/9dee19b6185d325d0e6fa5f7cbba81d007d99166.camel@sapience.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241231000646.324fb5f7@gandalf.local.home
Fixes: 65a25d9f7ac02 ("tracing: Add "%s" check in test_event_printk()")
Reported-by: Genes Lists <lists@sapience.com>
Tested-by: Gene C <arch@sapience.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -346,6 +346,18 @@ static bool process_string(const char *f
 	} while (s < e);
 
 	/*
+	 * Check for arrays. If the argument has: foo[REC->val]
+	 * then it is very likely that foo is an array of strings
+	 * that are safe to use.
+	 */
+	r = strstr(s, "[");
+	if (r && r < e) {
+		r = strstr(r, "REC->");
+		if (r && r < e)
+			return true;
+	}
+
+	/*
 	 * If there's any strings in the argument consider this arg OK as it
 	 * could be: REC->field ? "foo" : "bar" and we don't want to get into
 	 * verifying that logic here.


