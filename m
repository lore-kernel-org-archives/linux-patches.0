Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964001ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13428C433C9;
	Tue, 25 Jul 2023 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284464;
	bh=9ZwEcm4U4G5WCSnIpDN3TmaeAjzX10U+TYWhhAg8HiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC23ELtJOv17U95xzcElfr17jEelq68ei/WJckiZ1MVad2P2aToB9twBpTqPXn1Mr
	 YnNEOI3EgZBzT5e/rUqhDL6UEsoMwp30FVfMcCh0TQgHzqt8Xk7rU561jjcMX33NJP
	 K9PnNeFiN2lrP4ozS6Na1ksd9CB+JEpK8z8xymI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/509] riscv: bpf: Avoid breaking W^X
Date: Tue, 25 Jul 2023 12:45:04 +0200
Message-ID: <20230725104610.438294866@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit fc8504765ec5e812135b8ccafca7101069a0c6d8 ]

We allocate Non-executable pages, then call bpf_jit_binary_lock_ro()
to enable executable permission after mapping them read-only. This is
to prepare for STRICT_MODULE_RWX in following patch.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: c56fb2aab235 ("riscv, bpf: Fix inconsistent JIT image generation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index e295c9eed9e93..5d247198c30d3 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -153,6 +153,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
 
 	if (!prog->is_func || extra_pass) {
+		bpf_jit_binary_lock_ro(jit_data->header);
 out_offset:
 		kfree(ctx->offset);
 		kfree(jit_data);
@@ -170,7 +171,7 @@ void *bpf_jit_alloc_exec(unsigned long size)
 {
 	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
 				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
-- 
2.39.2



