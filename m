Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55827A123;
	Mon, 13 Oct 2025 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370242; cv=none; b=OsAAwbE+lpEWV7xwSR755C4HlpncR63qHloZjHeTjRiUzSnHkN3n1C0x9V8wOnGHkqV8C1TRqj4MKE82F685L/eEYNZXjqiqw1vmJbTeAn8CEMNrUVm+RwgEEFSrr45ZXM9SDTVAF9WRn8Gtu13OWFtvDL292Hot8wBOhiudp5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370242; c=relaxed/simple;
	bh=kjrxBdW9H7YQYpEqfTT/RiK4PMIYgREFNdkX7/PimFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SssAdjXvEt78j6rDC4uHEWOQK9ERJ/r+QddjZmfim3TxC5wOaDTfudS075cnm6T7JZ7ZYaEd9+1CiDznr/oTvSiIHuUCN7P5A5gYr1drN/ueX9GkdQK8hfuHmhKde9XyXDZ91amb8iEdbSRQro9ZAYRFNPjGPQaKxwqbzIk5feo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl4nJw3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl4nJw3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F5C4CEE7;
	Mon, 13 Oct 2025 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370242;
	bh=kjrxBdW9H7YQYpEqfTT/RiK4PMIYgREFNdkX7/PimFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl4nJw3pHDsNt7w/E5Dwt7MgsPpwCskRI+OxCEDGrssLr5NuoPU5Aoeramde4CRz3
	 lSQ62J3/vi8mk3F4BjXOWFrDgUorCGYzEgEJ2LVCySvDdFEwKIsASkjWOlakOXyKU8
	 zLMze28QCi6MOM4SFf2IdzqtmVKKV/VzCe3jS4rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 529/563] LoongArch: BPF: No text_poke() for kernel text
Date: Mon, 13 Oct 2025 16:46:30 +0200
Message-ID: <20251013144430.474247039@linuxfoundation.org>
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

commit 3d770bd11b943066db11dba7be0b6f0d81cb5d50 upstream.

The current implementation of bpf_arch_text_poke() requires 5 nops
at patch site which is not applicable for kernel/module functions.
Because LoongArch reserves ONLY 2 nops at the function entry. With
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y, this can be done by ftrace
instead.

See the following commit for details:
  * commit b91e014f078e ("bpf: Make BPF trampoline use register_ftrace_direct() API")
  * commit 9cdc3b6a299c ("LoongArch: ftrace: Add direct call support")

Cc: stable@vger.kernel.org
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1294,8 +1294,10 @@ int bpf_arch_text_poke(void *ip, enum bp
 	u32 old_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
 	u32 new_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
 
-	if (!is_kernel_text((unsigned long)ip) &&
-		!is_bpf_text_address((unsigned long)ip))
+	/* Only poking bpf text is supported. Since kernel function entry
+	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
+	 */
+	if (!is_bpf_text_address((unsigned long)ip))
 		return -ENOTSUPP;
 
 	ret = emit_jump_or_nops(old_addr, ip, old_insns, is_call);


