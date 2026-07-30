Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569DE3B0598;
	Thu, 30 Jul 2026 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424670; cv=none; b=ABAhL6t0dBMCc6xzmSuTIv9IYLcUZ6ZPQdT203QGNiGYa4pvDs1EAw9xT6+clE6Pcis6i1UkhRUe+2qHWhy54HR7OApOSPbjUPn7KvorHbcpVcyntwWW4sXxdxVuis672lsvQCUxJ4QPVyIFDRHKGcJdgi15Y+6vPQ6CT5bsc7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424670; c=relaxed/simple;
	bh=6+4nDIjc/xgxtR/Y4oW2R8vgi/0Ot6cy6CBixHdfIiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJIxynPjV9SpslhIv7fKxRd+qH4H+y07AbZhw7kF652FjZdZML6tjfboVZwbkWJmohCJkz5kuSWRcxrcotWT+JxNbourF+wmfBHRJv7stgNpB5Y68d5uhw30wZHp+F3sJfzBr6r/C1FfnAUBYKAtt1FGmh+i7L9QRr8rrKqKyQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUE54E76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUE54E76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B01F000E9;
	Thu, 30 Jul 2026 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424669;
	bh=wIYpm+na3n75aPTrkAo6uN2jIdHKY38dSOCh4xBzVD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUE54E76xJz4VCgPgohaRW6EadHcKVFBZfBiKtehGI6g2pM+hbdBLzEkjLDkiBUnf
	 hd8HmGgKapWCWmPFiVRC8z6grlW55qImsjuWauwAnCIFFt+/TX6VEM4Blb2axTI3wW
	 EgLdjL28/xtsCpRbqPnXUxiasXsyFjC13snaRvrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 475/675] LoongArch: Move jump_label_init() before parse_early_param()
Date: Thu, 30 Jul 2026 16:13:25 +0200
Message-ID: <20260730141455.223590084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


