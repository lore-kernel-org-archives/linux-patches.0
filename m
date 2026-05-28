Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FFB2C15AC;
	Thu, 28 May 2026 20:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000403; cv=none; b=UAaQxcBVWg9NdCiAasRmmyVTvwiL3BaPgT1GvANuQV9dhhggfISdFGwDatz1j/e0DNcpMqw4LC8Jls8aJ4pLTUQDE14liKW9bm/a7Po0LdrXDuVkp0z8/7R3x6ThJrhd7VdzGhZiyrGg8jTVd34XqYd3T/PoSLj68xn2mbiHNmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000403; c=relaxed/simple;
	bh=lafHSACwYpsey980Ky2WIg2qAOkBzKQuTsGDZfTWUFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baONQIWdvMC7i1N2HfEC2A8OsJHJNCpOQUsA0QeuHkN14ak26HE2BJTl0xmW4Z+TSxXHQrTA5eQdINxh8Rsa0UQvIr/LRqf5xdxrdCsosgHkvilKOLGmhgOcorKVoLtHR+Bmv2dwBxSeBy5ZBxryFbWjK5irKgDUgNBK7xmPFi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QzjXCeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QzjXCeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC09F1F000E9;
	Thu, 28 May 2026 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000402;
	bh=jmpIBO94319hfOzg+ZbQeZ0DEWv4tTPA9wTOuFC4mmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QzjXCeWV9zoVJmU8Qhk4AdDiL/Kr8xEBCH9wFX5x8hTLFE36E15P8t0STLF6s97e
	 DiOMF1M9roX4UYWQ4F49X9T/G1RJ2cWib2dXOybX93ov56NxD8UJlsJcV5WTeZouhq
	 d4KsMIZ5qNxkTQG5YZlPO170GMO58rXubVewwmOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/272] tracing: Fix the bug where bpf_get_stackid returns -EFAULT on the ARM64
Date: Thu, 28 May 2026 21:46:46 +0200
Message-ID: <20260528194630.288960950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

commit fd2f74f8f3d3c1a524637caf5bead9757fae4332 upstream.

When using bpf_program__attach_kprobe_multi_opts on ARM64 to hook a BPF program
that contains the bpf_get_stackid function, the BPF program fails
to obtain the stack trace and returns -EFAULT.

This is because ftrace_partial_regs omits the configuration of the pstate register,
leaving pstate at the default value of 0. When get_perf_callchain executes,
it uses user_mode(regs) to determine whether it is in kernel mode.
This leads to a misjudgment that the code is in user mode,
so perf_callchain_kernel is not executed and the function returns directly.
As a result, trace->nr becomes 0, and finally -EFAULT is returned.

Therefore, the assignment of the pstate register is added here.

Fixes: b9b55c8912ce ("tracing: Add ftrace_partial_regs() for converting ftrace_regs to pt_regs")
Closes: https://lore.kernel.org/bpf/20250919071902.554223-1-yangfeng59949@163.com/
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/ftrace.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index 10e56522122aa..46d4300dd48d3 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -145,6 +145,7 @@ ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
 	regs->pc = afregs->pc;
 	regs->regs[29] = afregs->fp;
 	regs->regs[30] = afregs->lr;
+	regs->pstate = PSR_MODE_EL1h;
 	return regs;
 }
 
-- 
2.53.0



