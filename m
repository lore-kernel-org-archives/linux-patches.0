Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E924284B26;
	Tue,  6 Jan 2026 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722617; cv=none; b=NLqcA5gWkbD6+/Y7pwzQJnf9Kohokh6GmO6vC/b6KFdDvlb4is3PhXgC2PlnshY77XWXi6VAMuCYeFXGoCGqPpTyCas+XsT2oXAFRsvfQ9I3P6TyntxIEtwqqqTVTrJKcU9MavbuuI4DJcslsb8ENTCF4jnLhQu12Rwc1BK409Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722617; c=relaxed/simple;
	bh=gf9XdvP7AvckO+vz2mWF5b8IdE6RAIXnjZsSzxyULmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3hR52OfhhAVf3xdwoEcb668lvfcuU8dmN5sHwAsVr5Lxeus9Rw2Clr2/5aef0rhBM/kdVTHvFshULWaJF9FIz4GQ8fKHNy6RycDcQUUFmi2McDrm+zMRxzLlmAXT8vCN4d07Z5ERHt5qiQ1P3wHXdayF5PV4OiJqAH734yu1Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+Xcoqgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+Xcoqgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A4EC116C6;
	Tue,  6 Jan 2026 18:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722617;
	bh=gf9XdvP7AvckO+vz2mWF5b8IdE6RAIXnjZsSzxyULmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+Xcoqgpq2minvLq3AuOMpfc/R4NsmkKgT4BfFuydOaaBKSJOP+A7dUYn+FJjSDfp
	 BdCydoLepltiMqq5Yv2F+d8GtM0dW76xlQdIbhASZzsmsDUiGv/d/umHQiKRVebluo
	 4ydsI7n5uSJtd6PwFUrEIQx57tK3sye/TcifIKnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 309/312] LoongArch: BPF: Enhance the bpf_arch_text_poke() function
Date: Tue,  6 Jan 2026 18:06:23 +0100
Message-ID: <20260106170559.037779115@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghao Duan <duanchenghao@kylinos.cn>

commit 73721d8676771c6c7b06d4e636cc053fc76afefd upstream.

Enhance the bpf_arch_text_poke() function to enable accurate location
of BPF program entry points.

When modifying the entry point of a BPF program, skip the "move t0, ra"
instruction to ensure the correct logic and copy of the jump address.

Cc: stable@vger.kernel.org
Fixes: 677e6123e3d2 ("LoongArch: BPF: Disable trampoline for kernel module function trace")
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1307,6 +1307,10 @@ int bpf_arch_text_poke(void *ip, enum bp
 		       void *old_addr, void *new_addr)
 {
 	int ret;
+	unsigned long size = 0;
+	unsigned long offset = 0;
+	void *image = NULL;
+	char namebuf[KSYM_NAME_LEN];
 	bool is_call = (poke_type == BPF_MOD_CALL);
 	u32 old_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
 	u32 new_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
@@ -1314,9 +1318,20 @@ int bpf_arch_text_poke(void *ip, enum bp
 	/* Only poking bpf text is supported. Since kernel function entry
 	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
 	 */
-	if (!is_bpf_text_address((unsigned long)ip))
+	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
 		return -ENOTSUPP;
 
+	image = ip - offset;
+
+	/* zero offset means we're poking bpf prog entry */
+	if (offset == 0) {
+		/* skip to the nop instruction in bpf prog entry:
+		 * move t0, ra
+		 * nop
+		 */
+		ip = image + LOONGARCH_INSN_SIZE;
+	}
+
 	ret = emit_jump_or_nops(old_addr, ip, old_insns, is_call);
 	if (ret)
 		return ret;


