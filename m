Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B7B265CDF;
	Tue,  8 Apr 2025 12:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113753; cv=none; b=HFQ9ZmkCfwD+KIvDPhvGocq1mrRwuTZBfzLjxruYSlyRhhSl3sN23/iGfOW6sI1H7mySx32yTqImIFo+zJB+od4FgDqx8gDC5l2vqx98u91TOi59VgTZU8gh8trV6LuTRl0c3shxG1kRjc6KEbIFv03wHlIPJCR1uYbrcclllpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113753; c=relaxed/simple;
	bh=E7a6Ky19GGFEATI/fkVYrs+RxgN6wsm/FsSZwgLst7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzgPsoOA1FYw+BjLblmRy3z2cmM3LfRcCCC1aPyBkzdqkz1Zc6eudB77HjFRqcSl6ELphg9EMAl2bx2oIN5pMeE9lUp6m8YnaovEj6fhYGB0xAK0LWTlYiwCgh48StJT61ufEjeX7ztM9nOkvdvDnB7ubgasnyT+MDxgGXw8jvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gzi/IdhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gzi/IdhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB5C4CEE5;
	Tue,  8 Apr 2025 12:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113753;
	bh=E7a6Ky19GGFEATI/fkVYrs+RxgN6wsm/FsSZwgLst7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gzi/IdhU1JbHvIifcN8+b81YGzo+XfRb3lUsdWMjCwH6F8Wve/l6efp9x0xkTTwy0
	 QiLBvY7tMX21RuzgUv7JJhAFCNSQUOF85xJjAyMYuYpKNBucQ+GphhzE+X7KXX01oZ
	 wRhvofi6HrRqgldjGmWaTkILHiuI90E1xcCTnalA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 234/268] LoongArch: BPF: Use move_addr() for BPF_PSEUDO_FUNC
Date: Tue,  8 Apr 2025 12:50:45 +0200
Message-ID: <20250408104834.901790612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -872,7 +872,10 @@ static int build_insn(const struct bpf_i
 	{
 		const u64 imm64 = (u64)(insn + 1)->imm << 32 | (u32)insn->imm;
 
-		move_imm(ctx, dst, imm64, is32);
+		if (bpf_pseudo_func(insn))
+			move_addr(ctx, dst, imm64);
+		else
+			move_imm(ctx, dst, imm64, is32);
 		return 1;
 	}
 


