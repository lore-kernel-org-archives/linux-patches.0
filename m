Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD51D63C5;
	Thu, 13 Feb 2025 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460929; cv=none; b=hxcM+QUHjihKWXj48HpeOjwnDp205masfgFq8ex01ydhGC2GGmbjmMW2dYoT76zM3IA41mI6ZCD/CN9x9LAZ0SnlNedW6H+ix+PKILtmrBYAufTuvAfeln5vQkzink6hhrbP+YjHzwFcHxZAfjjue35WQRsSA1oFeiuwrkOoD84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460929; c=relaxed/simple;
	bh=iWuRbBiLxudn29gm0ZYmJ2BDlil3l8c77teekNhFsiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itoe6RJalim3P5aNGe9PfdkkuFs3yrieZDl8exvmXnPPYskaGGq43iCb0r1vOjylA13vPlP8cNdz/isMx02ZP51x31IXSj2ABilPjnV9q4HpzZvKM1p0IpLljtmmvMsGj5Irxwkzrl6XoNBs7NNGVRl8bb6sWEFo/4ku7GkmqUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuwlblgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuwlblgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538E6C4CEE5;
	Thu, 13 Feb 2025 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460928;
	bh=iWuRbBiLxudn29gm0ZYmJ2BDlil3l8c77teekNhFsiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuwlblgm0NyBeEWTm9OU1FJCZDKUAHvV0WpANOlT6NBYEntN/ePF2ZmA7phfWhE/5
	 +Riw4VH4OBSTT4Z7zAhmu6QOJ31HJL9TdLt4LZRa+PbaarcJaSTgOPfOlWpMTW1u6x
	 z7Xvs7b5D2PporK/k+V7feFBfsBA/ecG4glO+Tx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 254/273] rtla/timerlat_hist: Stop timerlat tracer on signal
Date: Thu, 13 Feb 2025 15:30:26 +0100
Message-ID: <20250213142417.462113055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomas Glozar <tglozar@redhat.com>

commit c73cab9dbed04d8f65ca69177b4b21ed3e09dfa7 upstream.

Currently, when either SIGINT from the user or SIGALRM from the duration
timer is caught by rtla-timerlat, stop_tracing is set to break out of
the main loop. This is not sufficient for cases where the timerlat
tracer is producing more data than rtla can consume, since in that case,
rtla is looping indefinitely inside tracefs_iterate_raw_events, never
reaches the check of stop_tracing and hangs.

In addition to setting stop_tracing, also stop the timerlat tracer on
received signal (SIGINT or SIGALRM). This will stop new samples so that
the existing samples may be processed and tracefs_iterate_raw_events
eventually exits.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-3-tglozar@redhat.com
Fixes: 1eeb6328e8b3 ("rtla/timerlat: Add timerlat hist mode")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -949,9 +949,12 @@ out_err:
 }
 
 static int stop_tracing;
+static struct trace_instance *hist_inst = NULL;
 static void stop_hist(int sig)
 {
 	stop_tracing = 1;
+	if (hist_inst)
+		trace_instance_stop(hist_inst);
 }
 
 /*
@@ -997,6 +1000,12 @@ int timerlat_hist_main(int argc, char *a
 	}
 
 	trace = &tool->trace;
+	/*
+	 * Save trace instance into global variable so that SIGINT can stop
+	 * the timerlat tracer.
+	 * Otherwise, rtla could loop indefinitely when overloaded.
+	 */
+	hist_inst = trace;
 
 	retval = enable_timerlat(trace);
 	if (retval) {
@@ -1129,7 +1138,7 @@ int timerlat_hist_main(int argc, char *a
 
 	return_value = 0;
 
-	if (trace_is_off(&tool->trace, &record->trace)) {
+	if (trace_is_off(&tool->trace, &record->trace) && !stop_tracing) {
 		printf("rtla timerlat hit stop tracing\n");
 
 		if (!params->no_aa)


