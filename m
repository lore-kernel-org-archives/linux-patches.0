Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A0B1C07DB;
	Tue, 15 Oct 2024 13:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997428; cv=none; b=Er4vzfuxk+p1igUftLdrcJaWIoaKQWVKA7cORVe5qpmlCI5tlAPaRgeNmj918UnpZQPEbRGK3WjH1jxgDU2Yfc8cqKfE1VQzdO1/PIpEStq+Wz5sdYwO/+xOv+yBRcpW+xWV9xn6qthRTpAnlJLbnkDLyGcWWPHNj8FE900WG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997428; c=relaxed/simple;
	bh=ezqZ44Yo36CaAZH5w0Byk9KmuDwbWnZ2y4A3COOe8+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbvUrxq1VXxzKjLrqksL2QmKQzXQdtzu3M2Z2Q3cPrEgzSjd+iPKJF21JLwnZVE1Yn8yRRTYfxHBbKMGbxE9Lo1JAb7bMQW544sPRIS6D2sFhidHCNk78OjICq28RqGLhV/hSAde6CAqEOytHhj72TwLiJDwzKMTAuf0G3FkM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5w/r1PR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5w/r1PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D45AC4CEC6;
	Tue, 15 Oct 2024 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997428;
	bh=ezqZ44Yo36CaAZH5w0Byk9KmuDwbWnZ2y4A3COOe8+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5w/r1PRr2PUBwE31iFzV0xjkP/EuEIofbVU6B2BLeBr6u3yKtZmofRTDSq+7Ws79
	 PuZrIk+GAkW1B0wQdFUjLc+ciV8sODfvjTOzikqAe0FEnO0HW0vDPalYizrfIPTtXy
	 LtRc8ObArtSnCvpLbaH1rOFoLNC6iyc4ThhpzTXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/518] riscv: Fix fp alignment bug in perf_callchain_user()
Date: Tue, 15 Oct 2024 14:41:24 +0200
Message-ID: <20241015123923.937525009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb02811df7143..3c0a43cb1c33e 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -71,7 +71,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 	perf_callchain_store(entry, regs->epc);
 
 	fp = user_backtrace(entry, fp, regs->ra);
-	while (fp && !(fp & 0x3) && entry->nr < entry->max_stack)
+	while (fp && !(fp & 0x7) && entry->nr < entry->max_stack)
 		fp = user_backtrace(entry, fp, 0);
 }
 
-- 
2.43.0



