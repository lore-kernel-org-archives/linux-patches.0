Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207932;
	b=qmgKri0/Uhh9Ww2HvGY4jpF51OmkridWImfUr49kbD8dOc7buf57HcJYM3Qyq5v4oDz7
	 OwJO/6Y3vDGXHeI0yE/NubffU+1yLH2HseFCX51ilwpUyF11nhI51s5lV/LIvd3WQFp/D
	 6ND373u7nYKTtdcvbfekc6l2edd6wjjWNTmkuuE2mtDRgdIR/Zoqch5lxybv1+bDPQas6
	 iLiynAXPkC8wvqxgs4Bqrl7H/iszGrUmHXN4Tf8i97omseCDgevtOz9J+IWqq0XqcfpvF
	 s22QrCX4Svxts3PzwmKmVbX8Yz/te0s4MzO4q+XSvF0LfA/TIMJoZ2VDxcoxLfJyvJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZhxLIypkkN6q06lk4wx1LZB0RyYbQ+g+AxzWJtvyT/k=;
	b=xuWTbSSwBz9aRwapbgn2Rm1tvMB/2iLuAp21mEr4Jbg1CCIXxvDBmIV6rQhpbMYU+fJq
	 J7gmk7WPZtZkS5Uo8ilSl8Efi8Vr5auIfAov5DnzzN594uFXxRy77fVTgHPSKyaXzsuT4
	 xW2tTNS4ursQbD5RMkDDMmjIO9LRHLmEbCJ39IuEky5DS9M9uIklQz49yxF7JH6BC036I
	 T/pTHDujZ3RLe1Y32T1RKGEWO/8zRpPYPzfat0XHyJDV2uTWgldPorw4wpH6Lq+1RdILf
	 TGvUMFc76hpnf5Fq9iDLsY3sEE2MrblaH0NnwO9tJibuc5CiW9PVFzLjN2/ZK5QqNkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JTwSSl/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499FF606A322;
	Wed, 28 Oct 2026 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTwSSl/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5921F01825;
	Wed, 28 Oct 2026 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207931;
	bh=ZhxLIypkkN6q06lk4wx1LZB0RyYbQ+g+AxzWJtvyT/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTwSSl/v5MzxWq5F1hSTpCD5lhnNPukAID8VDZj4nIQHAfHd2ARNq7Ku5j34AZ+OO
	 dikrsdi77rNsXr5oagkr2bWbN9yrRs6+7hz15ps3H4Y3lTab07H4shMujSB7cpddVq
	 Lmj3OJnk/EhF00DIdgUpZ787BoT3PvgIcWhxLrC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 191/247] tracing/histograms: Verify event_call identity when updating synth_event refcount
Date: Wed, 28 Oct 2026 17:59:54 +0100
Message-ID: <20261028165951.941655831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6725,7 +6725,6 @@ static void hist_unreg_all(struct trace_
 	struct event_trigger_data *test, *n;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -6738,8 +6737,7 @@ static void hist_unreg_all(struct trace_
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			se_name = trace_event_name(file->event_call);
-			se = find_synth_event(se_name);
+			se = find_synth_event_call(file->event_call);
 			if (se)
 				se->ref--;
 
@@ -6763,7 +6761,6 @@ static int event_hist_trigger_parse(stru
 	struct hist_trigger_data *hist_data;
 	char *param, *filter, *p, *start;
 	struct synth_event *se;
-	const char *se_name;
 	bool remove;
 	int ret = 0;
 
@@ -6857,8 +6854,7 @@ static int event_hist_trigger_parse(stru
 		}
 
 		event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
-		se_name = trace_event_name(file->event_call);
-		se = find_synth_event(se_name);
+		se = find_synth_event_call(file->event_call);
 		if (se)
 			se->ref--;
 		ret = 0;
@@ -6893,8 +6889,7 @@ static int event_hist_trigger_parse(stru
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
@@ -857,6 +857,16 @@ struct synth_event *find_synth_event(con
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


