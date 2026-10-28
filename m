Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216543;
	b=CdmbrNvZWBjsnBjhr+KZMte4ZFOQ/VxSAuDPgZEHEa9UVFzaGFiUfur9k82t2MHwVoxB
	 Ne556E0qyyrs+PS/tyoMbAtM39iPuzFXMch0qynMmIr5E4RDvXPJOtMtu1/+ZnQuPYg35
	 qp1Cj4Zse+EWDq2PiNcOKMqj0ppKGHo+o3nThOQpUJIxwMHF8USu3Px3shGGPOf6+FQIb
	 wB2HjlCfDaJc2EWPSffRj70MnhKzleGiZuX0Qe6vYGgWZnID+bg3FRWBGgvBMr9Rq+jPo
	 ZbD3J9JkpCZeaTzjRZcc9VnVYGjzawdlzJesyak1uYoBWxjcyI3Sg4RhFuHdvbU9Wfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Af5OdZ8PYSE0P5OtXb4t5naHohggp/m6CLjMLjou50I=;
	b=RyhN3Ty04Tmoi8WSEUwjS+eBS1Mo7bOOum5/R6ZEeisNwE3QQ9QBghkMtuDki0nzrmR2
	 Rj7DCOt2J5vhdIqyMeswVPRA/nJJ0EIW6POKV2+0jEmAaa4F9oiSVJbtkdwDFAu2Ba1P9
	 YVDVviqHosaapeSwcfQHDLdg1uK0N856lrPDPcoIFL7H7DJBcnyQsATw6Cepa4reUyfNc
	 HzEFJAS4ALoYilVsYCPp/uKGR6oLx2wfxxZq1TsuwflATijfzsznlxPlo++c72HMplPm7
	 CKkv7oUGQ/cS2KXGuZSE+3a+KEHZS/5B1sIzAvbPdQ1W4nFN59Of0WCqtnOFhvnO7Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn3bqkXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C53606A31D;
	Wed, 28 Oct 2026 19:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn3bqkXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9271F01825;
	Wed, 28 Oct 2026 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216543;
	bh=Af5OdZ8PYSE0P5OtXb4t5naHohggp/m6CLjMLjou50I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vn3bqkXE2bcCSKM40xeefp68oKxB5hwJVz/OY+CiLyEUA0KXS0zofCwpRsBLAySu0
	 6iyFhntoSlNUacCntjQdZtWjK+t01rWrNJmenywzRuUGu0YinUTVIWp+zVNtOan7et
	 HpQkiWP1bgLQbl0aK/SEEqiF/zdHABf9ELXOdF5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1591/1887] bpf, x86: Fix trampoline stack size for 128-bit arguments
Date: Wed, 28 Oct 2026 18:01:27 +0100
Message-ID: <20261028170535.676597931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 814cba835ef648e0c5eb79505c96c0493b29eea6 ]

btf_distill_func_proto() accepts a function argument up to 16 bytes, so a
128-bit scalar such as __int128 reaches the x86 trampoline with
arg_size == 16. But the current implementation assumes an __int128
argument only needs one register, so the register save area is
under-allocated and save_args() overwrites adjacent stack slots.

Compute the register count from arg_size for all arguments to fix it.

Fixes: a9c5ad31fbdc ("bpf: x86: Support in-register struct arguments in trampoline programs")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260729050204.2586457-1-yonghong.song@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 30c6a021abcaf..803fa8b249e36 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2131,10 +2131,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	u8 *prog;
 	bool save_ret;
 
-	/* extra registers for struct arguments */
 	for (i = 0; i < m->nr_args; i++)
-		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
-			nr_regs += (m->arg_size[i] + 7) / 8 - 1;
+		nr_regs += (m->arg_size[i] + 7) / 8 - 1;
 
 	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
 	if (nr_regs > 6)
-- 
2.53.0



