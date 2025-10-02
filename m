Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E86E1D554;
	Thu,  2 Oct 2025 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419037; cv=none; b=jWmYITwBw5q7y756MZOHzpW8AJrhqiXMsA0cl9+yGCHw7qd5DrNV1C316mDcN4kh/pucd0O3jouVJuCm1vucfZmcWhqdHRKTJ+02p8RVlbeoJmKFNKBZPEnwQVvME2zHQ9zm4dI0Sk7n5/L69J/TjmFbK1mDvGjrjl+mz39lHUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419037; c=relaxed/simple;
	bh=o/uLA398BYfKlbY0pdWtj3IwxtO2zQxajL77FWEY6To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0dQz4EGuG1rP77g4xlvCXDRoE3+GWLZTq40Upb0hR2qREqTxJ6E3moNZiCvB3cCheUyrinPD4IG/m7BHoejqaRdr2R1IhOjJ+9Y8IkRkjm74uz2mHh/zxG1c753DyuV2IvNZqOyfMzf9Vl6x5sRmbNqbz8ASX0wNq9yAHgWKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSzVD0a1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSzVD0a1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F45C4CEFB;
	Thu,  2 Oct 2025 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419036;
	bh=o/uLA398BYfKlbY0pdWtj3IwxtO2zQxajL77FWEY6To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSzVD0a1XLzUcU/ZLkl3/IQwPsot1DngFpzyX/xcZM8HXYybe4lbM25GIZr8HmOSQ
	 MwOfRKit1wszXeyCF8c5gvTY/lnUUbiZrBB3w8r3VJo236B6PupUjDuPFzIKOGvurf
	 3bRsOIWC7+heUwbGoppkhwLs4AYRgdgo8ESCiqohDkW+WmQD4M307cLQKS3d7LxnDa
	 Htq6Ner0kmTtbfyKRWc3GPD4oI7+FzNsi9JNS2XBcAt6sV7Wnxf+Y4cwZIArd/er6J
	 8J32kOvit64ACX4C6oJstKf3HEEiT+1tVIJaQWdP/kYHOI6DBxWBGduheWYGc7Xkj6
	 6cE/mrJ3eJHxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sami Mujawar <sami.mujawar@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.16] arm64: realm: ioremap: Allow mapping memory as encrypted
Date: Thu,  2 Oct 2025 11:29:55 -0400
Message-ID: <20251002153025.2209281-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit fa84e534c3ec2904d8718a83180294f7b5afecc7 ]

For ioremap(), so far we only checked if it was a device (RIPAS_DEV) to choose
an encrypted vs decrypted mapping. However, we may have firmware reserved memory
regions exposed to the OS (e.g., EFI Coco Secret Securityfs, ACPI CCEL).
We need to make sure that anything that is RIPAS_RAM (i.e., Guest
protected memory with RMM guarantees) are also mapped as encrypted.

Rephrasing the above, anything that is not RIPAS_EMPTY is guaranteed to be
protected by the RMM. Thus we choose encrypted mapping for anything that is not
RIPAS_EMPTY. While at it, rename the helper function

  __arm64_is_protected_mmio => arm64_rsi_is_protected

to clearly indicate that this not an arm64 generic helper, but something to do
with Realms.

Cc: Sami Mujawar <sami.mujawar@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Tested-by: Sami Mujawar <sami.mujawar@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, I can now provide my
determination.

## Analysis Summary

### Code Change Analysis

The commit makes a **critical logic change** in
`arch/arm64/kernel/rsi.c:104`:

**Before**: `if (ripas != RSI_RIPAS_DEV) break;`
- Only returns true if **all** regions are RIPAS_DEV (device memory)
- Other states (RIPAS_RAM, RIPAS_DESTROYED) cause early exit → mapped as
  **decrypted**

**After**: `if (ripas == RSI_RIPAS_EMPTY) break;`
- Returns true for RIPAS_RAM, RIPAS_DESTROYED, and RIPAS_DEV
- Only RIPAS_EMPTY (unprotected/shared) regions are mapped as
  **decrypted**

### Problem Being Fixed

The original implementation from commit 371589437616f (Oct 2024) only
encrypted RIPAS_DEV regions. However, **firmware-reserved memory
regions** use RIPAS_RAM state:

- **EFI Coco Secret Securityfs** areas
- **ACPI CCEL** (Confidential Computing Event Log) tables

Without this fix, these RIPAS_RAM regions are incorrectly mapped with
`pgprot_decrypted()`, which sets `PROT_NS_SHARED`, making them
**accessible to the untrusted hypervisor**.

### Security Impact

This is a **security and data integrity bug**:
1. **Confidential data leakage**: Hypervisor can read protected firmware
   secrets
2. **Data corruption**: Hypervisor can modify what should be protected
   memory
