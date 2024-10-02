Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F761CFECF;
	Wed,  2 Oct 2024 13:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876492; cv=none; b=b7E8cFWm5kzxYIfJOJKtYS+JBYx2MQmJjzNlkbGMxmcRNTLncRC2funMqV59wlrfL5F3BVEq6dckKw5+06mZuVJl/BAYjloqwcPouYk+7JgkuCAqVrohW9q32kTMbh1knUHoZp1tZKEzbccZi0tw0YrxlUluub7Eihg2ALDBFtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876492; c=relaxed/simple;
	bh=iEDsbB1doT5R3mNOpD+Jsndnytz7eCgcVx+BtmIBKW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SvvC6G8Nrbm28yZqianop7qWfn1bXKsJpLqROkTHZSuS5hCvnln970iFkGG39vFtC0qQgbFcGXNv2YtTUYdgL2H1xxTq9SvgtWr+24rdaefO36ZDXLCWovMaUK8o2t7LCGlqbOmAu0aIt14l2Nwd2Shl6M0xu8aM+2gz6HQHZDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haKxdDyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haKxdDyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F53EC4CEC5;
	Wed,  2 Oct 2024 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876492;
	bh=iEDsbB1doT5R3mNOpD+Jsndnytz7eCgcVx+BtmIBKW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haKxdDyn7s469LGV6E2WZSaDLRXTe/uqApg3tQ2Hb5b1/o3TAMYZZCoNAzIAUB64p
	 EYJPTb56pGSXqh6kXsawyOGeU4h6dpdx4obB/8g8g+cFwLj8jp3wpYqt90ULKgT7DL
	 8L0c2FTXKBA+H4eBMPM15jwouiA3TUT7uLvi1b7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 421/695] riscv: Fix fp alignment bug in perf_callchain_user()
Date: Wed,  2 Oct 2024 14:56:59 +0200
Message-ID: <20241002125839.259122473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



