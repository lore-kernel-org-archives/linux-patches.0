Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020EA198E79;
	Thu,  6 Jun 2024 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683468; cv=none; b=RgqFimZACllzyydU7wrQLUCPyazRCb4oQROG/xw2kIPWrAiC7PTiJCeN0M3dCrBek7BH7QQmB37Fw2nRFXZL6e4bPojJxT7o4ZWW8q7NW8aIQNtH/+Piu2wvwhELvmr+z/6wJnARo5u6bCkcHZtYv/b2sMxiDhP/Qu6tTWcTTMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683468; c=relaxed/simple;
	bh=Jt6nlVRIf6KtO2M0w5MjdEGJvRhmi1wV1rn/Gr1fcnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZkfKz2Mdtu1bsv2gqhNT3/A04x716BetH3KOs0r3bIrsW3ZnNR231fLdO3H6saxaym/SDTZEdevdzz2aVxmua3TG9157Bu+0ZSw+t6Ahw3N52LaIIQaU+mDd5gRKwzQta/hhmdX9H0P4yazWC4USRKWUIfSxuV92aRL2aAzUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFZC+sT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFZC+sT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EF1C32781;
	Thu,  6 Jun 2024 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683467;
	bh=Jt6nlVRIf6KtO2M0w5MjdEGJvRhmi1wV1rn/Gr1fcnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFZC+sT3gMOiP2V9u7WP/dTZhZWrhEu7rBZaoCiR2s1/fB06TfTIdEV4vr6u5eUt+
	 GCKZEM6Fr+xZ1uiMuKrlmVJneznxhu2i3Jq56iYOllnt/+H4ZJSlg/0DJOHMjPaLs3
	 EqS02QX0N0ZXwstcST0YDibdmMCqm6lzvDOvbHEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 354/473] s390/vdso: Use standard stack frame layout
Date: Thu,  6 Jun 2024 16:04:43 +0200
Message-ID: <20240606131711.612836142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bf30997657ac8..2e1591d97a428 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -20,6 +20,7 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_32 += -m31 -s
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mpacked-stack,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin -fasynchronous-unwind-tables
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index f8643d50ba6a6..b260c0bc90125 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -25,6 +25,7 @@ KBUILD_AFLAGS_64 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_64 := $(filter-out -mpacked-stack,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -munaligned-symbols,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_64))
-- 
2.43.0



