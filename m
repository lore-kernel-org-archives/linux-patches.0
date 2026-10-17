Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F343335DA41;
	Sat, 17 Oct 2026 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260225; cv=none; b=jXQFps3bXoBFZ3nfsVNrGQYm9j91c7eN89jqQwvl3tySB5IsuMibUMXN/mWzI79aC9L1klwJB8V6Gyc4VMq8L2R1seyJvof2XhZ50XKXJjbuOwaMwnpXDV2C0n1i0aY8ebBCeBzDNzuQqYzO5Ec6T1aZgn7JmYfw4t+Xwdw7E6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260225; c=relaxed/simple;
	bh=gDWdmvlwHOIu0QvO/sejO312YQWn68eeftZRSqf5rOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKDy5d8fXPvo2ep/6FBQaV477NFwSv5vU9FEGBt5UssysZtxE87V9TVnlDv4GNhyxYP4hSyH1U7t+JzF6D32mUyLhnOlysO2exN6/Q4K8CzqoyVhgwHca1OFN0Lr/UQZZapajCJZaWwaCTe6e0Wfz4XP+AZnXQJ01PmzGjcaeRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcqiM37o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcqiM37o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0351F000C4;
	Sat, 17 Oct 2026 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260223;
	bh=g3gW4vs6tyz24JxGH3G3PQ15nyifXjdYO/yBJmhxtQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcqiM37o6uc1nF06bqniHNbZUHS7R2JoXmF2uIjPCoWeCnaZTXQG6D+SZLqEFy07K
	 pUs1vk+TXUTEBm9luMa5LTNjsPoQBZBPk9iSqE/dsg/5xN18qIEwAsvkrioHzRhGiK
	 fz+uzsTouBHkMR8UW8Qmc1mc20bojFPTdMN7IUHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1474/1674] riscv, bpf: Fix memory leak in bpf_jit_free
Date: Sat, 17 Oct 2026 18:02:26 +0200
Message-ID: <20261017160508.996940795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c459ad46739e1..e439cb0bc5b0a 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -269,6 +269,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 */
 		if (jit_data) {
 			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
+			kfree(jit_data->ctx.offset);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
-- 
2.53.0



