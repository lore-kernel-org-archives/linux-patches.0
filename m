Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06341D625;
	Thu, 30 Jul 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422894; cv=none; b=YhmH59/YYOqd5FR38fUbgEgpsquy9XTqfN5X0+so4mUvCbG6N7r6gXtXmWLEPvCjkz4ioRME9aHdMW+D8yEGdDqE7MAj/ZM1tz6iuMLMDwAAj37rVKeUc75IvKRILS7IsbFqQRYDXylhfi05umgK8l3hYgoDNsbF6QP2jA+KZX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422894; c=relaxed/simple;
	bh=X97EEnSSvfXm4XAN6mAk5yeYTCgPibDTPGZyOMUeUp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVxxqEWUhSRlCCs+2HzR1EQ8HBkZdQLnWYjFR0G5pcxlsbIJsxyB7mw1hbWJCNOmlUUCXj0CjALyTan1tOI2CBgjslNT/mTQH1vLZmhBhUlDt4s/vkbLnEIK3uscxWUwWvQJtpSzIMSzaQ79xkpPP6KtonT9SW1teI/NVZtLR94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTEA8iaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTEA8iaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBEA1F000E9;
	Thu, 30 Jul 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422893;
	bh=XlUqGxdCc6tjtP6luHj//8LrD3bw/y06iLxukAarAOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTEA8iaXvXUmOrHDFm1XojAnVYVn0g74j7yK5OVJzV4i0XDf0iF2inNAyFvYP60Q8
	 lVEwXhBp1MXPQ+aHDAz2K6yeoGAIjaH7JYgVAt66fgqIh/KVWMDA/zvAOEv8BL+8tQ
	 YBuR2id1KKtcNI1ghXyxaSRFqlimXmqPeGjKW/Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Usama Arif <usama.arif@linux.dev>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 591/744] tracing: Fix context switch counter truncation
Date: Thu, 30 Jul 2026 16:14:24 +0200
Message-ID: <20260730141456.843045076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6191,7 +6191,7 @@ char *trace_user_fault_read(struct trace
 {
 	int cpu = smp_processor_id();
 	char *buffer = per_cpu_ptr(tinfo->tbuf, cpu)->buf;
-	unsigned int cnt;
+	unsigned long long cnt;
 	int trys = 0;
 	int ret;
 


