Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883911547F3;
	Mon, 14 Oct 2024 14:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915855; cv=none; b=CvU1Uk2Uig+VbZboHazqY1Cua6O+0tvku6Z64i2ueBNila/VN6COB+WHUETbf4vo8/X8uL9T2vd+4R5uMwqSvJIEUPx1x0mo+6SVS7lS0awoWFgXYPN9546OVi9w780WdaenHcjjmR0H9peWwDeatUkkcdE3m1yTSIjJRAVbKn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915855; c=relaxed/simple;
	bh=RrfvP8/kYQIpavjDSEcu1i0oCOE2ZKCQH9Me2KdZLj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONt4oDeeMqNDfRO/0Phe8zK8QuVxmTKtulhFkS7iKusfBRWrLzZ9B7jDwO4eksC+644g/Eg4bXFDbOD1r3EmazJOzeqNsPkzKlbrEAW+wXKyAyXMtgyq1NCK+tCBD0A03JeByyjo+ILcBX1sDtOHQrutqe2OPjRKDiGXzF/reio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0m8AlqsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0m8AlqsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38BFC4CEC3;
	Mon, 14 Oct 2024 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915855;
	bh=RrfvP8/kYQIpavjDSEcu1i0oCOE2ZKCQH9Me2KdZLj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0m8AlqsQDWiuaqggj9aM1p8nOM/qI9SGWSk06BscTzS3yOa3cnalD7+SA1Pt87l5W
	 sdS/EqTa4eydfoc/wH7LQP0U6Gje8da9SVXA7ESP27rs1AxEyUb9lueLM9mMyP7Rah
	 K7idswvBIsqCy6IZkjScUAEn6wcSahxPSlwxwJpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 019/214] s390/boot: Compile all files with the same march flag
Date: Mon, 14 Oct 2024 16:18:02 +0200
Message-ID: <20241014141045.743575611@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit fccb175bc89a0d37e3ff513bb6bf1f73b3a48950 ]

Only a couple of files of the decompressor are compiled with the
minimum architecture level. This is problematic for potential function
calls between compile units, especially if a target function is within
a compile until compiled for a higher architecture level, since that
may lead to an unexpected operation exception.

Therefore compile all files of the decompressor for the same (minimum)
architecture level.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/Makefile | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 4f476884d3404..f1b2989cc7cca 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -11,11 +11,8 @@ KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
 KMSAN_SANITIZE := n
 
-KBUILD_AFLAGS := $(KBUILD_AFLAGS_DECOMPRESSOR)
-KBUILD_CFLAGS := $(KBUILD_CFLAGS_DECOMPRESSOR)
-
 #
-# Use minimum architecture for als.c to be able to print an error
+# Use minimum architecture level so it is possible to print an error
 # message if the kernel is started on a machine which is too old
 #
 ifndef CONFIG_CC_IS_CLANG
@@ -24,16 +21,10 @@ else
 CC_FLAGS_MARCH_MINIMUM := -march=z10
 endif
 
-ifneq ($(CC_FLAGS_MARCH),$(CC_FLAGS_MARCH_MINIMUM))
-AFLAGS_REMOVE_head.o		+= $(CC_FLAGS_MARCH)
-AFLAGS_head.o			+= $(CC_FLAGS_MARCH_MINIMUM)
-AFLAGS_REMOVE_mem.o		+= $(CC_FLAGS_MARCH)
-AFLAGS_mem.o			+= $(CC_FLAGS_MARCH_MINIMUM)
-CFLAGS_REMOVE_als.o		+= $(CC_FLAGS_MARCH)
-CFLAGS_als.o			+= $(CC_FLAGS_MARCH_MINIMUM)
-CFLAGS_REMOVE_sclp_early_core.o	+= $(CC_FLAGS_MARCH)
-CFLAGS_sclp_early_core.o	+= $(CC_FLAGS_MARCH_MINIMUM)
-endif
+KBUILD_AFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_AFLAGS_DECOMPRESSOR))
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_CFLAGS_DECOMPRESSOR))
+KBUILD_AFLAGS += $(CC_FLAGS_MARCH_MINIMUM)
+KBUILD_CFLAGS += $(CC_FLAGS_MARCH_MINIMUM)
 
 CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
 
-- 
2.43.0



