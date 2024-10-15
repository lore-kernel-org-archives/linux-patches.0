Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD70F1D4154;
	Tue, 15 Oct 2024 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992909; cv=none; b=N3rfxX96V2zNpuYDDBTTCNzVUNUyuPK34wA/NTFqqr+RHdEfC7ADM8Yeqd80QsH2+F37ZbNHLO7Qywwo3xpXl95BkGAxm83dW+tpFmSpbDwH3+K/khL7/zesBkn/fBXqufUnHJ0l0uYiCZC2BRa1d0I5Iol0DE6WYsksp4MbX4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992909; c=relaxed/simple;
	bh=BbapBC36l00SeU4pNMUZ+J6bGuE1RQvMNUZf2n5ri5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gb85uBNI4VPKd4mgzhAi8Xd7jEcMyOO8hv2MRf5anxI8FCMnNt0/S8gvc+L56SACx1hR3eBvr5Ga8VSFkJknuRpqlTC6bbCRoMM3Pw4UUk2bAL8kmOTHBYxF4uT6Kd3whcih65vRpMLhxxvkshfPqF7rBif1CfIABhb/iuhtvm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yxw7ofsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yxw7ofsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9FDC4CEC6;
	Tue, 15 Oct 2024 11:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992908;
	bh=BbapBC36l00SeU4pNMUZ+J6bGuE1RQvMNUZf2n5ri5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yxw7ofsK62TST779SC8bk9zNnrvX4G/Bob7J0XvoEMQQSc+KK3uephErv/2WZd2+P
	 ywhy46SNf7gilGYufnZYCaM9uX905Px8gZe9iDe5R8XqnmEGyEksmDIgusOPIKf+CO
	 QESoGJ41bODGrYQ0f+TWvqp4+VzetVBa5a76jvg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/691] riscv: Fix fp alignment bug in perf_callchain_user()
Date: Tue, 15 Oct 2024 13:23:23 +0200
Message-ID: <20241015112450.472155458@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 357f985041cb9..31b105fb77f1f 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -67,7 +67,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 	perf_callchain_store(entry, regs->epc);
 
 	fp = user_backtrace(entry, fp, regs->ra);
-	while (fp && !(fp & 0x3) && entry->nr < entry->max_stack)
+	while (fp && !(fp & 0x7) && entry->nr < entry->max_stack)
 		fp = user_backtrace(entry, fp, 0);
 }
 
-- 
2.43.0



