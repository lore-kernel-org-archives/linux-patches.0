Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126C01D3653;
	Tue,  8 Oct 2024 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393473; cv=none; b=GXXZCBGawJAcwyw8hB1xmzZroO4GD4xt2yeZ4wHyUhvVtjKQVFZDV/R3Np/xP1vUosYoAbDF3GIaMxl5Us2UPwEPiEp5vdR0cjrGxV3skIrK6Gez9ZQHDMLhYH3CTAhnle8QGE2U1yNxC8gwk5AaE75R8hcMLOGfmJLmFY5LJto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393473; c=relaxed/simple;
	bh=/tEuvF1HGIItV/HilD64+hYYpvZow1PBniRnhwjQ6OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPXtO3U24vH2a7ukZt2T3OuPXYOhlnIxsAYxCEeIKMrVHkEsBL61Oi6lHheYrSoBeoy8/D/WRZU/kfBZc9S9rbZH4U2Vh9BLoE8BkEHi4KqcPOHRrVVb/+XJl+YZwHp4bdvLQVqSlCyYoxfkXqJ6AluJU0p7+tduRwc6C4N1jZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdiO3rlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdiO3rlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72219C4CEC7;
	Tue,  8 Oct 2024 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393472;
	bh=/tEuvF1HGIItV/HilD64+hYYpvZow1PBniRnhwjQ6OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdiO3rlc7DRNdDt/uPnVQNTT/p7a8EZfWd+zLmwQTilzuBBIRwUnRQNUFWBrUo48q
	 fx/ntvOGo1JXoEylSt9eEdFNw40O5w6UwI7HG+mlTNv74uCuvqOUjd+recev1bvS8O
	 gSSh/BcZXwG9eAkeiFwC/rCmYS6yvqz8MI3QPbdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/386] selftests/nolibc: avoid passing NULL to printf("%s")
Date: Tue,  8 Oct 2024 14:06:06 +0200
Message-ID: <20241008115634.199213100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit f1a58f61d88642ae1e6e97e9d72d73bc70a93cb8 ]

Clang on higher optimization levels detects that NULL is passed to
printf("%s") and warns about it.
While printf() from nolibc gracefully handles that NULL,
it is undefined behavior as per POSIX, so the warning is reasonable.
Avoid the warning by transforming NULL into a non-NULL placeholder.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20240807-nolibc-llvm-v2-8-c20f2f5fc7c2@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 1fc4998f06bf6..4aaafbfc2f973 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -522,7 +522,7 @@ int expect_strzr(const char *expr, int llen)
 {
 	int ret = 0;
 
-	llen += printf(" = <%s> ", expr);
+	llen += printf(" = <%s> ", expr ? expr : "(null)");
 	if (expr) {
 		ret = 1;
 		result(llen, FAIL);
@@ -541,7 +541,7 @@ int expect_strnz(const char *expr, int llen)
 {
 	int ret = 0;
 
-	llen += printf(" = <%s> ", expr);
+	llen += printf(" = <%s> ", expr ? expr : "(null)");
 	if (!expr) {
 		ret = 1;
 		result(llen, FAIL);
-- 
2.43.0



