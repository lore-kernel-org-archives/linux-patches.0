Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3C83A14;
	Mon,  6 Jan 2025 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177677; cv=none; b=XR6qykE4pAmN59AQFiTt6qJI/w+22nmT9IBz5IIXDfwjglrbmqRKwJvscRu8+1K9a452Q2zMIl96garOOwLb4rIDA/COpVVUvIxfzFyN7ABEr6C29I/Ue7E9gR3UJnG9LcOuQrDgtPPsBwUD1aYoZIBT+odjl3d6Fby2zyk/gpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177677; c=relaxed/simple;
	bh=O/lKGuuyTmU1bQg5tZCLlP9YcOxTqUQCnDh6f3OKFKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOLdVQ85acLy4+BL3TeYPDpHSLQyAvj9y/EpQIjpdMqd0irWANOLWWKhjBdqtyJ4onUuvkJ9+jIj4l+y9IuOJGTnc/OiOrzXxzkKQfIWh3LLpUpiP5Z2idUaDUOsWY0G0BJBxBlIQXm52G2eCCXPIztJFFQlbCmCq4BBMSDA/Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DglR7tCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DglR7tCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFFBC4CED2;
	Mon,  6 Jan 2025 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177676;
	bh=O/lKGuuyTmU1bQg5tZCLlP9YcOxTqUQCnDh6f3OKFKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DglR7tCFsAwct01VpgYXfgJrtnpKcAQiP6kmP+e2yNhKjLajuvGhF1vLAvy3ULABm
	 AekbzpUtZejqp2r65TEHfHNVjB1HAMSLY/1WP7kJX6vRGb0A5DhBmB8zG636I/hrFf
	 1lcy+EtwaigKs/6HagqqBM7blr0dODeGJFNkYz8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Genes Lists <lists@sapience.com>,
	Gene C <arch@sapience.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 009/156] tracing: Have process_string() also allow arrays
Date: Mon,  6 Jan 2025 16:14:55 +0100
Message-ID: <20250106151142.095426997@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -365,6 +365,18 @@ static bool process_string(const char *f
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


