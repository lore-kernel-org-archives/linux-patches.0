Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578536404D;
	Sat, 12 Sep 2026 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200269; cv=none; b=PQkFFGuxwszPttMrvdtcNoFGCRV78JrqITtqhzamw83QV2uCzdEBKgoZop6FGXJ7Lmf3Gx8iKiAWFcwVJEuhh+F8MNXlvJGsW1hrVLp1WHaatlZi23uN/H4sKyHhKCW5OE68yGgTeS4uukhG7alIKdpX9MmiHGKKpG25vJKW9AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200269; c=relaxed/simple;
	bh=R9FiSLO1FiQfYJnbIRR1jlAKPDud65uaqIx3miByJa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOdRVxyPgD74rDzuJ2UHPqkvr+zaB4XsCDGKk4Dy5akn9IujUoBre5KugJD+8c0PhXiW21JRmBalajnYWGrgq9DZzUrwffPqcA54qB8SmEaCeNxGN7YKbDOy6cR0TzJOccWmcBh7Dt9RRJzKSviG7KD8mWHu8xvytx+QYq/U2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iE4YvnWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iE4YvnWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0A01F000FF;
	Sat, 12 Sep 2026 08:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200267;
	bh=0+44Sq7QMOOuWu8UJ8/JWAkGbiDUbNeiMw1X6G/lMg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iE4YvnWSHmlFmiBmX66+n+dk8ePPoc4tU+x7Jm1fevd/fzMLUTDEdPRvINJCtXQVR
	 DfYbdUQYSprrfs3ntIwuRFeDq9PkFKteaR5fXZ1jcYrV9kI23UxbdFqCiovIc0xeZr
	 lpW0uBbs8FOTvKFpFUdHwZJO2lppPQoN6yWHixP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Jens Remus <jremus@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0755/1815] s390/vdso: Pass --eh-frame-hdr to the linker
Date: Sat, 12 Sep 2026 08:41:45 +0200
Message-ID: <20260912065706.631666059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit dc161efb6df8518b3cfa7f0a5efdc16a1aee815b ]

Commit 2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link
vDSO") accidentally broke the GNU_EH_FRAME program table entry in
the vDSO, causing it to be empty:

  $ readelf --program-headers arch/s390/kernel/vdso/vdso.so
  ...
  Program Headers:
    Type           Offset             VirtAddr           PhysAddr
                   FileSiz            MemSiz              Flags  Align
  ...
    GNU_EH_FRAME   0x0000000000000000 0x0000000000000000 0x0000000000000000
                   0x0000000000000000 0x0000000000000000         0x8
  ...

Originally, the compiler would implicitly add --eh-frame-hdr when
invoking the linker, but when this Makefile was converted from invoking
the linker via the compiler, to invoking it directly, the option was
missed.

This is the s390 variant of x86 commit cd01544a268a ("x86/vdso: Pass
--eh-frame-hdr to the linker").

Fixes: 2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link vDSO")
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/vdso/Makefile b/arch/s390/kernel/vdso/Makefile
index fece5d975eaf8..35c834b895ecb 100644
--- a/arch/s390/kernel/vdso/Makefile
+++ b/arch/s390/kernel/vdso/Makefile
@@ -30,7 +30,8 @@ KBUILD_CFLAGS_VDSO := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLA
 KBUILD_CFLAGS_VDSO += -fPIC -fno-common -fno-builtin -fasynchronous-unwind-tables
 KBUILD_CFLAGS_VDSO += -fno-stack-protector $(DISABLE_KSTACK_ERASE)
 ldflags-y := -shared -soname=linux-vdso.so.1 \
-	     --hash-style=both --build-id=sha1 -T
+	     --hash-style=both --build-id=sha1 \
+	     $(call ld-option, --eh-frame-hdr) -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_VDSO)
 $(targets:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_VDSO)
-- 
2.53.0



