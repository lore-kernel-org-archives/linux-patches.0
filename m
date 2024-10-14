Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70620EB;
	Mon, 14 Oct 2024 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916764; cv=none; b=SwCs5GiL4J8Vm+EU7IiDXJwGj5kaM7JxpdPkNnABVhi1LvKBFmSk9tet0i8lauZ+7WESk64gyMKSt+5aNT/+HBvKzkb27HAmsqJC5yIVXwASY4vNkUJSaQFwbjeLqQ4cr2Q0+DIuIimz4HcbdD0brtOAblpNVXD5/Cg3fNDJNjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916764; c=relaxed/simple;
	bh=29U+ZR+TBn7jO35UaX8jYTTxvqI7s44YIlvGeaMmoFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcsTGUrmxcT/QBkQPvxb2pubkVYc6FpSwdMp7Y3D/RtU8IooWKlWN6aiyMV9cYhrU82/TDs2JBetLwqLa4mNUQZD5lrIWcaOemyxbxFuz1848fZNMzJDv7IfsPbBXAopA3+9Nda8EwN4lW1rTchAuf0IuNQ8tV2MyeWAqpH1VPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIv2dwDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIv2dwDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BCBC4CECF;
	Mon, 14 Oct 2024 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916764;
	bh=29U+ZR+TBn7jO35UaX8jYTTxvqI7s44YIlvGeaMmoFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIv2dwDHyTMlGL9I9UNrJKHG/gtXizVu+T8MaQUCqoZy1N171FS/XGYSiQiLTULXc
	 3u9fpyLZlZdbThx3Yye6a/ygHtGM2LKFw3+dNBQ3RL0o8+hwWawFEk7FFn54yub3T3
	 mbTh3VvMyNtI0XVAFTclwd7+GBislhSR+WJDzj1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/213] s390/boot: Compile all files with the same march flag
Date: Mon, 14 Oct 2024 16:19:24 +0200
Message-ID: <20241014141045.255622720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
index c7c81e5f92189..e4def3a6c6cca 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -9,11 +9,8 @@ UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
 
-KBUILD_AFLAGS := $(KBUILD_AFLAGS_DECOMPRESSOR)
-KBUILD_CFLAGS := $(KBUILD_CFLAGS_DECOMPRESSOR)
-
 #
-# Use minimum architecture for als.c to be able to print an error
+# Use minimum architecture level so it is possible to print an error
 # message if the kernel is started on a machine which is too old
 #
 ifndef CONFIG_CC_IS_CLANG
@@ -22,16 +19,10 @@ else
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



