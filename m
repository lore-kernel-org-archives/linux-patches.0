Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C7A1D042F;
	Wed,  2 Oct 2024 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878346; cv=none; b=h4yebdm5aahait+7tGPlO7LIKcJ9Rr+M+0rozrs05ccJN6bQd0PEE0M1cX/Yu4nKCVO32E+Bea5EsOs6gVX4mnbOhFcEjoKCURR4sx/VXhzzFAQw8utgqQUxtxkxOAJepCNqntKoqsrHJGsV4BiN1HQWXIjQkH9DzwCY3cc+Tv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878346; c=relaxed/simple;
	bh=HZLeXjJUzP4adgiW6A3iVE1SSgpuRZ714pQGlrPhpsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mayYEp/5a4LURg091CZPx/sptQATZZk7v6AFtHGYEyTpy/2hirorUwYucM70oOJuT0/qS5NN5i6k740iIwxGbBlSAxiXnp/Q7skpASCpIqJhlj+6A9fwxr7rRPrHon1QDPr5tmiuzGgbu8BJzi9FmEe9bfZUAoT/S1LwOlSTcf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXD+IxiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXD+IxiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E1FC4CEC2;
	Wed,  2 Oct 2024 14:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878346;
	bh=HZLeXjJUzP4adgiW6A3iVE1SSgpuRZ714pQGlrPhpsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXD+IxiCnw/E75H06gkM/YS/YGItov9PygG2NiJQZujlvXP3EUUYUHfEdgEAYu0s6
	 4XKTwnOgKh0O3PxOPwlbzhsV7fPF6L3BL2WSI/XZJtsAiSotIoBaEsQ6qjYlgDHOX8
	 epEV6SNFDhadd45NnU2bgiLPgCfneh/nfmfUXZN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 383/634] riscv: Fix fp alignment bug in perf_callchain_user()
Date: Wed,  2 Oct 2024 14:58:03 +0200
Message-ID: <20241002125826.219113553@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 22ab08955ea13be04a8efd20cc30890e0afaa49c ]

The standard RISC-V calling convention said:
	"The stack grows downward and the stack pointer is always
	kept 16-byte aligned".

So perf_callchain_user() should check whether 16-byte aligned for fp.

Link: https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf

Fixes: dbeb90b0c1eb ("riscv: Add perf callchain support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20240708032847.2998158-2-ruanjinjie@huawei.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/perf_callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
index 3348a61de7d99..2932791e93882 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -62,7 +62,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 	perf_callchain_store(entry, regs->epc);
 
 	fp = user_backtrace(entry, fp, regs->ra);
-	while (fp && !(fp & 0x3) && entry->nr < entry->max_stack)
+	while (fp && !(fp & 0x7) && entry->nr < entry->max_stack)
 		fp = user_backtrace(entry, fp, 0);
 }
 
-- 
2.43.0



