Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADC26FDBF;
	Tue, 26 Aug 2025 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214302; cv=none; b=Ab7SA8Aow7cZrViVIOv1Jup7ii1QQlKS9iUd8j0U6Qd3LbCkPLhROniNksaxbSpbF1TfaAcrDINCmeG5fm4q8Sx7ce6Qt5u5+zUAWC2i5VsDsZ0D88UzEVicBGN6TbjV2HGO2MNMVxmT44/SoCdYnDhgRTHocgJosUkckCX0XNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214302; c=relaxed/simple;
	bh=keb5UXWHXk7mHRAZ3l4uookjXPztH02KErlX8jR/wlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NjGH7gCaKGPNeHWoFrf9Ywa0Rc+X3E8YQbIl+8+ouFHwo3ruEZZemxYkYX8TZ7KO1KgJtTq/2wNwYBadQdYXrjXqXDwwyOVYnGxj1S7pTJrxqa48HMzA76GvBFoiNNlfIsLQcwi8lQx5E463X8OTBoKpSuX+h4nmEcQprjH94Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtxN8g2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtxN8g2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AEDC4CEF1;
	Tue, 26 Aug 2025 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214302;
	bh=keb5UXWHXk7mHRAZ3l4uookjXPztH02KErlX8jR/wlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtxN8g2JL+6+cmrdbQLLanz8f4uKBmqqKwoutKqxzeOHc19NOIYi/Gxg0WvL89Bxd
	 N68d31R0nr7dLppjC8Q40CAeKX4lERwIpbLPNcVQo11HDWC3I5yI1c65xiBWepZ20Y
	 EGgg5deHIdpGjxnuT5Sd4//ChqPeuPl0FQao8EHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/482] tools/nolibc: define time_t in terms of __kernel_old_time_t
Date: Tue, 26 Aug 2025 13:05:33 +0200
Message-ID: <20250826110932.808692690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



