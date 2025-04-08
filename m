Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBAD2192F2;
	Tue,  8 Apr 2025 11:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112136; cv=none; b=CC1nE8Dvv97Hk/bTgBtcGr3eS4ENoknqldFvRbcGlnyoK8jdeT+o73rl+b3wJsuXpkxNtbve97u5RCyeNa8sDGCV7IJR/nN08GdtyDmC1jYrKHfCvrX8yKmqwvzR+pk7Gi8VYF7v7EkZd9/3H/YGlk3BnUnzGem6CgxpH2MbZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112136; c=relaxed/simple;
	bh=uHfNI3nmTlvXV6mrvgHKf2CNQw2CzqnS+6TQwKr57q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mea6B3SS88NKRFNduXuDjYm+i9LgrqvU66X6+ZpzTJ3DoXAF005j5iGMPoZ1BQz4CbI1oarJ+bBxC0W8ghVFrXF352Nj72K/FMmdW33K7SXi6GMsijJohfAPxNZMF0Krwps7m/pjjZk2r5fMDUc5Xx6RJDnjw07aK1YFCdX4yuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtIAB++E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtIAB++E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32817C4CEE5;
	Tue,  8 Apr 2025 11:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112136;
	bh=uHfNI3nmTlvXV6mrvgHKf2CNQw2CzqnS+6TQwKr57q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtIAB++En1OVnbAlPLJOInQ2MKvCKK41Y9OZzJ6cikZvtMhLJCZJcLILWvji/P66+
	 xDUJ4souUub5u/yCqBpW9s0B68F6fhfK2175l7PnGPul7zjqGnrA57aFHLOsLmLf6N
	 BFQdcBP8wDmeibAXUCAZDUDPjX5etILATHX4qnIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.14 690/731] ARM: 9443/1: Require linker to support KEEP within OVERLAY for DCE
Date: Tue,  8 Apr 2025 12:49:47 +0200
Message-ID: <20250408104930.317702893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit e7607f7d6d81af71dcc5171278aadccc94d277cd upstream.

ld.lld prior to 21.0.0 does not support using the KEEP keyword within an
overlay description, which may be needed to avoid discarding necessary
sections within an overlay with '--gc-sections', which can be enabled
for the kernel via CONFIG_LD_DEAD_CODE_DATA_ELIMINATION.

Disallow CONFIG_LD_DEAD_CODE_DATA_ELIMINATION without support for KEEP
within OVERLAY and introduce a macro, OVERLAY_KEEP, that can be used to
conditionally add KEEP when it is properly supported to avoid breaking
old versions of ld.lld.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/381599f1fe973afad3094e55ec99b1620dba7d8c
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig                   |    2 +-
 arch/arm/include/asm/vmlinux.lds.h |    6 ++++++
 init/Kconfig                       |    5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -121,7 +121,7 @@ config ARM
 	select HAVE_KERNEL_XZ
 	select HAVE_KPROBES if !XIP_KERNEL && !CPU_ENDIAN_BE32 && !CPU_V7M
 	select HAVE_KRETPROBES if HAVE_KPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if (LD_VERSION >= 23600 || LD_IS_LLD)
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if (LD_VERSION >= 23600 || LD_CAN_USE_KEEP_IN_OVERLAY)
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_OPTPROBES if !THUMB2_KERNEL
--- a/arch/arm/include/asm/vmlinux.lds.h
+++ b/arch/arm/include/asm/vmlinux.lds.h
@@ -34,6 +34,12 @@
 #define NOCROSSREFS
 #endif
 
+#ifdef CONFIG_LD_CAN_USE_KEEP_IN_OVERLAY
+#define OVERLAY_KEEP(x)		KEEP(x)
+#else
+#define OVERLAY_KEEP(x)		x
+#endif
+
 /* Set start/end symbol names to the LMA for the section */
 #define ARM_LMA(sym, section)						\
 	sym##_start = LOADADDR(section);				\
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -129,6 +129,11 @@ config CC_HAS_COUNTED_BY
 	# https://github.com/llvm/llvm-project/pull/112636
 	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)
 
+config LD_CAN_USE_KEEP_IN_OVERLAY
+	# ld.lld prior to 21.0.0 did not support KEEP within an overlay description
+	# https://github.com/llvm/llvm-project/pull/130661
+	def_bool LD_IS_BFD || LLD_VERSION >= 210000
+
 config RUSTC_HAS_COERCE_POINTEE
 	def_bool RUSTC_VERSION >= 108400
 


