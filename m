Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C624228D84F;
	Mon, 13 Oct 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370335; cv=none; b=injGG4mXftgpURatLYzjlbYrdvhJ+Fd7Pw+TFUUxwqDdvwctx5tSIhReXpNqJIgFPVkgSnxVLdz3O4nRAiHCQhHwcaawAYcvSAbR47UBcXW3ZUx64Bu2xJnGu4Hq7bJr7TupaXaRlrAESYVdpzRf/u9s+czy4MvbxQwqzhivbL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370335; c=relaxed/simple;
	bh=trcywAFgWipGX9BpLjGd1txsBufWPpa88//2OYdhD4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdtJ7ajCFn7DmtjDT4210xN87uwD5aOzdRXhCYUN1je6cUgxzCK7+1MyVsHZzJ9v2gnNgfAIwd8eCeCxZHIZUMSYu80BgI3kw6CYy8tq/zW6RcYoCpfx3Vd1As0/90sTCc9Kc2RVHpR0WmFwZYpgu0LjbImdFVavMe3eyPszErg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1fqxpTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1fqxpTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1134C4CEE7;
	Mon, 13 Oct 2025 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370335;
	bh=trcywAFgWipGX9BpLjGd1txsBufWPpa88//2OYdhD4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1fqxpTU2Rd0rktlmcdvagQPvYnvXIvKWYIKhHZetwHbdJAAmNkGAcFPlviNRdk0x
	 hVVGXrzdcT0pybPjjDpJG3p7G1r67ChlyH2+Iky/RhUzfaygAv4WvpNk+xvFOXR/kj
	 7yMmHfPrMGHjR0QqhcKlhTKihOKkwABxE4NwToJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 527/563] LoongArch: BPF: Make error handling robust in arch_prepare_bpf_trampoline()
Date: Mon, 13 Oct 2025 16:46:28 +0200
Message-ID: <20251013144430.402707695@linuxfoundation.org>
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

commit de2c0b7788648850b68b75f7cc8698b2749dd31e upstream.

Bail out instead of trying to perform a bpf_arch_text_copy() if
__arch_prepare_bpf_trampoline() failed.

Cc: stable@vger.kernel.org
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1756,7 +1756,10 @@ int arch_prepare_bpf_trampoline(struct b
 
 	jit_fill_hole(image, (unsigned int)(ro_image_end - ro_image));
 	ret = __arch_prepare_bpf_trampoline(&ctx, im, m, tlinks, func_addr, flags);
-	if (ret > 0 && validate_code(&ctx) < 0) {
+	if (ret < 0)
+		goto out;
+
+	if (validate_code(&ctx) < 0) {
 		ret = -EINVAL;
 		goto out;
 	}


