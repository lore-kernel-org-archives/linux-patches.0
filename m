Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CBC374A0E;
	Thu, 30 Jul 2026 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424715; cv=none; b=H77MCvYcoMpTFeNo3KWpmrwGDnopsDYU1macBSz87CcYCrD6oToKs2FRWCNd1TP+THA6/Gf1IxXpIrX4Oi0xCmqKcxg7z7S21djxA5Utb2yssfs7aKTzNoJVlodivuIJg3oRynMogGOnaMypqHm6mGMRK9wKx63nlxM+Jscu8SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424715; c=relaxed/simple;
	bh=d+wLCY0tLZ6iZ2m28sCoHMPgQB/7h5gHjpWuKAwdR68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kfpwi5tyc+eTQhfxNvrmcZJ2kJSUuhmB30Nt2+PULzhLY5t6SSjM7iyF6dwPMFrcBPZsY2XhJ6z8baqCLpFudGF/tcfCiSy5i4tug5n9a01vsQljV/hJ+lKqb5Qjj0coRuH47X8k/yyIdpuSXme9xRMbBbgiV1ZUS+cadQ6MRgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTuK8g01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTuK8g01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF511F00A3A;
	Thu, 30 Jul 2026 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424714;
	bh=4XStNNYsvTJzGmw/VeOEV/2btT2vRs5S4ppc0WPWIew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTuK8g01DVekf62aERLGz88shg9XrLnf7o+bbyyjsO1h+MTOFGf2OpBbhXHiK7Q5d
	 UixtoqDBhe1Fd0ms3JRUKeYAyzz9jUpx9r0TY9720ZBismHasQ94iXAWdrkekBmv5y
	 zIzwMdaQhzpdcY1zqgdkDZBl2CD5JKmrBX5r/WKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Usama Arif <usama.arif@linux.dev>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 490/675] tracing: Fix context switch counter truncation
Date: Thu, 30 Jul 2026 16:13:40 +0200
Message-ID: <20260730141455.536258619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

commit 8f76afb9b114bee1c1251e0e52553e9dc7c59f20 upstream.

trace_user_fault_read() samples nr_context_switches_cpu() before enabling
preemption and retries the user copy if the counter changes. The helper
returns unsigned long long because rq->nr_switches is u64, but the saved
value is unsigned int.

Once a CPU has performed 2^32 context switches, assigning the counter to
cnt discards its upper bits. The comparison after the copy promotes cnt
back to unsigned long long, but the lost bits remain zero, so it reports a
change even when the task was never scheduled out. Every retry then fails
the same way until the 100-try guard warns and the user copy is abandoned.

This affects long-running systems and workloads with high context-switch
rates. A CPU switching 1,000 times per second takes about 50 days.

Store the sampled count in unsigned long long so the full value is
preserved.

Cc: stable@vger.kernel.org
Fixes: 64cf7d058a00 ("tracing: Have trace_marker use per-cpu data to read user space")
Link: https://patch.msgid.link/20260717173252.3431565-1-usama.arif@linux.dev
Reported-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7325,7 +7325,7 @@ static char *trace_user_fault_read(struc
 {
 	int cpu = smp_processor_id();
 	char *buffer = per_cpu_ptr(tinfo->tbuf, cpu)->buf;
-	unsigned int cnt;
+	unsigned long long cnt;
 	int trys = 0;
 	int ret;
 


