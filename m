Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207060;
	b=cdyVqqg/QtsGmAaiIy0/WWBYmh6y2WN0q7txyANWuAfEXp4ig9chEyEx7bPW8AwDBKt7
	 kwNgeYnCYOFuRbrdeDpexTzvCLouQfcoGUbPrvsEemkz/HkC6sZh1D1ZsalJSOdsAjEqT
	 wmUvnRYFWBREhVcEFoJJJOEreQmE8m7YqaC3mS0Y3n1ffe5T9NpH1moZZ6swPbcpnvfbm
	 BEgShGI2A7WjPzgJ4GFA/sPeLPrOWyUe0PBTYLHyPlAOc+U/Bt0YN8upVhyJBLvRwty1q
	 qqSL83E1adul3JsH9xB4NbrxJBGaJXf/VwlvPrLejY5JoJA2p5/hPwol0uqo6H5YBrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+Uc4CDTXDRuda30c0tiXSzeWFMfiCVMPP+DAwqhJxU=;
	b=09SRsBODUTd9PUOvvH2QdRIqvVplmBxDMmSAzdxHjysiDblRl0afuEaNYe2CQgZ8f2IO
	 Ed7MA8O2u/e6wSFuqBeHqTWueUojGVr37GWXI3lau642CKMV8KC51tw+dkKbuCbhu5SPi
	 FTvGoNeJ0MpdBu5LfoH6tNbpW97AgbschRZoZ9JyISdrvhvrx08IQQeKT0suODyJZLlh0
	 mC+XBYm51uGHSA9SpDAnLN0IINfTU9cnVu9l/WN/yYKPG0EQaqpO5KyOG25LoGv5tmheh
	 88xE1/WBh6c5TyNdv4ZwK0a3oB92OZ9wWN7K2b0A5S6DRMJPKiurjxvY5Q9FfJkVPRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vh5GH6xt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DB5606A31A;
	Wed, 28 Oct 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vh5GH6xt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA781F01825;
	Wed, 28 Oct 2026 17:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207059;
	bh=3+Uc4CDTXDRuda30c0tiXSzeWFMfiCVMPP+DAwqhJxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vh5GH6xtkacbSJPYg8pC1u60OHEJ2bcFYTh4+cO1fdf7GI+59kbpubd2ekOHvfBK8
	 nLijubO8jZYOyarBSbGRPFtlmkmBIcz1Y4tdEhUiIxNYpX0TJZ3TnqrJfOPAK0BhhJ
	 UT0Rn8PTw52vrqiCpEtOsGRMBbSNcEfK0c1PKF9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 12/38] tracing/histograms: Verify event_call identity when updating synth_event refcount
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028165940.708689771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6802,7 +6802,6 @@ static void hist_unreg_all(struct trace_
 	struct event_trigger_data *test, *n;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -6815,8 +6814,7 @@ static void hist_unreg_all(struct trace_
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			se_name = trace_event_name(file->event_call);
-			se = find_synth_event(se_name);
+			se = find_synth_event_call(file->event_call);
 			if (se)
 				se->ref--;
 
@@ -6840,7 +6838,6 @@ static int event_hist_trigger_parse(stru
 	struct hist_trigger_data *hist_data;
 	char *param, *filter, *p, *start;
 	struct synth_event *se;
-	const char *se_name;
 	bool remove;
 	int ret = 0;
 
@@ -6934,8 +6931,7 @@ static int event_hist_trigger_parse(stru
 		}
 
 		event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
-		se_name = trace_event_name(file->event_call);
-		se = find_synth_event(se_name);
+		se = find_synth_event_call(file->event_call);
 		if (se)
 			se->ref--;
 		ret = 0;
@@ -6970,8 +6966,7 @@ static int event_hist_trigger_parse(stru
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


