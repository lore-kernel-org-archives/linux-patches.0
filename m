Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625889;
	b=PeJeV0h1AA9z2nJnntvN5FI6zZMSg9Ip/iasSpELfDGt66m3GdVen/v3eiZ6EV+F71qw
	 Vq3yWjkQXrV6bvTxVz5SSIGXPz39ZCGe2gIjVQTpFYq4U1p4bdvYkMS/hdqCfuZm6EM4N
	 AIpV8iu1gvhPHpRmVv8NrZ1MlSBzErO/k9+SiqwIboIs/i9VnfNVcDMmHImzAiJ9iPe+D
	 1VtArY7ScSw4d+sP1CT5nxHqq7/wYa7EZDZYB53iorGKGsoLtBupm9rQvGr/4r8MfmJAz
	 HCdsa/uhxz6awKvKIjfugVDZt0xs17zyzpTBSLeRjULLEJzcLgF4rSHu6R7EwsANS1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SiuQl/EwbzQJMQVzB438roEuHTtvxm/nYA2adEDufE4=;
	b=aEVdpYjtvEdyrx48vPNVGUpTJhvBNYqqqDL5ALqLYyraX+okVltE8EGyMY7wCjNiyC7l
	 Q0Gu+0raXTQqGgs2qa+BPQht0iXF4FlVgLnooTB2pLTLpgyDDZMtHkJkXN6wyrgEY4/Xk
	 xQ8uT1Fsm76UoHCiZbnIHHBInLex/c3hNNcH+ejy9qNZQnjvtP0QtBpBNAacOYCX4PQcC
	 soIhabPy/Kv9Hb1Tv5X+cbQ2mqM1ItkDbYXW1z8l1TliKPT+eEUx/RrGAHRAkki64RvTd
	 vlIKPiIilWRlSjxHVlZzakXdt4LHo+AM2tKPu50VOz1ZMV+YHEJTBCO4Ot2vW1HsCUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdIlyWfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9F3606A31E;
	Wed, 25 Nov 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdIlyWfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24B11F000C4;
	Wed, 25 Nov 2026 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625889;
	bh=SiuQl/EwbzQJMQVzB438roEuHTtvxm/nYA2adEDufE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdIlyWfdQDYHgz8C9kpJb28ZEYba8A7yqYB1Rvx6+b95cLiVMYzB2FQ/Jjnz8rmBO
	 Wss7R7QlGIwinqX7RMuyAOhDJwaIAZ28/ZrCs5Td0idjiTp1NNZ5PjSXX6IGErAOtH
	 EpbTV2LhaIogDeuj2kCsW27kGEyyQuI3TCb9ugpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 656/816] tracing/probes: Check enabled and busy state before unlinking sibling probes
Date: Wed, 25 Nov 2026 15:36:44 +0100
Message-ID: <20261125143904.365122933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit f1d9b7a3fe99b4228acdbab3c744c29f7ffe86ef upstream.

When a multiprobe event is enabled or referenced (for example, by an
eprobe, trigger, or open tracefs file) and a user attempts to delete the
event or one of its probes via dynamic_events, checking
trace_probe_has_sibling() before the enabled and busy checks allows the
first probe to be unlinked and freed while the event is still active,
only returning -EBUSY on the last sibling probe. For uprobe events,
unlinking and freeing an enabled sibling probe without unregistering its
uprobe_consumer also causes a use-after-free.

Ensure all four probe types (kprobe, fprobe, uprobe, and eprobe) verify
that the event is neither enabled nor busy before unlinking any sibling
probe.

Link: https://lore.kernel.org/all/179455848898.403392.17675270675769076596.stgit@devnote2/

Fixes: ca89bc071d5e ("tracing/kprobe: Add multi-probe per event support")
Fixes: 41af3cf587f4 ("tracing/uprobe: Add multi-probe per uprobe event support")
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   12 ++++++++----
 kernel/trace/trace_fprobe.c |    8 ++++----
 kernel/trace/trace_kprobe.c |    8 ++++----
 kernel/trace/trace_uprobe.c |    8 ++++++--
 4 files changed, 22 insertions(+), 14 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -88,14 +88,18 @@ static int eprobe_dyn_event_show(struct
 
 static int unregister_trace_eprobe(struct trace_eprobe *ep)
 {
-	/* If other probes are on the event, just unregister eprobe */
-	if (trace_probe_has_sibling(&ep->tp))
-		goto unreg;
-
 	/* Enabled event can not be unregistered */
 	if (trace_probe_is_enabled(&ep->tp))
 		return -EBUSY;
 
+	/* If there's a reference to the dynamic event */
+	if (trace_event_dyn_busy(trace_probe_event_call(&ep->tp)))
+		return -EBUSY;
+
+	/* If other probes are on the event, just unregister eprobe */
+	if (trace_probe_has_sibling(&ep->tp))
+		goto unreg;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (trace_probe_unregister_event_call(&ep->tp))
 		return -EBUSY;
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -753,10 +753,6 @@ static void __unregister_trace_fprobe(st
 /* Unregister a trace_probe and probe_event */
 static int unregister_trace_fprobe(struct trace_fprobe *tf)
 {
-	/* If other probes are on the event, just unregister fprobe */
-	if (trace_probe_has_sibling(&tf->tp))
-		goto unreg;
-
 	/* Enabled event can not be unregistered */
 	if (trace_probe_is_enabled(&tf->tp))
 		return -EBUSY;
@@ -765,6 +761,10 @@ static int unregister_trace_fprobe(struc
 	if (trace_event_dyn_busy(trace_probe_event_call(&tf->tp)))
 		return -EBUSY;
 
+	/* If other probes are on the event, just unregister fprobe */
+	if (trace_probe_has_sibling(&tf->tp))
+		goto unreg;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (unregister_fprobe_event(tf))
 		return -EBUSY;
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -538,10 +538,6 @@ static void __unregister_trace_kprobe(st
 /* Unregister a trace_probe and probe_event */
 static int unregister_trace_kprobe(struct trace_kprobe *tk)
 {
-	/* If other probes are on the event, just unregister kprobe */
-	if (trace_probe_has_sibling(&tk->tp))
-		goto unreg;
-
 	/* Enabled event can not be unregistered */
 	if (trace_probe_is_enabled(&tk->tp))
 		return -EBUSY;
@@ -550,6 +546,10 @@ static int unregister_trace_kprobe(struc
 	if (trace_event_dyn_busy(trace_probe_event_call(&tk->tp)))
 		return -EBUSY;
 
+	/* If other probes are on the event, just unregister kprobe */
+	if (trace_probe_has_sibling(&tk->tp))
+		goto unreg;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (unregister_kprobe_event(tk))
 		return -EBUSY;
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -392,13 +392,17 @@ static int unregister_trace_uprobe(struc
 {
 	int ret;
 
-	if (trace_probe_has_sibling(&tu->tp))
-		goto unreg;
+	/* Enabled event can not be unregistered */
+	if (trace_probe_is_enabled(&tu->tp))
+		return -EBUSY;
 
 	/* If there's a reference to the dynamic event */
 	if (trace_event_dyn_busy(trace_probe_event_call(&tu->tp)))
 		return -EBUSY;
 
+	if (trace_probe_has_sibling(&tu->tp))
+		goto unreg;
+
 	ret = unregister_uprobe_event(tu);
 	if (ret)
 		return ret;


