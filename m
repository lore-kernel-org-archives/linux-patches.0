Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3957319259A;
	Wed,  5 Feb 2025 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768332; cv=none; b=nQXRQ5Oj8IcVgXXVhEbAmPjdvISpKZeeqiBYcaXJkDQgs/+ElnRTqacJKOyD3hQ8lR2zL011LlwWK89usd1SDvAykj6S6djEoORbPoZ2jVIcQ4sBHPmK8TDeP66N4s8iGF46sc+CgNcUmWPdqUu1CZk1Z2Gnx+QhyhkckiSkxSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768332; c=relaxed/simple;
	bh=7+mybLEliGQjTK4PnAHueTdSxQ8BgbwkuOT/d98f+dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnuYynbznNIw0c3XuRijZYOjMQq55WNpd4r5o7nsn1rMn/VEsVdibWIegcmsiV31++ExiUD/KxEd9laj1RQAiwVhxokRxFDAk6lticBZx/HK3KoF30cYtwT1WHHIaTATdHp8sM3EvUJoDhwbbdIJ4GSrzxgBog1RlVas63/qsng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZNn5kp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZNn5kp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9771BC4CED1;
	Wed,  5 Feb 2025 15:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768332;
	bh=7+mybLEliGQjTK4PnAHueTdSxQ8BgbwkuOT/d98f+dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZNn5kp8L1gDlKD9x7uc1/As55MbBsl4tCB5Er6tr2N8R3U15LUmh3vogngRpE4I8
	 uh+slxdFMTFvvv1YnHsEjprdxmsnh9RfLY/n/y7FVVU/iM6VFMqLD6T1eaRBw6MCiO
	 aSwNWktyOSVuH0NF7UQ+AeZA2ptwo3TtYxsNHFa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 585/590] s390: Add -std=gnu11 to decompressor and purgatory CFLAGS
Date: Wed,  5 Feb 2025 14:45:40 +0100
Message-ID: <20250205134517.643720141@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 3b8b80e993766dc96d1a1c01c62f5d15fafc79b9 upstream.

GCC changed the default C standard dialect from gnu17 to gnu23,
which should not have impacted the kernel because it explicitly requests
the gnu11 standard in the main Makefile. However, there are certain
places in the s390 code that use their own CFLAGS without a '-std='
value, which break with this dialect change because of the kernel's own
definitions of bool, false, and true conflicting with the C23 reserved
keywords.

  include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
     11 |         false   = 0,
        |         ^~~~~
  include/linux/stddef.h:11:9: note: 'false' is a keyword with '-std=c23' onwards
  include/linux/types.h:35:33: error: 'bool' cannot be defined via 'typedef'
     35 | typedef _Bool                   bool;
        |                                 ^~~~
  include/linux/types.h:35:33: note: 'bool' is a keyword with '-std=c23' onwards

Add '-std=gnu11' to the decompressor and purgatory CFLAGS to eliminate
these errors and make the C standard version of these areas match the
rest of the kernel.

Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250122-s390-fix-std-for-gcc-15-v1-1-8b00cadee083@kernel.org
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile           |    2 +-
 arch/s390/purgatory/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -22,7 +22,7 @@ KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FL
 ifndef CONFIG_AS_IS_LLVM
 KBUILD_AFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),$(aflags_dwarf))
 endif
-KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -mpacked-stack
+KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -mpacked-stack -std=gnu11
 KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -D__DECOMPRESSOR
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float -mbackchain
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -13,7 +13,7 @@ CFLAGS_sha256.o := -D__DISABLE_EXPORTS -
 $(obj)/mem.o: $(srctree)/arch/s390/lib/mem.S FORCE
 	$(call if_changed_rule,as_o_S)
 
-KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes
+KBUILD_CFLAGS := -std=gnu11 -fno-strict-aliasing -Wall -Wstrict-prototypes
 KBUILD_CFLAGS += -Wno-pointer-sign -Wno-sign-compare
 KBUILD_CFLAGS += -fno-zero-initialized-in-bss -fno-builtin -ffreestanding
 KBUILD_CFLAGS += -Os -m64 -msoft-float -fno-common


