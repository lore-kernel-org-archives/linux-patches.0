Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55501CDFDE;
	Mon, 14 Oct 2024 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919040; cv=none; b=a2mN4VceYwBpSQpnGZKNRSyGim1kRLfKfk6ZAbpxStGdLs8RvqVlmc1tUkIZWswAk8Do1b2Qgirg51e/lC2xJ7MhW8YJUKPIAyu6He4MnWF1QAiAwGIM8HFSP8I6I0xxVvZ9dfqV61JG3PSQu93H9FTQbOVCBcX/2duwymk8PnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919040; c=relaxed/simple;
	bh=JjHhAd5utNu2JfD/TXKmYwM8DYE3GbWsVRkDoQtHi3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=efGZbTVOM1MvnqdHbn9SJchSFnRgWG3XC77Uuq52MGPMQXmWmeCA5cP8yXdbVKgiEt+EqMOl6HT8qsqI+mTHqwjAFk0S6ggPPRKMcDj61VLmJFUkCCiVZEUhfGOIJNVFXElBhqf18SRpPmGjvUUaeRMc3h7F2AiiOXhZucRM0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmkG86fC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmkG86fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B465C4CEC3;
	Mon, 14 Oct 2024 15:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919040;
	bh=JjHhAd5utNu2JfD/TXKmYwM8DYE3GbWsVRkDoQtHi3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmkG86fC4LdqcR0nP0guRPMyNgRm1fRNvS7uFknB303y/f1uF7z86i9K2icjj/uxj
	 cYQtQa1elHTLHmQ8WWP1yhdd8sxMFtg/jhmuE8cYQ/jHfjsrHlPMbmISQT4/3Laben
	 SSfea4o0y7e3HfwglHXF7VQqgzkesvakIKVj6Kug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 464/798] selftests/nolibc: avoid passing NULL to printf("%s")
Date: Mon, 14 Oct 2024 16:16:58 +0200
Message-ID: <20241014141236.205581442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8e8e8d2a5e18..c6ef8b3e83458 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -353,7 +353,7 @@ static int expect_strzr(const char *expr, int llen)
 {
 	int ret = 0;
 
-	llen += printf(" = <%s> ", expr);
+	llen += printf(" = <%s> ", expr ? expr : "(null)");
 	if (expr) {
 		ret = 1;
 		llen += pad_spc(llen, 40, "[FAIL]\n");
@@ -371,7 +371,7 @@ static int expect_strnz(const char *expr, int llen)
 {
 	int ret = 0;
 
-	llen += printf(" = <%s> ", expr);
+	llen += printf(" = <%s> ", expr ? expr : "(null)");
 	if (!expr) {
 		ret = 1;
 		llen += pad_spc(llen, 40, "[FAIL]\n");
-- 
2.43.0



