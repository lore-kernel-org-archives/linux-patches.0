Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD80299920;
	Sat, 12 Sep 2026 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208605; cv=none; b=V+oWpb1q6vyJsBjFEI5hoqjpkPQeru48kpm+mjTCdNcKRGME2Kmt0F2JgtyEDKT1lxssLjJWYlvggmG8mYENAvjk/fdRrb/8Lyf8Tp2NpAhVdbA5SpaMFPJnv9UD0kD4t6wFIjajbXcX0C+lTXSx3foVpJV7X2zE/NRZv7IDWqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208605; c=relaxed/simple;
	bh=pneWWb4NJUJARJ3gIRIDwUOjwLevtsjRuaw60JovbtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7UkOyfNNoTyMJWWZ1JSWtYwXTYJXelmnBAy7JabDS4bE9SBlTV8f4tVZHBIy5JY87ZDONIWd3DLP5l24nHxJvwDWk9k4F0VoPcXzxUfOTm39RIzY3Xmy5pVlafgOZ96nNhqVRCXNw2q3HbdT7T9O9Jhh5uUQPhQT42wKtW2qOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx034GM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx034GM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96C61F000FF;
	Sat, 12 Sep 2026 10:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208603;
	bh=e3rUONltdLolioCNHeHuyy3fBsxDgQhhrUORtqPyCX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hx034GM45sZa60Enl3ahZFJVwg/6hTmheeWfm2Hp2wUVx4i6MTIrJw+2preTRfQJI
	 NNeIBjn4euHEyj2FXEtdMV3xivTviKtHDagPYF96PI/dfPb2Va6a+IaEC5MU+gt8hj
	 uMsd88HMEfe3PqHk5VYdyNIKgmvLKqzjpKcDLFic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Jens Remus <jremus@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0644/1518] s390/vdso: Pass --eh-frame-hdr to the linker
Date: Sat, 12 Sep 2026 08:46:53 +0200
Message-ID: <20260912065637.997485493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 924be0a6a2df3..548ed3baf5a8a 100644
--- a/arch/s390/kernel/vdso/Makefile
+++ b/arch/s390/kernel/vdso/Makefile
@@ -34,7 +34,8 @@ KBUILD_CFLAGS_VDSO := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLA
 KBUILD_CFLAGS_VDSO += -m64 -fPIC -fno-common -fno-builtin -fasynchronous-unwind-tables
 KBUILD_CFLAGS_VDSO += -fno-stack-protector
 ldflags-y := -shared -soname=linux-vdso.so.1 \
-	     --hash-style=both --build-id=sha1 -T
+	     --hash-style=both --build-id=sha1 \
+	     $(call ld-option, --eh-frame-hdr) -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_VDSO)
 $(targets:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_VDSO)
-- 
2.53.0



