Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8436607D;
	Thu, 30 Jul 2026 15:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426282; cv=none; b=i+KJo4tsaR2AWiLBhCG7b1x9Wvr8ILy5sd4R/UNobILDvpHU5lsCzg/ZaQO9x8AYF9W5KV30RpT71KGw51gnnK5ZgkgKuqfieqmgBGaAUjZhXSxLhadSGF8zsPsCrgU+OhUnRwbsYniiN4d6usBIdtnDlSTIvI3WBojgqHd+v/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426282; c=relaxed/simple;
	bh=vU3K1nf5oMWCqxTe8To6U+qHn89SIQ+wBqdoab+FGt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caEEHBHQ0teopE8bIvzaqDXmnM/Zs/6hMBituZ9ZgI/5/usUWYuOTWNFMfnt35rlGbRgB70bHKilfnXTVzY9ib23z+yHdmVMjOAPXvAGYzGCtTb0Hu3hPrlFSUUjekzjYOdkQ/F1gHQxsWxwOddOddvy4XTwW/0ttr/zz1KyHPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJM3q9OZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJM3q9OZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB451F000E9;
	Thu, 30 Jul 2026 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426281;
	bh=NZaBkQ8QT2rx6xomvnPClM3dLRWCBPfbmDEmyGfALkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJM3q9OZr5sOkuMSvG+V7zEiAplKeJ7SRATXz6/pinuLQQsZEOWmwVGXQsecTHy9b
	 a9DRYsQFu+3fu8Hsbyw5muzC7Y3UO6WB1qIQqdYEyNXHm2IiZ9lF7FY6Hn2Ljz8Xld
	 M5qjFol4CDjN2ykwCHm0N/+vqWJPxSvO+94iSIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 363/602] LoongArch: Move jump_label_init() before parse_early_param()
Date: Thu, 30 Jul 2026 16:12:35 +0200
Message-ID: <20260730141443.588478584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanglong Wang <wangkanglong@loongson.cn>

commit ea68d444a658783234a06f05414e41cf93a18fb2 upstream.

When enabling both CONFIG_MEM_ALLOC_PROFILING=y and
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y, then diabling memory
profiling by adding the boot parameter 'sysctl.vm.mem_profiling=0' will
cause the kernel failed to boot.

After analysis, this is because jump_label_init() must be called before
parse_early_param(), the early param handlers may modify static keys by
static_branch_enable/disable().

Fix this by moving jump_label_init() to before parse_early_param(). The
solution is similar to other architectures.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kanglong Wang <wangkanglong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/setup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -610,6 +610,7 @@ void __init setup_arch(char **cmdline_p)
 	memblock_init();
 	pagetable_init();
 	bootcmdline_init(cmdline_p);
+	jump_label_init(); /* Initialise the static keys for early params */
 	parse_early_param();
 	reserve_initrd_mem();
 
@@ -617,8 +618,6 @@ void __init setup_arch(char **cmdline_p)
 	arch_mem_init(cmdline_p);
 
 	resource_init();
-	jump_label_init(); /* Initialise the static keys for paravirtualization */
-
 #ifdef CONFIG_SMP
 	plat_smp_setup();
 	prefill_possible_map();


