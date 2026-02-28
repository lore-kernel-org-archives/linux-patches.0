Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ED4361648
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300925; cv=none; b=a6mfLzhBFYqZuLRRwtPPU3dqR4Bki++/KKE0O77b/UlEG98KMraDSWn9AJi+ODsN4hGMTLa2PIxAu7fZ6Gp477Ml2FwKtXClIbxI7INAfply3jvNia7mYpdK1hgBAKiifMaqu2Di1Kg/lIPA6WdQQIyJx6Y7SYdC5ttrHcMXU1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300925; c=relaxed/simple;
	bh=nPOOwTN9rQfIl16ZfqCD65HJGRJgMP1p3/FYRG1qNRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+dhd3kf3jN3LXEPUy6mJ2KwBlaPYcGE7U+jMJ55Z6nVieUbEXBxYJYYZz5G4EVjS8wd0f/Ve60Y3QKvOLUktlmdZ+Ngpc3Awi/hQruwl8Tm5Eign1DlHHtUWsDb4Dn0xGfhB3GkDwyGoCOoOYklPyHfwsghntiv/UqE6/JDFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBjYhjh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBjYhjh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF265C19425;
	Sat, 28 Feb 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300925;
	bh=nPOOwTN9rQfIl16ZfqCD65HJGRJgMP1p3/FYRG1qNRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBjYhjh8FEbJM9dKD11W9/4aCkjNryvnNb2cYi74gbOXxNItUcblKldVIHCYq3n9n
	 ArGeg4OF1BIztblZSIqmXzT1JAv/yDdcmV9qcjcRcohEcI40JvxGJ5O0jQ6EA6+RbQ
	 ovXC/VuGHLub/grwxNvoZ55PF8hTvZrGSfuo9DFp1lR+xvIouk5ZxvejAXYvPhnuxW
	 ItRzdtkDZihrdGeIYZNZrvJn+j74kacZandWr8V7ZraCQICXVEy+6eZumEypzDC0yx
	 pKAlvXAacHKgTy2271ljge93qD4OeB+Y0UprjV3VtM5wUP1KXvQJ6v1Q2U/pOQJt1J
	 I/ipIuIkkTOOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/752] s390/boot: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS
Date: Sat, 28 Feb 2026 12:35:54 -0500
Message-ID: <20260228174750.1542406-43-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5ba35a6c13fff0929c34aba6b7602dacbe68686c ]

Add -Wno-default-const-init-unsafe to boot KBUILD_CFLAGS, similar to
scripts/Makefile.extrawarn, since clang generates warnings for the dummy
variable in typecheck():

    CC      arch/s390/boot/version.o
      arch/s390/include/asm/ptrace.h:221:9: warning: default initialization of an object of type 'typeof (regs->psw)' (aka 'const psw_t') leaves the object uninitialized [-Wdefault-const-init-var-unsafe]
        221 |         return psw_bits(regs->psw).pstate;
            |                ^
      arch/s390/include/asm/ptrace.h:98:2: note: expanded from macro 'psw_bits'
         98 |         typecheck(psw_t, __psw);                \
            |         ^
      include/linux/typecheck.h:11:12: note: expanded from macro 'typecheck'
         11 |         typeof(x) __dummy2; \
            |                   ^

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 02f2cf0827487..1768424a1824f 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -21,6 +21,7 @@ KBUILD_AFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_AFLAGS_DECOMPRESSOR))
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_CFLAGS_DECOMPRESSOR))
 KBUILD_AFLAGS += $(CC_FLAGS_MARCH_MINIMUM) -D__DISABLE_EXPORTS
 KBUILD_CFLAGS += $(CC_FLAGS_MARCH_MINIMUM) -D__DISABLE_EXPORTS
+KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
 
 CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
 
-- 
2.51.0

