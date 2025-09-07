Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942531A704B;
	Sun,  7 Sep 2025 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277388; cv=none; b=MhA4IHfBP43K6vwVQPtWeoFHCq3WGTMv0xkdhht5F922cJu7nieKY7Rh5y8G0Iq2Woc+TybPH+2S2GSg3Zr8a7Rrqm+C/iSVA7M/EMF1F8fWBwk6eCJbaS+42jkewgiTf0ymR719WEb5qRsk+PxHp32pCP/RoCyqitjFlOrlwHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277388; c=relaxed/simple;
	bh=QczqCFI7TaiH+TwSnQ4qnzU/xS5r1rRJOYIuTdpomtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5BTl5tsNDOvgODatU8CKezM2B/yTn53lfdDSz1FgJHBSqz9y3NNyw30SrwB3xg0urrXYmfklvJLDjj7Rzd22cFbcE6ZsMYCjAdPs/zYw62c3pIUL+UrKs8vXiBHP3nmBg1Sgwwa9+9hadhI7H+pDKF0vG8AIzaFsGUXkDrk/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSlqjKOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSlqjKOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F36C4CEF0;
	Sun,  7 Sep 2025 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277388;
	bh=QczqCFI7TaiH+TwSnQ4qnzU/xS5r1rRJOYIuTdpomtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSlqjKOZ43VqP43aD81ljoJ3wFZ9XI36k3k9twAxWwizhTypodBngGt0IjgcgxPj2
	 sBLWQHgJp7JnWsHMr262dS2cKpIAfu9vfSkTHfLUajuAWkcxNSWsyyfSUn0Q+ACQP7
	 VQatuakIhwfHAnzpLwAKq/6jszB87sUDfu2uguV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Pu Lehui <pulehui@huawei.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 173/175] riscv, bpf: use lw when reading int cpu in bpf_get_smp_processor_id
Date: Sun,  7 Sep 2025 21:59:28 +0200
Message-ID: <20250907195618.954558732@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

commit 8a16586fa7b8a01360890d284896b90c217dca44 upstream.

emit_ld is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: 2ddec2c80b44 ("riscv, bpf: inline bpf_get_smp_processor_id()")
Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20250812090256.757273-4-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/net/bpf_jit_comp64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1557,7 +1557,7 @@ int bpf_jit_emit_insn(const struct bpf_i
 		 */
 		if (insn->src_reg == 0 && insn->imm == BPF_FUNC_get_smp_processor_id) {
 			/* Load current CPU number in R0 */
-			emit_ld(bpf_to_rv_reg(BPF_REG_0, ctx), offsetof(struct thread_info, cpu),
+			emit_lw(bpf_to_rv_reg(BPF_REG_0, ctx), offsetof(struct thread_info, cpu),
 				RV_REG_TP, ctx);
 			break;
 		}


