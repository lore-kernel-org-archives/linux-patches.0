Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207176;
	b=1otsLPM7rsk9r/LH6XewZ/23qbr2xK4txvSm7ioO1MaubtvBmB+qfTXB9YR8TyQNxQ9n
	 TluLxU9ac92IqIfUMZTqc5kNGz7BAf4HB1bfB5Nm6WiXjf/a4GTkyJ8IUJBp6+3khD6T4
	 fEzryRaZgPDhERUIQnJKnN3bpRifOwffh3CFLKj4bufNTyavnwtftWp95Yz/JeBjuxL9u
	 +hVM4+xo48L2rCSKhLuUDG3yArxMRe+6LINqz8eNIgvPcnKbcmMPTIk7IeApKd3unV95T
	 lS5V0j42QIEC+zQ8ZQfJUV80qkTM93v0wxS+nH23B/mh0NsZASHHZU8HoZVODarPG5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+rqqJOPw4RPXJNjPwxaPlC/rBJCs67efHCb+z3OwjUo=;
	b=QtGYlI3SJeTXVDIhAJO7ENdlARiJe2JpgjSYXsUE5GtVCdrzMKVbZJS3+ZMK/rGfRMJ0
	 Qzv+WjE7OgCu4sIIoFgg2ijAMT2Y+EeNjqF2rUnnsSZpl6fsPHsg6pwyWBXpUCpvHB2w1
	 GYqDXZS+eVy4riBLw8FGj/q6EKcqqGg52nacXcsNazjDos14sXWvlQ9uPCxCxwxUrTczB
	 jHRo0CFSlpZL5aFFji2ggrOqZlvhLyiFm3w9U7k/i9pjSYcCRTpAEzQo+iUvNj20S/G4Q
	 7q5w208x8sFvjU4uWVxDs6B0100vJ8dXMKBEP3whnBWQvwxzBC7i8DmtOQZoQFfBlJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pd+ZpU4h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2059B606A31C;
	Wed, 28 Oct 2026 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pd+ZpU4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D4A1F031E1;
	Wed, 28 Oct 2026 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207176;
	bh=+rqqJOPw4RPXJNjPwxaPlC/rBJCs67efHCb+z3OwjUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pd+ZpU4h2fwocRD/I6SwF2P6dMDmi7Jur9Egie89b/uHTNj/o9jecZqD+YbEdLswg
	 uX3AT1Uxe6PEr4rjwQuQQYSP7moQzsXRzZcvH3fp3bj01efeIrcjNcaNZtrNm4ZcsN
	 aXdENiBIvWbtFnW5TQn9QIwWDMeBADP6Pxk6MNeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 14/88] tracing/histograms: Verify event_call identity when updating synth_event refcount
Date: Wed, 28 Oct 2026 17:59:22 +0100
Message-ID: <20261028165942.451494411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit 3403d9bb27ebc3572bd048620746b4414e073bf9 upstream.

In event_hist_trigger_parse() and hist_unreg_all(), the histogram
registration and unregistration paths look up find_synth_event() using
trace_event_name(file->event_call) and adjust se->ref if a match is
found.

Because find_synth_event() only compares the event basename, registering
or removing a histogram on a non-synthetic trace event whose basename
matches a synthetic event erroneously modifies the synthetic event's
reference count.  If a histogram is registered on the non-synthetic
event before the synthetic event is created and removed afterwards,
se->ref is decremented without a matching increment, allowing the
synthetic event to be freed while an active histogram action still holds
a pointer to it.

Introduce find_synth_event_call() to verify that &se->call matches
file->event_call before adjusting se->ref.

Fixes: 4b147936fa50 ("tracing: Add support for 'synthetic' events")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261019120730.2342739-1-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c  |   11 +++--------
 kernel/trace/trace_events_synth.c |   10 ++++++++++
 kernel/trace/trace_synth.h        |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6779,7 +6779,6 @@ static void hist_unreg_all(struct trace_
 	struct event_trigger_data *test, *n;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -6792,8 +6791,7 @@ static void hist_unreg_all(struct trace_
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			se_name = trace_event_name(file->event_call);
-			se = find_synth_event(se_name);
+			se = find_synth_event_call(file->event_call);
 			if (se)
 				se->ref--;
 
@@ -6817,7 +6815,6 @@ static int event_hist_trigger_parse(stru
 	struct hist_trigger_data *hist_data;
 	char *param, *filter, *p, *start;
 	struct synth_event *se;
-	const char *se_name;
 	bool remove;
 	int ret = 0;
 
@@ -6911,8 +6908,7 @@ static int event_hist_trigger_parse(stru
 		}
 
 		event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
-		se_name = trace_event_name(file->event_call);
-		se = find_synth_event(se_name);
+		se = find_synth_event_call(file->event_call);
 		if (se)
 			se->ref--;
 		ret = 0;
@@ -6947,8 +6943,7 @@ static int event_hist_trigger_parse(stru
 	if (ret)
 		goto out_unreg;
 
-	se_name = trace_event_name(file->event_call);
-	se = find_synth_event(se_name);
+	se = find_synth_event_call(file->event_call);
 	if (se)
 		se->ref++;
  out:
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -914,6 +914,16 @@ struct synth_event *find_synth_event(con
 	return NULL;
 }
 
+struct synth_event *find_synth_event_call(struct trace_event_call *call)
+{
+	struct synth_event *se;
+	const char *name;
+
+	name = trace_event_name(call);
+	se = find_synth_event(name);
+	return se && &se->call == call ? se : NULL;
+}
+
 static struct trace_event_fields synth_event_fields_array[] = {
 	{ .type = TRACE_FUNCTION_TYPE,
 	  .define_fields = synth_event_define_fields },
--- a/kernel/trace/trace_synth.h
+++ b/kernel/trace/trace_synth.h
@@ -37,5 +37,6 @@ struct synth_event {
 };
 
 extern struct synth_event *find_synth_event(const char *name);
+extern struct synth_event *find_synth_event_call(struct trace_event_call *call);
 
 #endif /* __TRACE_SYNTH_H */


