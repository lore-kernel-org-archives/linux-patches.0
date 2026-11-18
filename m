Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059256;
	b=XqWOT5qYZAeRwQWV3mwahbZCIyL+jbSW6rELPambYCATTtHJaqswFlUAvrz5XA1yT6Ca
	 orfLz91H87b/hRf5LkjH1ns+TChCQlmrF5znLaPb7wmeINdydkIMQDD7tyDn25QmH24i3
	 bCO4aMlKOs8DgLo2YKgaYckP1asvdeKeqyKm0mqjHKV7hGzegrJsQOnypWolD42RfFyZT
	 X/XBWu8dngK9KvrscQb/fcTMEq93ssPb+0TL+yKMVFIFwfc67CC8aSWSDRwUZKsHyF7Xy
	 7SJmjKiGF/Pfd/lohWMfAKH6kBA4cf9o9q4BNmqkdoygLzjVFhlCdty0qZavqp2Os1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mVcr24KSqZwNhVdlcAwx1TkKOw02dhaOUCpktSgIyd8=;
	b=YsnQgRbB17PoHfhp986kMgIU5ZgoO09Y15siSxLRjKWhx24Ys+eVQX04pab4PfEBgsnV
	 fg71dBh7/nv6JB9XOm2ikJ0dxDvbZZ3tz13SSZgv18zYqpLpb/+asLYddnUpun3XKfDUp
	 GlDMyX1zax4p9fDBCSUR+fsmbKsGvRrzLKjTNRjM09+uXb8D7CPhn17aYbUfg0iGOCPvq
	 X+cT1497DXdb6MlBfTlvy4dFTh3B8KFIjJTVy1v4SRO4x3Nv3ApUNXTJG/e1u9dW+142v
	 DTELd/+wa6Wi3ZlOBSPVmBFeX0Djc50+hugFmU02VqgsfMcRCFI9x6mQdvyUUN4Sq0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X57VpgTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2351606A320;
	Thu, 19 Nov 2026 03:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X57VpgTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19311F000C4;
	Thu, 19 Nov 2026 03:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059256;
	bh=mVcr24KSqZwNhVdlcAwx1TkKOw02dhaOUCpktSgIyd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X57VpgTbVVVUGW68iMrpN8/gDJIeNHoTlO5geOHOJc0Axc7H1Ss1C4KWjoo+KBJCU
	 v3Prv20X/ptyZZO76y7LM2/ILKaG0HUsyiAosdzr15ngBwEsfMR+45RledmdFbnF51
	 Rxlnuf0mU4xUxE1511AMCa7DZeCII5RrpdYsZcR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0777/1848] tracing/histograms: Verify event_call identity when updating synth_event refcount
Date: Wed, 18 Nov 2026 15:46:55 +0100
Message-ID: <20261118145949.008931589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 3403d9bb27ebc3572bd048620746b4414e073bf9 ]

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
[Lee: Context conflict in event_hist_trigger_func() - no functional change]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c  | 11 +++--------
 kernel/trace/trace_events_synth.c | 10 ++++++++++
 kernel/trace/trace_synth.h        |  1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index f36b793147f8e..7c3c8cfb873c1 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5666,7 +5666,6 @@ static void hist_unreg_all(struct trace_event_file *file)
 	struct event_trigger_data *test, *n;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -5679,8 +5678,7 @@ static void hist_unreg_all(struct trace_event_file *file)
 			list_del_rcu(&test->list);
 			trace_event_trigger_enable_disable(file, 0);
 
-			se_name = trace_event_name(file->event_call);
-			se = find_synth_event(se_name);
+			se = find_synth_event_call(file->event_call);
 			if (se)
 				se->ref--;
 
@@ -5703,7 +5701,6 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 	struct event_trigger_ops *trigger_ops;
 	struct hist_trigger_data *hist_data;
 	struct synth_event *se;
-	const char *se_name;
 	bool remove = false;
 	char *trigger, *p;
 	int ret = 0;
@@ -5800,8 +5797,7 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 		}
 
 		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
-		se_name = trace_event_name(file->event_call);
-		se = find_synth_event(se_name);
+		se = find_synth_event_call(file->event_call);
 		if (se)
 			se->ref--;
 		ret = 0;
@@ -5842,8 +5838,7 @@ static int event_hist_trigger_func(struct event_command *cmd_ops,
 	if (ret)
 		goto out_unreg;
 
-	se_name = trace_event_name(file->event_call);
-	se = find_synth_event(se_name);
+	se = find_synth_event_call(file->event_call);
 	if (se)
 		se->ref++;
 	/* Just return zero, not the number of registered triggers */
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index b126af59e61c3..e7867d02a9e92 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -821,6 +821,16 @@ struct synth_event *find_synth_event(const char *name)
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
diff --git a/kernel/trace/trace_synth.h b/kernel/trace/trace_synth.h
index 077c748a8b3a6..87320dab449a8 100644
--- a/kernel/trace/trace_synth.h
+++ b/kernel/trace/trace_synth.h
@@ -37,5 +37,6 @@ struct synth_event {
 };
 
 extern struct synth_event *find_synth_event(const char *name);
+extern struct synth_event *find_synth_event_call(struct trace_event_call *call);
 
 #endif /* __TRACE_SYNTH_H */
-- 
2.53.0



