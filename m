Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC71615E5BB;
	Sat, 17 Oct 2026 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257489; cv=none; b=JgAB/jeYNbXzD3xgx6We1Q4H49OUfi2PSkLNQ9KHUBipoKdfsHFa+cYMsUPxeJ0UYuMOquR85Kl+G2NKa9EUHieAv7hJp4Lms2O4vgOJYHKleBL68QdHW2n8sxgmdDvlMVTmhlQXW6O8QrW4sk213f5LAawvdZv8+5uVI7q6F9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257489; c=relaxed/simple;
	bh=6s9ya0AzvNzKqrGjpK0GIrwbFCvjkAPmhePqbCSz3IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQM1xyCp79ctiSp8kilsYXeGXy8rvQty/WpFVAehbDtpjjk0ZvDW/5Sn2dC8opwwtQH59LJVAO8Ld6TzGI6IoNbo/8MikIxoTg1ayNQAI8kMVR1Rxt4EwlaDpx0isRaSLvmWC91cwr5L5TB3DNLWg5YWsPdzBM2mbwcaTf0y1qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHIKCdPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHIKCdPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445921F000C4;
	Sat, 17 Oct 2026 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257487;
	bh=CMEp3s7cZZqsJD/R0YUYfZs6n36KVMtLunRSHltb+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHIKCdPW8365nSCmrjCi3d0iG5Uo3orxQyr+l3IH8zz5yLUkMITTMwE4dFX58/raq
	 UckIoELc/WZFSN6vM4xxHIWz/vRIIu5kxmeAveaWNKUzUeWlXBzqqpDStT5dj7gmuw
	 eYzVKQzpgE3IvYSaPC+mS7drCx4Apel8/qahJKZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0568/1674] tracing: Set the trace clock before registering the histogram trigger
Date: Sat, 17 Oct 2026 17:47:20 +0200
Message-ID: <20261017160445.674181729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 6ede78d0563a2a3ae3e46f9c07cedb5d79645429 ]

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
[Lee: Call data->ops->init(data) as b052d70f7c9c ("tracing: Merge struct
      event_trigger_ops into struct event_command") is not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index d96faf3436a05..492e183d09a0a 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6565,12 +6565,6 @@ static int hist_register_trigger(char *glob,
 		data->ops = &event_hist_trigger_named_ops;
 	}
 
-	if (data->ops->init) {
-		ret = data->ops->init(data);
-		if (ret < 0)
-			goto out;
-	}
-
 	if (hist_data->enable_timestamps) {
 		char *clock = hist_data->attrs->clock;
 
@@ -6583,6 +6577,15 @@ static int hist_register_trigger(char *glob,
 		tracing_set_filter_buffering(file->tr, true);
 	}
 
+	if (data->ops->init) {
+		ret = data->ops->init(data);
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
-- 
2.53.0



