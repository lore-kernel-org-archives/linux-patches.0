Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DB826B083;
	Thu, 13 Feb 2025 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458399; cv=none; b=hu/W+TXuMkAujab+19LrpsEtY94ba+Deuzh9OXEd1VNGoMWzgNywL92A7LQt+/JhneKgz9NztNIRQAakCyEMfl+Dt2buK8AoZRUftrWOZ5dTL1f0F/y49X6ardc4gDXOS/L2+UuxQd5sbQqyFOP8QXisyGrCS2jD6bKYXM2eT28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458399; c=relaxed/simple;
	bh=hPJhw8TztUyqUCbilzpv7nXqv1CwjPGCWAz6EGZi3O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhX49RPwIkrOsipeVpIKtW1YHM1KQvOATpZVS79MdxLjWn/kboOs+pa2ipCR3g20mL0UT9mCadzsEDkXoKVIlbsI1Tbkv4J//EGunxmUyYvCCqaojDbmc4gJ+yn346cArMe1B8iZwMiWoFltN1ahY2/CJZN8ndrzt1SO7i1qMbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiWvgTt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiWvgTt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AD1C4CED1;
	Thu, 13 Feb 2025 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458399;
	bh=hPJhw8TztUyqUCbilzpv7nXqv1CwjPGCWAz6EGZi3O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiWvgTt2NSkn9ChL0PutieqVdHzNkUDUoiBA5iWPz3ZuTAaHPCUWk5o3jgLDktHC8
	 4D+BI2GZeZWemH0NP9nHIQQwfN7xZVqtdU5GNTNABcRl96/Lmh81h8RohGiuHAM2Nf
	 qc9UHb8EY0M87scYt363bCR6Gr3Xdx+ZeT8Nl74U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 388/422] rtla/timerlat_top: Stop timerlat tracer on signal
Date: Thu, 13 Feb 2025 15:28:57 +0100
Message-ID: <20250213142451.521893489@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,9 +894,12 @@ out_err:
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
@@ -943,6 +946,13 @@ int timerlat_top_main(int argc, char *ar
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
@@ -1102,7 +1112,7 @@ int timerlat_top_main(int argc, char *ar
 
 	return_value = 0;
 
-	if (trace_is_off(&top->trace, &record->trace)) {
+	if (trace_is_off(&top->trace, &record->trace) && !stop_tracing) {
 		printf("rtla timerlat hit stop tracing\n");
 
 		if (!params->no_aa)


