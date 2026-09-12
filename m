Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BB83B637C;
	Sat, 12 Sep 2026 20:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243557; cv=none; b=Wd1NDePKQ1hCvl0r+eun1/XIc4P/apoHAIRh1vNcynVo+WRLCIC1eL1nwwxrxdSSt9/c1ZxXqcLFPQ0e7mJIc5xw/BlmnTdrAdiW2j/iWcF7x92cbmO8FGjpXKBXQrpVCaOlu7DW5a/iPqsqcBH3dmC06Az+cVGhha5fPLw3Tg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243557; c=relaxed/simple;
	bh=z/9LL/z4nt5fuiNNyhzJs5KXcTBdfr1vK4be45JOedI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syLiS6K8FmGa5btX6loK7l9X8fMrFpZzeLhJSmkOTtx1ffEw3y2Caw/sD5rjjbvOoU7JmgGs9UMhFXKrKp3cKMW+7bxQThz16+UiMUjenr7jDuijw338wbeiKN1h8cTs9GKJLl412QOXgZd8Tw38i3AjTX78OGWEeJJALpNTnCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLu5CaDK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLu5CaDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43041F000FF;
	Sat, 12 Sep 2026 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243552;
	bh=erqaYCYg1pDTJIdOyT/nnXcujpdPG+NpLrK49/FMSPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLu5CaDKcaWeXC7LTyayJZyDG1QWW6XeAQT9Wu24nTdJqQ3jlMHY/wsamqjaLF/ub
	 6l/S2C0MzTY6waxZKUVbXZMFA554tZ+dHiUXMqR5nWL8TGlzkwP15jGNSwaPzknzOy
	 mF5p4xWP0SBc2/dsbdKO6ZbtNWBW15RekdpKmsKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 796/798] tracing: Have trace event string test handle zero length strings
Date: Sat, 12 Sep 2026 09:07:04 +0200
Message-ID: <20260912065535.303727300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit eca344a7362e0f34f179298fd8366bcd556eede1 ]

If a trace event has in its TP_printk():

 "%*.s", len, len ? __get_str(string) : NULL

It is perfectly valid if len is zero and passing in the NULL.
Unfortunately, the runtime string check at time of reading the trace sees
the NULL and flags it as a bad string and produces a WARN_ON().

Handle this case by passing into the test function if the format has an
asterisk (star) and if so, if the length is zero, then mark it as safe.

Link: https://lore.kernel.org/all/YjsWzuw5FbWPrdqq@bfoster/

Cc: stable@vger.kernel.org
Reported-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Fixes: 9a6944fee68e2 ("tracing: Add a verifier to check string pointers for trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31d0abb1c9429..bfa6e2fe984b1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3586,12 +3586,17 @@ static char *trace_iter_expand_format(struct trace_iterator *iter)
 }
 
 /* Returns true if the string is safe to dereference from an event */
-static bool trace_safe_str(struct trace_iterator *iter, const char *str)
+static bool trace_safe_str(struct trace_iterator *iter, const char *str,
+			   bool star, int len)
 {
 	unsigned long addr = (unsigned long)str;
 	struct trace_event *trace_event;
 	struct trace_event_call *event;
 
+	/* Ignore strings with no length */
+	if (star && !len)
+		return true;
+
 	/* OK if part of the event data */
 	if ((addr >= (unsigned long)iter->ent) &&
 	    (addr < (unsigned long)iter->ent + iter->ent_size))
@@ -3755,7 +3760,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		 * instead. See samples/trace_events/trace-events-sample.h
 		 * for reference.
 		 */
-		if (WARN_ONCE(!trace_safe_str(iter, str),
+		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
 			      "fmt: '%s' current_buffer: '%s'",
 			      fmt, show_buffer(&iter->seq))) {
 			int ret;
-- 
2.53.0



