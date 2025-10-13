Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BA5221555;
	Mon, 13 Oct 2025 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370332; cv=none; b=Y6eYKnvy/0safSZ3+HqhuHPpvVOkDi7bjkShqwa0enzI4dYy2La18qw5/YEz7BG/D734MImYVd7dZiK3jYSakuuy+uRaFt+DkBUqcb7g2CDMTy0Uc80/bGea1KDAtTi4ExVTInS5ujrrWIIPnul5Oiuaf2NfMUwc3MnAU9VS7ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370332; c=relaxed/simple;
	bh=uLbsuuTQoMG/u7jIM6Whuu9ShAsv/NS4xNFBVSkbPFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpWZF5kxe+Hp/NKKlPk9qi8zhRoyCVTY12+aHp2mWB8DOD66j0Z1cqL9ujtCco8x/xjczrGKr2bmLQWwmRygAkzOSewbqY85KDGRdXX1LuHHfkjp+diK2ssTsutUXQSjTPKX4OmrDypt5pCxDsk+bWeIIeve34YOSP71uCWXIj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0kaooSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0kaooSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D9FC4CEE7;
	Mon, 13 Oct 2025 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370332;
	bh=uLbsuuTQoMG/u7jIM6Whuu9ShAsv/NS4xNFBVSkbPFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0kaooSgJihmyIr5dff0VdyHtxSfn4fiUTEe5T/fOZPBbjTFT0yKkiWKuCZkmp53E
	 wILWeFCHpXgjZwE+Xg4QBOd1opTCcVmg2cxkaZTbcx9+58rJU4nKvaqXx5TWEh5EhZ
	 GIByDDi5lk0hzfvlhbzVPSAw4ZxU6NX+9mG12oPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 526/563] LoongArch: BPF: Make trampoline size stable
Date: Mon, 13 Oct 2025 16:46:27 +0200
Message-ID: <20251013144430.366884303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit ea645cfd3d5f74a2bd40a60003f113b3c467975d upstream.

When attach fentry/fexit BPF programs, __arch_prepare_bpf_trampoline()
is called twice with different `struct bpf_tramp_image *im`:

    bpf_trampoline_update()
        -> arch_bpf_trampoline_size()
            -> __arch_prepare_bpf_trampoline()
        -> arch_prepare_bpf_trampoline()
            -> __arch_prepare_bpf_trampoline()

Use move_imm() will emit unstable instruction sequences, so let's use
move_addr() instead to prevent subtle bugs.

(I observed this while debugging other issues with printk.)

Cc: stable@vger.kernel.org
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1632,7 +1632,7 @@ static int __arch_prepare_bpf_trampoline
 		orig_call += LOONGARCH_BPF_FENTRY_NBYTES;
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		move_imm(ctx, LOONGARCH_GPR_A0, (const s64)im, false);
+		move_addr(ctx, LOONGARCH_GPR_A0, (const u64)im);
 		ret = emit_call(ctx, (const u64)__bpf_tramp_enter);
 		if (ret)
 			return ret;
@@ -1682,7 +1682,7 @@ static int __arch_prepare_bpf_trampoline
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		im->ip_epilogue = ctx->ro_image + ctx->idx;
-		move_imm(ctx, LOONGARCH_GPR_A0, (const s64)im, false);
+		move_addr(ctx, LOONGARCH_GPR_A0, (const u64)im);
 		ret = emit_call(ctx, (const u64)__bpf_tramp_exit);
 		if (ret)
 			goto out;


