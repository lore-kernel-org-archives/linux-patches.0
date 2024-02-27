Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B913AA55;
	Tue, 27 Feb 2024 13:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041975; cv=none; b=cWagAVIr7vOmAESn1E0gyGQSSVpbsz/8zTBAB8PU4KhW7B0R/l/ID9KQN1OlJybUNQq5RdYhvQNs6q8otvBKVge+r/40qxuF05Qi+2AGpbNdJYVGBoRRh0dXcCBEKFzMwlRXvkdMRObvPV7PGsy417TrKCWQ5nBex8AHFc+MUX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041975; c=relaxed/simple;
	bh=aawsmxtdGl8GOsWd+deZxtzShsgBBhbi4FMink25SyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbeOSoW/nZobcV5zFr8VVKNqZju2TL816xeAGNd28PoB/g55SndZvpPO6ayt/pGrhg3OQ7zhqjgKF6Ale3dOBecfAbmtYBsdYehSQ6VtckotyX/jE078uGiqcq4km8MtG54H9HhNM6wDuXNiRxMiG66msKr3TGrCI9plCHwyxqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ue5bLjt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ue5bLjt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01936C433F1;
	Tue, 27 Feb 2024 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041975;
	bh=aawsmxtdGl8GOsWd+deZxtzShsgBBhbi4FMink25SyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ue5bLjt69zcoQRY7kTYNUK6uqaCNozY8JZPS2FuuvfOJFwUssPoKQHUOXdfbK5tEJ
	 R7FSXA1/S5/nbbHpjfedI5NvpQTmfD2JVVxg/kUUhsiDPX9Kmgw55o90kRnRBw4BpF
	 iuiR3g1Kf/irrRCdwSlVMmTjyZA6pppMArRqJJ3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 136/299] LoongArch: Call early_init_fdt_scan_reserved_mem() earlier
Date: Tue, 27 Feb 2024 14:24:07 +0100
Message-ID: <20240227131630.235324623@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 9fa304b9f8ec440e614af6d35826110c633c4074 upstream.

The unflatten_and_copy_device_tree() function contains a call to
memblock_alloc(). This means that memblock is allocating memory before
any of the reserved memory regions are set aside in the arch_mem_init()
function which calls early_init_fdt_scan_reserved_mem(). Therefore,
there is a possibility for memblock to allocate from any of the
reserved memory regions.

Hence, move the call to early_init_fdt_scan_reserved_mem() to be earlier
in the init sequence, so that the reserved memory regions are set aside
before any allocations are done using memblock.

Cc: stable@vger.kernel.org
Fixes: 88d4d957edc707e ("LoongArch: Add FDT booting support from efi system table")
Signed-off-by: Oreoluwa Babatunde <quic_obabatun@quicinc.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -367,6 +367,8 @@ void __init platform_init(void)
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
 #endif
+
+	early_init_fdt_scan_reserved_mem();
 	unflatten_and_copy_device_tree();
 
 #ifdef CONFIG_NUMA
@@ -400,8 +402,6 @@ static void __init arch_mem_init(char **
 
 	check_kernel_sections_mem();
 
-	early_init_fdt_scan_reserved_mem();
-
 	/*
 	 * In order to reduce the possibility of kernel panic when failed to
 	 * get IO TLB memory under CONFIG_SWIOTLB, it is better to allocate


