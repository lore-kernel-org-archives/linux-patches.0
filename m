Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C65345CCE;
	Sat, 12 Sep 2026 08:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203379; cv=none; b=sSvU/a5MdtRkCYy93Uip1tM4VfCwzWSS9Zt6NLvUcGraxl2SSTZbvfjRmBJZm+uyBVnx5dw/++4QYHnaQEnMumNM9ajII35RuJwLwMru6IYG9o8kf4bOmIwy3Ekch7wWfy5wMuEjfPd3yg1VIQjgwoPBgza6NqN1kUY3SWFPhps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203379; c=relaxed/simple;
	bh=68I8AIVrfhuOGQ4uvAAhnI6n+B82HKr3Tumm9pM9b0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKvE9s1klZDAYxfSdZYoZDVYyU9yrZwkTLVL0IerzQHnN9zi/Jb4OEJLJGUAtc/IbUo1KgQLh8eTY5mklCb5/cezPm84DI4oPKJzhCG2TFjx+TxdomSsTDuV+Sig14F8zRn3kBPZijrpcRxdChW8+MiwhGzCw974v15xFmmsEZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLbCGBK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLbCGBK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E401F000FF;
	Sat, 12 Sep 2026 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203377;
	bh=FpiGFxSmiZ+Ok2Zv+S+g42HZBeI736ScgO+wue2ulc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLbCGBK/JL5mb3Jp38hUn5PsPGLuiEmL8vTijAiwInW15OqrdIZUsZvmd2zT7vgkT
	 WCUMHpdtz8pQWNQKN+2PKspiK4gMfHpRIy4GExJawdC83EZr2XlZK7EsE9heYvRKzN
	 2PfcMiHCqQ7dxWUQ5hYu2D5t1uxPYADzuQ5diKOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Gus Bourg <gus@bourg.net>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1396/1815] arm64/efi: Avoid voluntary preemption with efi_mm installed
Date: Sat, 12 Sep 2026 08:52:26 +0200
Message-ID: <20260912065721.796685713@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit e98a9d0146372b046d863164025a66ab4488b972 ]

Gus reports a bad kernel memory access when using software PAN
(CONFIG_ARM64_SW_TTBR0_PAN=y) on a machine with support for EFI runtime
services:

  Unable to handle kernel access to user memory outside uaccess routines
    at virtual address 00000000f322ff30
  Mem abort info:
    ESR = 0x0000000096000004
    FSC = 0x04: level 0 translation fault
  Internal error: Oops: 0000000096000004 [#1]  SMP
  Workqueue: efi_rts_wq efi_call_rts
  pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : efi_call_rts+0xd8/0x288
  Call trace:
   efi_call_rts+0xd8/0x288 (P)
   process_one_work+0x178/0x4f8
   worker_thread+0x194/0x328

This is because the fpsimd context management code called from
__efi_fpsimd_begin() can preempt voluntarily, returning later to the EFI
code with an incorrect value for TTBR0_EL1 thanks to the deferred mm
switching used by the software PAN implementation.

Since EFI runtime services cannot preempt voluntarily and because the
fpsimd switching code does not rely on the TTBR0_EL1 mappings, simply
reorder the fpsimd switch so that it occurs before we change the
page-table.

Cc: Ard Biesheuvel <ardb@kernel.org>
Reported-by: Gus Bourg <gus@bourg.net>
Tested-by: Gus Bourg <gus@bourg.net>
Fixes: a5baf582f4c0 ("arm64/efi: Call EFI runtime services without disabling preemption")
Link: https://lore.kernel.org/all/20260806000144.3388823-1-gus@bourg.net/
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 30cd7f8043986..0ec90fd1754ed 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -184,6 +184,8 @@ void arch_efi_call_virt_setup(void)
 		efi_virtmap_load();
 	}
 
+	__efi_fpsimd_begin();
+
 	/*
 	 * Enable access to the valid TTBR0_EL1 and invoke the errata
 	 * workaround directly since there is no return from exception when
@@ -191,8 +193,6 @@ void arch_efi_call_virt_setup(void)
 	 */
 	uaccess_ttbr0_enable();
 	post_ttbr_update_workaround();
-
-	__efi_fpsimd_begin();
 }
 
 void arch_efi_call_virt_teardown(void)
-- 
2.53.0



