Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF722E4248;
	Tue, 12 Aug 2025 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020715; cv=none; b=s11TcombJRLap9UcQxWKqesEfgyJN5HGn+ikrSvGOzqNRWU6FGP0ganupb4aU/fkp2hEwTBWX7JCZYyvgms1m8E8QcW8GITMg7x3n4aQc//BNqwAe0mQ3voazU81Umz4vunOR9umaDTKYhKDfgcsZb1xbFAqKBrgF18W1+E7mnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020715; c=relaxed/simple;
	bh=JFDZ6y0Fa49CpNPOX7Do3Dh8fKzT2T0OeiI0D0zli2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2MLSbjT3EeK0Nbkqjk1IdFmy1ZYRaElZ2oyl0xfRDsuUNMrRjAJwMz8yGvmySp1I0msELlsG4210CYHbfJdopJamCXTb+AvAIv/kGo+cseawXTUaHkqqAVUY4qDVYn60loo11EQB7kgdsAbcyO1HtoU6GtcoDpRoNMncdzrfrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rd+l5Mi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rd+l5Mi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1EAC4CEF0;
	Tue, 12 Aug 2025 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020715;
	bh=JFDZ6y0Fa49CpNPOX7Do3Dh8fKzT2T0OeiI0D0zli2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rd+l5Mi8n7DqZa+dNN9di8kn8iCvx+UoUQMKFPYkWwWjnzfZLN3sXLF2/39sCxWYf
	 R1YLa7J+0h5dFUPXp+406TNOoaRDepNe5EF9I3ftn0pTvpWoMA6RKbtoMOo7dHWYKL
	 gwgkTx0tyfHb2WBk6SPhQ0oSJMjeQjWzo8FB/Txw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Song Chen <chensong_2000@189.cn>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/253] kernel: trace: preemptirq_delay_test: use offstack cpu mask
Date: Tue, 12 Aug 2025 19:29:05 +0200
Message-ID: <20250812172955.400641480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit adc353c0bfb243ebfd29b6222fa3bf149169a6de ]

A CPU mask on the stack is broken for large values of CONFIG_NR_CPUS:

kernel/trace/preemptirq_delay_test.c: In function ‘preemptirq_delay_run’:
kernel/trace/preemptirq_delay_test.c:143:1: error: the frame size of 8512 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

Fall back to dynamic allocation here.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Song Chen <chensong_2000@189.cn>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250620111215.3365305-1-arnd@kernel.org
Fixes: 4b9091e1c194 ("kernel: trace: preemptirq_delay_test: add cpu affinity")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/preemptirq_delay_test.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index cb0871fbdb07..8af92dbe98f0 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -119,12 +119,15 @@ static int preemptirq_delay_run(void *data)
 {
 	int i;
 	int s = MIN(burst_size, NR_TEST_FUNCS);
-	struct cpumask cpu_mask;
+	cpumask_var_t cpu_mask;
+
+	if (!alloc_cpumask_var(&cpu_mask, GFP_KERNEL))
+		return -ENOMEM;
 
 	if (cpu_affinity > -1) {
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(cpu_affinity, &cpu_mask);
-		if (set_cpus_allowed_ptr(current, &cpu_mask))
+		cpumask_clear(cpu_mask);
+		cpumask_set_cpu(cpu_affinity, cpu_mask);
+		if (set_cpus_allowed_ptr(current, cpu_mask))
 			pr_err("cpu_affinity:%d, failed\n", cpu_affinity);
 	}
 
@@ -141,6 +144,8 @@ static int preemptirq_delay_run(void *data)
 
 	__set_current_state(TASK_RUNNING);
 
+	free_cpumask_var(cpu_mask);
+
 	return 0;
 }
 
-- 
2.39.5



