Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F6F144D11;
	Thu, 13 Jun 2024 12:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282327; cv=none; b=Pu4iTB6vhO25t86o+vBccCmI1N/7/793nIzDbgC9B7ZIs0qi/sHXznjlFCs54WXfjKaejy6ll0Md/6BbSiRvth9NbaThfmIpXMeF8LhEH7Powfli7dYeMsPS+w6QwjEhsLe7ggIGH1Oz6uHfUv5wFJnqRvYRf+i6aZUQe678stQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282327; c=relaxed/simple;
	bh=gVDqgk19bp3XRqIPS362bFyRSz9H6FR/+zcRkG9a0Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKFMh4fuNpOKX1aaEAoVfDIWnmVy+CouCEZVF3JOV9CpEGlGkmD9bLbwp4fL5USbXxJ5oFsbRAxGirEbpCTb518EwMhe23dricnddfD2WeiyT9KChz8W0xR4sE0i8NjlNmxnm7+ir5h6b3tb45oQCP/kTxQrncJ5tJZTDoF6bBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaacwcV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaacwcV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A65C4AF1A;
	Thu, 13 Jun 2024 12:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282327;
	bh=gVDqgk19bp3XRqIPS362bFyRSz9H6FR/+zcRkG9a0Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaacwcV6tJ5TGcyVnLfLp+uGbkRFL6aSobGdnKo2K14dc/30JaushDTC2GBskJaIG
	 0k6ZODZ+dRFhEcOlu1Vw8ODHJUxMRxEOVnSwJ9J0BUxueSTrfRZEG+5B3xtrFhI0sP
	 8YlorApkRqpMekHkxxnmOA3s5dp+DvOfgcxXNE8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/402] s390/vdso: filter out mno-pic-data-is-text-relative cflag
Date: Thu, 13 Jun 2024 13:33:16 +0200
Message-ID: <20240613113311.466491894@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit d15e4314abec83e4f910659437bc809b0889e3a5 ]

cmd_vdso_check checks if there are any dynamic relocations in
vdso64.so.dbg. When kernel is compiled with
-mno-pic-data-is-text-relative, R_390_RELATIVE relocs are generated and
this results in kernel build error.

kpatch uses -mno-pic-data-is-text-relative option when building the
kernel to prevent relative addressing between code and data. The flag
avoids relocation error when klp text and data are too far apart

kpatch does not patch vdso code and hence the
mno-pic-data-is-text-relative flag is not essential.

Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: 10f705253651 ("s390/vdso: Generate unwind information for C modules")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/Makefile | 1 +
 arch/s390/kernel/vdso64/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index cc513add48eb5..1783e4d335136 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -20,6 +20,7 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_32 += -m31 -s
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
 
 LDFLAGS_vdso32.so.dbg += -shared -soname=linux-vdso32.so.1 \
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 42d918d50a1ff..08e87b083647c 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -25,6 +25,7 @@ KBUILD_AFLAGS_64 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin
 ldflags-y := -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
-- 
2.43.0



