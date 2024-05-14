Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F766311D;
	Tue, 14 May 2024 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685939; cv=none; b=NgDsp8Q6l9x/ZCQk8LaUjbJ+XFTRptvKvO66eAJ4AJLwvU13LUOkHuXipHoxj5qAYYBePM6xSIp+yQ3LegJKeaRguoz8X7oioTknNBi5oqaIa6i5/gGb0/WHlYZj09+fd74W+/0u2nfKisxg05xWyHOzUS+koTssaeHZ0/aa5Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685939; c=relaxed/simple;
	bh=5wyuGDZNTRf4bUDcGsthorRnKTzQ2Pxde0tqzpDxzso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M//RWHHodSfuwlAgjai4eL7IWv/sYMVFkPPuhDxf4gX79QVlRBHBuZRaOTim6y9sDGg06AcV8vQ3d3y9JKuuaxYNHqLeq/OKRsGwV01+PdrHh13f7cXM4MkiVskrBKj2IP6LuOdxzVBONsW2dn2wpdx7tYxX8HdwkkhiUhvRs4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyam7xGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyam7xGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6489C2BD10;
	Tue, 14 May 2024 11:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685938;
	bh=5wyuGDZNTRf4bUDcGsthorRnKTzQ2Pxde0tqzpDxzso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyam7xGHu7odC9Tlq5vW0xDeBJ0nzH/8cbfa8yZgSVD4lP3sPHGaJe8Xx/AJr5Vte
	 NY47JnbD02ZuccfgVYHS9B/VBqetyvSV3dpvlDyO7Q91E9Gu26HbKOGNNXYS+GFXZM
	 lKaWYIBPQbL/lCmpm6mmYEQDMO1YnHwrEpA4xhuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mark Brown <broonie@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 281/301] selftests/mm: fix powerpc ARCH check
Date: Tue, 14 May 2024 12:19:12 +0200
Message-ID: <20240514101042.874320941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 7e6423441b36e3a03907e2df84b73c414c9c3763 upstream.

In commit 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
the logic to detect the machine architecture in the Makefile was changed
to use ARCH, and only fallback to uname -m if ARCH is unset.  However the
tests of ARCH were not updated to account for the fact that ARCH is
"powerpc" for powerpc builds, not "ppc64".

Fix it by changing the checks to look for "powerpc", and change the
uname -m logic to convert "ppc64.*" into "powerpc".

With that fixed the following tests now build for powerpc again:
 * protection_keys
 * va_high_addr_switch
 * virtual_address_range
 * write_to_hugetlbfs

Link: https://lkml.kernel.org/r/20240506115825.66415-1-mpe@ellerman.id.au
Fixes: 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>	[6.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -12,7 +12,7 @@ uname_M := $(shell uname -m 2>/dev/null
 else
 uname_M := $(shell echo $(CROSS_COMPILE) | grep -o '^[a-z0-9]\+')
 endif
-ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
+ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/powerpc/')
 endif
 
 # Without this, failed build products remain, with up-to-date timestamps,
@@ -95,13 +95,13 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),ppc64))
+ifneq (,$(findstring $(ARCH),powerpc))
 TEST_GEN_FILES += protection_keys
 endif
 
 endif
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sparc64 x86_64))
+ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64))
 TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs


