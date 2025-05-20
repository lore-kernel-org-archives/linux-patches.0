Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055C722DF87;
	Tue, 20 May 2025 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749561; cv=none; b=a0hlYp0WtUePNPj2rxo7gAa8q+S1YD1S7il9PRaOHg+54bc0ufXfo6IDXpn1AoHbWYMYPWiiDcbeoZ1+gzDKe4XO8dWu9706Tig0Nq1R3T8OK3lHyOaceK8D9UMhzmxxnzRinTQcMJQSJMkERDw0wPjlhf9o6pBkFCRIcrKC1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749561; c=relaxed/simple;
	bh=8umGciIlQgsZ4QPQVJpx3hvH1LgPne1ihx61O/adBus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMgXIybjkBSYbJUJDBdv+CQWI1/drC8dnVuYa6U7yjCsdjOIMtAtnzvgJNP0iqRZBButpks4D5cqxTMaDWaNzilCR8bSbJ+c5ZjC+7Yd1wfPUPusxIxpllq8QyYuZfVTP9Y9Yd9e4JZc+mrtDBkRMpu2OB+llKumlbPVDKeG/pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B625f/Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B625f/Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8456CC4CEE9;
	Tue, 20 May 2025 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749560;
	bh=8umGciIlQgsZ4QPQVJpx3hvH1LgPne1ihx61O/adBus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B625f/Y8xcdWRoVMFEeIvHQcqewCVF8eITJfCQi7zljRjAhM8mJQJ6pT5lcAKRinE
	 uo9Qv6FTKIQgplpfTX/Gr3xMuEBMWCdIMP61uzd1NjlhPToYXMWcjHKMI5TqBqlUIV
	 KCIBFWahiz0Ao4pTRhos6okN65IHIS+GJXRscYzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Xu Kuohai <xukuohai@huawei.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 83/97] bpf, arm64: Fix address emission with tag-based KASAN enabled
Date: Tue, 20 May 2025 15:50:48 +0200
Message-ID: <20250520125803.888108058@linuxfoundation.org>
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

From: Peter Collingbourne <pcc@google.com>

commit a552e2ef5fd1a6c78267cd4ec5a9b49aa11bbb1c upstream.

When BPF_TRAMP_F_CALL_ORIG is enabled, the address of a bpf_tramp_image
struct on the stack is passed during the size calculation pass and
an address on the heap is passed during code generation. This may
cause a heap buffer overflow if the heap address is tagged because
emit_a64_mov_i64() will emit longer code than it did during the size
calculation pass. The same problem could occur without tag-based
KASAN if one of the 16-bit words of the stack address happened to
be all-ones during the size calculation pass. Fix the problem by
assuming the worst case (4 instructions) when calculating the size
of the bpf_tramp_image address emission.

Fixes: 19d3c179a377 ("bpf, arm64: Fix trampoline for BPF_TRAMP_F_CALL_ORIG")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://linux-review.googlesource.com/id/I1496f2bc24fba7a1d492e16e2b94cf43714f2d3c
Link: https://lore.kernel.org/bpf/20241018221644.3240898-1-pcc@google.com
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/net/bpf_jit_comp.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1942,7 +1942,11 @@ static int prepare_trampoline(struct jit
 	emit(A64_STR64I(A64_R(20), A64_SP, regs_off + 8), ctx);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
+		/* for the first pass, assume the worst case */
+		if (!ctx->image)
+			ctx->idx += 4;
+		else
+			emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_enter, ctx);
 	}
 
@@ -1986,7 +1990,11 @@ static int prepare_trampoline(struct jit
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		im->ip_epilogue = ctx->image + ctx->idx;
-		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
+		/* for the first pass, assume the worst case */
+		if (!ctx->image)
+			ctx->idx += 4;
+		else
+			emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_exit, ctx);
 	}
 


