Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB952F1FE3;
	Mon, 22 Sep 2025 19:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570292; cv=none; b=mqJb723g9b3rhU2OfLbT10eUhCw6mjOuRiYcjgizme1yrHgczAKuAIggEdJ4DgKgxqDiZuMCY0xa76n2RrVOo5JCYaX25064Q/3/ENyGqaeJCznSw6mbm94xJbLGag4vl0lxls340fwwV3sWlCVpRHBBEnpJANq6Ev9Rj52xik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570292; c=relaxed/simple;
	bh=GjB5fNxDOjrryCP/HzfJ05rqsndtjbnB/AClmZwHp0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYIFhd45BPQLV9C56anBcRlhuJTevOIYZV32bblszaysHjUOxRSMeK/5NFQIxeB2ZSsT8eb8gBR0ktB4CTT442x9XCJXHemOTTBJj6GSuX5Nw3hfovmyTs60TyTCPIwfSH4u6F6EHBV0kfA5J9VtI5y0j7GnFMsADknpqkRBoQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gaxn/zXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gaxn/zXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A3FC4CEF0;
	Mon, 22 Sep 2025 19:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570292;
	bh=GjB5fNxDOjrryCP/HzfJ05rqsndtjbnB/AClmZwHp0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gaxn/zXkJ+XdKUseN+b/6rwa/adHesZytbx0+XgHhQQyNj4Nj8dvnxn2K1AtE6Fka
	 9Hcn1i2CwZMsi5ON1HY4K89v7m8Ov6ipEqKgWdjDpho+AQhZj2X+hfeHl6kHh+TWmx
	 isJEsMt+XneYRMIxrKXmV1ex3mSaLxZbbhO7BbeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.16 092/149] x86/sev: Guard sev_evict_cache() with CONFIG_AMD_MEM_ENCRYPT
Date: Mon, 22 Sep 2025 21:29:52 +0200
Message-ID: <20250922192415.207328819@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 7f830e126dc357fc086905ce9730140fd4528d66 upstream.

The sev_evict_cache() is guest-related code and should be guarded by
CONFIG_AMD_MEM_ENCRYPT, not CONFIG_KVM_AMD_SEV.

CONFIG_AMD_MEM_ENCRYPT=y is required for a guest to run properly as an SEV-SNP
guest, but a guest kernel built with CONFIG_KVM_AMD_SEV=n would get the stub
function of sev_evict_cache() instead of the version that performs the actual
eviction. Move the function declarations under the appropriate #ifdef.

Fixes: 7b306dfa326f ("x86/sev: Evict cache lines during SNP memory validation")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org # 6.16.x
Link: https://lore.kernel.org/r/70e38f2c4a549063de54052c9f64929705313526.1757708959.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/sev.h |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -564,6 +564,24 @@ enum es_result sev_es_ghcb_hv_call(struc
 
 extern struct ghcb *boot_ghcb;
 
+static inline void sev_evict_cache(void *va, int npages)
+{
+	volatile u8 val __always_unused;
+	u8 *bytes = va;
+	int page_idx;
+
+	/*
+	 * For SEV guests, a read from the first/last cache-lines of a 4K page
+	 * using the guest key is sufficient to cause a flush of all cache-lines
+	 * associated with that 4K page without incurring all the overhead of a
+	 * full CLFLUSH sequence.
+	 */
+	for (page_idx = 0; page_idx < npages; page_idx++) {
+		val = bytes[page_idx * PAGE_SIZE];
+		val = bytes[page_idx * PAGE_SIZE + PAGE_SIZE - 1];
+	}
+}
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -607,6 +625,7 @@ static inline int snp_send_guest_request
 static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline void sev_evict_cache(void *va, int npages) {}
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
@@ -621,24 +640,6 @@ int rmp_make_shared(u64 pfn, enum pg_lev
 void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
-
-static inline void sev_evict_cache(void *va, int npages)
-{
-	volatile u8 val __always_unused;
-	u8 *bytes = va;
-	int page_idx;
-
-	/*
-	 * For SEV guests, a read from the first/last cache-lines of a 4K page
-	 * using the guest key is sufficient to cause a flush of all cache-lines
-	 * associated with that 4K page without incurring all the overhead of a
-	 * full CLFLUSH sequence.
-	 */
-	for (page_idx = 0; page_idx < npages; page_idx++) {
-		val = bytes[page_idx * PAGE_SIZE];
-		val = bytes[page_idx * PAGE_SIZE + PAGE_SIZE - 1];
-	}
-}
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -654,7 +655,6 @@ static inline int rmp_make_shared(u64 pf
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
-static inline void sev_evict_cache(void *va, int npages) {}
 #endif
 
 #endif


