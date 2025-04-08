Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570DF26A0A6;
	Tue,  8 Apr 2025 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115338; cv=none; b=WRwc9n8xmPRQxM20tk1zO4EYSUe2GqRdFfeZLAANGUofnpg8VN+arkDjRS1t17xWf4V0HBcr+JFYTyjiBP4HDRbfSefsl3mje3gKKzM0DgNQoIndG5KTQOAeNn1GVewJLbbbJu8Z6bdPweL5fdVXxb2zErFdHWXFlH+9jNFNDgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115338; c=relaxed/simple;
	bh=Grg0P4P6Dv2sZhHjz6XCbkEU+KT8ebFZkqcI7NgCZBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upEz8i4wlZ32WSSJjWF8Znn6LrUO/S2GSf1V14Yp/PycDfFcOy0YY3wP2x90wwuwhyHKvlWFnTz3XZyLdEy09bB4vgKyoC8DPvaQKdIRuLM/hufnEZ7RNLjNUeZ/x86LGV29k2B0wxEkifZY4Z7AVwjMnRi6y8SsyhIsKfIw1vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEt0qH5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEt0qH5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8868C4CEE5;
	Tue,  8 Apr 2025 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115338;
	bh=Grg0P4P6Dv2sZhHjz6XCbkEU+KT8ebFZkqcI7NgCZBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEt0qH5Fz4QqWiQEXuyOZ84RLvYkhdtN7e7OwKpcW9QqEXI7Hm1X6kEgUs0vK1nQ4
	 dzbnpJwMA0NEZCbP8eZdZAI3A029lwATaK+1UEvEJczQtV0OeWJ1wvyu/VVu3rMbA6
	 bxs4XnHliR0W4BIa6UbRkZVn5ce/dKxP3EEjY7to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 438/499] LoongArch: BPF: Dont override subprogs return value
Date: Tue,  8 Apr 2025 12:50:50 +0200
Message-ID: <20250408104902.152263515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit 60f3caff1492e5b8616b9578c4bedb5c0a88ed14 upstream.

The verifier test `calls: div by 0 in subprog` triggers a panic at the
ld.bu instruction. The ld.bu insn is trying to load byte from memory
address returned by the subprog. The subprog actually set the correct
address at the a5 register (dedicated register for BPF return values).
But at commit 73c359d1d356 ("LoongArch: BPF: Sign-extend return values")
we also sign extended a5 to the a0 register (return value in LoongArch).
For function call insn, we later propagate the a0 register back to a5
register. This is right for native calls but wrong for bpf2bpf calls
which expect zero-extended return value in a5 register. So only move a0
to a5 for native calls (i.e. non-BPF_PSEUDO_CALL).

Cc: stable@vger.kernel.org
Fixes: 73c359d1d356 ("LoongArch: BPF: Sign-extend return values")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -907,7 +907,10 @@ static int build_insn(const struct bpf_i
 
 		move_addr(ctx, t1, func_addr);
 		emit_insn(ctx, jirl, LOONGARCH_GPR_RA, t1, 0);
-		move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
+
+		if (insn->src_reg != BPF_PSEUDO_CALL)
+			move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
+
 		break;
 
 	/* tail call */


