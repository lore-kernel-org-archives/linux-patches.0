Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB992D24B7;
	Tue, 10 Mar 2026 11:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141118; cv=none; b=iIoeddyl5v8En27pUUesrbZfRveIXaOmf07Nu2jF9czkkrRGfkQVfs/kcoGJj0DtqhaJQfvqGZgjjpiyJuT7PxQxGU2GHGgqBB8qZ3WUq6IGrm2XTUTyAg8yZds5YV1DdlIGUSFVXOEF8oZvPBP09oY8dAtlKUcnA3PwNBieB1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141118; c=relaxed/simple;
	bh=Kibr1oJzbv76dXRlqhDBv8/K3VTdDqA/zUFGpzIEjr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf/3jl0OMliDjG37jh/51n5y19u6f4bEBQ9+It9g33edirbk1W96ZVeQs4ZZhyiMbxU+qwP+epWx0qs97aFr4QIj0qAFmBftka0qBK5Zk2N2xOSmvFfLVQ9pIcLB62SXMpPvBinUIbfHr1CWlRya0HTaF/p2HwalGXh5W/1C8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3nVEcdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3nVEcdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1369C2BC9E;
	Tue, 10 Mar 2026 11:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141118;
	bh=Kibr1oJzbv76dXRlqhDBv8/K3VTdDqA/zUFGpzIEjr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3nVEcdiPf3AumIO0zTKUVKYMj/YL7ExqEdIdz1kcy8J47QXvp1NzBSPBWRZYN97C
	 P+CRibOW4eIWZ7m1oeM3RINlTRs84pzl1aXqH6YLaQmJUvfaV/yQxnhNUFPZaykh0o
	 ppWzijmGv9eRJArAbjIlPoMe7N/r9F3WFRPEaKMKDyrPiBJkoavTU9lG4kvxpdG7W7
	 3V7f+kDKnQTiioMt4sDgYbwH9i6a7Nw4ritKKDBcJmu9HxGIKPMo7JPkcqqlhfEzhx
	 CicNARztzYjUJp2Yfz0Ah0BNZFRMkF4699rV54mxkPE/cts5//oGxRa8wp2+qgMeNz
	 AtJ+alN95i9tQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Kevin Hui <kevinhui@meta.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 120/311] x86/boot/sev: Move SEV decompressor variables into the .data section
Date: Tue, 10 Mar 2026 07:02:47 -0400
Message-ID: <c1db5dfb3c17d01d247c4da7f571b84e465cfc69.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 4ca191cec17a997d0e3b2cd312f3a884288acc27 upstream.

As part of the work to remove the dependency on calling into the decompressor
code (startup_64()) for a UEFI boot, a call to rmpadjust() was removed from
sev_enable() in favor of checking the value of the snp_vmpl variable.

When booting through a non-UEFI path and calling startup_64(), the call to
sev_enable() is performed before the BSS section is zeroed. With the removal
of the rmpadjust() call and the corresponding check of the return code, the
snp_vmpl variable is checked.

Since the kernel is running at VMPL0, the snp_vmpl variable will not have been
set and should be the default value of 0.  However, since the call occurs
before the BSS is zeroed, the snp_vmpl variable may not actually be zero,
which will cause the guest boot to fail.

Since the decompressor relocates itself, the BSS would need to be cleared both
before and after the relocation, but this would, in effect, cause all of the
changes to BSS variables before relocation to be lost after relocation.

Instead, move the snp_vmpl variable into the .data section so that it is
initialized and the value made safe during relocation. As a pre-caution
against future changes, move other SEV-related decompressor variables into the
.data section, too.

Fixes: 68a501d7fd82 ("x86/boot: Drop redundant RMPADJUST in SEV SVSM presence check")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Changyuan Lyu <changyuanl@google.com>
Tested-by: Kevin Hui <kevinhui@meta.com>
Tested-by: Changyuan Lyu <changyuanl@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/5648b7de5b0a5d0dfef3785f9582b718678c6448.1770217260.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/sev.c     | 8 ++++----
 arch/x86/boot/startup/sev-shared.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 2b639703b8dd4..e468476e9e4a0 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -28,17 +28,17 @@
 #include "sev.h"
 
 static struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
-struct ghcb *boot_ghcb;
+struct ghcb *boot_ghcb __section(".data");
 
 #undef __init
 #define __init
 
 #define __BOOT_COMPRESSED
 
-u8 snp_vmpl;
-u16 ghcb_version;
+u8 snp_vmpl __section(".data");
+u16 ghcb_version __section(".data");
 
-u64 boot_svsm_caa_pa;
+u64 boot_svsm_caa_pa __section(".data");
 
 /* Include code for early handlers */
 #include "../../boot/startup/sev-shared.c"
diff --git a/arch/x86/boot/startup/sev-shared.c b/arch/x86/boot/startup/sev-shared.c
index a0fa8bb2b9458..d9ac3a929d335 100644
--- a/arch/x86/boot/startup/sev-shared.c
+++ b/arch/x86/boot/startup/sev-shared.c
@@ -31,7 +31,7 @@ static u32 cpuid_std_range_max __ro_after_init;
 static u32 cpuid_hyp_range_max __ro_after_init;
 static u32 cpuid_ext_range_max __ro_after_init;
 
-bool sev_snp_needs_sfw;
+bool sev_snp_needs_sfw __section(".data");
 
 void __noreturn
 sev_es_terminate(unsigned int set, unsigned int reason)
-- 
2.51.0

