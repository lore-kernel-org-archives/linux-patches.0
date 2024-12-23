Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015D02EAE6;
	Mon, 23 Dec 2024 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969865; cv=none; b=eDjzykEoNqpFcMMEeBXsPg/YeRp7M18+eXA2EdEadIufDpro91h2oXknHRN/DUZyHzNQhk4uIXv6OfiL6MBRwAov7SFn7oE2BusserCtUJIXKEJeUEbr83+5wsNfdOrygKGqB3TfWGLSxtwdIGW2bSvmQRfTyPyWdy12VA0Uo8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969865; c=relaxed/simple;
	bh=O1zpdRU0AboaL0Nim65yWKjt0dhsWcXMApBcKu6iQqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0JKEN8vbbmuExRUonOxE1A1Q/aV5Sy3ZRk1OazHH1NidEwqe7baXMc0oI5Jr14mtFrUXU349o2roCQE3ZmMG4ng9UMp7n5UJiyIVM7TCsv7YjcRFB8SQAcKmrTf/tIvuVlqGoOAVxaAAhPKhdWGrUfmeUA2GLWdBKtHgof0op8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEb1WAxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEb1WAxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BFCC4CED3;
	Mon, 23 Dec 2024 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969864;
	bh=O1zpdRU0AboaL0Nim65yWKjt0dhsWcXMApBcKu6iQqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEb1WAxRVBgPyFnzZ31I65fu7Sstk6lUL0VouB9y4rECYj8e9p4pI6fbRNt12jm5a
	 RuW6p9aOjSfpu8mHZyUtskSsamJJzZ4ZzQqV0F4pVKmgpLNcNRCs2eedBQFiEi873q
	 d9lJ3nsAQxcqX97Igy9Mt8C9A3jIC96/alMxlm+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Cain <bcain@quicinc.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 075/160] hexagon: Disable constant extender optimization for LLVM prior to 19.1.0
Date: Mon, 23 Dec 2024 16:58:06 +0100
Message-ID: <20241223155411.584617131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

commit aef25be35d23ec768eed08bfcf7ca3cf9685bc28 upstream.

The Hexagon-specific constant extender optimization in LLVM may crash on
Linux kernel code [1], such as fs/bcache/btree_io.c after
commit 32ed4a620c54 ("bcachefs: Btree path tracepoints") in 6.12:

  clang: llvm/lib/Target/Hexagon/HexagonConstExtenders.cpp:745: bool (anonymous namespace)::HexagonConstExtenders::ExtRoot::operator<(const HCE::ExtRoot &) const: Assertion `ThisB->getParent() == OtherB->getParent()' failed.
  Stack dump:
  0.      Program arguments: clang --target=hexagon-linux-musl ... fs/bcachefs/btree_io.c
  1.      <eof> parser at end of file
  2.      Code generation
  3.      Running pass 'Function Pass Manager' on module 'fs/bcachefs/btree_io.c'.
  4.      Running pass 'Hexagon constant-extender optimization' on function '@__btree_node_lock_nopath'

Without assertions enabled, there is just a hang during compilation.

This has been resolved in LLVM main (20.0.0) [2] and backported to LLVM
19.1.0 but the kernel supports LLVM 13.0.1 and newer, so disable the
constant expander optimization using the '-mllvm' option when using a
toolchain that is not fixed.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/issues/99714 [1]
Link: https://github.com/llvm/llvm-project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
Link: https://github.com/llvm/llvm-project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
Reviewed-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/hexagon/Makefile
+++ b/arch/hexagon/Makefile
@@ -32,3 +32,9 @@ KBUILD_LDFLAGS += $(ldflags-y)
 TIR_NAME := r19
 KBUILD_CFLAGS += -ffixed-$(TIR_NAME) -DTHREADINFO_REG=$(TIR_NAME) -D__linux__
 KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_NAME)
+
+# Disable HexagonConstExtenders pass for LLVM versions prior to 19.1.0
+# https://github.com/llvm/llvm-project/issues/99714
+ifneq ($(call clang-min-version, 190100),y)
+KBUILD_CFLAGS += -mllvm -hexagon-cext=false
+endif


