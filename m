Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58330F814;
	Mon, 13 Oct 2025 15:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368882; cv=none; b=SeL2v8QCD2thSgojgiww8kySETpZg00pp53/Y8MFSzq/ZzKUo5jG6h3xCra3cQx9VTm5qM4DBlQqnnK5hFxa0vA4Y04KGqJk70kFwgOYvClo4xE5rEOGjqBmkulNmgr0zMiR8qYVDW6q32gUGRsLOXwhAkckJEpyK4iZtkl8sAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368882; c=relaxed/simple;
	bh=hXG8mwkRrGrov6r3A9WFi015nS/1zd6u3nmc8kJ8I8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZlIFt04E1alIUVGFhp7WFX2tyh3OI+/RHyvYu6Izjbyk0hUniF32C0zBJnWTCsWXipuDneydpFFEOsn6Dklm21IfF3JHkzl673dMdJiqr5wwf7usFguD5BD6yBFUnRzVvrpKsILOWQHeLwLkMBqaOsB+q6XK6rsWzFV5NvJM8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT5BVjci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT5BVjci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636DCC4CEFE;
	Mon, 13 Oct 2025 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368881;
	bh=hXG8mwkRrGrov6r3A9WFi015nS/1zd6u3nmc8kJ8I8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT5BVjcibwiV5vA4rSVLKC4krUzOJ7NkAgmVuoQj/gHHws+kxJ4RY/Bm05akNcnuk
	 67l9gbmsQQ8yJXMtl0FZHHLdEqa1kzPQVZyY+pfuiFVEK445OFIarxRIv6Fv4tcC22
	 T8rMBJ/bQPXQfOEzDpti1gZyd/HOP/66gg+vRTbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 050/563] tools/nolibc: fix error return value of clock_nanosleep()
Date: Mon, 13 Oct 2025 16:38:31 +0200
Message-ID: <20251013144413.105660822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 1201f6fb5bfdbd10985ac3c8f49ef8f4f88b5c94 ]

clock_nanosleep() returns a positive error value. Unlike other libc
functions it *does not* return -1 nor set errno.

Fix the return value and also adapt nanosleep().

Fixes: 7c02bc4088af ("tools/nolibc: add support for clock_nanosleep() and nanosleep()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250731-nolibc-clock_nanosleep-ret-v1-1-9e4af7855e61@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/time.h                  | 5 +++--
 tools/testing/selftests/nolibc/nolibc-test.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/time.h b/tools/include/nolibc/time.h
index d02bc44d2643a..e9c1b976791a6 100644
--- a/tools/include/nolibc/time.h
+++ b/tools/include/nolibc/time.h
@@ -133,7 +133,8 @@ static __attribute__((unused))
 int clock_nanosleep(clockid_t clockid, int flags, const struct timespec *rqtp,
 		    struct timespec *rmtp)
 {
-	return __sysret(sys_clock_nanosleep(clockid, flags, rqtp, rmtp));
+	/* Directly return a positive error number */
+	return -sys_clock_nanosleep(clockid, flags, rqtp, rmtp);
 }
 
 static __inline__
@@ -145,7 +146,7 @@ double difftime(time_t time1, time_t time2)
 static __inline__
 int nanosleep(const struct timespec *rqtp, struct timespec *rmtp)
 {
-	return clock_nanosleep(CLOCK_REALTIME, 0, rqtp, rmtp);
+	return __sysret(sys_clock_nanosleep(CLOCK_REALTIME, 0, rqtp, rmtp));
 }
 
 
diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index a297ee0d6d075..cc4d730ac4656 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -1334,6 +1334,7 @@ int run_syscall(int min, int max)
 		CASE_TEST(chroot_root);       EXPECT_SYSZR(euid0, chroot("/")); break;
 		CASE_TEST(chroot_blah);       EXPECT_SYSER(1, chroot("/proc/self/blah"), -1, ENOENT); break;
 		CASE_TEST(chroot_exe);        EXPECT_SYSER(1, chroot(argv0), -1, ENOTDIR); break;
+		CASE_TEST(clock_nanosleep);   ts.tv_nsec = -1; EXPECT_EQ(1, EINVAL, clock_nanosleep(CLOCK_REALTIME, 0, &ts, NULL)); break;
 		CASE_TEST(close_m1);          EXPECT_SYSER(1, close(-1), -1, EBADF); break;
 		CASE_TEST(close_dup);         EXPECT_SYSZR(1, close(dup(0))); break;
 		CASE_TEST(dup_0);             tmp = dup(0);  EXPECT_SYSNE(1, tmp, -1); close(tmp); break;
-- 
2.51.0



