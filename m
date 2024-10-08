Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DBA192594;
	Tue,  8 Oct 2024 13:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393327; cv=none; b=n1AO1OMuxmpXy9YWZNov1IhR1iDZS+Z7kf/VuKeMi/T1rZhDGlBijaq2ws1SM8Is93wRTm2kdpja8HIOWFqtrMMhb3FAtO8tnc1xYUGSe0byvC1b4lJQP4JiJoDa1GL36aagk+9ZjcBnVUIlsWrwjPfbRzyQl1Pz4L5vpXBWhgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393327; c=relaxed/simple;
	bh=KP28jVeeLzb8+9R1v3oSZDeoF+LEOA+uqRz0JB4v3kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYp1J0p3FWLCW7yMFxezf24S/YkgSHXUIeJ+yNQKngqMoI+xKz7s9xdrTzzyiJgL/FcObfu9V7vnEp19ugFJYN+sChwu2VZMI2LMjE9zLiFM/ozx3wPBEPZN6JqSF5OXOiquO8y4QceEn8GkW/IehSQrQ04Dd5jQVpjZGR918nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK+kVFt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK+kVFt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82D6C4CEC7;
	Tue,  8 Oct 2024 13:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393327;
	bh=KP28jVeeLzb8+9R1v3oSZDeoF+LEOA+uqRz0JB4v3kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rK+kVFt9wC16Jxqnskz759h1pkQgU51CVGe0mzvGkPmFTkTkbztlPHyDXVet7apI+
	 MPF0Fkp9IgvFd2ihoou02Ni6TIk/eVHA5merotBB9klZ4NkbiilkVMAFf9fj/6kGm9
	 TtKsPjzR5kKILE7dAm6c65ZybsC43EMwVBoSA83Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Liu <ltao@redhat.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Pavin Joseph <me@pavinjoseph.com>,
	Sarah Brofeldt <srhb@dbc.dk>,
	Eric Hagberg <ehagberg@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/386] x86/kexec: Add EFI config table identity mapping for kexec kernel
Date: Tue,  8 Oct 2024 14:06:02 +0200
Message-ID: <20241008115634.046185758@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Tao Liu <ltao@redhat.com>

[ Upstream commit 5760929f6545c651682de3c2c6c6786816b17bb1 ]

A kexec kernel boot failure is sometimes observed on AMD CPUs due to an
unmapped EFI config table array.  This can be seen when "nogbpages" is on
the kernel command line, and has been observed as a full BIOS reboot rather
than a successful kexec.

This was also the cause of reported regressions attributed to Commit
7143c5f4cf20 ("x86/mm/ident_map: Use gbpages only where full GB page should
be mapped.") which was subsequently reverted.

To avoid this page fault, explicitly include the EFI config table array in
the kexec identity map.

Further explanation:

The following 2 commits caused the EFI config table array to be
accessed when enabling sev at kernel startup.

    commit ec1c66af3a30 ("x86/compressed/64: Detect/setup SEV/SME features
                          earlier during boot")
    commit c01fce9cef84 ("x86/compressed: Add SEV-SNP feature
                          detection/setup")

This is in the code that examines whether SEV should be enabled or not, so
it can even affect systems that are not SEV capable.

This may result in a page fault if the EFI config table array's address is
unmapped. Since the page fault occurs before the new kernel establishes its
own identity map and page fault routines, it is unrecoverable and kexec
fails.

Most often, this problem is not seen because the EFI config table array
gets included in the map by the luck of being placed at a memory address
close enough to other memory areas that *are* included in the map created
by kexec.

Both the "nogbpages" command line option and the "use gpbages only where
full GB page should be mapped" change greatly reduce the chance of being
included in the map by luck, which is why the problem appears.

Signed-off-by: Tao Liu <ltao@redhat.com>
Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Pavin Joseph <me@pavinjoseph.com>
Tested-by: Sarah Brofeldt <srhb@dbc.dk>
Tested-by: Eric Hagberg <ehagberg@gmail.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/all/20240717213121.3064030-2-steve.wahl@hpe.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/machine_kexec_64.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index d287fe290c9ab..2fa12d1dc6760 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -28,6 +28,7 @@
 #include <asm/setup.h>
 #include <asm/set_memory.h>
 #include <asm/cpu.h>
+#include <asm/efi.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -90,6 +91,8 @@ map_efi_systab(struct x86_mapping_info *info, pgd_t *level4p)
 {
 #ifdef CONFIG_EFI
 	unsigned long mstart, mend;
+	void *kaddr;
+	int ret;
 
 	if (!efi_enabled(EFI_BOOT))
 		return 0;
@@ -105,6 +108,30 @@ map_efi_systab(struct x86_mapping_info *info, pgd_t *level4p)
 	if (!mstart)
 		return 0;
 
+	ret = kernel_ident_mapping_init(info, level4p, mstart, mend);
+	if (ret)
+		return ret;
+
+	kaddr = memremap(mstart, mend - mstart, MEMREMAP_WB);
+	if (!kaddr) {
+		pr_err("Could not map UEFI system table\n");
+		return -ENOMEM;
+	}
+
+	mstart = efi_config_table;
+
+	if (efi_enabled(EFI_64BIT)) {
+		efi_system_table_64_t *stbl = (efi_system_table_64_t *)kaddr;
+
+		mend = mstart + sizeof(efi_config_table_64_t) * stbl->nr_tables;
+	} else {
+		efi_system_table_32_t *stbl = (efi_system_table_32_t *)kaddr;
+
+		mend = mstart + sizeof(efi_config_table_32_t) * stbl->nr_tables;
+	}
+
+	memunmap(kaddr);
+
 	return kernel_ident_mapping_init(info, level4p, mstart, mend);
 #endif
 	return 0;
-- 
2.43.0



