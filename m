Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8325194C96;
	Mon,  4 Aug 2025 00:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267110; cv=none; b=AJPVUf9oWp08H2Vbuz7J9G3276uO536TqNZNIScbp0xsH//u1tHSkXgpIGtSf05dJcCj96O65GT72cokB6eBptVrYblRgFR8EpCocFudHC1VSu59SeretLbr/bZ2pZHHpQS9/MyvafA1G4aYEzVCORbvsUYOGfM51Saluvs+qMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267110; c=relaxed/simple;
	bh=WxIextwFDYhl19EYzWRWuxAs5JX6CHOrK+Hx5CYcQpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QuYRwbe388FLRypkSq319fbSFnetnLXntgzwT131YNspmBgrEZFQdF/+m7iQaLXwxE/IFT+TiWCSQUXvgHCVqc5yx8Nujz2sshaLCPwpxSymSiAQG1HLAUDout4YgLdGk+H2xNnYTW6yB8+s97x+uscDhMkOw0E/VdM3Vnp7Xqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUNnmbyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUNnmbyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A088FC4CEEB;
	Mon,  4 Aug 2025 00:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267110;
	bh=WxIextwFDYhl19EYzWRWuxAs5JX6CHOrK+Hx5CYcQpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUNnmbyboBDW8FtxdbUO63KCYLgBGpa5q9YopuNh4AHK2uUmLRWk7vszGFQW100Vi
	 ZQWyf3Dr1nnfpE1jvjGGY6t91psKqzDr40/yLfEF3gzPgQtQbbJgUdcKnkWkLB2def
	 pBrWCHXdIsQ8/KaeCccTyKz6Lv7SBl+kIYmvy+r1ZZgY1fU8QrZbCsoTwAvs7HlhAV
	 tMdhm340/GrV6wJ2AOcr+sct+ZhyIwfT25DMzDTKLqfoICwbpJxpOoHCJvWv3tXe1F
	 /8vkxEr7ESKxDYNhqMPWxt2Gf4sLkPbud3wlw86s1gIEHdI48e04LjLACtlfhACuIN
	 vN93RtxhmHNPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16 31/85] tools/nolibc: define time_t in terms of __kernel_old_time_t
Date: Sun,  3 Aug 2025 20:22:40 -0400
Message-Id: <20250804002335.3613254-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d5094bcb5bfdfea2cf0de8aaf77cc65db56cbdb5 ]

Nolibc assumes that the kernel ABI is using a time values that are as
large as a long integer. For most ABIs this holds true.
But for x32 this is not correct, as it uses 32bit longs but 64bit times.

Also the 'struct stat' implementation of nolibc relies on timespec::tv_sec
and time_t being the same type. While timespec::tv_sec comes from the
kernel and is of type __kernel_old_time_t, time_t is defined within nolibc.

Switch to the __kernel_old_time_t to always get the correct type.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20250712-nolibc-x32-v1-1-6d81cb798710@weissschuh.net
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This fixes a real ABI compatibility bug where nolibc
   incorrectly assumes `time_t` is always the same size as `long`. On
   x32 architecture (x86-64 with 32-bit pointers), `long` is 32-bit but
   kernel time values are 64-bit, causing type mismatches.

2. **Clear Impact**: The commit message clearly explains the issue - the
   `struct stat` implementation in nolibc relies on `timespec::tv_sec`
   and `time_t` being the same type. Looking at the code:
   - In `/include/uapi/linux/time.h:12`, `struct timespec` uses
     `__kernel_old_time_t tv_sec`
   - In the original nolibc code at `tools/include/nolibc/std.h:30`,
     `time_t` was defined as `signed long`
   - In `tools/include/nolibc/types.h:183-185`, the stat structure uses
     unions that expect `time_t` and `struct timespec` members to be
     compatible

3. **Small and Contained Fix**: The change is minimal - just changing
   one typedef from `signed long` to `__kernel_old_time_t` and adding
   the necessary include. This is exactly the kind of focused fix
   suitable for stable.

4. **No Feature Changes**: This doesn't add new functionality or change
   the API - it just corrects the type definition to match what the
   kernel actually uses.

5. **Low Risk**: The change uses the kernel's own type definition
   (`__kernel_old_time_t`) which is already defined as `__kernel_long_t`
   in the generic case, so for most architectures this is a no-op. It
   only changes behavior on architectures like x32 where it's actually
   needed.

6. **Prevents Runtime Failures**: Without this fix, nolibc programs on
   x32 would have incorrect stat structures where time fields don't
   align properly with kernel expectations, potentially causing data
   corruption or incorrect time values.

The commit follows stable kernel rules by fixing an important bug with
minimal changes and low regression risk. It's a clear correctness fix
for a specific architecture compatibility issue.

 tools/include/nolibc/std.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/std.h b/tools/include/nolibc/std.h
index adda7333d12e..ba950f0e7338 100644
--- a/tools/include/nolibc/std.h
+++ b/tools/include/nolibc/std.h
@@ -16,6 +16,8 @@
 #include "stdint.h"
 #include "stddef.h"
 
+#include <linux/types.h>
+
 /* those are commonly provided by sys/types.h */
 typedef unsigned int          dev_t;
 typedef unsigned long         ino_t;
@@ -27,6 +29,6 @@ typedef unsigned long       nlink_t;
 typedef   signed long         off_t;
 typedef   signed long     blksize_t;
 typedef   signed long      blkcnt_t;
-typedef   signed long        time_t;
+typedef __kernel_old_time_t  time_t;
 
 #endif /* _NOLIBC_STD_H */
-- 
2.39.5

