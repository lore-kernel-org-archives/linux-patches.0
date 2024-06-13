Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33C21F937;
	Thu, 13 Jun 2024 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282333; cv=none; b=imLFAOZNTsmGPocrQlJaGpXrbk3YOh7Sh7y+thBsugyvawdOmHOsIZo7KOVshpboPqaVO7WCSNRd6byLDI3vFzOyquQ1jT3XTsRf6YBuIWPKdU67FTVJshM5IGJ9MJk6m+q9Q1DcMyL+O/qDgx1sjawSq6PlA6XygC/pCMKQ31Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282333; c=relaxed/simple;
	bh=nv/3M6LjsHNltjV/Xa7mc7eKcYMWIv7RJFj8hWE4xAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ari1BaP6pZCyKL5H2OrjvM7XYXt6/m2kCJPFTf52juTxvLTaVfXse0KbxjZWJiOYb7/S9NSmr0mQHFfubmsIASHvR9fxzXQgn31SQFFKXleGKE1u828Wir40FQUouj+qQqsOUU7Ugsp/3aM41/ruCrbsNu0lE+RwdBpeeR4UOp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtSuIzfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtSuIzfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26807C32786;
	Thu, 13 Jun 2024 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282333;
	bh=nv/3M6LjsHNltjV/Xa7mc7eKcYMWIv7RJFj8hWE4xAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtSuIzfOnc6vrInq+28efZFKkZygIHjZBDsnEHruej6DxBjREIPdp/pgQIZRgQ6BM
	 HVgx7C5HqmZQNMBwHWkwr9cvVYrEIPyWsQMrsY92mYZGlKWeOa/WT59uG+TO1iutVK
	 AyiT6iBcyRugy8HRX4zOZYI4r+4ens0NBngCU+8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/402] s390/vdso: Generate unwind information for C modules
Date: Thu, 13 Jun 2024 13:33:18 +0200
Message-ID: <20240613113311.547466994@linuxfoundation.org>
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
index 1783e4d335136..66f7b0c8e6117 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -21,7 +21,8 @@ KBUILD_AFLAGS_32 += -m31 -s
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
+KBUILD_CFLAGS_32 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin -fasynchronous-unwind-tables
 
 LDFLAGS_vdso32.so.dbg += -shared -soname=linux-vdso32.so.1 \
 	--hash-style=both --build-id=sha1 -melf_s390 -T
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index e2e031e4d9243..e520c548d303e 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -27,7 +27,8 @@ KBUILD_AFLAGS_64 += -m64 -s
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



