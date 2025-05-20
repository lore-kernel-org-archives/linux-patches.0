Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1FE246799;
	Tue, 20 May 2025 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749558; cv=none; b=efvepiEtN6tzjIznucS8qjDR1p+2yJGRPvjxawCSnx7DrONX0bMebtxmrCgTPtD0WU36xpP1T+7mALvRFgoVp8gGSTddkElZL/LEBcJjQO8fHqx6svOqLxSrHO/Tr+FnGyewaSTAbnd7QBVWm9kHK2l4yK1/6iGnZF2dHvdRTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749558; c=relaxed/simple;
	bh=GyO1WoCbqExrVvmV2kr+ihKh9F+i+7mDHr6m57fPm9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1KWG3mBVthN0tWQF9mwn5SCf0K0zcVtxbbdZ3/3lpXdx6YsEgsYEygECwtj6sTNfUATbxJOTbxBmaelBeJe/qMsXKoBSKcUGXRqIteq00BGAtGnVNv9z0dPf0/3VbRLU1OU3YaVukLDdv5CC+CRfOz0htJkZqrXFgNv3Fwp6ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sjATwJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sjATwJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AF0C4CEF3;
	Tue, 20 May 2025 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749557;
	bh=GyO1WoCbqExrVvmV2kr+ihKh9F+i+7mDHr6m57fPm9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sjATwJBoOPe8VHh9phQG6g+KUbZJVVq5v07nT94/5bT7eMFjpVNTk52Hj0FT5Ail
	 igz7uVhstXbmHeeDxNlmXkK4cgne4IVo/a/V7YMcfw4HAQHsnxQFKc+YivFWVbmnam
	 wLhZ74NzxRFGQgLesENXyslqhrREQxpwByggN8AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 82/97] bpf, arm64: Fix trampoline for BPF_TRAMP_F_CALL_ORIG
Date: Tue, 20 May 2025 15:50:47 +0200
Message-ID: <20250520125803.851214571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

commit 19d3c179a37730caf600a97fed3794feac2b197b upstream.

When BPF_TRAMP_F_CALL_ORIG is set, the trampoline calls
__bpf_tramp_enter() and __bpf_tramp_exit() functions, passing them
the struct bpf_tramp_image *im pointer as an argument in R0.

The trampoline generation code uses emit_addr_mov_i64() to emit
instructions for moving the bpf_tramp_image address into R0, but
emit_addr_mov_i64() assumes the address to be in the vmalloc() space
and uses only 48 bits. Because bpf_tramp_image is allocated using
kzalloc(), its address can use more than 48-bits, in this case the
trampoline will pass an invalid address to __bpf_tramp_enter/exit()
causing a kernel crash.

Fix this by using emit_a64_mov_i64() in place of emit_addr_mov_i64()
as it can work with addresses that are greater than 48-bits.

Fixes: efc9909fdce0 ("bpf, arm64: Add bpf trampoline for arm64")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://lore.kernel.org/all/SJ0PR15MB461564D3F7E7A763498CA6A8CBDB2@SJ0PR15MB4615.namprd15.prod.outlook.com/
Link: https://lore.kernel.org/bpf/20240711151838.43469-1-puranjay@kernel.org
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1942,7 +1942,7 @@ static int prepare_trampoline(struct jit
 	emit(A64_STR64I(A64_R(20), A64_SP, regs_off + 8), ctx);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_enter, ctx);
 	}
 
@@ -1986,7 +1986,7 @@ static int prepare_trampoline(struct jit
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		im->ip_epilogue = ctx->image + ctx->idx;
-		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_exit, ctx);
 	}
 


