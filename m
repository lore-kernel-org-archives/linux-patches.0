Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF084152DE5;
	Tue, 20 Feb 2024 21:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463733; cv=none; b=MkazofBQ74R2mru9yQ5iU95WR0NQPmrrRrcSWk0rCbeXLuRjAHUfOoVE+QUrBvgLEZycNm8Ix2x4vqj34ImfxXM6QIpGmRPkwwskLZFTk0Kz8lHjI2HhEUoiX/Q30iCU0L4CqKOy2xlYUq2t5Pxd/sdWWoYcTjpSZyIJEO1B5h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463733; c=relaxed/simple;
	bh=J//KcESzmYs4hjv9V3V0p6Y19+iIszVnRoRY+aUgnwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7C2yr28472aoKgP5+gwkUn06TBKsRZbhHS0rgFgHcLkGnvM/v0Sq4raB8avaUmFkkn7OlPPQsJ1LwhpDDZSTfgXfEqQJnasLJdCuKeUwu7/44gr7AE4XUamOfCHzErSeMDxGel3CxhUPFvRZrg22qf1L8DPrcxVHvy9FBooMv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XB35TxE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB35TxE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CCBC433C7;
	Tue, 20 Feb 2024 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463732;
	bh=J//KcESzmYs4hjv9V3V0p6Y19+iIszVnRoRY+aUgnwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XB35TxE+WgaH8uWhXUMBP3/d+bbJsd1+8VsxQFKQKFO/H4nBtOibBz4dJxeyfjqnU
	 EOQzI3dI5l2f8YEWeRNR2iJeWeO8WrcxgLQJuYJMwqDOZxlm5Dj7nj/e2XWMTnhoBU
	 OHfkUoPItMgkens/q8m0bnAPcTw8QhyKc8kJviIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.6 135/331] um: Fix adding -no-pie for clang
Date: Tue, 20 Feb 2024 21:54:11 +0100
Message-ID: <20240220205641.812430807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 846cfbeed09b45d985079a9173cf390cc053715b upstream.

The kernel builds with -fno-PIE, so commit 883354afbc10 ("um: link
vmlinux with -no-pie") added the compiler linker flag '-no-pie' via
cc-option because '-no-pie' was only supported in GCC 6.1.0 and newer.

While this works for GCC, this does not work for clang because cc-option
uses '-c', which stops the pipeline right before linking, so '-no-pie'
is unconsumed and clang warns, causing cc-option to fail just as it
would if the option was entirely unsupported:

  $ clang -Werror -no-pie -c -o /dev/null -x c /dev/null
  clang-16: error: argument unused during compilation: '-no-pie' [-Werror,-Wunused-command-line-argument]

A recent version of clang exposes this because it generates a relocation
under '-mcmodel=large' that is not supported in PIE mode:

  /usr/sbin/ld: init/main.o: relocation R_X86_64_32 against symbol `saved_command_line' can not be used when making a PIE object; recompile with -fPIE
  /usr/sbin/ld: failed to set dynamic section sizes: bad value
  clang: error: linker command failed with exit code 1 (use -v to see invocation)

Remove the cc-option check altogether. It is wasteful to invoke the
compiler to check for '-no-pie' because only one supported compiler
version does not support it, GCC 5.x (as it is supported with the
minimum version of clang and GCC 6.1.0+). Use a combination of the
gcc-min-version macro and CONFIG_CC_IS_CLANG to unconditionally add
'-no-pie' with CONFIG_LD_SCRIPT_DYN=y, so that it is enabled with all
compilers that support this. Furthermore, using gcc-min-version can help
turn this back into

  LINK-$(CONFIG_LD_SCRIPT_DYN) += -no-pie

when the minimum version of GCC is bumped past 6.1.0.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/1982
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -115,7 +115,9 @@ archprepare:
 	$(Q)$(MAKE) $(build)=$(HOST_DIR)/um include/generated/user_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
-LINK-$(CONFIG_LD_SCRIPT_DYN) += $(call cc-option, -no-pie)
+ifdef CONFIG_LD_SCRIPT_DYN
+LINK-$(call gcc-min-version, 60100)$(CONFIG_CC_IS_CLANG) += -no-pie
+endif
 LINK-$(CONFIG_LD_SCRIPT_DYN_RPATH) += -Wl,-rpath,/lib
 
 CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,) \


