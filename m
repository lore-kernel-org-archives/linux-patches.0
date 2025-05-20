Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6907242D9A;
	Tue, 20 May 2025 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749943; cv=none; b=LpAX0gpTASrl7RMj1Ei77jcjo64flfo9zDZ4gCz7oUMldl7AN+/FRASSUYQ9ViNontK31/UvNzneKgjrmcVncUS/IDmSs4mckrYtFcLNG8aery/O6s0KcME5EudjZ7S4E+dl3JHHMS5UiCGVNKhy/uluat2V1X4X2Di283HcLtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749943; c=relaxed/simple;
	bh=eiktyX4Mw71N6h6o9y96bh1q477aAQVhhJo/DTMA2kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2/dC4d/olfcVUPRq7S3rJ+gENRYFVxJ7C4QwQA8cRbS0+BazF+uaqv+axg3ACd1yOPaAP/QQNB9/AW26Xsx80KRZKKzSe99E/qlvi6fpXxsjy+6C5g4l+/5Fu3dbdEUjvpp/eNC3Kv/kml+si2vHWTMFXTeUj2j3xiCFM1Zqao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccSefF1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccSefF1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B78C4CEE9;
	Tue, 20 May 2025 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749943;
	bh=eiktyX4Mw71N6h6o9y96bh1q477aAQVhhJo/DTMA2kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccSefF1g2akUGRb+Kwi2D13QazAi8lJ6ERysnMRQqul252LegcjIWwGvrgwwFTcs8
	 /AmSbAw7sgAVyEAwNz6P61GuO07EKSpgqKD4rv9qm1jvYJsuEYQaqyXW3OrLrADF4u
	 PsNxU+93n8O7RKdjtZM8kV8WdgOhGZ8bzfVAO+68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 109/117] bpf, arm64: Fix trampoline for BPF_TRAMP_F_CALL_ORIG
Date: Tue, 20 May 2025 15:51:14 +0200
Message-ID: <20250520125808.329937406@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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
@@ -2001,7 +2001,7 @@ static int prepare_trampoline(struct jit
 	emit(A64_STR64I(A64_R(20), A64_SP, regs_off + 8), ctx);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_enter, ctx);
 	}
 
@@ -2045,7 +2045,7 @@ static int prepare_trampoline(struct jit
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		im->ip_epilogue = ctx->image + ctx->idx;
-		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_exit, ctx);
 	}
 


