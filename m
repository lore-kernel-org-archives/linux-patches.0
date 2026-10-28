Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209762;
	b=B1TAv0LbiTp9XRO/lN/WbB3e/f/wSpWhqoaWz7fubATKs89ZJvhKvh5xLhoBqa9cp3Lr
	 DkvuHCptYU6uvucabysN8NOUXOcXeVujA4+olLBG2JNK2CCNRUx6xOlterHl4DYR9Pxx6
	 sQ87z+hvKa4msQG6/5XSaCTLbTBGOOlB38fNzVW/agfqoIAsuFXmKz2biZ2CfjCQDEnwO
	 YB5PQJ9iSwYanzVNnO9Z2loUx2woHxb+y29ZX+WGklErPeXp/l9SsosQufiRx/ji0fc4A
	 4qYpXtX972GT1HQprdVXE9vgJMxs3hAXNLo60DO7iHrqWKZ8yAkq0f1HVR1i3IsghYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/SQIFnu3KeTgUxUljYST3aqaOMlp8x94FFO8VmqgWng=;
	b=Hwa/cj3g+oZXBInxIpU6MV+DYw3KydRV08VksFfwUlEysfEQaB5P9ACYisPVLuzf5kMp
	 dfcYcwoWGydLBCeVnszAbbXx9gv6CTVuviCJeMRMKwTjBzHNifO8b3wg++PNTZIZeS1dM
	 fEnKv5nY8KZsqJRvLJByuyIUGuGEdc4zv2WYPYF6XGzjHFRZA+AhZ5BteId4q6RldYrkv
	 HzB/zWkz2XgXUCaCpYRdsDfVL1dBCYrFuZbjc0/i0A6ZOzgLFZ3X2GI+6fpgOgTrZfdTw
	 m/vOf+UeN9gn+FOg34+2L1ndscO+3GDmomxECoQejNifXXko+n+s9rp3Da2PQFcx5Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6qTdwzQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53580606A31A;
	Wed, 28 Oct 2026 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6qTdwzQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28121F01829;
	Wed, 28 Oct 2026 17:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209762;
	bh=/SQIFnu3KeTgUxUljYST3aqaOMlp8x94FFO8VmqgWng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6qTdwzQHll9PPFho+MlDYGjZw/dhzFYbF6LhXRoLFi4rcwdg38Lq2K/tF/ldjpjC
	 pKVRzdPX0XZcfyGIW4Pc2P14Mn3DwPD0pjB2r/JjyMTElQgP5Gf67yG6csZWVoLKZy
	 Fg7+Pw7vxQQEKqqLINDTw1KzeqP/065bNwAWdQnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 041/109] tracing/histograms: Verify event_call identity when updating synth_event refcount
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028165943.329329818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6753,7 +6753,6 @@ static void hist_unreg_all(struct trace_
 	struct event_trigger_data *test, *n;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -6766,8 +6765,7 @@ static void hist_unreg_all(struct trace_
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			se_name = trace_event_name(file->event_call);
-			se = find_synth_event(se_name);
+			se = find_synth_event_call(file->event_call);
 			if (se)
 				se->ref--;
 
@@ -6791,7 +6789,6 @@ static int event_hist_trigger_parse(stru
 	struct hist_trigger_data *hist_data;
 	char *param, *filter, *p, *start;
 	struct synth_event *se;
-	const char *se_name;
 	bool remove;
 	int ret = 0;
 
@@ -6885,8 +6882,7 @@ static int event_hist_trigger_parse(stru
 		}
 
 		event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
-		se_name = trace_event_name(file->event_call);
-		se = find_synth_event(se_name);
+		se = find_synth_event_call(file->event_call);
 		if (se)
 			se->ref--;
 		ret = 0;
@@ -6921,8 +6917,7 @@ static int event_hist_trigger_parse(stru
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
@@ -848,6 +848,16 @@ struct synth_event *find_synth_event(con
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


