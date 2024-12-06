Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83475145A05;
	Fri,  6 Dec 2024 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496285; cv=none; b=DHQBDGpt8OasR06kiRLgMTEWtKi25ifvTfiRJf6h3TZUC4lIMO6AOEF80GwbrzfjQOW9X/KwQHi0PAWS2PqmBAip1cBykC27Dgxb0hb3OAKNekTkYsep87FfbObt3TwP/IWWM/m6OUwKGJG2rMf0cYrJf1fpFxMnRydpDh0Qky4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496285; c=relaxed/simple;
	bh=tKeVdtLEM974TRS9U9J4pDAZ44DUXqkNlIRqbMHcNdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxCO6+1DWqctwFSfPlsTIgyRa8o6ADIWwBoDmUpqxtaw6AvG1RQjIcy6vkQWZeLkj6LqJg0qJegsPdieF+uG6kEiD4rqwCaPCRo6M2G9bkqqcKQnvj7ddW4jV3gczvbV5usXTBBKOYGnvR2lA4BpWmp3OU0cNG1beQgxzZVcAuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0cawheK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0cawheK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5360C4CED1;
	Fri,  6 Dec 2024 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496285;
	bh=tKeVdtLEM974TRS9U9J4pDAZ44DUXqkNlIRqbMHcNdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0cawheKiJJOtt2roW3jpTxsV6Ri04ohv6zdBiMYEuahdkWHD1huax7GHOsIDDDfw
	 R301A3gLc4l8CwIgzZJTsrNQmEXI6g3nBq6769tZYA0fhCw8eHZWhVfr22FRDexbzd
	 9C91xKhcOo7IkTFElnuB8CS7rAMLBESWqisQxZao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Packard <keithp@keithp.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.12 107/146] powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang
Date: Fri,  6 Dec 2024 15:37:18 +0100
Message-ID: <20241206143531.777582728@linuxfoundation.org>
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

commit bee08a9e6ab03caf14481d97b35a258400ffab8f upstream.

After fixing the HAVE_STACKPROTECTER checks for clang's in-progress
per-task stack protector support [1], the build fails during prepare0
because '-mstack-protector-guard-offset' has not been added to
KBUILD_CFLAGS yet but the other '-mstack-protector-guard' flags have.

  clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
  clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
  make[4]: *** [scripts/Makefile.build:229: scripts/mod/empty.o] Error 1
  make[4]: *** [scripts/Makefile.build:102: scripts/mod/devicetable-offsets.s] Error 1

Mirror other architectures and add all '-mstack-protector-guard' flags
to KBUILD_CFLAGS atomically during stack_protector_prepare, which
resolves the issue and allows clang's implementation to fully work with
the kernel.

Cc: stable@vger.kernel.org # 6.1+
Link: https://github.com/llvm/llvm-project/pull/110928 [1]
Reviewed-by: Keith Packard <keithp@keithp.com>
Tested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241009-powerpc-fix-stackprotector-test-clang-v2-2-12fb86b31857@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Makefile |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -100,13 +100,6 @@ KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
-cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard=tls
-ifdef CONFIG_PPC64
-cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard-reg=r13
-else
-cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard-reg=r2
-endif
-
 LDFLAGS_vmlinux-y := -Bstatic
 LDFLAGS_vmlinux-$(CONFIG_RELOCATABLE) := -pie
 LDFLAGS_vmlinux-$(CONFIG_RELOCATABLE) += -z notext
@@ -402,9 +395,11 @@ prepare: stack_protector_prepare
 PHONY += stack_protector_prepare
 stack_protector_prepare: prepare0
 ifdef CONFIG_PPC64
-	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls -mstack-protector-guard-reg=r13 \
+				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
 else
-	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls -mstack-protector-guard-reg=r2 \
+				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
 endif
 endif
 


