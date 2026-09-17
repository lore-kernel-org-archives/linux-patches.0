Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE94E77F1;
	Thu, 17 Sep 2026 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660084; cv=none; b=qnIxzYtjNrT6vNW5vkrM+TMkXeaDrZ4Jabm30yTQELqRt/lZC9wkiGCakUjX9+klCL9/zdLUB1bJ4JBbNNdWQVIOROOULgqFqO+L9B6kQREsMSU3F5X0S2pVyJpt1tw5Lp2JSCloVfqDHLBzFqTG+rVRweP88mQ7kiunS4fyHyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660084; c=relaxed/simple;
	bh=ioRCnt2RvcabLGUE0TKsT/faIvjl63EWKwggeZqh0hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDsIl20FkHXVvJj14EmdtKoaif0bKTxczWPLapj34Fb5bHcL0tBrDZOwI0GEB6N3ANJYKX4TYwEdVYRUiyMui2asEa81GRuJzX9xNq28e9GDEbdxBRY92Cx5nJgNJLZHPmgJosrn605T/d5GS6EXgzWdKIEtgStGangRekLFnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntYjv9LJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntYjv9LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193FF1F000FF;
	Thu, 17 Sep 2026 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660076;
	bh=e5RJP3u7CG8TdOABsYlWJw5Pu63RCzoXOCZLoGPXKnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntYjv9LJaKBuOJm3/2njuB8GzZv5zyV87oylpk6WyjITK9klZBhs+6V6ehb4Dd3T5
	 Mjg/LbNAHZBD9uW/1x196EgGIFX0Kzx2g9oJiJAHlN911GlsDc0bsAcpQDHValLrqz
	 Z4CZM28BYJBHSCs8wD3vEdvfjDyzVQjVkE8uUClk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 471/733] tracing: Set the trace clock before registering the histogram trigger
Date: Thu, 17 Sep 2026 16:12:59 +0100
Message-ID: <20260917151403.726780399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 6ede78d0563a2a3ae3e46f9c07cedb5d79645429 upstream.

hist_register_trigger() puts the trigger on the global named_triggers
list in cmd_ops->init(), and only then sets the trace clock:

	if (data->cmd_ops->init) {
		ret = data->cmd_ops->init(data);
		if (ret < 0)
			goto out;
	}

	if (hist_data->enable_timestamps) {
		ret = tracing_set_clock(file->tr, hist_data->attrs->clock);
		if (ret) {
			hist_err(tr, HIST_ERR_SET_CLOCK_FAIL, errpos(clock));
			goto out;
		}

The clock string is not checked anywhere before that call, so a named
trigger using common_timestamp with an unknown clock fails after it has
already become findable. event_hist_trigger_parse() then frees it
without taking it off the list, and the next lookup by name reads the
freed object:

 ~# cd /sys/kernel/tracing/events/sched/sched_switch
 ~# echo 'hist:name=foo:keys=common_pid:ts=common_timestamp:clock=bogus' > trigger
 bash: echo: write error: Invalid argument
 ~# echo 'hist:name=foo:keys=common_pid' > trigger

  BUG: KASAN: slab-use-after-free in find_named_trigger+0xac/0xc0
  Read of size 8 at addr ffff88800915d760 by task init/1
   find_named_trigger+0xac/0xc0
   hist_register_trigger+0xc1/0x900
   event_hist_trigger_parse+0x3146/0x6af0
   event_trigger_write+0xce/0x160
  Freed by task 63:
   kfree+0x154/0x420
   trigger_kthread_fn+0xfd/0x160

Set the clock before the trigger is registered, so that nothing which
can fail runs after it is published, the way commit 6f86bdeab633
("tracing: Fix bad hist from corrupting named_triggers list") moved the
registration below the rest of the setup.

tracing_set_filter_buffering() is reference counted, so the init failure
path has to drop the reference that the clock block now takes first.

Cc: stable@vger.kernel.org
Fixes: a4072fe85ba3 ("tracing: Add a clock attribute for hist triggers")
Link: https://patch.msgid.link/20260907091415.554535-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6631,12 +6631,6 @@ static int hist_register_trigger(char *g
 		data->cmd_ops = cmd_ops;
 	}
 
-	if (data->cmd_ops->init) {
-		ret = data->cmd_ops->init(data);
-		if (ret < 0)
-			goto out;
-	}
-
 	if (hist_data->enable_timestamps) {
 		char *clock = hist_data->attrs->clock;
 
@@ -6649,6 +6643,15 @@ static int hist_register_trigger(char *g
 		tracing_set_filter_buffering(file->tr, true);
 	}
 
+	if (data->cmd_ops->init) {
+		ret = data->cmd_ops->init(data);
+		if (ret < 0) {
+			if (hist_data->enable_timestamps)
+				tracing_set_filter_buffering(file->tr, false);
+			goto out;
+		}
+	}
+
 	if (named_data) {
 		remove_hist_vars(hist_data);
 		destroy_hist_data(hist_data);


