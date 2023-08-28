Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5CF11C98
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1102C433CD;
	Mon, 28 Aug 2023 10:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217947;
	bh=FRyvC9re465I7rqqqm29dfcHhAzqfTqCMPYD8cgsyts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1LT7Mw+8ESPJvieVLaPQz0bY4+3cXWeq9pWCu66jdFfZhhYJHSr+0TU9WDyUsKHI
	 w3IChgSW7ScOBbK66/pP5OsT/FzmQu9mIJBM8cK9KpJwSztaZOYq5OmPA1kwFH3plx
	 5LZlAhyq5mR3Vznvw4aGTTVKyaLZBO5xCF+Cpq3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	vnagarnaik@google.com,
	shuah@kernel.org,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 011/129] tracing: Fix cpu buffers unavailable due to record_disabled missed
Date: Mon, 28 Aug 2023 12:11:30 +0200
Message-ID: <20230828101157.761298598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit b71645d6af10196c46cbe3732de2ea7d36b3ff6d ]

Trace ring buffer can no longer record anything after executing
following commands at the shell prompt:

  # cd /sys/kernel/tracing
  # cat tracing_cpumask
  fff
  # echo 0 > tracing_cpumask
  # echo 1 > snapshot
  # echo fff > tracing_cpumask
  # echo 1 > tracing_on
  # echo "hello world" > trace_marker
  -bash: echo: write error: Bad file descriptor

The root cause is that:
  1. After `echo 0 > tracing_cpumask`, 'record_disabled' of cpu buffers
     in 'tr->array_buffer.buffer' became 1 (see tracing_set_cpumask());
  2. After `echo 1 > snapshot`, 'tr->array_buffer.buffer' is swapped
     with 'tr->max_buffer.buffer', then the 'record_disabled' became 0
     (see update_max_tr());
  3. After `echo fff > tracing_cpumask`, the 'record_disabled' become -1;
Then array_buffer and max_buffer are both unavailable due to value of
'record_disabled' is not 0.

To fix it, enable or disable both array_buffer and max_buffer at the same
time in tracing_set_cpumask().

Link: https://lkml.kernel.org/r/20230805033816.3284594-2-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <vnagarnaik@google.com>
Cc: <shuah@kernel.org>
Fixes: 71babb2705e2 ("tracing: change CPU ring buffer state from tracing_cpumask")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fd051f85efd4b..17663ce4936a4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5260,11 +5260,17 @@ int tracing_set_cpumask(struct trace_array *tr,
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&per_cpu_ptr(tr->array_buffer.data, cpu)->disabled);
 			ring_buffer_record_disable_cpu(tr->array_buffer.buffer, cpu);
+#ifdef CONFIG_TRACER_MAX_TRACE
+			ring_buffer_record_disable_cpu(tr->max_buffer.buffer, cpu);
+#endif
 		}
 		if (!cpumask_test_cpu(cpu, tr->tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&per_cpu_ptr(tr->array_buffer.data, cpu)->disabled);
 			ring_buffer_record_enable_cpu(tr->array_buffer.buffer, cpu);
+#ifdef CONFIG_TRACER_MAX_TRACE
+			ring_buffer_record_enable_cpu(tr->max_buffer.buffer, cpu);
+#endif
 		}
 	}
 	arch_spin_unlock(&tr->max_lock);
-- 
2.40.1



