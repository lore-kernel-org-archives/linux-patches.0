Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210105;
	b=RHYxhOKvwZSY8TWAA43yhTzOQvqHVWxGEdBZX9PNrmxqOJogWnFyrRViXHLOicxr+vJU
	 JUcmDmnoOd/3S0QxapCRnudgy2KIuuRx3V5YT9Jd0XcSyyKxvjXjSmfOPw16evUBvaGOF
	 jyfGRIgNmeNzad9B6GxuQu2kRDbcQSTmMmDtC1T5/dpYFFElylUvduB+j4aHNHS6W/9I7
	 wfqHBsL39VYR27UX4DLObSJdDohpNLvJi90Wl4Vyv8geKrbC8P5z5rEGZ9suAmFzztp1p
	 +zguWq8ifMdD3I/G0Ti5XCIf5JSqiyYqWOcmENeLsKxEQGjKa9rXklAsiAVnh8fcvwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OG991RQMkyMnZUrkVZFm+ArAT+fACVCoKMbyRjpidmU=;
	b=FYLp6FEIxNZRPghGP/bHeg1tVs525sYNTn0FkICpjHtBdt7/iSs8KZAEX37oR/TXwikI
	 SNI/Ljn72ykKzB70/qoqtTfSo8DX4yNubRnw/licDIE1iZWGLky40qPDMVO6qU7Wb0yWN
	 WJqBUHGKKismvM8un/TfxAleis6eDWa4qSwKt9LNeBZx93lwfupeKWvSBwSaziBWFnW49
	 xZt6w1w0R5st+4mHklDpHO4e66jDJTs9OxLCLIFpd4P5j2ubRY6YjCkwUIKU7iSrFHTXw
	 0ZazjG4aBSwt0v3semi01LknSc1XYRFkfPsF6RYGShkKUH9Mjs+SRg40fV0+AXTDTgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2GKgKqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA2C606A321;
	Wed, 28 Oct 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2GKgKqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4091F01825;
	Wed, 28 Oct 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210105;
	bh=OG991RQMkyMnZUrkVZFm+ArAT+fACVCoKMbyRjpidmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2GKgKqGjoa8AD88EeC11X1DhMm6gfD6v/KGkeqELuHdN3L3r5y4dV5iOz6RdUqMH
	 Mi6sbdOFFKhMddvkEfTzV/S6aOl6ANK/+GWRFWsypol8qLso5fj3popz3d8INjdoR0
	 Jo7ksl030UdF12GxFzBEqfVwlpeOvwz+ru/gbL3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 051/168] tracing/histograms: Reject non-stacktrace fields for synthetic stacktrace fields
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028165944.297482113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit a244c241593b5b38a08f0df2cb43c26574efbdcb upstream.

In check_synth_field(), when a synthetic event field is a stacktrace
(field->is_stack) and the histogram field is not a "long[" stacktrace
array, validation falls through to the generic size and signedness
comparison.

Because parse_synth_field() sets a stacktrace field's type to
"__data_loc unsigned long[]", its size is sizeof(u64) and
synth_field_signed() marks it as signed.  Consequently, any 8-byte
signed scalar histogram field passes the fallback check, and its scalar
value is subsequently dereferenced as a kernel stacktrace pointer in
get_field_size() and trace_stack().

Furthermore, checking strstr(hist_field->type, "long[") is insufficient
because tracepoint fields defined with __bitmask() or __rel_bitmask()
also have type "__data_loc unsigned long[]" or "__rel_loc unsigned
long[]", whilst create_hist_field() treats them as 4-byte scalar values
without HIST_FIELD_FL_STACKTRACE.

Propagate HIST_FIELD_FL_STACKTRACE to variable references and field
variables (whilst excluding variable aliases from per-element
stacktrace capture), and reject any mismatch between
HIST_FIELD_FL_STACKTRACE and field->is_stack in check_synth_field().

Cc: stable@vger.kernel.org
Fixes: 00cf3d672a9d ("tracing: Allow synthetic events to pass around stacktraces")
Link: https://patch.msgid.link/20261013112449.1006088-1-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2098,7 +2098,8 @@ static int init_var_ref(struct hist_fiel
 	ref_field->size = var_field->size;
 	ref_field->is_signed = var_field->is_signed;
 	ref_field->flags |= var_field->flags &
-		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
+		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS |
+		 HIST_FIELD_FL_STACKTRACE);
 
 	if (system) {
 		ref_field->system = kstrdup(system, GFP_KERNEL);
@@ -3286,6 +3287,7 @@ static struct field_var *create_field_va
 		ret =  -ENOMEM;
 		goto err;
 	}
+	var->flags |= val->flags & HIST_FIELD_FL_STACKTRACE;
 
 	field_var->var = var;
 	field_var->val = val;
@@ -3904,7 +3906,10 @@ static int check_synth_field(struct synt
 	    && field->is_dynamic)
 		return 0;
 
-	if (strstr(hist_field->type, "long[") && field->is_stack)
+	if (!!(hist_field->flags & HIST_FIELD_FL_STACKTRACE) != field->is_stack)
+		return -EINVAL;
+
+	if (field->is_stack)
 		return 0;
 
 	if (strcmp(field->type, hist_field->type) != 0) {
@@ -4443,7 +4448,8 @@ static int create_var_field(struct hist_
 	if (!ret && hist_data->fields[val_idx]->flags & HIST_FIELD_FL_EXECNAME)
 		update_var_execname(hist_data->fields[val_idx]);
 
-	if (!ret && hist_data->fields[val_idx]->flags &
+	if (!ret && !(hist_data->fields[val_idx]->flags & HIST_FIELD_FL_ALIAS) &&
+	    hist_data->fields[val_idx]->flags &
 	    (HIST_FIELD_FL_STRING | HIST_FIELD_FL_STACKTRACE))
 		hist_data->fields[val_idx]->var_str_idx = hist_data->n_var_str++;
 
@@ -5185,7 +5191,8 @@ static void hist_trigger_elt_update(stru
 		if (hist_field->flags & HIST_FIELD_FL_VAR) {
 			var_idx = hist_field->var.idx;
 
-			if (hist_field->flags &
+			if (!(hist_field->flags & HIST_FIELD_FL_ALIAS) &&
+			    hist_field->flags &
 			    (HIST_FIELD_FL_STRING | HIST_FIELD_FL_STACKTRACE)) {
 				unsigned int str_start, var_str_idx, idx;
 				char *str, *val_str;


