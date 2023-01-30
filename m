Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BAE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2446C433EF;
	Mon, 30 Jan 2023 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087653;
	bh=0heJl2Tk0v+1HVH/3AIH5jzj7Q1EcbNsVpGjgYtGFIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09cJGnFaJ4sMDLOoWG48UOEdjOH0FwJfORLAya6Q6me+QotytLa+sk5TLL3eK8LUn
	 1PBKXE3r7HqofAYnrQwRFEb2VEw5+nNpGel3QUSmqsMJmuax3JQKXbf1wjvmPepJlW
	 Y9HVXYSwJ6Mq7/sk+dqIf14tPg8vywQpSQcpnSAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Chuang Wang <nashuiliang@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 280/313] tracing/osnoise: Use built-in RCU list checking
Date: Mon, 30 Jan 2023 14:51:55 +0100
Message-Id: <20230130134349.773591666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuang Wang <nashuiliang@gmail.com>

[ Upstream commit 685b64e4d6da4be8b4595654a57db663b3d1dfc2 ]

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence false lockdep
warning when CONFIG_PROVE_RCU_LIST is enabled.

Execute as follow:

 [tracing]# echo osnoise > current_tracer
 [tracing]# echo 1 > tracing_on
 [tracing]# echo 0 > tracing_on

The trace_types_lock is held when osnoise_tracer_stop() or
timerlat_tracer_stop() are called in the non-RCU read side section.
So, pass lockdep_is_held(&trace_types_lock) to silence false lockdep
warning.

Link: https://lkml.kernel.org/r/20221227023036.784337-1-nashuiliang@gmail.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: dae181349f1e ("tracing/osnoise: Support a list of trace_array *tr")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 4300c5dc4e5d..1c07efcb3d46 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -125,9 +125,8 @@ static void osnoise_unregister_instance(struct trace_array *tr)
 	 * register/unregister serialization is provided by trace's
 	 * trace_types_lock.
 	 */
-	lockdep_assert_held(&trace_types_lock);
-
-	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
+	list_for_each_entry_rcu(inst, &osnoise_instances, list,
+				lockdep_is_held(&trace_types_lock)) {
 		if (inst->tr == tr) {
 			list_del_rcu(&inst->list);
 			found = 1;
-- 
2.39.0



