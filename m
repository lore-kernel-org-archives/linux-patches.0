Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105751DDD7;
	Mon,  4 Dec 2023 23:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNvG9d52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B00C433C7;
	Mon,  4 Dec 2023 23:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701731517;
	bh=DVXCZ9jpOAnNg7LJEUeeMDB9ZjLGevPMDsIyu7d5WpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bNvG9d527lXukIxR9+gLXuTRtcZ3LR1hX2B3aNpA7rsRtLbhjqerlUJqsy/CtL3nI
	 DV9uuBfDQGd3TsZ5jgfL9uVmWQ/LEuoIl5Bvi3YFPD6uBoSg2njjtQPrzENhVc0/aL
	 1PYLH1+nRyRY98F5llMANneXs5tqpN/pSD2oWFma3NQYi+LKKL+xqBmzKOeID/JiSh
	 G/Eexl0vTWn7OZdUAlf+F4x58PjrDMnwV60SmD2zzTdiM32tNACPy5C2XJssIetlqM
	 M+u4biG2quLP3Z/9NIBBcJ2VThXSLB8KWbpQoYGT51jEVSQ1qYgDJctD7YlVNd3TiD
	 U3Bz9P6gsHB+g==
Date: Mon, 4 Dec 2023 16:11:55 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Fangrui Song <maskray@google.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	conor@kernel.org, ndesaulniers@google.com,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
Message-ID: <20231204231155.GA3560411@dev-arch.thelio-3990X>
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
 <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
 <CAFP8O3JscgacLPX-_pc2J0uhqk=ehtxSNStzo7PwewPSuXkxiw@mail.gmail.com>
 <20231201194858.GA290910@dev-arch.thelio-3990X>
 <CAFP8O3+uta+GQO7dpeNLe0OMFnX-tdEyvHREEu1ThjA3nFtTkQ@mail.gmail.com>
 <20231201215021.GA2579712@dev-arch.thelio-3990X>
 <CAFP8O3LJPqPVxcRzi_Qxvu_w8w76BXmfWv8YnsK+bMvqXb701Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFP8O3LJPqPVxcRzi_Qxvu_w8w76BXmfWv8YnsK+bMvqXb701Q@mail.gmail.com>

On Fri, Dec 01, 2023 at 08:31:12PM -0800, Fangrui Song wrote:
> Perhaps: Clang generates .uleb128 with label differences for DWARF v5,
> a feature that older binutils ports, utilizing RISC-V style linker
> relaxation, do not support.
> 
> (Signed LEB128 is used by DWARF as well, but it is encoded directly
> into DW_OP_fbreg/DW_LNS_advance_line/etc, and explicit .sleb128
> directives are not emitted)
> (In assemblers, "label difference" is a more common term.)
> (People working on DWARF tend to prefer DWARF v5 to DWARF5, when the
> full "DWARF version 5" feels too verbose.)

Thanks, does this diff seem reasonable to you? I'd like to keep the
issue link as a paper trail and I figured that we might as well make the
configuration name slightly more accurate with that additional
information. I will send it as a separate patch in v2 tomorrow if so in
order to give people a chance to further chime in on the series.

Cheers,
Nathan

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a0ebce05a368..76c2cc697573 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -231,9 +231,10 @@ config DEBUG_INFO
 	  in the "Debug information" choice below, indicating that debug
 	  information will be generated for build targets.
 
-# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5, which
-# some targets may not support: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
-config AS_HAS_NON_CONST_LEB128
+# Clang generates .uleb128 with label differences for DWARF v5, a feature that
+# older binutils ports do not support when utilizing RISC-V style linker
+# relaxation: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
+config AS_HAS_NON_CONST_ULEB128
 	def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)
 
 choice
@@ -258,7 +259,7 @@ config DEBUG_INFO_NONE
 config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 	bool "Rely on the toolchain's implicit default DWARF version"
 	select DEBUG_INFO
-	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
+	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
 	help
 	  The implicit default version of DWARF debug info produced by a
 	  toolchain changes over time.
@@ -283,7 +284,7 @@ config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	select DEBUG_INFO
 	depends on !ARCH_HAS_BROKEN_DWARF5
-	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
