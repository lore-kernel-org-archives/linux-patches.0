Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAFF1990BE;
	Thu,  6 Jun 2024 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682962; cv=none; b=uOTIws1BjB9ON5/n0ux/TmWxrlpoE6tj84q1EM7GlbWeeAcj6354FALOL+HP9roJhd+GuBsqmrU4I3RCmes+bYegY7zTTBsfuq2yO3sFtzShn4uqmfBV+q0Uzemxxw41kwALBX/NuSM8KmGisFsqySeNH4hEOqQLm6rJK/+pCiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682962; c=relaxed/simple;
	bh=Eb89jDtLApkHrEbZh0rGByGsHX+4RI4HNpvpOp0s8vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itsXjV8ZdiDn34wEcSE4+X3M85e4Ip7nEmFQTC1nObCY1/3dYLvJhed18CsgQfyPqp/4LR4Dt6a88/tkqI5QDvIkNdE5tGoVJXVoMqAWkqmPmnXN8irzwsZJdFr+5wSMse5m1y8dG3ca/XfWeIgfYXoAiSuElTBmWuMfTdTb31Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiZjWgM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiZjWgM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D41C32782;
	Thu,  6 Jun 2024 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682961;
	bh=Eb89jDtLApkHrEbZh0rGByGsHX+4RI4HNpvpOp0s8vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiZjWgM5g3/4mvJZXtshp8uLXCqOSvEX1GeiuwxjUn2zwhUrRB9gCAShHf+tUZEVS
	 Ro2s8lkb94bykeJgdJstFruBu8E2IY7X44/Md2kVRS3evSALDT2UbfldTCC886EGDC
	 pWxmOTR7pJtTeyCZ8VYOmfyJWg/aHh9eDhRczrIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 129/374] s390/vdso: Use standard stack frame layout
Date: Thu,  6 Jun 2024 16:01:48 +0200
Message-ID: <20240606131656.224283396@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



