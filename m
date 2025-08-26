Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DE93376A5;
	Tue, 26 Aug 2025 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215826; cv=none; b=Z7QCru/CfJNZCzh1z3lmAcehdnF7ywpsxe2mpjms7QR3OI+QTw/cnlnLaRlCn0A43uGv+R8uYYIuSNFPVa28F92YYbemlp534bI7LvEQLDvL3Xonwkz1uCQBcLxcRVtzVBC5xoxwU+u+oNj2VZUyES++yXU6p9gvzUToDELQrag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215826; c=relaxed/simple;
	bh=YYfi4v8LWtoQUWd+6QAr0jPk6vwUOV5Xv4mTFM3TZik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZB0H4zD40h1GVKG67nMUcCD35EoqAadPoWrkz/T7cB09JbAeQp75q6+hx6eHflCzSV1v4aoMQK2p9MbVpue9Xso7SKinMFZEyP6YtCucVuF0MzBFYDnBX64gbeIVcfKPwGN5AXXfv8wYhaWWDK/7GrR9tuoDKty6qMPzgOwPTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoHASfFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoHASfFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE7C4CEF1;
	Tue, 26 Aug 2025 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215826;
	bh=YYfi4v8LWtoQUWd+6QAr0jPk6vwUOV5Xv4mTFM3TZik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoHASfFH8pAWttoVJHyrzY90c9Pmzz7TmMSLj2887rl7DWGLV2fLKGF9RYO5U2jx7
	 WBY+2WFuZXEOwXCaLiDkF1Icb6egQLZ6bRw43StsA/ZvyhDVtrpWhBznLix1BV0HFO
	 +PhMgOCSiZft/53jtPjfwvQJS1nRjAwkywr/W4JU=
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
Subject: [PATCH 5.15 180/644] kernel: trace: preemptirq_delay_test: use offstack cpu mask
Date: Tue, 26 Aug 2025 13:04:31 +0200
Message-ID: <20250826110950.929258621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



