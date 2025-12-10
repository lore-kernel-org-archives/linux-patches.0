Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3756302140;
	Wed, 10 Dec 2025 07:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352030; cv=none; b=EjNBY2ExINC4xoWuSetjlSL3k/Zx0YgZHvRkMKbnJEkFGAVjcxfGtgcCJiX8LrEGpN95mpB0xRp23jSeUmd06mwpGRmUcWndvZ4PqWk7cg7pK1J+jeKIRXyqpz33h+Tb7xUTHyqgsXEexG7oycrPNW+yMQejWzWK7SedPGYXoAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352030; c=relaxed/simple;
	bh=wmhiGEJAXX+TqCFMTWT3udon4yc5VmRV51WSvl1gOqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/X9iJiLikxeybJsvurhauutVfZN4nrKNhUViGL78Oo6rGXiLlF1AJOPEzlxecvnliTltfCvViOvIku3qiSAT9b56wMmeaFSPmOg2Z5yBd+pH1RFuBY+1neRzfOmpTLqm/eikCybtEEp0XhdZJukU/ufHBx8tGpqKZkTL6qLwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chSoz/7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chSoz/7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C54C4CEF1;
	Wed, 10 Dec 2025 07:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352030;
	bh=wmhiGEJAXX+TqCFMTWT3udon4yc5VmRV51WSvl1gOqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chSoz/7/0x8fDwj9nMMlyCWP2DRbAd6qbGX3iqHvpTuCXqgFZkMRJStbvfWSICyoK
	 XKw6TBajzv7MvKaL2jsN1Bj7ahTfSV+CAUkg+lJsh76X7rNnYgHwHSWrP7b5yUA19/
	 MqMDOHh1VH3fpAZS0oH0sKStk5hGYTBHWIyDoWls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fanqin Cui <cuifq1@chinatelecom.cn>,
	=?UTF-8?q?Adrian=20Barna=C5=9B?= <abarnas@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 24/60] arm64: Reject modules with internal alternative callbacks
Date: Wed, 10 Dec 2025 16:29:54 +0900
Message-ID: <20251210072948.432673793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Barnaś <abarnas@google.com>

[ Upstream commit 8e8ae788964aa2573b4335026db4068540fa6a86 ]

During module loading, check if a callback function used by the
alternatives specified in the '.altinstruction' ELF section (if present)
is located in core kernel .text. If not fail module loading before
callback is called.

Reported-by: Fanqin Cui <cuifq1@chinatelecom.cn>
Closes: https://lore.kernel.org/all/20250807072700.348514-1-fanqincui@163.com/
Signed-off-by: Adrian Barnaś <abarnas@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
[will: Folded in 'noinstr' tweak from Mark]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/alternative.h |  7 +++++--
 arch/arm64/kernel/alternative.c      | 19 ++++++++++++-------
 arch/arm64/kernel/module.c           |  9 +++++++--
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 00d97b8a757f4..51746005239bc 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -26,9 +26,12 @@ void __init apply_alternatives_all(void);
 bool alternative_is_applied(u16 cpucap);
 
 #ifdef CONFIG_MODULES
-void apply_alternatives_module(void *start, size_t length);
+int apply_alternatives_module(void *start, size_t length);
 #else
-static inline void apply_alternatives_module(void *start, size_t length) { }
+static inline int apply_alternatives_module(void *start, size_t length)
+{
+	return 0;
+}
 #endif
 
 void alt_cb_patch_nops(struct alt_instr *alt, __le32 *origptr,
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 8ff6610af4966..f5ec7e7c1d3fd 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -139,9 +139,9 @@ static noinstr void clean_dcache_range_nopatch(u64 start, u64 end)
 	} while (cur += d_size, cur < end);
 }
 
-static void __apply_alternatives(const struct alt_region *region,
-				 bool is_module,
-				 unsigned long *cpucap_mask)
+static int __apply_alternatives(const struct alt_region *region,
+				bool is_module,
+				unsigned long *cpucap_mask)
 {
 	struct alt_instr *alt;
 	__le32 *origptr, *updptr;
@@ -166,10 +166,13 @@ static void __apply_alternatives(const struct alt_region *region,
 		updptr = is_module ? origptr : lm_alias(origptr);
 		nr_inst = alt->orig_len / AARCH64_INSN_SIZE;
 
-		if (ALT_HAS_CB(alt))
+		if (ALT_HAS_CB(alt)) {
 			alt_cb  = ALT_REPL_PTR(alt);
-		else
+			if (is_module && !core_kernel_text((unsigned long)alt_cb))
+				return -ENOEXEC;
+		} else {
 			alt_cb = patch_alternative;
+		}
 
 		alt_cb(alt, origptr, updptr, nr_inst);
 
@@ -193,6 +196,8 @@ static void __apply_alternatives(const struct alt_region *region,
 		bitmap_and(applied_alternatives, applied_alternatives,
 			   system_cpucaps, ARM64_NCAPS);
 	}
+
+	return 0;
 }
 
 static void __init apply_alternatives_vdso(void)
@@ -277,7 +282,7 @@ void __init apply_boot_alternatives(void)
 }
 
 #ifdef CONFIG_MODULES
-void apply_alternatives_module(void *start, size_t length)
+int apply_alternatives_module(void *start, size_t length)
 {
 	struct alt_region region = {
 		.begin	= start,
@@ -287,7 +292,7 @@ void apply_alternatives_module(void *start, size_t length)
 
 	bitmap_fill(all_capabilities, ARM64_NCAPS);
 
-	__apply_alternatives(&region, true, &all_capabilities[0]);
+	return __apply_alternatives(&region, true, &all_capabilities[0]);
 }
 #endif
 
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index d6d443c4a01ac..0b15c57285add 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -489,8 +489,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 	int ret;
 
 	s = find_section(hdr, sechdrs, ".altinstructions");
-	if (s)
-		apply_alternatives_module((void *)s->sh_addr, s->sh_size);
+	if (s) {
+		ret = apply_alternatives_module((void *)s->sh_addr, s->sh_size);
+		if (ret < 0) {
+			pr_err("module %s: error occurred when applying alternatives\n", me->name);
+			return ret;
+		}
+	}
 
 	if (scs_is_dynamic()) {
 		s = find_section(hdr, sechdrs, ".init.eh_frame");
-- 
2.51.0



