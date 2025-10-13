Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8268A308F3C;
	Mon, 13 Oct 2025 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370245; cv=none; b=pVEE5PSRoRMhjzUJJXLJ6hvEyMU9sBLp76tQrndOg4K1Ud1jHP8kKXQ4tsQRjLjEK1oXPNQh5JxuCcYwfRSHRVUxs5qpkiLzNU+9+muy7c4znAlpV+S9vEEIJoQbCq88E2tGdyVrQrP9VHJ1Nu9xvbMG8ubQsCyBrZ+6L1ryiKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370245; c=relaxed/simple;
	bh=dMCWlACgbj27J4xhbqCe7UtliATKJVN8pWtwtiebOBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0zmLuNeal+g0z/VfJERaINAWktj6IAevkJBoiQ3qSTrkbJPrcF0KT+GSgPcFXFlEoTsDKCFxDy5t18rXWIl425nWI+OPneg6n42Ap9Ni1OviMcdQwFA/VQtzKJtuhkWj1cDoFM3qsfVKkWMcLGoo7gawNKs1DFXziG8laHFgxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnh9he+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnh9he+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E428C116C6;
	Mon, 13 Oct 2025 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370245;
	bh=dMCWlACgbj27J4xhbqCe7UtliATKJVN8pWtwtiebOBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnh9he+YDWCaesT1i6v1lTE38P+a5PHx4Mwym0weB9ratIBEuTVL455z1qcNDoLRu
	 p0yF3OpdVjLola3o6sFbJ+tv++kaPkoiDHAa1PPPwDeL7+Cdtm2FmhGbDDh9/7uQSq
	 rV/NVYUdSE0HJjDR8Y5KtYK8XYgX2iTe132HvELs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 530/563] LoongArch: BPF: Remove duplicated flags check
Date: Mon, 13 Oct 2025 16:46:31 +0200
Message-ID: <20251013144430.510462728@linuxfoundation.org>
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

commit 909d3e3f51b1bc00f33a484ce0d41b42fed01965 upstream.

The check for (BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_SHARE_IPMODIFY) is
duplicated in __arch_prepare_bpf_trampoline(). Remove it.

While at it, make sure stack_size and nargs are initialized once.

Cc: stable@vger.kernel.org
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1486,7 +1486,7 @@ static int __arch_prepare_bpf_trampoline
 					 void *func_addr, u32 flags)
 {
 	int i, ret, save_ret;
-	int stack_size = 0, nargs = 0;
+	int stack_size, nargs;
 	int retval_off, args_off, nargs_off, ip_off, run_ctx_off, sreg_off, tcc_ptr_off;
 	bool is_struct_ops = flags & BPF_TRAMP_F_INDIRECT;
 	void *orig_call = func_addr;
@@ -1495,9 +1495,6 @@ static int __arch_prepare_bpf_trampoline
 	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
 	u32 **branches = NULL;
 
-	if (flags & (BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_SHARE_IPMODIFY))
-		return -ENOTSUPP;
-
 	/*
 	 * FP + 8       [ RA to parent func ] return address to parent
 	 *                    function
@@ -1537,10 +1534,8 @@ static int __arch_prepare_bpf_trampoline
 	if (flags & (BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_SHARE_IPMODIFY))
 		return -ENOTSUPP;
 
-	stack_size = 0;
-
 	/* Room of trampoline frame to store return address and frame pointer */
-	stack_size += 16;
+	stack_size = 16;
 
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
 	if (save_ret) {