3. **Violation of ARM CCA guarantees**: Breaks confidential computing
   promises

### Dependencies

Two related commits were **already backported** (based on "Upstream
commit" tags):
- `bda90416d53f`: "arm64: Enable EFI secret area Securityfs support"
- `09b8e2bf3bf1`: "arm64: acpi: Enable ACPI CCEL support"

Both depend on this fix to function correctly.

### Risk Assessment

**LOW RISK**:
- Isolated to ARM64 Realm subsystem (v6.13+)
- Only affects ARM CCA Realm guests
- Simple, well-understood logic inversion
- Multiple reviewers (Gavin Shan, Steven Price) and testers (Sami
  Mujawar)
- No follow-up fixes or reverts found
- Function rename improves code clarity

### Stable Tree Rules

✅ Fixes important security/correctness bug
✅ Small and contained (3 files, ~30 lines)
✅ No new features or architectural changes
✅ Minimal regression risk
✅ Well-tested and reviewed

---

## **Answer: YES**

**This commit should be backported to stable kernel trees that include
ARM64 Realm support (v6.13+).**

**Rationale**: This fixes a security vulnerability where firmware-
reserved protected memory (RIPAS_RAM) is incorrectly mapped as decrypted
instead of encrypted, violating ARM CCA confidential computing
guarantees. The bug allows the untrusted hypervisor to access or corrupt
protected firmware data (EFI secrets, ACPI CCEL tables). The fix is
small, contained, well-tested, and has minimal regression risk.
Additionally, two dependent features (EFI Secret and ACPI CCEL support)
were already backported and require this fix to work correctly.

 arch/arm64/include/asm/io.h  |  2 +-
 arch/arm64/include/asm/rsi.h |  2 +-
 arch/arm64/kernel/rsi.c      | 26 ++++++++++++++++++++++----
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 9b96840fb979b..82276282a3c72 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -311,7 +311,7 @@ extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
 static inline bool arm64_is_protected_mmio(phys_addr_t phys_addr, size_t size)
 {
 	if (unlikely(is_realm_world()))
-		return __arm64_is_protected_mmio(phys_addr, size);
+		return arm64_rsi_is_protected(phys_addr, size);
 	return false;
 }
 
diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
index b42aeac05340e..88b50d660e85a 100644
--- a/arch/arm64/include/asm/rsi.h
+++ b/arch/arm64/include/asm/rsi.h
@@ -16,7 +16,7 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
 
 void __init arm64_rsi_init(void);
 
-bool __arm64_is_protected_mmio(phys_addr_t base, size_t size);
+bool arm64_rsi_is_protected(phys_addr_t base, size_t size);
 
 static inline bool is_realm_world(void)
 {
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index ce4778141ec7b..c64a06f58c0bc 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -84,7 +84,25 @@ static void __init arm64_rsi_setup_memory(void)
 	}
 }
 
-bool __arm64_is_protected_mmio(phys_addr_t base, size_t size)
+/*
+ * Check if a given PA range is Trusted (e.g., Protected memory, a Trusted Device
+ * mapping, or an MMIO emulated in the Realm world).
+ *
+ * We can rely on the RIPAS value of the region to detect if a given region is
+ * protected.
+ *
+ *  RIPAS_DEV - A trusted device memory or a trusted emulated MMIO (in the Realm
+ *		world
+ *  RIPAS_RAM - Memory (RAM), protected by the RMM guarantees. (e.g., Firmware
+ *		reserved regions for data sharing).
+ *
+ *  RIPAS_DESTROYED is a special case of one of the above, where the host did
+ *  something without our permission and as such we can't do anything about it.
+ *
+ * The only case where something is emulated by the untrusted hypervisor or is
+ * backed by shared memory is indicated by RSI_RIPAS_EMPTY.
+ */
+bool arm64_rsi_is_protected(phys_addr_t base, size_t size)
 {
 	enum ripas ripas;
 	phys_addr_t end, top;
@@ -101,18 +119,18 @@ bool __arm64_is_protected_mmio(phys_addr_t base, size_t size)
 			break;
 		if (WARN_ON(top <= base))
 			break;
-		if (ripas != RSI_RIPAS_DEV)
+		if (ripas == RSI_RIPAS_EMPTY)
 			break;
 		base = top;
 	}
 
 	return base >= end;
 }
-EXPORT_SYMBOL(__arm64_is_protected_mmio);
+EXPORT_SYMBOL(arm64_rsi_is_protected);
 
 static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
 {
-	if (__arm64_is_protected_mmio(phys, size))
+	if (arm64_rsi_is_protected(phys, size))
 		*prot = pgprot_encrypted(*prot);
 	else
 		*prot = pgprot_decrypted(*prot);
-- 
2.51.0

