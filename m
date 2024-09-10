Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ABA178CDE;
	Tue, 10 Sep 2024 09:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961570; cv=none; b=tuj7omnKf2s8XeZV4LWA59/fMp7GlDTbDlpR/Fhdg+kRdTnAskIeKEUfFuzU5+gXhqo1xqToHfIAI2jZLV/XZVLMDXWMTfwUVqrPp9VOyX4UlPxIdQXs+sen4cG3lr/vpbKstHm/ufXKAZ0u6mM4EiCvCyMd/bEMKrniRTOPQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961570; c=relaxed/simple;
	bh=Ip0NaEWESY1irrHcYlTwt0IGO6j1I9BPBcVbp6kAnjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aI8+T2Fx18y+VaaKWYIYlqZsCfx5XbDEhPMvcy13AOXS00hJGm9GYUN5gwjvxfXyRsK+KY9oaZBzk2bS60ci3VcLXN9CxzzgoGpy1fX14tuSIcDSy9nCyl9EGwMZXNLLB8PLtEwKRi9oVh/xR12Om58OB0m+zsnIK4u5+/BJL+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xh6EMvfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xh6EMvfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15225C4CEC3;
	Tue, 10 Sep 2024 09:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961570;
	bh=Ip0NaEWESY1irrHcYlTwt0IGO6j1I9BPBcVbp6kAnjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xh6EMvferlS4sjslJovhgsKGY5FIufBvtCy2Xxr1UHJITdyfRz3n1VCAwsKNbYasw
	 8zLR5cOkUCN0Rsrhzpqeh3Yhjcpk23QNj576hgHwLz7Vxj6umxPjudcxDzqNe+P5/L
	 LZ6/O//s1TbvuGfQUu6Af1JwiJ36yqdQ4cHdfFTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 115/375] riscv: kprobes: Use patch_text_nosync() for insn slots
Date: Tue, 10 Sep 2024 11:28:32 +0200
Message-ID: <20240910092626.282455789@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit b1756750a397f36ddc857989d31887c3f5081fb0 ]

These instructions are not yet visible to the rest of the system,
so there is no need to do the whole stop_machine() dance.

Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20240327160520.791322-4-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/kprobes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index dfb28e57d900..03cd103b8449 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -29,9 +29,8 @@ static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 
 	p->ainsn.api.restore = (unsigned long)p->addr + offset;
 
-	patch_text(p->ainsn.api.insn, &p->opcode, 1);
-	patch_text((void *)((unsigned long)(p->ainsn.api.insn) + offset),
-		   &insn, 1);
+	patch_text_nosync(p->ainsn.api.insn, &p->opcode, 1);
+	patch_text_nosync(p->ainsn.api.insn + offset, &insn, 1);
 }
 
 static void __kprobes arch_prepare_simulate(struct kprobe *p)
-- 
2.43.0



