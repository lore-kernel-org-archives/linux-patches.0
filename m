Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D38471264;
	Tue, 21 Jul 2026 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659309; cv=none; b=UqALMko3mbkevM17O9mVBz8NC4nucA4ckoyBtUx8DN1oMUBmuYDZ51WvfJ9ETOn9pv0B8QrmOm6/93aPabUp/ku6X5nB7VfUbmLzZtwiRHW271CpV6h/e2TALsyPCf3HQAUpFlB+pDTFKrFyWLzfCG+YbG/7rwlp2vGkRMWxBBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659309; c=relaxed/simple;
	bh=amS4sjhTCQqGDSE8BrVmA5NNNfTjh/iXEFM/wDECTNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gThjN1dJIi0Uym9dI+R7azPZ4ToKD0n1lPwl0FowMwdFdksMRbS5n1N9fRZsfz7Af4pVOlGDFPo2sza5rcGwEfDxsalE/rs6YVE8K9Xg4JthPo/ag7ePnS+kFsny5LL2AzGEzow3YquYn9HaTUzrsy5DofEKWBMt312fQaMqEvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfN130/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfN130/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442E11F000E9;
	Tue, 21 Jul 2026 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659308;
	bh=pOVm95jd2uHvzMZY5WgfHfxTiYNuIG3hIDrSxx+PScU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfN130/hmzFgPaGsG/8ICSL+/9WWMCQw+3nCSdMiCPAU2Dp87DLqsDmNIgV9vsh18
	 LotHz6MthaGMgsntTBvGNqgw3h4aeC5Fb4vogTBD0N84s0sOjq6ZtFddP6NGTd0dJ5
	 pBvnup8HcflZVk1Lvwziuu3I9re8gXwxa4GA2alA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 1471/1611] selftests/rseq: Fix a building error for riscv arch
Date: Tue, 21 Jul 2026 17:26:27 +0200
Message-ID: <20260721152548.533313691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit a2ac823d8a228e392bc6a79ea63b550ab84a55b2 upstream.

RISC-V rseq selftests include asm/fence.h from tools/arch/riscv,
but the rseq Makefile only adds tools/include in the CFLAGS, this
results in the building failure both for native and cross build:

    In file included from rseq.h:131,
                     from rseq.c:37:
    rseq-riscv.h:11:10: fatal error: asm/fence.h: No such file or directory

To fix it, add the matching tools/arch/$(ARCH)/include path in the
CFLAGS and derive ARCH from SUBARCH for standalone native builds where
ARCH is not set.

Fixes: c92786e179e0 ("KVM: riscv: selftests: Use the existing RISCV_FENCE macro in `rseq-riscv.h`")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://patch.msgid.link/20260707082348.36896-1-hui.wang@canonical.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index 50d69e22ee7a..aba6317f6cb8 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -5,9 +5,13 @@ CLANG_FLAGS += -no-integrated-as
 endif
 
 top_srcdir = ../../../..
+include $(top_srcdir)/scripts/subarch.include
+ARCH ?= $(SUBARCH)
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 
 CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES) -L$(OUTPUT) -Wl,-rpath=./ \
-	  $(CLANG_FLAGS) -I$(top_srcdir)/tools/include
+	  $(CLANG_FLAGS) -I$(top_srcdir)/tools/include \
+	  -I$(LINUX_TOOL_ARCH_INCLUDE)
 LDLIBS += -lpthread -ldl
 
 # Own dependencies because we only want to build against 1st prerequisite, but
-- 
2.55.0



