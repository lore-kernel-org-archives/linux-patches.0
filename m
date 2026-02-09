Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A928312F;
	Mon,  9 Feb 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648855; cv=none; b=MDFI6D2RVWAeUvjDQCF8BHWRsgmfM+bB3PcFfqYvQUXlGR+JH/RRdwjycvqzb2xX4ZdK7egBsNo33gOc243Y58fTzbLcebN9iEhm1sKeQ6FRD/KSRsibYbpNhiOoFhO896L2exCJMRJTbKnaJZjGuo8zdYG3UFBusDIN0JvsTmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648855; c=relaxed/simple;
	bh=wf56Bc9AJGRoICZ6Fe3q5CEfVL9JCIE/i3TM40ajC1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og90Zdux6UVqp79YWqB9/P9WyWVEe2d/SNa85R08CuSeO6nZ5lS4LLNKu+FhzNXtcKOnu5PkrVWZcxoc18kwCleonRbkVJybs4l8vagyZRt7nQQO19Csx0g6AJ5XUr1kIH+pRTsAuob35UDKh521pik2je1aKlw1RjarpdsfRME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu06uWGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu06uWGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E192C16AAE;
	Mon,  9 Feb 2026 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648855;
	bh=wf56Bc9AJGRoICZ6Fe3q5CEfVL9JCIE/i3TM40ajC1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu06uWGaX+z7x22Pwt4Ijov0Z0CPLvKZjYE4SEdjEDtoiDjgjIVewD4olWGbLD+jq
	 cABinlfWpv3txT9OdNMQ/zO/C44YVN+nSIitRgnQc1o9GZAkS2Z3mXDQW1geb1chII
	 bYocdim5WK9/eZ005jRu+Q3bPNU30cub6IFw0xpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mathieu.desnoyers@efficios.com,
	Wupeng Ma <mawupeng1@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/75] ring-buffer: Avoid softlockup in ring_buffer_resize() during memory free
Date: Mon,  9 Feb 2026 15:24:33 +0100
Message-ID: <20260209142303.148414423@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wupeng Ma <mawupeng1@huawei.com>

[ Upstream commit 6435ffd6c7fcba330dfa91c58dc30aed2df3d0bf ]

When user resize all trace ring buffer through file 'buffer_size_kb',
then in ring_buffer_resize(), kernel allocates buffer pages for each
cpu in a loop.

If the kernel preemption model is PREEMPT_NONE and there are many cpus
and there are many buffer pages to be freed, it may not give up cpu
for a long time and finally cause a softlockup.

To avoid it, call cond_resched() after each cpu buffer free as Commit
f6bd2c92488c ("ring-buffer: Avoid softlockup in ring_buffer_resize()")
does.

Detailed call trace as follow:

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: 	24-....: (14837 ticks this GP) idle=521c/1/0x4000000000000000 softirq=230597/230597 fqs=5329
  rcu: 	(t=15004 jiffies g=26003221 q=211022 ncpus=96)
  CPU: 24 UID: 0 PID: 11253 Comm: bash Kdump: loaded Tainted: G            EL      6.18.2+ #278 NONE
  pc : arch_local_irq_restore+0x8/0x20
   arch_local_irq_restore+0x8/0x20 (P)
   free_frozen_page_commit+0x28c/0x3b0
   __free_frozen_pages+0x1c0/0x678
   ___free_pages+0xc0/0xe0
   free_pages+0x3c/0x50
   ring_buffer_resize.part.0+0x6a8/0x880
   ring_buffer_resize+0x3c/0x58
   __tracing_resize_ring_buffer.part.0+0x34/0xd8
   tracing_resize_ring_buffer+0x8c/0xd0
   tracing_entries_write+0x74/0xd8
   vfs_write+0xcc/0x288
   ksys_write+0x74/0x118
   __arm64_sys_write+0x24/0x38

Cc: <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20251228065008.2396573-1-mawupeng1@huawei.com
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 90a8dd91e2eb0..d17ebe6a4ebfd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2322,6 +2322,8 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
 					list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
+
+			cond_resched();
 		}
 	}
  out_err_unlock:
-- 
2.51.0



