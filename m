Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0D91A0B06;
	Thu,  6 Jun 2024 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683659; cv=none; b=iHsXrs+sS/JynKbno7qur9DcQwR4wFml8vaqkKJ0/n5OhUEZSNu0xCVB3pV45zdVdpHibflJSW5PehRb2szTJs+Vlj/jWOXeX0za8EryMpZJm5DTZPhWbPYJrehE4+v8Mss4OdVueI8Rfz8Z/FOYgxNC2To43V3rDil0xhOwBqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683659; c=relaxed/simple;
	bh=9votOwkAVc/1V1bb8EcXD8jwJ63Urs/IfScIvC3V8NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVxAMGqqEQPxsv7805OKRpqRXUYd4IJoaN87eoX1mNA5mp9DEMuPsCUHBH8KmxTnQ65Q2JdGbh70DY7eLdVTBLCxK21xn4FtWrWGGwpnMn9uDMvUDHlORHec1DeiMu0o3b5b9j3rg5whIYdUOYQxTLi9T8Ui1DqCAz8BCqXbHrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERqzS2ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERqzS2ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD58C2BD10;
	Thu,  6 Jun 2024 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683659;
	bh=9votOwkAVc/1V1bb8EcXD8jwJ63Urs/IfScIvC3V8NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERqzS2ey9dI9b4ctzrMOU54cAGuvrfY9TFBk9QIZR4ptkKIYBRogrhCs6x/+Yvwi6
	 UQJ85MVMjw6ceq1Vwoqbv13+XrSDpNczzXWyvGOYo+t+hs3kwrF7H1QdfKSSczdjPh
	 vVC9gX93uJ4J/a6MxYA3tyyy5wIaLQaMaK+HvH2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 538/744] s390/vdso: Use standard stack frame layout
Date: Thu,  6 Jun 2024 16:03:30 +0200
Message-ID: <20240606131749.714648694@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 185445c7c137822ad856aae91a41e199370cb534 ]

By default user space is compiled with standard stack frame layout and not
with the packed stack layout. The vdso code however inherited the
-mpacked-stack compiler option from the kernel. Remove this option to make
sure the vdso is compiled with standard stack frame layout.

This makes sure that the stack frame backchain location for vdso generated
stack frames is the same like for calling code (if compiled with default
options). This allows to manually walk stack frames without DWARF
information, like the kernel is doing it e.g. with arch_stack_walk_user().

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/Makefile | 1 +
 arch/s390/kernel/vdso64/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index 9090c0e5de254..4800d80decee6 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -19,6 +19,7 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_32 += -m31 -s
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mpacked-stack,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin -fasynchronous-unwind-tables
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index a44f51de1f1ea..2f2e4e997030c 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -24,6 +24,7 @@ KBUILD_AFLAGS_64 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_64 += -m64
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_64 := $(filter-out -mpacked-stack,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -munaligned-symbols,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_64))
-- 
2.43.0



