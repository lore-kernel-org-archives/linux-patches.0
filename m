Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0814F277CB8;
	Mon, 13 Oct 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368876; cv=none; b=TBCK6E/RJezdyemEYks2mE88YMKvPRIDnkx6a+MOxrR6PxcenoHHpC1G3bPqU91sjsrJv1doT+hX4JJJLOcAUo9tyjYD+9usJ5L+nwOgpxxDgautz3ig5AaWgcLEM91hYswW1SSF8Fc7eZURt9dkyfuOIGMPi9bY5kM7SGkrdas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368876; c=relaxed/simple;
	bh=0uXpZAzZz/GL1Dnph+DCV5or2eNoyCoujEy1EMIUWrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph5gOq1Bip4D6SMbsejvUM4X8wgDx2endNsYYTRD+OzKHk0eXpmu8YlamZ+Rj8J+zlapJKVz7aQNSdZ4erfmARWU1L2j+e1X3jBWbcgAcGN0vYOzJxieeHMXszJvR6Jn1Q+Nx2Ifm96BUbxNASkefM7kNxbj8bpYPCKnyoWaoBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzGgvhhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzGgvhhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CC1C4CEE7;
	Mon, 13 Oct 2025 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368875;
	bh=0uXpZAzZz/GL1Dnph+DCV5or2eNoyCoujEy1EMIUWrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzGgvhhTdaCAF7x7jFyN2d5n0N4SnUIVrvuLgkn6okRhkL5QX5xdPhS/b0cIn1PnF
	 1dFQyY9oEm8Y+Av+MuQP2QN/jRhecL+MbvhOuHjfuDaqnFPNG8RbrQPsqhQMvzNWER
	 a/wCV8gYI1sLLg20zdE6ZeISTf44iFVR2uo8A6zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/563] bpf: Remove migrate_disable in kprobe_multi_link_prog_run
Date: Mon, 13 Oct 2025 16:38:29 +0200
Message-ID: <20251013144413.033886140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit abdaf49be5424db74e19d167c10d7dad79a0efc2 ]

Graph tracer framework ensures we won't migrate, kprobe_multi_link_prog_run
called all the way from graph tracer, which disables preemption in
function_graph_enter_regs, as Jiri and Yonghong suggested, there is no
need to use migrate_disable. As a result, some overhead may will be reduced.
And add cant_sleep check for __this_cpu_inc_return.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250814121430.2347454-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3ae52978cae61..606007c387c52 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2728,20 +2728,25 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	struct pt_regs *regs;
 	int err;
 
+	/*
+	 * graph tracer framework ensures we won't migrate, so there is no need
+	 * to use migrate_disable for bpf_prog_run again. The check here just for
+	 * __this_cpu_inc_return.
+	 */
+	cant_sleep();
+
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
 		bpf_prog_inc_misses_counter(link->link.prog);
 		err = 1;
 		goto out;
 	}
 
-	migrate_disable();
 	rcu_read_lock();
 	regs = ftrace_partial_regs(fregs, bpf_kprobe_multi_pt_regs_ptr());
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.session_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
-	migrate_enable();
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-- 
2.51.0



