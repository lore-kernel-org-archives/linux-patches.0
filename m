Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209546;
	b=r1BXPfMhU/J/dQLRo4voFcSM1M987+4VLdY6VsmA6X2EV6kFwbneFXCpK6JrYB/Yu41O
	 XqiRQvnZARMzh1BgmtZygd0qaoiHwztYzIdT0dXtrnixYxh8q+QrU7ltM9+4GhC1xa1PG
	 RShqe9M7bilwa2i+/L3FGideKpJv3F+3ZcjfgHKJ3hQT6MYFK2WMhMH1/oIoaxAPRdMAq
	 Tp8YtSg6OGFN1fJyPk7PzHB78klC6pWp0LDM0ty+W6NEioiCuL3/N9xwXGNE8wI6BVFkw
	 4agloud8o5OibeZicDRRKWSyoYiyuDobvSSZH8H+e29YAFc4SKUkS3AToVcJQmpM8VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h5EqvADY1r7UDoj/6k3k3VDKtC8fGgmR5FrdvLMqOQM=;
	b=FeVu5Zp6iPAET/gajldLF41NI9S79Z5CQ80P34LU2B+5fAzzQrEhVKFbCHhezium73ds
	 DYtBq7MB7K5/99HvlhrLfyBLz0NQId3atO15nFo9iD2+37g89I32KvovC2vgpdTyKRFPn
	 87UYlodFWEowmUwBsHlpuP3PIKoxAT7JCABOVau5JhJCweJLaDQeN5w1FkS8i7AEaZtr8
	 AVW7Zqmx5BIoJAlL23xhzdCZN0FD75LTUSqRjnAtfCzuMw+2KMWJJTL+cF+/dsMr0VRRA
	 7egxD47tMNC7LPChqRAElh0aEOFG/Zevy07LZtqGmhbYtz8iH4OCflkjla59wJ59l8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1089YY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2EA606A31C;
	Wed, 28 Oct 2026 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1089YY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4391F031E0;
	Wed, 28 Oct 2026 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209545;
	bh=h5EqvADY1r7UDoj/6k3k3VDKtC8fGgmR5FrdvLMqOQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1089YY0TmsR4mFps47OVqXc1puG58y2JI5kdz2Cp1danLIWJkG/72ep9PApQ9+VE
	 s5AHCRjcM0wgqiteMt9YCqSldPa1UJNSNY8GYw20n4pivp9ccmQAmyHgBdUzM41dS5
	 8CE+y16sLvL3p1AKbxi7JeFAmaNajlubgCy2fRck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 507/516] tracing: Save the event file instead of the compatible histogram
Date: Wed, 28 Oct 2026 18:00:59 +0100
Message-ID: <20261028170015.487498509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -338,7 +338,7 @@ struct field_var {
 };
 
 struct field_var_hist {
-	struct hist_trigger_data	*hist_data;
+	struct trace_event_file		*file;
 	char				*cmd;
 };
 
@@ -2552,8 +2552,8 @@ create_field_var_hist(struct hist_trigge
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* Save the compatible histogram information */
-	var_hist->hist_data = hist_data;
+	/* Needed to remove the histogram when the target goes away */
+	var_hist->file = file;
 
 	/* Create the new histogram with our variable */
 	ret = event_hist_trigger_func(&trigger_hist_cmd, file,
@@ -5274,7 +5274,7 @@ static void unregister_field_var_hists(s
 	int ret;
 
 	for (i = 0; i < hist_data->n_field_var_hists; i++) {
-		file = hist_data->field_var_hists[i]->hist_data->event_file;
+		file = hist_data->field_var_hists[i]->file;
 		cmd = hist_data->field_var_hists[i]->cmd;
 		ret = event_hist_trigger_func(&trigger_hist_cmd, file,
 					      "!hist", "hist", cmd);


