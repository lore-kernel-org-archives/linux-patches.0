Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210230;
	b=vJb+MWcXCJxi+ew/loNi9UIIN8zHab8AVLwxT/q0PjNmZ1GP6k6Ur6SvK8Fq+t/SXoiW
	 1LkmVoCebxJODLmXVeITull5VpVfhA81VsonoglkyO++/rvBErkDKapZcvW+7vtk7fyC8
	 E7WL//b8IailESMXYy3Uaz8NB1Yf+g6nqenDysSjSYLBdWioTxECXI4cMbqW5xEDNot3b
	 QH3tMnWsPvfgaJnHrmwt6V+mnomf4/Hjnr74bud0QoxR94Ss4mptXLUQUm+TsVsfwW2Gp
	 II9sHw4eZCS0/7L1BV+CuS973YLD1/pLSRi3SmK+657qLcFyxtCHoEYUlaoslJnfd8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5RZbts1/8vax1BKQLyxHozeVpq5ewcITmhpjrIDnRM=;
	b=jFghQ378X+Sa7NjXjn/MJ7+BPyAt4NdZEeepunh9PD0r13GD8JiVJIpIYLjiCAxdBTA4
	 KK8HR/TL3IkA1MjDQuXzqc+sE42aF1St9PWo+uopBToYzexSIGdI28iTdS7UzNvwRms2h
	 1DhwRm7yRpjaqUroXIBZVNhiP63NNAhma7VsLURoFvduHKnelccpIpQ3yi8cMQcCDPVs+
	 EuRZga/UqxyvEuCrtNUF3l5+4QruV5FUVh7KtXqYP518KOBRbOod4piI5a7KrPkuU+Nik
	 T2uT4kJzTs6celEBcGACvTbR+Hw1bAzgaIluHo8oovhHipwMUBOzuCOOS0vtO0PRHGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJtboycu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0126606A327;
	Wed, 28 Oct 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJtboycu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD4E1F01825;
	Wed, 28 Oct 2026 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210229;
	bh=t5RZbts1/8vax1BKQLyxHozeVpq5ewcITmhpjrIDnRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJtboyculwp4frJiw2ypcTX5lVZ6UoVFX42BokrOUsOx1tl1V599kxK4nmMMCyZWQ
	 VwLj5DvOxuVsiCYBCyxNCyZC/BK5d7LrASzB8AZ0YJQ4NQVijS3rp5E9FIgF/jGRGI
	 /LzDUQzihwfG8AXmbe6xAxCgoxSvX10ZjHRwR2YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 122/168] tracing: Save the event file instead of the compatible histogram
Date: Wed, 28 Oct 2026 18:00:58 +0100
Message-ID: <20261028165945.974106760@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit d5c42664fc094899af9aae5300b27fe8fdb658ef upstream.

create_field_var_hist() creates a histogram on the matched event to
supply a field variable, and records it on the target so it can be torn
down later:

	hist_data = find_compatible_hist(target_hist_data, file);
	...
	/* Save the compatible histogram information */
	var_hist->hist_data = hist_data;

hist_data is not the histogram it creates. It is one that was already
there, whose keys the new one copies. The saved pointer has a single
user, unregister_field_var_hists(), which runs when the target is
removed:

	file = hist_data->field_var_hists[i]->hist_data->event_file;

find_compatible_hist() matches on keys alone, so it can pick one with no
variables of its own. check_var_refs() then returns false and the user
can remove it while the target still points at it:

 BUG: KASAN: slab-use-after-free in event_hist_trigger_free+0x2b2/0x320
 Read of size 8 at addr ffff8880093b90e0 by task init/1

 Freed by task 1:
  kfree+0x154/0x420
  event_hist_trigger_free+0x1d5/0x320
  event_hist_trigger_parse+0x35f3/0x69e0
  trigger_process_regex+0x1a6/0x250

Save the event file instead. It is all the dereference ever wanted, and
it does not go away when the user removes a trigger.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260914110753.221E61F000FF@smtp.kernel.org/
Link: https://patch.msgid.link/20260914234754.3676905-1-donggeunyoo.kernel@gmail.com
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Acked-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -542,7 +542,7 @@ struct field_var {
 };
 
 struct field_var_hist {
-	struct hist_trigger_data	*hist_data;
+	struct trace_event_file		*file;
 	char				*cmd;
 };
 
@@ -3077,8 +3077,8 @@ create_field_var_hist(struct hist_trigge
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* Save the compatible histogram information */
-	var_hist->hist_data = hist_data;
+	/* Needed to remove the histogram when the target goes away */
+	var_hist->file = file;
 
 	/* Create the new histogram with our variable */
 	ret = event_hist_trigger_parse(&trigger_hist_cmd, file,
@@ -6300,7 +6300,7 @@ static void unregister_field_var_hists(s
 	int ret;
 
 	for (i = 0; i < hist_data->n_field_var_hists; i++) {
-		file = hist_data->field_var_hists[i]->hist_data->event_file;
+		file = hist_data->field_var_hists[i]->file;
 		cmd = hist_data->field_var_hists[i]->cmd;
 		ret = event_hist_trigger_parse(&trigger_hist_cmd, file,
 					       "!hist", "hist", cmd);


