Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224837CD41;
	Wed, 20 May 2026 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294722; cv=none; b=XGH/jpHKZL/p1nYDeO+xvw61RVJssuHLZuHtPChJ0o02tC8Wy4cRntD0UJqK53eJK01BBIhst6ypGSsI5W+NrN7xVlnjmbG8UCAgpBuYyl/T94JVnyvQki/AIQ1t3zJI65mcRdDA8k/GHIzjTWsXZBdXGy3+7My0QVzxcisJm34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294722; c=relaxed/simple;
	bh=aJi58fGKiXhTHltr73GASKVzyU+0MhTaDECdryVu+x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZoa8rG174ls30wZalTOjvV77sRPdBmreIrsvC3p9+6R/pTZlEkYxrDqmxFSR2PHRGXtqQY+s/9CmXL19am384zqEJQAeCpQbuMdwiUOIEOIQRPdDhHetsq9FO5R87gYY7EAU9SaSc8+RL09SKHEL78aYudMSxN+NUTk77ww85w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxdAEEvV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxdAEEvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B9B1F000E9;
	Wed, 20 May 2026 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294719;
	bh=OLUyUvLFaTM7lD+ZSQi6xx+I49nRoIAtG3i+QbrpuBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxdAEEvVVkP/nV5qWwgUJcdP9qXPhNqZSsQfr1Fyyj2z3mHT6PJS8NAujViI03Q47
	 u4GPrAYU1/AG5tjJWu/hoyAdW31UT3uOMlA4iVTcJ0JONYOW5V1E/opF7zaHMszAPA
	 1edQenRsaKmbfC0/eUxiEAQzqGRp5uTOd3dA0GNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Song Liu <song@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0146/1146] bpf: Fix abuse of kprobe_write_ctx via freplace
Date: Wed, 20 May 2026 18:06:36 +0200
Message-ID: <20260520162151.611032191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 611fe4b79af72d00d80f2223354284447daafae9 ]

uprobe programs are allowed to modify struct pt_regs.

Since the actual program type of uprobe is KPROBE, it can be abused to
modify struct pt_regs via kprobe+freplace when the kprobe attaches to
kernel functions.

For example,

SEC("?kprobe")
int kprobe(struct pt_regs *regs)
{
	return 0;
}

SEC("?freplace")
int freplace_kprobe(struct pt_regs *regs)
{
	regs->di = 0;
	return 0;
}

freplace_kprobe prog will attach to kprobe prog.
kprobe prog will attach to a kernel function.

Without this patch, when the kernel function runs, its first arg will
always be set as 0 via the freplace_kprobe prog.

To fix the abuse of kprobe_write_ctx=true via kprobe+freplace, disallow
attaching freplace programs on kprobe programs with different
kprobe_write_ctx values.

Fixes: 7384893d970e ("bpf: Allow uprobe program to change context registers")
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20260331145353.87606-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 700938782bed2..ed595159f1c53 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3754,6 +3754,23 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		tr = prog->aux->dst_trampoline;
 		tgt_prog = prog->aux->dst_prog;
 	}
+	/*
+	 * It is to prevent modifying struct pt_regs via kprobe_write_ctx=true
+	 * freplace prog. Without this check, kprobe_write_ctx=true freplace
+	 * prog is allowed to attach to kprobe_write_ctx=false kprobe prog, and
+	 * then modify the registers of the kprobe prog's target kernel
+	 * function.
+	 *
+	 * This also blocks the combination of uprobe+freplace, because it is
+	 * unable to recognize the use of the tgt_prog as an uprobe or a kprobe
+	 * by tgt_prog itself. At attach time, uprobe/kprobe is recognized by
+	 * the target perf event flags in __perf_event_set_bpf_prog().
+	 */
+	if (prog->type == BPF_PROG_TYPE_EXT &&
+	    prog->aux->kprobe_write_ctx != tgt_prog->aux->kprobe_write_ctx) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 
 	err = bpf_link_prime(&link->link.link, &link_primer);
 	if (err)
-- 
2.53.0



