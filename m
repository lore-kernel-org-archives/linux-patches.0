Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571E327935B;
	Tue,  8 Apr 2025 12:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117053; cv=none; b=Mld/ADolwo4/TRK6kc4ZCc6s9x0X/wUM9ovFZY32hM5/2tMGcly4qIWwdOtLxUjDK9Q3PIncmxdc5clHiN1/MBycXLdRp0eWCmjAEzufgtohFZAKOZMG17f4mP3VG58HzzkFeGrxQQZKZuqiGWW1ctpR7WV6NYDCODO4u0PATgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117053; c=relaxed/simple;
	bh=yW4itkjGsfDj0hlXqDxavmM73JQjI1gN/WagPW7fxjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcfZ6l0fzmadEIaTIsFcTTnvPk+HO3juve0ob1FvMIgcp5CKnyes8Wd05umJljUZbggNM6sM7jSCvFm5C4tiyWr6TK2sLQo0ezGVRepvZ0hFB1syJN8EI0/ZWPTceLgn+mbx0Bd6I3DQ8HLChJmVT6ylSZ6bcDOK/8nVTjfWRJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4o6rQNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4o6rQNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD1BC4CEE5;
	Tue,  8 Apr 2025 12:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117053;
	bh=yW4itkjGsfDj0hlXqDxavmM73JQjI1gN/WagPW7fxjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4o6rQNrV5Q+mNqjbXt4ArqZXXB4AnMvzrmINP3U53SwTVAMAMzWaUsKnyPrD17oy
	 DxDDXVfRBdV9PjyxZhSgwDqP1aoRu+Z3jcnYUQ8v/T762uhePbTauPeHB2Diw8HDcG
	 oOL5vxkBv1wdKahOydWghpnaOQbhpx0rDH72UODM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 367/423] LoongArch: BPF: Use move_addr() for BPF_PSEUDO_FUNC
Date: Tue,  8 Apr 2025 12:51:33 +0200
Message-ID: <20250408104854.412012602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hengqi Chen <hengqi.chen@gmail.com>

commit 52266f1015a8b5aabec7d127f83d105f702b388e upstream.

Vincent reported that running XDP synproxy program on LoongArch results
in the following error:

    JIT doesn't support bpf-to-bpf calls

With dmesg:

    multi-func JIT bug 1391 != 1390

The root cause is that verifier will refill the imm with the correct
addresses of bpf_calls for BPF_PSEUDO_FUNC instructions and then run
the last pass of JIT. So we generate different JIT code for the same
instruction in two passes (one for placeholder and the other for the
real address). Let's use move_addr() instead.

See commit 64f50f6575721ef0 ("LoongArch, bpf: Use 4 instructions for
function address in JIT") for a similar fix.

Cc: stable@vger.kernel.org
Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Fixes: bb035ef0cc91 ("LoongArch: BPF: Support mixing bpf2bpf and tailcalls")
Reported-by: Vincent Li <vincent.mc.li@gmail.com>
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Closes: https://lore.kernel.org/loongarch/CAK3+h2yfM9FTNiXvEQBkvtuoJrvzmN4c_NZsFXqEk4Cj1tsBNA@mail.gmail.com/T/#u
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -935,7 +935,10 @@ static int build_insn(const struct bpf_i
 	{
 		const u64 imm64 = (u64)(insn + 1)->imm << 32 | (u32)insn->imm;
 
-		move_imm(ctx, dst, imm64, is32);
+		if (bpf_pseudo_func(insn))
+			move_addr(ctx, dst, imm64);
+		else
+			move_imm(ctx, dst, imm64, is32);
 		return 1;
 	}
 


