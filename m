Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4C01474A9;
	Fri,  6 Dec 2024 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496211; cv=none; b=hRdKaMu005AjhOvWcbdNqX7qPAmDN689kt9E5u8ocWWyxS0gtsgZwKWOxE+F/f/ktOdp4AJT1mfn8BOo3iFivq2LC2S3/BruxR2lADd85tDjOlXw35wM7Y2SkqKGMfSZq3u2c81tgFLdw/SbYDCJH5yVD9djVTVSo4Xvp6s2phw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496211; c=relaxed/simple;
	bh=NAmJDnPk+GijqrIOwUa8DzbgGjbRq9RG14wEA451LdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLqAWiMQaIrGSUAIvCxWz6AMXBhLcr9r6g0D1PYz74vaP1lBl58wN+KnrDwRbbv5BUIsj9Ds+Z3uPAFTOEgR0kg4wwixcdm39N9fNFoBsUlE9FZiLiGuH/5XPiKpHUfvvrB/z8DFLwA8+/l31aJ7YdVPrRY6zciYxDK5ryYz8QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg40R/DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg40R/DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C192EC4CED1;
	Fri,  6 Dec 2024 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496211;
	bh=NAmJDnPk+GijqrIOwUa8DzbgGjbRq9RG14wEA451LdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg40R/DSOTXQV4sM0NuClA4nOR7D7a4ZL903dgkZRQC0oFWLktsYU3BrgRgNtqRDr
	 /8ou5UAVCzPIq2TYtPWdCiz3Ip5whwZszduI5nlPXd77EiLDgXO45mUfvgTE47ms0r
	 RRKVmjdkCzMuTm8w1WEA8GtyV+ECza5eRoOzSYgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.12 052/146] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang
Date: Fri,  6 Dec 2024 15:36:23 +0100
Message-ID: <20241206143529.666061912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit d677ce521334d8f1f327cafc8b1b7854b0833158 upstream.

Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
end up in the 32-bit vDSO flags, resulting in build failures due to the
structure of clang's argument parsing of the stack protector options,
which validates the arguments of the stack protector guard flags
unconditionally in the frontend, choking on the 64-bit values when
targeting 32-bit:

  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  make[3]: *** [arch/powerpc/kernel/vdso/Makefile:85: arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
  make[3]: *** [arch/powerpc/kernel/vdso/Makefile:87: arch/powerpc/kernel/vdso/vgetrandom-32.o] Error 1

Remove these flags by adding them to the CC32FLAGSREMOVE variable, which
already handles situations similar to this. Additionally, reformat and
align a comment better for the expanding CONFIG_CC_IS_CLANG block.

Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vdso/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -54,10 +54,14 @@ ldflags-y += $(filter-out $(CC_AUTO_VAR_
 
 CC32FLAGS := -m32
 CC32FLAGSREMOVE := -mcmodel=medium -mabi=elfv1 -mabi=elfv2 -mcall-aixdesc
-  # This flag is supported by clang for 64-bit but not 32-bit so it will cause
-  # an unused command line flag warning for this file.
 ifdef CONFIG_CC_IS_CLANG
+# This flag is supported by clang for 64-bit but not 32-bit so it will cause
+# an unused command line flag warning for this file.
 CC32FLAGSREMOVE += -fno-stack-clash-protection
+# -mstack-protector-guard values from the 64-bit build are not valid for the
+# 32-bit one. clang validates the values passed to these arguments during
+# parsing, even when -fno-stack-protector is passed afterwards.
+CC32FLAGSREMOVE += -mstack-protector-guard%
 endif
 LD32FLAGS := -Wl,-soname=linux-vdso32.so.1
 AS32FLAGS := -D__VDSO32__


