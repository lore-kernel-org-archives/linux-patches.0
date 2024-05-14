Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091A7433BE;
	Tue, 14 May 2024 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682255; cv=none; b=WiI7JTyZ07QShVklqk2AsplwzBFBb5kIMY1ZKAgymFY2EGXZEtq6uPxArCLRf3qZ2KRYaYmh6dSrCWihxOiupW6Hx7g2ZblRgHWgL0rFLJf1ayZk4NRi5u9Jum0jiOlDvBoyFlmLQzxbIITZbxg17Szt7GEkAZeZ7cl0qEm8bNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682255; c=relaxed/simple;
	bh=rhrqFmi/rxli9qjWmEgoOljrQv5NxMT7mw6UHA4gbNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edkwiHavlyx1wCItw6unbc00eMF44zJGTucW074cyXyojXRW4+LRXyyV7YL8N+6sZ3JEy20I8vapeLbmDHO3w2/KvYkD1AJD7EkaxEPND2GdlMcO8eln+hOu22pE4HYGZ8dQDmS2NYHdNEvWLydHpixo3R8gLJFVmIux+vm5SLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5FYTHte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5FYTHte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B06FC2BD10;
	Tue, 14 May 2024 10:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682254;
	bh=rhrqFmi/rxli9qjWmEgoOljrQv5NxMT7mw6UHA4gbNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5FYTHteC8L1IxNpZCQ0tdcAHu44nIunZQZmRIAY5/gotIXkY/amCPFmed+py9ofF
	 Uw6hBwDCOQ4sHWFdk0g79LMkqnP1PCsMeGu46giVCVIm8l/KbCHplAVWhQEKg9FG/0
	 LCmHmfV8ocRL9jnlXP0U+aiACxNizPE4MLvkdTPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 035/336] riscv, bpf: Fix incorrect runtime stats
Date: Tue, 14 May 2024 12:13:59 +0200
Message-ID: <20240514101039.934696038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 10541b374aa05c8118cc6a529a615882e53f261b ]

When __bpf_prog_enter() returns zero, the s1 register is not set to zero,
resulting in incorrect runtime stats. Fix it by setting s1 immediately upon
the return of __bpf_prog_enter().

Fixes: 49b5e77ae3e2 ("riscv, bpf: Add bpf trampoline support for RV64")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20240416064208.2919073-3-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 719a97e7edb2c..0bd747d1d00fc 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -740,6 +740,9 @@ static int invoke_bpf_prog(struct bpf_tramp_link *l, int args_off, int retval_of
 	if (ret)
 		return ret;
 
+	/* store prog start time */
+	emit_mv(RV_REG_S1, RV_REG_A0, ctx);
+
 	/* if (__bpf_prog_enter(prog) == 0)
 	 *	goto skip_exec_of_prog;
 	 */
@@ -747,9 +750,6 @@ static int invoke_bpf_prog(struct bpf_tramp_link *l, int args_off, int retval_of
 	/* nop reserved for conditional jump */
 	emit(rv_nop(), ctx);
 
-	/* store prog start time */
-	emit_mv(RV_REG_S1, RV_REG_A0, ctx);
-
 	/* arg1: &args_off */
 	emit_addi(RV_REG_A0, RV_REG_FP, -args_off, ctx);
 	if (!p->jited)
-- 
2.43.0



