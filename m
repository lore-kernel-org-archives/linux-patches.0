Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E9F18C034;
	Thu, 17 Apr 2025 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913388; cv=none; b=ZnURym82MUBQErDEVhVI7l8JpKFdAWU+xoSeKYAwDPBzExj1AYGqaOgYLMr7qJ3F0Edd6gWDgNTw6B7MD7oxY+DYygbtI4eqaa+0kOIpycOEBi2jVAjVoaFVVBnxUswPAFfuhekydmNXndTAG2YSWMFFGBVdJudm0HJ1Cqe2rQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913388; c=relaxed/simple;
	bh=mPbOFYJX82+JQjI5woCTlwS9ixZlR++14FGBiBFUc/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa6HtOlbZRS/A3lAq1YRFEXhIQCKE8fLa0FBBBC0a2//LxouXN9TPotPj7bzEvXUMrlEHU1EQf0k13Bt9fqm2f8NVcl4LqlVUhNTzsyjc4W1gvkSYtpVhrJAPsxxj610bg+WaqkzLt0KsCWtU6sogQjG6VxfPWbR/xxpis5YDxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lROa/bQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lROa/bQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993E8C4CEE4;
	Thu, 17 Apr 2025 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913388;
	bh=mPbOFYJX82+JQjI5woCTlwS9ixZlR++14FGBiBFUc/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lROa/bQPbj/LH0qvAze10caZKQ8Za8nzrvAvAnEpt7pEHd+DiKXpRYPnGG7H1BqQO
	 gbAyYLWaFKEQ/XAn795QJE8rx/5BNpM9Tp5vvOmnZwiLhXIcowVBXgNJKb+ZCZX5Vm
	 +Q8EAf+r5SLgq5Blvuu7e45MXAt/2E+CUtISByCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.14 322/449] kbuild: Add -fno-builtin-wcslen
Date: Thu, 17 Apr 2025 19:50:10 +0200
Message-ID: <20250417175131.084137416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

commit 84ffc79bfbf70c779e60218563f2f3ad45288671 upstream.

A recent optimization change in LLVM [1] aims to transform certain loop
idioms into calls to strlen() or wcslen(). This change transforms the
first while loop in UniStrcat() into a call to wcslen(), breaking the
build when UniStrcat() gets inlined into alloc_path_with_tree_prefix():

  ld.lld: error: undefined symbol: wcslen
  >>> referenced by nls_ucs2_utils.h:54 (fs/smb/client/../../nls/nls_ucs2_utils.h:54)
  >>>               vmlinux.o:(alloc_path_with_tree_prefix)
  >>> referenced by nls_ucs2_utils.h:54 (fs/smb/client/../../nls/nls_ucs2_utils.h:54)
  >>>               vmlinux.o:(alloc_path_with_tree_prefix)

Disable this optimization with '-fno-builtin-wcslen', which prevents the
compiler from assuming that wcslen() is available in the kernel's C
library.

[ More to the point - it's not that we couldn't implement wcslen(), it's
  that this isn't an optimization at all in the context of the kernel.

  Replacing a simple inlined loop with a function call to the same loop
  is just stupid and pointless if you don't have long strings and fancy
  libraries with vectorization support etc.

  For the regular 'strlen()' cases, we want the compiler to do this in
  order to handle the trivial case of constant strings. And we do have
  optimized versions of 'strlen()' on some architectures. But for
  wcslen? Just no.    - Linus ]

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/9694844d7e36fd5e01011ab56b64f27b867aa72d [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -1065,6 +1065,9 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS   += -fconserve-stack
 endif
 
+# Ensure compilers do not transform certain loops into calls to wcslen()
+KBUILD_CFLAGS += -fno-builtin-wcslen
+
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)


