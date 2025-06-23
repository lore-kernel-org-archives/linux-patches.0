Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8F5C2E0;
	Mon, 23 Jun 2025 22:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716808; cv=none; b=b/MEJLIafxLGmroloBKMpQoRsVNdBUJKDtGR2oN40yo4FFlNxnJXReei2HCeyya34PKgSjiMnb1N8XuGUJu6HmIglmaaW4eAzibKraMMCrE/4gGmCxSMOLhgB9dyM+exxPHJqbvfXl/tOjpmaq+ZhO/23lwSnKVHDYQBFnfXYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716808; c=relaxed/simple;
	bh=zVZpLWl+s4c5XOyoUrEF5d/bG73tIrmUhsqMSOgE+rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX2RWybWSmd9yiF0prhiwMnkD49b/WRNW0w/EsfWFKOBQgiSd4h5kmHhXpkMTkvXgDkL7ABRW0iL5Oadfw7b5DKYmjdoAPmLj0yvnJBiITreLms1r1cF+MA0NZL/cH8J6kjcEVOuWDkwkliZs7zU/eC/Wsw0sRGdKG5up22kFxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI66RhYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI66RhYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E0AC4CEEA;
	Mon, 23 Jun 2025 22:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716808;
	bh=zVZpLWl+s4c5XOyoUrEF5d/bG73tIrmUhsqMSOgE+rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI66RhYjluoaAX26YuLt9lFQ6fH3BznHQprt4Wrl/dRlc0DfUXYuzKmIztCRULOMB
	 6T9V+FeK/t8EWxkYk7ODNCTB9qelTeUV+JgFn5QAf5xje71Eyty85120jmy4whhY/z
	 RHavu6xnQj/qNiLQNj3oTR9LfXQGsqVWWvD/BNoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khem Raj <raj.khem@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 361/508] mips: Add -std= flag specified in KBUILD_CFLAGS to vdso CFLAGS
Date: Mon, 23 Jun 2025 15:06:46 +0200
Message-ID: <20250623130654.245442508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khem Raj <raj.khem@gmail.com>

commit 0f4ae7c6ecb89bfda026d210dcf8216fb67d2333 upstream.

GCC 15 changed the default C standard dialect from gnu17 to gnu23,
which should not have impacted the kernel because it explicitly requests
the gnu11 standard in the main Makefile. However, mips/vdso code uses
its own CFLAGS without a '-std=' value, which break with this dialect
change because of the kernel's own definitions of bool, false, and true
conflicting with the C23 reserved keywords.

  include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
     11 |         false   = 0,
        |         ^~~~~
  include/linux/stddef.h:11:9: note: 'false' is a keyword with '-std=c23' onwards
  include/linux/types.h:35:33: error: 'bool' cannot be defined via 'typedef'
     35 | typedef _Bool                   bool;
        |                                 ^~~~
  include/linux/types.h:35:33: note: 'bool' is a keyword with '-std=c23' onwards

Add -std as specified in KBUILD_CFLAGS to the decompressor and purgatory
CFLAGS to eliminate these errors and make the C standard version of these
areas match the rest of the kernel.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/vdso/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -32,6 +32,7 @@ endif
 # offsets.
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
+	$(filter -std=%,$(KBUILD_CFLAGS)) \
 	-O3 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \
 	-mrelax-pic-calls $(call cc-option, -mexplicit-relocs) \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \


