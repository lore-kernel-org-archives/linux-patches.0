Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF271E04BF;
	Wed,  6 Nov 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898086; cv=none; b=iqiIJRWW2okKrAPintkFPEwUrCfBQlo0o9enukKL170RAcNzbxGcluEAK2af3oSrrce87jRIWjIOwJZ63qUhH6JYNuoBr4yUrO2HkMHWLSOvXna1iHXQXxo3D6VNNzpIo2NuuIo4AHaFNX1h0c4LAY7B3zqnqNSEZ1gYpJNAeMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898086; c=relaxed/simple;
	bh=+Fc8vpy0s2jfFY01/J5UsPYneAq1mOqwu7GzgOIyvus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TyhekVYsRFj/SNkMnfRcGatZoxcHB0VzBLWAeYYyU4LpkyFv9vghzT9VKW/klN90ZLk4yiSLZrsK6wMD652Hoz0Ul++Wf9Ba+J1KKn5yiAYu8dL20eQfP1ivWxKFYwRfhVkLUHNwl6ncxGMIOXEKCLm9P2fHPwqrbQzZSqdhXCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+v7sfch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+v7sfch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8998FC4CECD;
	Wed,  6 Nov 2024 13:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898085;
	bh=+Fc8vpy0s2jfFY01/J5UsPYneAq1mOqwu7GzgOIyvus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+v7sfchix3FoIDOkXzgUbYcy/5ZDDsVggG25MSQxDYC0UknYZL1jnZiw+DTld3jF
	 8+UD6Xr2MXziPmVRwC5iP1E9jlSLbepqjqWACG/2yUHDYFqur2S9adGhGRn0pDCUEb
	 9tN996NRTHyntzHQAaCkmqUL+sqbs9uA/TluXBc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/462] riscv: Fix fp alignment bug in perf_callchain_user()
Date: Wed,  6 Nov 2024 13:00:13 +0100
Message-ID: <20241106120334.471704838@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1de5991916eb9..11541cbe26b3d 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -71,7 +71,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 	perf_callchain_store(entry, regs->sepc);
 
 	fp = user_backtrace(entry, fp, regs->ra);
-	while (fp && !(fp & 0x3) && entry->nr < entry->max_stack)
+	while (fp && !(fp & 0x7) && entry->nr < entry->max_stack)
 		fp = user_backtrace(entry, fp, 0);
 }
 
-- 
2.43.0



