Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBE326B0BF;
	Thu, 13 Feb 2025 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459988; cv=none; b=d5tI/mwIEKXS1yMqphbm6cz/XcTWAqxsWkHFNB6k0ivalT4t0pxEr0ZxyKRrUMaZv/2ubg5ERopX7DHnzT4LkMjOT7u/PufO8SVry6s4utSrfWm0qOuZ0O4bVreIzKN4j/8UjhTLgCN+wIVbrH+IbR8zx4ITAWSGZE7G8sMxcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459988; c=relaxed/simple;
	bh=3PWXAMeW0DtUCVR7rjo+GLOpUB0vvnzLanI9VUnUPSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jif/elXt8nTzQ3roxYI1glz2Lfud8F+sQdFsjL5HsTh3yaZ29amrm8FHi/cEk6bKd5injKoBX8wnCeFOWXpY7kYkk/VaAE88eEhlai/Iws0n6VVLfO+qEjL5fiLwP1wCC5UFCsTQpu4ncXmkdDC1ySO+Iue0AmQ9o/tiEE3LuaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuFjj5Sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuFjj5Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D729C4CED1;
	Thu, 13 Feb 2025 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459988;
	bh=3PWXAMeW0DtUCVR7rjo+GLOpUB0vvnzLanI9VUnUPSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuFjj5SzmX+Hyf/ptLFUXkiCNtxkFmfhuEuZf185gyKwBO3Sf66ANt6LL7j5xCbhq
	 DVo6io9oZwq8UlLxExxv1NS3KiY9G29HTKXOkMe5cySAfSIX7uBDv59sDMNu08+nY8
	 3b0iwSz0XNN/bwPVqqZeAO0OMtu1MUPSl6cPxxrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 425/443] rtla/timerlat_top: Stop timerlat tracer on signal
Date: Thu, 13 Feb 2025 15:29:50 +0100
Message-ID: <20250213142457.021479461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit a4dfce7559d75430c464294ddee554be2a413c4a upstream.

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
Link: https://lore.kernel.org/20250116144931.649593-4-tglozar@redhat.com
Fixes: a828cd18bc4a ("rtla: Add timerlat tool and timelart top mode")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_top.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -903,9 +903,12 @@ out_err:
 }
 
 static int stop_tracing;
+static struct trace_instance *top_inst = NULL;
 static void stop_top(int sig)
 {
 	stop_tracing = 1;
+	if (top_inst)
+		trace_instance_stop(top_inst);
 }
 
 /*
@@ -953,6 +956,13 @@ int timerlat_top_main(int argc, char *ar
 	}
 
 	trace = &top->trace;
+	/*
+	* Save trace instance into global variable so that SIGINT can stop
+	* the timerlat tracer.
+	* Otherwise, rtla could loop indefinitely when overloaded.
+	*/
+	top_inst = trace;
+
 
 	retval = enable_timerlat(trace);
 	if (retval) {
@@ -1134,7 +1144,7 @@ int timerlat_top_main(int argc, char *ar
 
 	return_value = 0;
 
-	if (trace_is_off(&top->trace, &record->trace)) {
+	if (trace_is_off(&top->trace, &record->trace) && !stop_tracing) {
 		printf("rtla timerlat hit stop tracing\n");
 
 		if (!params->no_aa)


