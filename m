Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DD5221DA7;
	Tue, 29 Apr 2025 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947018; cv=none; b=Qbgp5EVng8U69015XM5yRlPiYAYZcEw+6qT/ZppeC59eBQlzWHrFPikBe/YLuCRUNpuFAgzdhk5bzp/Tp8TI8P4WZBFO5iVWcW8KnOyNOqAeHw8JpmZsGQmIGAGQeLCO88KaRL5Q2wGdFg4N+ZnTF7wyWlEWUvOQcuVJKkGXVLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947018; c=relaxed/simple;
	bh=u6fVYEM4dj6/RHkHEaWZEhjOwnkw6AUgxRslcmxIJPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXmuNxmvQ614UAtTDBfYd+f24kP5U7KPPqJg0lYbW3wVzpx6W24+ryTsO9Aa7h/DxsfXb8R7j8JUEywHdJUiXCNZNFf2WA8EwLx4nsM2e5js9EgxRjGml7N2nl4GVV87v7B6gTrgNznNYpaEZjtNp5tXJ0et+B9Ex9EYumdG2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXhM7tYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXhM7tYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC15C4CEE3;
	Tue, 29 Apr 2025 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947017;
	bh=u6fVYEM4dj6/RHkHEaWZEhjOwnkw6AUgxRslcmxIJPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXhM7tYga40zDEcgpty26189whS31/c16VL6z0+u5Gdal0hf6ZcFwwhaL3uGvPppV
	 DavCINK/x/rL47uUs4+nXb5owImGkeMfqxahs37G0wCM8eybCWLMt3PGA/H66Hzc2+
	 u6ja1Eks9kUrUBbDM+ggVKP9VvR/lZlswRu3tDKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 145/286] kbuild: Add -fno-builtin-wcslen
Date: Tue, 29 Apr 2025 18:40:49 +0200
Message-ID: <20250429161113.849616949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[nathan: Resolve small conflict in older trees]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -976,6 +976,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Wer
 # Require designated initializers for all marked structures
 KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
 
+# Ensure compilers do not transform certain loops into calls to wcslen()
+KBUILD_CFLAGS += -fno-builtin-wcslen
+
 # change __FILE__ to the relative path from the srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 


