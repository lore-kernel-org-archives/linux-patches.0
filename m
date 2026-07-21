Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8220446D0AC;
	Tue, 21 Jul 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655307; cv=none; b=CO3YHAS59KGlEhj4S2ieYllySdaA9QMr6VYDqq3u8BS8F3C5dMLoL97X1LSX3yqaYlttbgxnucfKa+2ZK1zjEauBBaRpyjnq0UtWQ1CqOE6KXc4Kz9eKL6Pz46LOoxP4PmdIrxri0rwWiQ2af0jw7IWgsfYvbKY5vb3xibV2x7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655307; c=relaxed/simple;
	bh=puoayWbAtbuJkx7hMY3HnTcSicOXyZ7XruigFWlURas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7Dg9kHRNx04yixUtztI83s5xGkajd3Bnr9SyHty967TVt3vxyX/cmhiimGkKAZeMHZrWelsMgdRMwMjx8HFmLYhlddgx5DIbqGCjiw2tqT+lHSSo1mkhxyVQGQjMehWolDGmK8osWrb3hlvWksBwBQH13ab5unReSKrY3cXp/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7a3DhHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7a3DhHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97071F000E9;
	Tue, 21 Jul 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655306;
	bh=DYDubQk3nMsuKUnHGexoRn1LgzdVz8KoQrac1TmERkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7a3DhHIUDaTjGmuduyrCwqKn1Itw/i0RmJnWIQRGyjoelPBdBtBnR/a/P+vvw4Rp
	 Bg4aOOOpx0ApcGF8VTIV4P+eu5wIktV2NNcz1GcdnwlbICd8ceXZqTF3/XaID+NsBi
	 Mgk9b24l8PqjR/snEEOVtui07KjzANLz5d9xvFNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 1992/2077] selftests/rseq: Fix a building error for riscv arch
Date: Tue, 21 Jul 2026 17:27:45 +0200
Message-ID: <20260721152639.695236540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/rseq/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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


