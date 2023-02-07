Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95EA28E7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDE1C433EF;
	Tue,  7 Feb 2023 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774726;
	bh=rEdM+xdn9H9nGWf6OO5T9Tq2O5sexImF9AO6K3ivGRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdDyiXfpKB0ttqOJF6nX0Q503XC3zchVEl3do+gt8mo5PmOF4voU70oXMMIEKMbLi
	 Zu0e1SFE0B9LEvI72h+9bwBmVxrF5p6eScS43AkljZJVtKelClK7wvzh2qp6Lx4xjg
	 gtkX+YNv7kqy2j62nXkik6H9caxxhMseGWMD6viM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Yonghong Song <yhs@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/208] bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers
Date: Tue,  7 Feb 2023 13:54:28 +0100
Message-Id: <20230207125634.976500575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yonghong Song <yhs@fb.com>

[ Upstream commit bdb7fdb0aca8b96cef9995d3a57e251c2289322f ]

In current bpf_send_signal() and bpf_send_signal_thread() helper
implementation, irq_work is used to handle nmi context. Hao Sun
reported in [1] that the current task at the entry of the helper
might be gone during irq_work callback processing. To fix the issue,
a reference is acquired for the current task before enqueuing into
the irq_work so that the queued task is still available during
irq_work callback processing.

  [1] https://lore.kernel.org/bpf/20230109074425.12556-1-sunhao.th@gmail.com/

Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
Tested-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20230118204815.3331855-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index eb8c117cc8b6..9d4163abadf4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -832,6 +832,7 @@ static void do_bpf_send_signal(struct irq_work *entry)
 
 	work = container_of(entry, struct send_signal_irq_work, irq_work);
 	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, work->type);
+	put_task_struct(work->task);
 }
 
 static int bpf_send_signal_common(u32 sig, enum pid_type type)
@@ -866,7 +867,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		 * to the irq_work. The current task may change when queued
 		 * irq works get executed.
 		 */
-		work->task = current;
+		work->task = get_task_struct(current);
 		work->sig = sig;
 		work->type = type;
 		irq_work_queue(&work->irq_work);
-- 
2.39.0



