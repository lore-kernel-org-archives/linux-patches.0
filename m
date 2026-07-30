Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBAC34D385;
	Thu, 30 Jul 2026 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422837; cv=none; b=TYeEJuRxvdivxTMVPBrT7nvRJLhGgTdcU5px9kSmnp5plS/OC+MAFUY63H1IL0Wcs9fFx++M7kU2Uy9zz4fCotXA0Rbq5dV/akQqgOeZpaebjR3KXZ3sQLCuApv5jNzOT3SFcDpKAYy5Q2nnZN8QBCdfhwynGR4oC4iDMEVg7Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422837; c=relaxed/simple;
	bh=H6UmH826QdHSTsGQcNo1o54VUPCf42ngvISEvgOl7Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq/dZ0mhaR7jqVKjH70qFYJoGybKbOiUtTcAdergnJP6RT/duzlIbJ8b1ZnrMCQI9EA5HVEihe17v7MU21yTpce0MAlZNEC4O2WdzZicXl7XiUhBUFey7/IWJi7dH3vzVjFZIqLMxg5fPEARQQUhfhm2DfTMFl8KB7U4nNGeInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0N/OPMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0N/OPMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EE01F000E9;
	Thu, 30 Jul 2026 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422836;
	bh=wP78JHhFEOBaOBqmxbr71H6A2jmGstS5FPmpXeL1vUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0N/OPMXJgLWiusaIEanp6V/FzWEa1GHqdheGkq5cVho+GAoEJXwquOAek73bmMBr
	 6q/fTjf37s8dVvdc3TpxwMxulPaQiWr6zCMZy7m4OI8Mt1nsJacDn9VwaWU7P21S+H
	 Rz/YPuNWaNkdVEybPhsF1+J1HWXi4F0ECW8n/DVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 573/744] LoongArch: Move jump_label_init() before parse_early_param()
Date: Thu, 30 Jul 2026 16:14:06 +0200
Message-ID: <20260730141456.464423423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -602,6 +602,7 @@ void __init setup_arch(char **cmdline_p)
 	memblock_init();
 	pagetable_init();
 	bootcmdline_init(cmdline_p);
+	jump_label_init(); /* Initialise the static keys for early params */
 	parse_early_param();
 	reserve_initrd_mem();
 
@@ -609,8 +610,6 @@ void __init setup_arch(char **cmdline_p)
 	arch_mem_init(cmdline_p);
 
 	resource_init();
-	jump_label_init(); /* Initialise the static keys for paravirtualization */
-
 #ifdef CONFIG_SMP
 	plat_smp_setup();
 	prefill_possible_map();


