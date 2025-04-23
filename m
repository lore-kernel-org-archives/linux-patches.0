Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7EA27F755;
	Wed, 23 Apr 2025 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419889; cv=none; b=oXpvlFdw2KFt/k4N1UbhujBDoS2AR2JFTuCSI/RBIah58aybhEwAa64ExWWlrV+JzgTcxdqlje2hP1TFH47VRL17hQbM4wUqljO1wY9yWHwnjeXrTQEbtYRZe4turC5OHRMG4fBDYeUSVcDyPdcbrKEqzwcXFZsszr0W4XgvwsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419889; c=relaxed/simple;
	bh=1dPfMqFpBXjbgqvsh3oh+v8nRefXwjriw6JNyPu91aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOAt+l1cA3u84ye+nbV2QE5ZVAQeqpMSpWeC86I/2l7v54mE7OQzbQUafA6fqx7s8F+E1iYzhLfr9NTy5/kakw1lWwZmrNJJr5dd0FwEfe/LF09CHoZ7XIM12jye7gim72/Zk7M7pl5WMaenFeuSh9ky518+gY4XfLna1b70PqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SVSoPs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SVSoPs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F912C4CEE8;
	Wed, 23 Apr 2025 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419889;
	bh=1dPfMqFpBXjbgqvsh3oh+v8nRefXwjriw6JNyPu91aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SVSoPs5n5vflrX5au3Gj93Y+kgdT7PCG4kMyGnsCM1L0BkfsbsgLFEdr0QtlndMD
	 1F+FZqAHjr12AGcH3sRGnCfIo1ze8kKnHdUdJoZVJFy6NyaYBUP00mrlk5Gd26lBxq
	 Yx70slJDAkx7yAhKKVejIvdwQIf0QYfpx9nFd6c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/223] riscv: Properly export reserved regions in /proc/iomem
Date: Wed, 23 Apr 2025 16:42:28 +0200
Message-ID: <20250423142620.221159222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit e94eb7ea6f206e229791761a5fdf9389f8dbd183 ]

The /proc/iomem represents the kernel's memory map. Regions marked
with "Reserved" tells the user that the range should not be tampered
with. Kexec-tools, when using the older kexec_load syscall relies on
the "Reserved" regions to build the memory segments, that will be the
target of the new kexec'd kernel.

The RISC-V port tries to expose all reserved regions to userland, but
some regions were not properly exposed: Regions that resided in both
the "regular" and reserved memory block, e.g. the EFI Memory Map. A
missing entry could result in reserved memory being overwritten.

It turns out, that arm64, and loongarch had a similar issue a while
back:

  commit d91680e687f4 ("arm64: Fix /proc/iomem for reserved but not memory regions")
  commit 50d7ba36b916 ("arm64: export memblock_reserve()d regions via /proc/iomem")

Similar to the other ports, resolve the issue by splitting the regions
in an arch initcall, since we need a working allocator.

Fixes: ffe0e5261268 ("RISC-V: Improve init_resources()")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250409182129.634415-1-bjorn@kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 7934613a98c88..194bda6d74ce7 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -66,6 +66,9 @@ static struct resource bss_res = { .name = "Kernel bss", };
 static struct resource elfcorehdr_res = { .name = "ELF Core hdr", };
 #endif
 
+static int num_standard_resources;
+static struct resource *standard_resources;
+
 static int __init add_resource(struct resource *parent,
 				struct resource *res)
 {
@@ -139,7 +142,7 @@ static void __init init_resources(void)
 	struct resource *res = NULL;
 	struct resource *mem_res = NULL;
 	size_t mem_res_sz = 0;
-	int num_resources = 0, res_idx = 0;
+	int num_resources = 0, res_idx = 0, non_resv_res = 0;
 	int ret = 0;
 
 	/* + 1 as memblock_alloc() might increase memblock.reserved.cnt */
@@ -195,6 +198,7 @@ static void __init init_resources(void)
 	/* Add /memory regions to the resource tree */
 	for_each_mem_region(region) {
 		res = &mem_res[res_idx--];
+		non_resv_res++;
 
 		if (unlikely(memblock_is_nomap(region))) {
 			res->name = "Reserved";
@@ -212,6 +216,9 @@ static void __init init_resources(void)
 			goto error;
 	}
 
+	num_standard_resources = non_resv_res;
+	standard_resources = &mem_res[res_idx + 1];
+
 	/* Clean-up any unused pre-allocated resources */
 	if (res_idx >= 0)
 		memblock_free(mem_res, (res_idx + 1) * sizeof(*mem_res));
@@ -223,6 +230,33 @@ static void __init init_resources(void)
 	memblock_free(mem_res, mem_res_sz);
 }
 
+static int __init reserve_memblock_reserved_regions(void)
+{
+	u64 i, j;
+
+	for (i = 0; i < num_standard_resources; i++) {
+		struct resource *mem = &standard_resources[i];
+		phys_addr_t r_start, r_end, mem_size = resource_size(mem);
+
+		if (!memblock_is_region_reserved(mem->start, mem_size))
+			continue;
+
+		for_each_reserved_mem_range(j, &r_start, &r_end) {
+			resource_size_t start, end;
+
+			start = max(PFN_PHYS(PFN_DOWN(r_start)), mem->start);
+			end = min(PFN_PHYS(PFN_UP(r_end)) - 1, mem->end);
+
+			if (start > mem->end || end < mem->start)
+				continue;
+
+			reserve_region_with_split(mem, start, end, "Reserved");
+		}
+	}
+
+	return 0;
+}
+arch_initcall(reserve_memblock_reserved_regions);
 
 static void __init parse_dtb(void)
 {
-- 
2.39.5



