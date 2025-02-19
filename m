Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3321DFE34;
	Wed, 19 Feb 2025 09:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957064; cv=none; b=L0gcHN6XFWvz1PvoRQQWvIAGihAS9gchpiCjoVeCbf5kIRM83hJrgtalSCsolJjSiOuYxYs26OycpzBEBRW0CQme2q0dhXK3QKrYmebLuj29XvVvdyB+KVzmHMxyLHe5MdrrFxr/IsIBmX8HKXiUScf06x5hVLKeco+cORjpoCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957064; c=relaxed/simple;
	bh=6FQB/nrklImaU8CCuPjFoEps4jPhk1md5xDoqqg2mbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Spwlx3fvis9GY4/peuFhdC0a6NKZ35FjzRk1dwrsRKmJ676dikYr98a0GpHdWmi3unuaT8fqgYyTQ0EsF487MI3zAj+YSC7wz4tEKLSkPIHor01EF/OcGEALU5EX+L2zGPjtVjWEzoFZvIZdMZHRdfPvsXHL+ErAAIAZnVAjVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liXwBUfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liXwBUfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BC4C4CED1;
	Wed, 19 Feb 2025 09:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957063;
	bh=6FQB/nrklImaU8CCuPjFoEps4jPhk1md5xDoqqg2mbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liXwBUfXwW1jq028m0U+vPTSbwKO5iPJWGiOSMRvUR9IIYDxU7o6hNGV4HBWGXX0M
	 Q7aOuyfqMszULaeZXbU3p9bbK/ipjgNVCoCEXTKYz4g7pV5Cz7IPTQ/GFV9wOPtsYn
	 0iUvzN+QdsMosE3DTaUdnrZOwoIqM50Frah8pVgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kostadin Shishmanov <kostadinshishmanov@protonmail.com>,
	Jakub Jelinek <jakub@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 396/578] x86/boot: Use -std=gnu11 to fix build with GCC 15
Date: Wed, 19 Feb 2025 09:26:40 +0100
Message-ID: <20250219082708.601972986@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit ee2ab467bddfb2d7f68d996dbab94d7b88f8eaf7 upstream.

GCC 15 changed the default C standard version to C23, which should not
have impacted the kernel because it requests the gnu11 standard via
'-std=' in the main Makefile. However, the x86 compressed boot Makefile
uses its own set of KBUILD_CFLAGS without a '-std=' value (i.e., using
the default), resulting in errors from the kernel's definitions of bool,
true, and false in stddef.h, which are reserved keywords under C23.

  ./include/linux/stddef.h:11:9: error: expected identifier before ‘false’
     11 |         false   = 0,
  ./include/linux/types.h:35:33: error: two or more data types in declaration specifiers
     35 | typedef _Bool                   bool;

Set '-std=gnu11' in the x86 compressed boot Makefile to resolve the
error and consistently use the same C standard version for the entire
kernel.

Closes: https://lore.kernel.org/4OAhbllK7x4QJGpZjkYjtBYNLd_2whHx9oFiuZcGwtVR4hIzvduultkgfAIRZI3vQpZylu7Gl929HaYFRGeMEalWCpeMzCIIhLxxRhq4U-Y=@protonmail.com/
Closes: https://lore.kernel.org/Z4467umXR2PZ0M1H@tucnak/
Reported-by: Kostadin Shishmanov <kostadinshishmanov@protonmail.com>
Reported-by: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250121-x86-use-std-consistently-gcc-15-v1-1-8ab0acf645cb%40kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -34,6 +34,7 @@ targets := vmlinux vmlinux.bin vmlinux.b
 # avoid errors with '-march=i386', and future flags may depend on the target to
 # be valid.
 KBUILD_CFLAGS := -m$(BITS) -O2 $(CLANG_FLAGS)
+KBUILD_CFLAGS += -std=gnu11
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIE
 KBUILD_CFLAGS += -Wundef
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING


