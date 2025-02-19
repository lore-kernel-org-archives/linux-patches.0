Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734F01C3BE9;
	Wed, 19 Feb 2025 09:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957195; cv=none; b=UYL0rdnpw63D/cBmmrUnMhhO+qCF6WnPrF3T8TYBjeUUlM6rnLmBHigAs+8G/Jk2B0SsI7P8onJEDdgjsm3kfp8x8tKEoWAi96aQK3pvzHTiVCkzDBElLNKA2P9izpoqtF4h7JDmj77Rpy+1iX2TeyoJ3N3dGjeYj/px6ObrEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957195; c=relaxed/simple;
	bh=ls+YL07gPGlQovFjfEdGqxnSuPXs2+Hq8oc45AoAgTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFY6PyF7PRrQVQvvN0pdW0oI39E/5qFCjykFkZmNLXnqUtOkiT81luRlpS8hSPD5IQ0pTdRUsgQUuLcMwEU1QrSVKz2botrke/KY/qN/06yWnhSUG9Ukg1/oUEhZ9CdJ4TbG/QkIfO+xCpoJUf0HqtODndsy8ipq2/xoqwWqqXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXVpAUTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXVpAUTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED792C4CEE7;
	Wed, 19 Feb 2025 09:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957195;
	bh=ls+YL07gPGlQovFjfEdGqxnSuPXs2+Hq8oc45AoAgTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXVpAUTgwAgjaLcPqXqCZGAKstjEWpLdoHBaiEFmY2ZDHyUJE/2nCAD5Xsd6dLooM
	 axwsK1tGkwV/wI5yztCY8skrLVkAhP1/EdhnafKbP3wPgMq+vv58BFJShAsBN14viQ
	 XX3+WPMFsndGSX9EUyZnYoZtLPjVa9mRMGh0F/HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 441/578] rtla/timerlat_hist: Stop timerlat tracer on signal
Date: Wed, 19 Feb 2025 09:27:25 +0100
Message-ID: <20250219082710.352358348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -783,9 +783,12 @@ out_err:
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
@@ -828,6 +831,12 @@ int timerlat_hist_main(int argc, char *a
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
@@ -894,7 +903,7 @@ int timerlat_hist_main(int argc, char *a
 
 	return_value = 0;
 
-	if (trace_is_off(&tool->trace, &record->trace)) {
+	if (trace_is_off(&tool->trace, &record->trace) && !stop_tracing) {
 		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);


