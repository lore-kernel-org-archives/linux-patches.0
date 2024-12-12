Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4D3237FD8;
	Thu, 12 Dec 2024 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020561; cv=none; b=OgFph5pbjbBpfbA8E3opweF352XzuKU/UaJu7TVjHnBAH8oE3QApu9QohMBXtosHwMUwRHZ+/XGCJete/5ry4G0htBr/sxEPv7qk+fFRUD4OERDJT7JNufx4HFOv7hrUx+yEH7HgSXKcsw6y0aC0p6+VRdGw8ERmdQ/pJRaAldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020561; c=relaxed/simple;
	bh=qTSvxEFyP8KtiFXqjZjI3JlW9BFVj2TcDkYFsxsVSK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVh09H/Fe/pQM6qIwJlT4vG65XdjIYu3t/+WonWKl6dDwerztrd5D2j1BkHmU1N4Ga7EskwT1uPe652/kPXqH8YPu5ZJOdEpwxrUovMNVfL3EXXea1Ni9Q5PhFjLzuVaZqii9S5SwfI6ia8CrB1YHZ6m2gOemHUNXOXeaxlfeX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM568JEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM568JEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0735C4CECE;
	Thu, 12 Dec 2024 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020561;
	bh=qTSvxEFyP8KtiFXqjZjI3JlW9BFVj2TcDkYFsxsVSK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JM568JEi+paKwGjJbI4KihPRlwtdzo+GPyFwa2JguieqxuaDXNJObPQak2SoD/5kZ
	 WT3uT0zOH77z2+F0zijRetgUjIJLVrNMymzJoQp0dIfEdMYd6RczcUVEgArzOWy9iv
	 2NdLNzkezOV8QzzXrZl7tApHMe/RZAm8FDl1HIKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Packard <keithp@keithp.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 500/772] powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang
Date: Thu, 12 Dec 2024 15:57:25 +0100
Message-ID: <20241212144410.622206896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,13 +89,6 @@ KBUILD_AFLAGS	+= -m$(BITS)
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
@@ -383,9 +376,11 @@ prepare: stack_protector_prepare
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
 


