Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46482853ED;
	Wed, 23 Apr 2025 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422548; cv=none; b=gzlJB0V/feekioOMVfdPbrOuXbqC6G7DlB6OGN3B1PlrsCFN004sCFBpxvy7qSkkMWv4LOUILg9n2KkEd/lauLYJsmI8WICcmwV3h7k16htE+k9kvyv+bZIvH+KbOO0oeVCvKqwsLWdLuVMGw+aMJR4JXovEuvtzxw46iE413Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422548; c=relaxed/simple;
	bh=TerNogXoomZ7A/9kUarVOD+VstC9Tjf2+5QB7mUtecA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHSF4Z9vJUIvf3wm0JGnBpol1DfpL556HK88ApSQN2kpB57QOnDhbhC3Bbl0PqgUNlq0dbCopc86AhcapGFdBYkUT4qQZWvnnIhg4DuKRLn3KHc87zoaL0CjlDr5zi5fZgThjbTlWPw/yT+hJM395dD6yegekTs3hUkRBkUdOsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhuZbGwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhuZbGwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8030C4CEE3;
	Wed, 23 Apr 2025 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422548;
	bh=TerNogXoomZ7A/9kUarVOD+VstC9Tjf2+5QB7mUtecA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhuZbGwx+SsG3MGtWJaXaMYPoLtNJS1JrzhXVIbDL4a1LcJzkBYqVfH37lumqD93V
	 ZUnszIEXIT6aCcOelV3+hBJSvvwvqwaGQFFY56VWVZuoVNPvR9U8eK/imX3BSzKxbh
	 kQFxO1A/mU1iJBmkiCPKNe7wlJtxq5yV/fkVaSVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 361/393] kbuild: Add -fno-builtin-wcslen
Date: Wed, 23 Apr 2025 16:44:17 +0200
Message-ID: <20250423142658.251329963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1004,6 +1004,9 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS   += -fconserve-stack
 endif
 
+# Ensure compilers do not transform certain loops into calls to wcslen()
+KBUILD_CFLAGS += -fno-builtin-wcslen
+
 # change __FILE__ to the relative path from the srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 


