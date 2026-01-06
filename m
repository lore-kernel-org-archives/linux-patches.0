Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E2836CE1C;
	Tue,  6 Jan 2026 17:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722381; cv=none; b=R0vLXynpf567wMiva9qd2Uti7RbEdoxSaTEwql+NPSkUodZlzEgMDoZAGXHfFuu0JAuDhiPv3pX1Uzw+Htn+PeT3TZhKmJIhT2xcLDAsJuncuXy5kiWTg+xjqzjVJK+B9Dc1EMFcSoDTF6S9Z1iWsFZ4te0Xw//mxd5XoWh0dxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722381; c=relaxed/simple;
	bh=LFR+bwFLKneBiPlQvgDzoYyuRotheo4WmLQ8n8DMcwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGi4xhYhts52tmUWTEQWB17GfL9g5rgI8E2UDdHzgsYC8uBYySqEBavVmYRaWaAdJONwA2iMf2jsSqRkCcp8uuMBhlecqkVUPwwyz9/cMXFC+1k6sgxKUktp8JD/rS0L+xKa0jE9/w5/Mohu2dLFu6RsnQ+bpcGrfqJk2wHUjBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZyZc19g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZyZc19g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAEFC116C6;
	Tue,  6 Jan 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722381;
	bh=LFR+bwFLKneBiPlQvgDzoYyuRotheo4WmLQ8n8DMcwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZyZc19g74aPQShMowf1rgoyT3fQH8arlxQwOXlQr50IK6uRW45gNjJUzyvfg9w39
	 /IiCEZo9HmGBiqcPNavimeH9WuU84EJBuBX5/PvnsnezPIedOutGyeteRm8mkwnUKX
	 DqkV06KrR+6wasfdhQy/BURgG+drNk5bIajdowHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 248/312] LoongArch: BPF: Save return address register ra to t0 before trampoline
Date: Tue,  6 Jan 2026 18:05:22 +0100
Message-ID: <20260106170556.821074536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit d314e1f48260cef3f869e3edc02a02c8a48b08e1 upstream.

Modify the build_prologue() function to ensure the return address
register ra is saved to t0 before entering trampoline operations.
This change ensures the accurate return address handling when a BPF
program calls another BPF program, preventing errors in the BPF-to-BPF
call chain.

Cc: stable@vger.kernel.org
Fixes: 677e6123e3d2 ("LoongArch: BPF: Disable trampoline for kernel module function trace")
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -139,6 +139,7 @@ static void build_prologue(struct jit_ct
 	stack_adjust = round_up(stack_adjust, 16);
 	stack_adjust += bpf_stack_adjust;
 
+	move_reg(ctx, LOONGARCH_GPR_T0, LOONGARCH_GPR_RA);
 	/* Reserve space for the move_imm + jirl instruction */
 	for (i = 0; i < LOONGARCH_LONG_JUMP_NINSNS; i++)
 		emit_insn(ctx, nop);


