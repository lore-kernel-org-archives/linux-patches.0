Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124C42FF16C;
	Tue, 12 Aug 2025 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023476; cv=none; b=Hts9f1uks6w/133lyNNHVUcNMsWr8VUiUd5DRAnB2/9aa1XpjPng6oBsomwSY9APq367dJS3PT9dp06bLHFH5bEXGtM1WDijjvjBv4oENJTX1GSvaoel+MbHG0btKMBEpiZHNdxJub22R9GFUvNOBrU4FXyAl5XSJrjBzxw8XGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023476; c=relaxed/simple;
	bh=xj7/OgE7M/zq6WpgECKoGCx8B5ULSbt45H/4BHtF/6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZOCknzUZ7VtoQ/RyEiZ0gy5QuUMdKVDb4KMSFQE3kxWEaDB+ozvtGssB55o0l9xMA2GsjEuPJbsp3ubZ2Kr4sW78iExl3ziNHL/r4aUvIyTqp1j7XEOUECBB557d47FHIgLlTgiF0WEBqEWEuvkXgXl/hABgMQY7RpqdjFQmik4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSvVkduR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSvVkduR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3978BC4CEF7;
	Tue, 12 Aug 2025 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023473;
	bh=xj7/OgE7M/zq6WpgECKoGCx8B5ULSbt45H/4BHtF/6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSvVkduRCN2G0DAyIrnJcrBChKTnCCLA1waEfhW6gaqWzQ4OWc7QVtTgHC+EhN58F
	 Y+5BaIV6WhHGChZmtc/I13PBSCEEcAjZKXzQYw5+pw9BIx3e8ruHUjknPxxoGJxqpJ
	 uYM5pr/SnC3lU2oEg6Xw03V5Fhn9GRIq4xNurOx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 089/627] selftests/nolibc: correctly report errors from printf() and friends
Date: Tue, 12 Aug 2025 19:26:24 +0200
Message-ID: <20250812173422.688655214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 4a40129087a4c32135bb1177a57bbbe6ee646f1a ]

When an error is encountered by printf() it needs to be reported.
errno() is already set by the callback.

sprintf() is different, but that keeps working and is already tested.

Also add a new test.

Fixes: 7e4346f4a3a6 ("tools/nolibc/stdio: add a minimal [vf]printf() implementation")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250704-nolibc-printf-error-v1-2-74b7a092433b@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdio.h                 |  4 ++--
 tools/testing/selftests/nolibc/nolibc-test.c | 23 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/stdio.h b/tools/include/nolibc/stdio.h
index c470d334ef3f..7630234408c5 100644
--- a/tools/include/nolibc/stdio.h
+++ b/tools/include/nolibc/stdio.h
@@ -358,11 +358,11 @@ int __nolibc_printf(__nolibc_printf_cb cb, intptr_t state, size_t n, const char
 				n -= w;
 				while (width-- > w) {
 					if (cb(state, " ", 1) != 0)
-						break;
+						return -1;
 					written += 1;
 				}
 				if (cb(state, outstr, w) != 0)
-					break;
+					return -1;
 			}
 
 			written += len;
diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index dbe13000fb1a..b5c04c137249 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -1646,6 +1646,28 @@ int test_strerror(void)
 	return 0;
 }
 
+static int test_printf_error(void)
+{
+	int fd, ret, saved_errno;
+
+	fd = open("/dev/full", O_RDWR);
+	if (fd == -1)
+		return 1;
+
+	errno = 0;
+	ret = dprintf(fd, "foo");
+	saved_errno = errno;
+	close(fd);
+
+	if (ret != -1)
+		return 2;
+
+	if (saved_errno != ENOSPC)
+		return 3;
+
+	return 0;
+}
+
 static int run_printf(int min, int max)
 {
 	int test;
@@ -1675,6 +1697,7 @@ static int run_printf(int min, int max)
 		CASE_TEST(width_trunc);  EXPECT_VFPRINTF(25, "                    ", "%25d", 1); break;
 		CASE_TEST(scanf);        EXPECT_ZR(1, test_scanf()); break;
 		CASE_TEST(strerror);     EXPECT_ZR(1, test_strerror()); break;
+		CASE_TEST(printf_error); EXPECT_ZR(1, test_printf_error()); break;
 		case __LINE__:
 			return ret; /* must be last */
 		/* note: do not set any defaults so as to permit holes above */
-- 
2.39.5



