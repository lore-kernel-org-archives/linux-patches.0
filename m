Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3123115E8B;
	Mon, 30 Dec 2024 15:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574029; cv=none; b=cs7A/WGnt5V3xM6Ke14KkeftnK4dpz2qtCZEsDuSD2mzewJUGiY8MPirPLY3cQj5gupwX3Pr3hLZmeLFPk/35RbD/o8Yg57lgK5nSOKHvLLpfqDWh8nTXZ9oASvwKlAJyw1eg9Wk6NiMjCQU48Mw0d5q+vvBqutFn7aNoDmSW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574029; c=relaxed/simple;
	bh=43P6t8il1B+TLzJCd4iD4h4wo5BE4FP3Uy6+PArnF40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8SMADJjknPpWTB3G+OES+fLZIqq5xq5Bahx7WnI141p/ziXOgUsYRTbz8P4DFbFCII13jB0XBMx9pcOnQhJLc2ZvaIj5JBCmhyvgWlYXj0Zwh/PY9RS/LtnQlTDSRCHkT4x302WN5ghCrB9wLSEamXoY5sCVlHTkUFrvor3v48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmzTPckY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmzTPckY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921F8C4CED0;
	Mon, 30 Dec 2024 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574029;
	bh=43P6t8il1B+TLzJCd4iD4h4wo5BE4FP3Uy6+PArnF40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmzTPckY2yMAC5jASQJ2+Bf7geiIcKpSVqg0SLKbfaL+VEFcQVBgV/DZjfHDgLrX6
	 vCVoXcjXbnjUR7eZOxodm8RHW0feTrrmK04Csr8MaGzYUA6mrVCh+rkSGgy3UyJzu2
	 rTmOj7FRn0+bzYrQyaTJuS6RwgExol+rdg4do+wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/114] bpf: Fix bpf_get_smp_processor_id() on !CONFIG_SMP
Date: Mon, 30 Dec 2024 16:42:01 +0100
Message-ID: <20241230154218.226125949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 23579010cf0a12476e96a5f1acdf78a9c5843657 ]

On x86-64 calling bpf_get_smp_processor_id() in a kernel with CONFIG_SMP
disabled can trigger the following bug, as pcpu_hot is unavailable:

 [    8.471774] BUG: unable to handle page fault for address: 00000000936a290c
 [    8.471849] #PF: supervisor read access in kernel mode
 [    8.471881] #PF: error_code(0x0000) - not-present page

Fix by inlining a return 0 in the !CONFIG_SMP case.

Fixes: 1ae6921009e5 ("bpf: inline bpf_get_smp_processor_id() helper")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241217195813.622568-1-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4c486a0bfcc4..84d958f2c031 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21085,11 +21085,15 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			 * changed in some incompatible and hard to support
 			 * way, it's fine to back out this inlining logic
 			 */
+#ifdef CONFIG_SMP
 			insn_buf[0] = BPF_MOV32_IMM(BPF_REG_0, (u32)(unsigned long)&pcpu_hot.cpu_number);
 			insn_buf[1] = BPF_MOV64_PERCPU_REG(BPF_REG_0, BPF_REG_0);
 			insn_buf[2] = BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0);
 			cnt = 3;
-
+#else
+			insn_buf[0] = BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_0);
+			cnt = 1;
+#endif
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
 			if (!new_prog)
 				return -ENOMEM;
-- 
2.39.5



