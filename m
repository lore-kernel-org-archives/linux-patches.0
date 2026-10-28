Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207923;
	b=cSxELTvgA/bM36nuJu3a4Vr1p9K6mkMn2k4/uKnPaqNo40ShmGbVgkcv58vaGHEpMs5V
	 0dqGjQ7G5KIu0inZAx6R2Kx4RKqLN92dnWwGG8Zr2/TObUDoYAAAPUw3QGZlDx5RzuoIL
	 W7KeAj5iP+E0uwdXjT14qhVPQavU2fSZJd7NG/PZ/1TvS8ccWXQo5ibjcUOJ61MuGLIbJ
	 T7TK9MmZbVIxnYjfzdCD40JP0HP/UvBk3MKwCGaec8z5Nci6MnwR/OUrkXZSsPmvZXQhb
	 cwlr4s7hj4QLKdZYEDluW0Vibwh9+DEyDu7FgtPB2bdK84imZMiz0SN79sftIRcXFCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=No0qZF9cM1+9RGS4Zz4ajE18B7To3+tBnTC/5sVdSXI=;
	b=Nf93qSfQibKOtG3MiANk8g3kb2TljdAAbrRx+YbDRZr0LjieaochicfJR/6kKJIn0OZ4
	 xy1bwhrXU/+ZyKnksZ6Si+NW2s+6RwPQnvUMSXlxI/M1iMLYEemkTLSUXMR1fcOu3oyc3
	 twGQM4WfVPquhm9PjZ4mZajnlmMejS2q7fOkyslG6QJxcj660CxvWcJNbC2JnP2ozR2U+
	 +nckGsMXMAW9m3PzkbsNj50UNgd7QMN80NBZtXUBT+YyogRA8H+a3z0ShrxjtqO0z7wZy
	 ihXR1MyXp/3aDFg76FE6ZwHhf0bjmVrFcYPwAfvrW60S8PmJI1OytHvleYz7iQ7botQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISr3wGfs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052D606A321;
	Wed, 28 Oct 2026 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISr3wGfs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA331F031E1;
	Wed, 28 Oct 2026 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207923;
	bh=No0qZF9cM1+9RGS4Zz4ajE18B7To3+tBnTC/5sVdSXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISr3wGfstDO7DMZEhJfReo8eEc+u1OvhiHeC2oMX9z2zSRqQqyOICbnFkTdRgw28H
	 txKhVaPcjgYwsOhM01dzaB0Pfbzr6H+DosQSD3Zd3wFacEHeDvniJb9ih/h/Gn4iOJ
	 IiqZHTI9kqeKDApQCEHia9zEgitHJShiDQSfQrUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 188/247] tracing: Save the event file instead of the compatible histogram
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028165951.871461488@linuxfoundation.org>
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
@@ -6299,7 +6299,7 @@ static void unregister_field_var_hists(s
 	int ret;
 
 	for (i = 0; i < hist_data->n_field_var_hists; i++) {
-		file = hist_data->field_var_hists[i]->hist_data->event_file;
+		file = hist_data->field_var_hists[i]->file;
 		cmd = hist_data->field_var_hists[i]->cmd;
 		ret = event_hist_trigger_parse(&trigger_hist_cmd, file,
 					       "!hist", "hist", cmd);


