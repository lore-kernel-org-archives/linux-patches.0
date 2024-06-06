Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C2819750E;
	Thu,  6 Jun 2024 14:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682961; cv=none; b=f21m6WjXtJmU2ZIXMIztclIPzI4lfgLvwyp7Jkb2PPDp8jIoytoW6pvZlv/8wCGzyG+tLI/duGNDbIU6wDFZDi+YhvgdqiSeqdMrkss5QyZa6Yrg3QeB90h97LcrlS2MjdFgfoKP23fyzV+gpFjtVJPmmSDrRnerftRdDaN1Fvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682961; c=relaxed/simple;
	bh=vXD4GgbOIo10lSpjmIptZ+b/CvKKYqKFO2YvDYCCNLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHQvXWcb0v6zroS6q3almH090y0LuhPaZvPZ0F5J2a22LYdoJZHq8gEEZiP1EQmXxR5rvDuxSlsVrdImf9o4LMm8lu9s1lLT1H68B4JM9vgPJ9hlAhsFX4j+mTdX4U4gtICBv3NiOjEE4ATz/Rar3t9p1e8uNMeVYSGBm3LiPV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW5GDrFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW5GDrFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BB5C32781;
	Thu,  6 Jun 2024 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682960;
	bh=vXD4GgbOIo10lSpjmIptZ+b/CvKKYqKFO2YvDYCCNLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW5GDrFqIZOifhMTo1U7Bi44bn8JdRQ5mxeTj3gfqEcBTW6WfkknOwp3Ff3PeEwqv
	 bqL5H3l2mGBNOAR/zyh9XmprdejJpm14pSbuJTNMNVVyshUPVa9XD4th0IXHtnasTk
	 X17f7oOdJvG5GLdR5W4Tvy7QRQxoZcw9gV1U7mC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 127/374] s390/vdso: Generate unwind information for C modules
Date: Thu,  6 Jun 2024 16:01:46 +0200
Message-ID: <20240606131656.153113519@linuxfoundation.org>
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

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit 10f70525365146046dddcc3d36bfaea2aee0376a ]

GDB fails to unwind vDSO functions with error message "PC not saved",
for instance when stepping through gettimeofday().

Add -fasynchronous-unwind-tables to CFLAGS to generate .eh_frame
DWARF unwind information for the vDSO C modules.

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/Makefile | 3 ++-
 arch/s390/kernel/vdso64/Makefile | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index b12a274cbb473..9090c0e5de254 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -20,7 +20,8 @@ KBUILD_AFLAGS_32 += -m31 -s
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
+KBUILD_CFLAGS_32 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin -fasynchronous-unwind-tables
 
 LDFLAGS_vdso32.so.dbg += -shared -soname=linux-vdso32.so.1 \
 	--hash-style=both --build-id=sha1 -melf_s390 -T
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index ef98327260972..a44f51de1f1ea 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -26,7 +26,8 @@ KBUILD_AFLAGS_64 += -m64
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -munaligned-symbols,$(KBUILD_CFLAGS_64))
-KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin
+KBUILD_CFLAGS_64 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_64))
+KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin -fasynchronous-unwind-tables
 ldflags-y := -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
 
-- 
2.43.0



