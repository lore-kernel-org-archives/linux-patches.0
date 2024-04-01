Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50881E525;
	Mon,  1 Apr 2024 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989238; cv=none; b=jUyc4984YnBiS6GADZNi2RTNRcE5OJNAdLaF/7QF+TMoGX6ZHwjOySJTNpnQjKcUf1HdZOR8vyaHIebqCtdli80TSffRS0lm3tOsUkdmhrjDCEpvWkZ/k3dDljyWsOfRQOA02MdWouWwwc0e+dCFPXMWjxslIqIjw5loO2B/vxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989238; c=relaxed/simple;
	bh=rmnYDa5Fx3gvX0SOO8yrN56iETvGYONWjerSq0kTaQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtOQifr7ODbq4Me7AH3tYIRw3/QhpYPcqmSaGb7UnCSMAa95nQOileGHEssGfYkA3Rd66ZU3mSRWgMz8eqmTIHMRVODM03gHuhX4N+fNwIUWTqnTaoorVKOFm5vSmBiNcX+iBIY2TUHCJCAwbpwt9DgL5s+xjQZd3YMXyYegbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LumfQqbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LumfQqbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B37C433F1;
	Mon,  1 Apr 2024 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989237;
	bh=rmnYDa5Fx3gvX0SOO8yrN56iETvGYONWjerSq0kTaQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LumfQqbjjDzCCKQ8nuI0TGu6pK9071Hq6wXoF7mBM2Sgu1J+72ayGgnQkR1Qinf0z
	 YOPKYn3sl61mI0zM1qTC8YwPWqm4R9Jns85TUL1GOHyPPCuHnrUGlyn/JeBI6F6jCk
	 SHk+WycvVEkOY2PulC39gWVEKKJnT4Wp/9O0vyFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Bohac <jbohac@suse.cz>,
	Li Huafei <lihuafei1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 423/432] crash: use macro to add crashk_res into iomem early for specific arch
Date: Mon,  1 Apr 2024 17:46:50 +0200
Message-ID: <20240401152606.041706178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

commit 32fbe5246582af4f611ccccee33fd6e559087252 upstream.

There are regression reports[1][2] that crashkernel region on x86_64 can't
be added into iomem tree sometime.  This causes the later failure of kdump
loading.

This happened after commit 4a693ce65b18 ("kdump: defer the insertion of
crashkernel resources") was merged.

Even though, these reported issues are proved to be related to other
component, they are just exposed after above commmit applied, I still
would like to keep crashk_res and crashk_low_res being added into iomem
early as before because the early adding has been always there on x86_64
and working very well.  For safety of kdump, Let's change it back.

Here, add a macro HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY to limit that
only ARCH defining the macro can have the early adding
crashk_res/_low_res into iomem. Then define
HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY on x86 to enable it.

Note: In reserve_crashkernel_low(), there's a remnant of crashk_low_res
handling which was mistakenly added back in commit 85fcde402db1 ("kexec:
split crashkernel reservation code out from crash_core.c").

[1]
[PATCH V2] x86/kexec: do not update E820 kexec table for setup_data
https://lore.kernel.org/all/Zfv8iCL6CT2JqLIC@darkstar.users.ipa.redhat.com/T/#u

[2]
Question about Address Range Validation in Crash Kernel Allocation
https://lore.kernel.org/all/4eeac1f733584855965a2ea62fa4da58@huawei.com/T/#u

Link: https://lkml.kernel.org/r/ZgDYemRQ2jxjLkq+@MiWiFi-R3L-srv
Fixes: 4a693ce65b18 ("kdump: defer the insertion of crashkernel resources")
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/crash_core.h |    2 ++
 kernel/crash_core.c               |    8 ++++++++
 2 files changed, 10 insertions(+)

--- a/arch/x86/include/asm/crash_core.h
+++ b/arch/x86/include/asm/crash_core.h
@@ -39,4 +39,6 @@ static inline unsigned long crash_low_si
 #endif
 }
 
+#define HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
+
 #endif /* _X86_CRASH_CORE_H */
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -377,6 +377,9 @@ static int __init reserve_crashkernel_lo
 
 	crashk_low_res.start = low_base;
 	crashk_low_res.end   = low_base + low_size - 1;
+#ifdef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
+	insert_resource(&iomem_resource, &crashk_low_res);
+#endif
 #endif
 	return 0;
 }
@@ -458,8 +461,12 @@ retry:
 
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
+#ifdef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
+	insert_resource(&iomem_resource, &crashk_res);
+#endif
 }
 
+#ifndef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
 static __init int insert_crashkernel_resources(void)
 {
 	if (crashk_res.start < crashk_res.end)
@@ -472,6 +479,7 @@ static __init int insert_crashkernel_res
 }
 early_initcall(insert_crashkernel_resources);
 #endif
+#endif
 
 int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 			  void **addr, unsigned long *sz)


