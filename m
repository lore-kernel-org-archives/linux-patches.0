Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9C529B799;
	Sat, 12 Sep 2026 07:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199354; cv=none; b=ih2OzXQr4CD0ixV6Xt/d5aREaWi2MI0qNQZAMcezPIqd96HigErVUbrBcBdBG0oWb3Z23yc7Id2xaiE/UmoElXcAKzqa0mnOhIunuGn7k0veZ9NoXbX5tKpEDRmIqwxDk1HUbMrRHBGegm1I+BUE9TdAxxDTmfbW4YnSo3Q/WiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199354; c=relaxed/simple;
	bh=P9kbdas3zzS+yZz4kID5zVzHWWHlMBQSIzQTvVPtjFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNvNlTG1oQM78zDvazpzIlwqdHpBgJNIRA416HFwc5YOEl2V1AX2Mih5x3kWl4QI2BTCd2+wTQ4a9yzs1RZK6nIoe0yKT1zFKCahU2QcwYItvMrF5ATRYAv1NXBASeMlE9rZjVC0/Z+25Ac0XKZIEmWnGpAc5KjFkTqzJ2283Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a95/xL6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a95/xL6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6A11F000FF;
	Sat, 12 Sep 2026 07:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199353;
	bh=9z0FHcnA3o5eO1mX9HMYcp7ajRZvtHYAv5Tnk58wowA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a95/xL6kOv2C7ppzclTitMgN5jBDp7wcAkLrwqCEIE94MbwTo07Mp6DyBYq4CIZSr
	 xVEMPtPabE2OYE3WZQ2o4WD/Zgu2U7Bt91sfSu2C61QFLF0XQuFgtnEUjKJMSB4YX/
	 efLAqPh9MV5pobixxAi+ZoYhDm3jk9kLKs958nRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0567/1815] riscv, bpf: Fix memory leak in bpf_jit_free
Date: Sat, 12 Sep 2026 08:38:37 +0200
Message-ID: <20260912065702.192463005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 369e4635d04801f394d5bd42556f21029e95ff93 ]

When bpf_int_jit_compile() is called for subprograms, it returns early
during the first pass (!prog->is_func || extra_pass is false), keeping
ctx->offset alive for the subsequent extra pass.

If JIT compilation fails for a later subprogram, the BPF core aborts
and calls bpf_jit_free() to clean up the first subprogram. However,
bpf_jit_free() fails to free jit_data->ctx.offset, which causes a
memory leak of the JIT context offsets array.

Fix this by adding the missing kfree(jit_data->ctx.offset) in
bpf_jit_free().

Fixes: 48a8f78c50bd ("bpf, riscv: use prog pack allocator in the BPF JIT")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20260708064436.2971933-3-pulehui@huaweicloud.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index ce3bd3762e08c..7cce191186190 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -234,6 +234,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 */
 		if (jit_data) {
 			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
+			kfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
-- 
2.53.0



