Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207148;
	b=VgrfRCl3WhdAmatW/DKD629GiieDDQp/awAcs2o9ErdGNCigO3BBT6/iz0A2ZucDaYD8
	 knutICCtoZewvmvgXCVnAI2quJmnT6Lf3n3+wxkRJGfvQKcGFNzdbR0MIfYTb70TsdNeC
	 2zqVgMp8qo0xRImoH0hCCNuiFZX4IKMvW0FrT0OlyT6Y94sCqsdG+4OZbCt+kXYw/VR0k
	 6pDu78POOfyRdQClGbB/dtgCp1cWbfki7D82IB1lrDoqqaW5iMDV4DRjD3dfqIvzQm01h
	 zQaqJnqCpAsdBDJaf8a6uirsGEgCgjTsXRkiClDeGuGANCd004HvUPHQxFC5ELGWPJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UpsmkqPMlTOcV/T9nJrD01n/zYKoAcng38JeWcMUXqE=;
	b=GleLOcs0Mvc+wO5dhMj1d5oUlIGLWY0qnytd6LUaAs0vNXqyY3QiIAPaPaeFckUhLEMu
	 ViaOE0voY9vyrOc19A4CNyOKhz395YkCZbX4KcaTKqwT2i0mXoRZ2qcY7s9SouQigWPLw
	 zjnle4fW49dQCxuj8ER7WRfi/Fh8RqwdSRSSFiC8lcgGIoYmkz1Sew0R+gKMby9qDDwpx
	 qTw+fS2PE9t8qyxwUYG8fAaw8+222DoOKbZU5FUzHKkGnqUFvIVS/C7TkrQlMCFXllWU4
	 J7nJHXS1X0HfD8r+v80iZKzCTrkMpYeWcyqD3IBdgFO5tIpTwotAQAGL45xhccSOZpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nf8F2mNo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468B606A31C;
	Wed, 28 Oct 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nf8F2mNo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7031F01825;
	Wed, 28 Oct 2026 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207147;
	bh=UpsmkqPMlTOcV/T9nJrD01n/zYKoAcng38JeWcMUXqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nf8F2mNo/MUeFsU3Tio/eB7LluOV7NFydSVD1NPlgIoIlfQNHgMl0o4PzJ8DE72zh
	 aWQJx3FVLuLLmghEaWBK8/+7tUD4bf1SehYm4zzgeRckL5GZEwK/ZYoqRU8XZGl202
	 IPpvFMdjFhAvh6i3LdVS3+2K+hg28DhZniWMO1y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 09/38] tracing: Unregister field variable histograms when the command fails
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028165940.636901858@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 91c14d6c13096091c56304120aaa26e479130b8b upstream.

An action that names a field on another event needs that field as a
variable, so create_field_var_hist() registers a second hist trigger on
that event to provide it, and records it in
target_hist_data->field_var_hists[].

If a later part of the same command fails, create_actions() returns an
error and event_hist_trigger_parse() jumps to out_free. The write fails
with -EINVAL and sched_switch gets no trigger, but:

  # echo 'hist:keys=pid:ts0=common_timestamp.usecs' >> \
      events/sched/sched_waking/trigger
  # echo 'my_synth u64 lat; int a; int b' >> synthetic_events
  # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:\
      onmatch(sched.sched_waking).my_synth($wakeup_lat,prio,nosuchfld)'\
      >> events/sched/sched_switch/trigger
  # cat events/sched/sched_waking/trigger
  hist:keys=pid:vals=hitcount:ts0=common_timestamp.usecs:sort=hitcount:size=2048:clock=global [active]
  hist:keys=pid:vals=hitcount:synthetic_prio=prio:sort=hitcount:size=2048 [active]

The second histogram is the one created for 'prio'. It is still active and
still counting.

out_free reaches destroy_field_var_hists(), which frees the
field_var_hists[] entries, but never unregister_field_var_hists(), which is
what removes the triggers and runs only from event_hist_trigger_free(). The
entry is freed and the trigger is left with nothing tracking it.

Unregister the field variable histograms in out_free as well, and record
each one as soon as its trigger is registered rather than after the lookup
that follows it, so no exit can leave a registered trigger untracked. The
entry then belongs to field_var_hists[] and is released by
destroy_field_var_hists(), so freeing it on that exit would be a double
free.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914104036.1768529-1-donggeunyoo.kernel@gmail.com
Fixes: 02205a6752f2 ("tracing: Add support for 'field variables'")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260913204302.DB2551F000FF@smtp.kernel.org/
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3135,20 +3135,18 @@ create_field_var_hist(struct hist_trigge
 
 	kfree(cmd);
 
+	n = target_hist_data->n_field_var_hists;
+	target_hist_data->field_var_hists[n] = var_hist;
+	target_hist_data->n_field_var_hists++;
+
 	/* If we can't find the variable, something went wrong */
 	event_var = find_synthetic_field_var(target_hist_data, subsys_name,
 					     event_name, field_name);
 	if (IS_ERR_OR_NULL(event_var)) {
-		kfree(var_hist->cmd);
-		kfree(var_hist);
 		hist_err(tr, HIST_ERR_SYNTH_VAR_NOT_FOUND, errpos(field_name));
 		return ERR_PTR(-EINVAL);
 	}
 
-	n = target_hist_data->n_field_var_hists;
-	target_hist_data->field_var_hists[n] = var_hist;
-	target_hist_data->n_field_var_hists++;
-
 	return event_var;
 }
 
@@ -6987,6 +6985,8 @@ static int event_hist_trigger_parse(stru
 
 	trigger_data_free(trigger_data);
 
+	unregister_field_var_hists(hist_data);
+
 	destroy_hist_data(hist_data);
 	goto out;
 }


