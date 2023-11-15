Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8F63A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQG17sDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E551CC433CA;
	Wed, 15 Nov 2023 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077721;
	bh=KSJXqv1FS9yiChj4cY92BFCvHgg1krgaQOWSOnpS4OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQG17sDn9YfRfNw87DM+Cx+iI0jJMgOA7lYggQv7XZfTgThQuiHQJMT7oKrRPnkz8
	 +mGRoCSFLiJZXAEdGj2Ra9ETooaF93RNLcr1RLpkR2GfCRP9vW6ngsJ+dASVRVJxME
	 XQgbszoza8OHS6InnjzSRvJ9l/Y7T3rtICIPL3J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sachin Sant <sachinp@linux.ibm.com>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 478/603] powerpc/vmcore: Add MMU information to vmcoreinfo
Date: Wed, 15 Nov 2023 14:17:03 -0500
Message-ID: <20231115191645.508387063@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Aditya Gupta <adityag@linux.ibm.com>

[ Upstream commit 36e826b568e412f61d68fedc02a67b4d8b7583cc ]

Since below commit, address mapping for vmemmap has changed for Radix
MMU, where address mapping is stored in kernel page table itself,
instead of earlier used 'vmemmap_list'.

    commit 368a0590d954 ("powerpc/book3s64/vmemmap: switch radix to use
    a different vmemmap handling function")

Hence with upstream kernel, in case of Radix MMU, makedumpfile fails
to do address translation for vmemmap addresses, as it depended on
vmemmap_list, which can now be empty.

While fixing the address translation in makedumpfile, it was identified
that currently makedumpfile cannot distinguish between Hash MMU and
Radix MMU, unless VMLINUX is passed with -x flag to makedumpfile. And
hence fails to assign offsets and shifts correctly (such as in L4 to
PGDIR offset calculation in makedumpfile).

For getting the MMU, makedumpfile uses `cur_cpu_spec.mmu_features`.

Add `cur_cpu_spec` symbol and offset of `mmu_features` in the `cpu_spec`
struct, to VMCOREINFO, so that makedumpfile can assign the offsets
correctly, without needing a VMLINUX.

Also, even along with `cur_cpu_spec->mmu_features` makedumpfile has to
depend on the 'MMU_FTR_TYPE_RADIX' flag in mmu_features, implying kernel
developers need to be cautious of changes to 'MMU_FTR_*' defines.

A more stable approach was suggested in the below thread by contributors:
 https://lore.kernel.org/linuxppc-dev/20230920105706.853626-1-adityag@linux.ibm.com/

The suggestion was to add whether 'RADIX_MMU' is enabled in vmcoreinfo

This patch also implements the suggestion, by adding 'RADIX_MMU' in
vmcoreinfo, which makedumpfile can use to get whether the crashed system
had RADIX MMU (in which case 'NUMBER(RADIX_MMU)=1') or not (in which
case 'NUMBER(RADIX_MMU)=0')

Fixes: 368a0590d954 ("powerpc/book3s64/vmemmap: switch radix to use a different vmemmap handling function")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Aditya Gupta <adityag@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231023072612.50874-1-adityag@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index de64c79629912..005269ac3244c 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -74,6 +74,9 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
 	VMCOREINFO_OFFSET(mmu_psize_def, shift);
 #endif
+	VMCOREINFO_SYMBOL(cur_cpu_spec);
+	VMCOREINFO_OFFSET(cpu_spec, mmu_features);
+	vmcoreinfo_append_str("NUMBER(RADIX_MMU)=%d\n", early_radix_enabled());
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
 }
 
-- 
2.42.0



