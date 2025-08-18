Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920951DC997;
	Mon, 18 Aug 2025 13:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523337; cv=none; b=IhOTEiBpoTti8Pm48rxiLJjoPW0m8NoJZDO2uez+mcKgRe21y+BwLqgme5MNov6/obIJQrdIzdPrLJsS+NORAWBZ6RzU2RK0xjRrmmx7b+H/XbIVKJ634aGaa067qsZF3oAQIiSFw4bTbWg5/mpxWneJFRhDKcC1uFUPNPgii/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523337; c=relaxed/simple;
	bh=wVTpvkLeqfTNSnV8y6OOaWUSYXj5hCjUyEOqYRQgg6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOHgTUnXuRELhLsoyqLyoTjaT94bhyHr+F22VWKOxB7TQqyp/08JpP+GSGZXQ5uqQyxOSkjmc3y35R1Q+yyisbm2B3JfTEX2uNW8yEhVlxrKegTz2WICjBXPYImE0F/wTgiTTIhpUl7vjCtw78TBNx9tGss8e3Rk5s5rr1E+Mvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRXEnwzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRXEnwzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEF2C4CEF1;
	Mon, 18 Aug 2025 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523337;
	bh=wVTpvkLeqfTNSnV8y6OOaWUSYXj5hCjUyEOqYRQgg6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRXEnwzwgR504V9fPC9TzIIWuoyqHepyGzSrZRP0n7SZeOqCLRaUJ7H5w0KOQFE5f
	 wsNPx15G9CYfyp+KnGT4X3HyGpsRHxLWC58vH5hiU9rB/l1A9JkB265j3W5AE+LljH
	 snA6j+yJSHE1tF5O6TH/hV3HqvYQ0o82OGMyo91g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 140/515] tools/nolibc: define time_t in terms of __kernel_old_time_t
Date: Mon, 18 Aug 2025 14:42:06 +0200
Message-ID: <20250818124503.780569027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 tools/include/nolibc/std.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/std.h b/tools/include/nolibc/std.h
index 933bc0be7e1c..a9d8b5b51f37 100644
--- a/tools/include/nolibc/std.h
+++ b/tools/include/nolibc/std.h
@@ -20,6 +20,8 @@
 
 #include "stdint.h"
 
+#include <linux/types.h>
+
 /* those are commonly provided by sys/types.h */
 typedef unsigned int          dev_t;
 typedef unsigned long         ino_t;
@@ -31,6 +33,6 @@ typedef unsigned long       nlink_t;
 typedef   signed long         off_t;
 typedef   signed long     blksize_t;
 typedef   signed long      blkcnt_t;
-typedef   signed long        time_t;
+typedef __kernel_old_time_t  time_t;
 
 #endif /* _NOLIBC_STD_H */
-- 
2.39.5



