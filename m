Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E08B1FF1C4;
	Tue, 26 Aug 2025 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212783; cv=none; b=ZaPzJxiDQ2bNvA4KagQUQJdepBIVx+lErbnSf94/4cvqwb/2K89Ni0/Riryt+BpiniYmeqnnBVtnnfkmngWfC3nJwJWK0mHyj/a8uc1evsmqTXN6GqWyFO7BvYhmbOfTI/DQzmLa9Yd7Xm1KtH5M6DFkd2gU0ngHKwzkfMN1AT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212783; c=relaxed/simple;
	bh=jc24UHJUWxcZnnHCpAmjIR7gZgUwXg5xWJV8X7FiVsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTZouhQMFz8OOMTIMqncswC1pi+IhvkeLkQgdHDcImL5blddR+A5jeaf+NKsB4bpze+qKGMRklv76pSTKNYJ/qLzJVT3jpQ5QDH+PeimDxVHp6TmyZvIIjQneDHtG0YspKkm8jfNjIPARFu1U/kNFei5Xo3kMYHmLEnFyhTtrzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNyCRhDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNyCRhDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75864C113CF;
	Tue, 26 Aug 2025 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212782;
	bh=jc24UHJUWxcZnnHCpAmjIR7gZgUwXg5xWJV8X7FiVsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNyCRhDAa334+cqezW9UO/7SDscUCAjgpgfZNPu4uI0P+PON3fNcD9jy2CC0Oa6W6
	 kbjN/+2Qq97DFHZB2VbC4OOoN4+6dEH8M32Ppiloxu6DN4Q+fA/FGIydPsgXbqX9yy
	 zwGrpObtBwP/CV9m/WCxhypDSTmPQAWdUza2Aasw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/587] tools/nolibc: define time_t in terms of __kernel_old_time_t
Date: Tue, 26 Aug 2025 13:04:10 +0200
Message-ID: <20250826110955.511066167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



