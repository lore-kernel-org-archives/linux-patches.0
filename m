Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826F5352082;
	Tue, 26 Aug 2025 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216163; cv=none; b=FxvEO+aSiQUXbApC0z1Iiy3iGrqvSgmKSkBDjeDcm0j28R+OQAbMAzsLOYvi4WO4CsZqtzOsFcqkLVr/HZ6wZHzyzIn/ZBLL5Yvnp26j/kBUGPMyTCAHlAxLZY++dDEQbnPgbe1yHxaEd1HPgXATFtclWPaEaI0Nz1VhE02OnyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216163; c=relaxed/simple;
	bh=V5VfKzjLxQXnXxx8x0ViMNBUM4kB4MeMAmF3MMvoiHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UtjKWFsHxWPpSp3fg/AzJ/6G5a2+US12i6aeXHQOcW3/S5mvEe1XoWkwVCTk7f0RuVuBthy4SCFhdCTvRlPkb/qxVxIMJ+zE4nMCHji56KnNlH492srke0e6hAiBGR/7Yb8SFClGckwscwrW7uLHiDmKZp9Wor+0wOvfH/xkuAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeOqXHjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeOqXHjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9A2C113D0;
	Tue, 26 Aug 2025 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216163;
	bh=V5VfKzjLxQXnXxx8x0ViMNBUM4kB4MeMAmF3MMvoiHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeOqXHjwG42QlTgLA0IjGKek4DLrqXmbRCYy/vKNDYSH8kA2kwRT9KCv3hTjTqtGG
	 vxhmOVtFP0NlnKzjs4neRUcC8ZpHHFGdAG/5BWBosU/BIoYuc6AhKzyRlx+FiBwusd
	 OKRYJ5I01EP5u0DFApig3slmepp3Fw9Q/wE9Gsxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/644] tools/nolibc: define time_t in terms of __kernel_old_time_t
Date: Tue, 26 Aug 2025 13:06:40 +0200
Message-ID: <20250826110954.042071013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1747ae125392..a0ea830e1ba1 100644
--- a/tools/include/nolibc/std.h
+++ b/tools/include/nolibc/std.h
@@ -33,6 +33,8 @@ typedef unsigned long     uintptr_t;
 typedef   signed long      intptr_t;
 typedef   signed long     ptrdiff_t;
 
+#include <linux/types.h>
+
 /* those are commonly provided by sys/types.h */
 typedef unsigned int          dev_t;
 typedef unsigned long         ino_t;
@@ -44,6 +46,6 @@ typedef unsigned long       nlink_t;
 typedef   signed long         off_t;
 typedef   signed long     blksize_t;
 typedef   signed long      blkcnt_t;
-typedef   signed long        time_t;
+typedef __kernel_old_time_t  time_t;
 
 #endif /* _NOLIBC_STD_H */
-- 
2.39.5



