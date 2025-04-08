Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4C726656B;
	Tue,  8 Apr 2025 12:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114260; cv=none; b=S5dvi6vXn+hRBTJwIc1I6S2JMG8Jcz4EFk9WJxz7TkTqml4LCf07IcKpEX4FcA8q9SNhXey++iRVfAQ0Ft+nXLwDffVJyR1O/w+4G4116XUrMUiXV79Gjvh1eO9c6c0iCve0Sinatz57bBYfBOjGrNIj2G6zkXo3UpIZOd5bB1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114260; c=relaxed/simple;
	bh=9z45IiyVWcoF2NT5FfRMoBLrC0cnDMozgmDlB8ALn4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHvyLDcPCLD8OWJKkbH0HfPW+8OHGxSyJS4b+OTWcjHDHPLZ141SaGR+MQRByWyoYkWAe8NnYI5Z6KZ0HTe1yk7VMjKFnhut1bPPdgnONgppPxxYKYo1L5MTNYSwxcRtali2QeJnkSkvIx4I2SipTydkKODmUk5BGnI0mhS/5eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2fCZtG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2fCZtG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607DDC4CEE5;
	Tue,  8 Apr 2025 12:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114260;
	bh=9z45IiyVWcoF2NT5FfRMoBLrC0cnDMozgmDlB8ALn4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2fCZtG2lFsNCh0rejGYvSVmd5zwTkLxafV46XGI/vX8BsSEOlFe2can1L7pYHdDt
	 jF05sz9Nj8q2Cz3i9rONvG6rP53DZmxz3P6eASYmIPpg9GRWt4ZTpkZeEqmNVbmhv+
	 stSZF84bBf0eT1UUzzUwiQwmaB7N/F7OOtZJgcbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 005/499] seccomp: fix the __secure_computing() stub for !HAVE_ARCH_SECCOMP_FILTER
Date: Tue,  8 Apr 2025 12:43:37 +0200
Message-ID: <20250408104851.389251155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit b37778bec82ba82058912ca069881397197cd3d5 ]

Depending on CONFIG_HAVE_ARCH_SECCOMP_FILTER, __secure_computing(NULL)
will crash or not. This is not consistent/safe, especially considering
that after the previous change __secure_computing(sd) is always called
with sd == NULL.

Fortunately, if CONFIG_HAVE_ARCH_SECCOMP_FILTER=n, __secure_computing()
has no callers, these architectures use secure_computing_strict(). Yet
it make sense make __secure_computing(NULL) safe in this case.

Note also that with this change we can unexport secure_computing_strict()
and change the current callers to use __secure_computing(NULL).

Fixes: 8cf8dfceebda ("seccomp: Stub for !HAVE_ARCH_SECCOMP_FILTER")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250128150307.GA15325@redhat.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seccomp.h |  8 ++------
 kernel/seccomp.c        | 14 ++++++++++----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index e45531455d3bb..d55949071c30e 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -22,8 +22,9 @@
 #include <linux/atomic.h>
 #include <asm/seccomp.h>
 
-#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 extern int __secure_computing(const struct seccomp_data *sd);
+
+#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 static inline int secure_computing(void)
 {
 	if (unlikely(test_syscall_work(SECCOMP)))
@@ -32,11 +33,6 @@ static inline int secure_computing(void)
 }
 #else
 extern void secure_computing_strict(int this_syscall);
-static inline int __secure_computing(const struct seccomp_data *sd)
-{
-	secure_computing_strict(sd->nr);
-	return 0;
-}
 #endif
 
 extern long prctl_get_seccomp(void);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 0cd1f8b5a102e..ec58f7cc0e94d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -29,13 +29,11 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+#include <asm/syscall.h>
+
 /* Not exposed in headers: strictly internal use only. */
 #define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
 
-#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
-#include <asm/syscall.h>
-#endif
-
 #ifdef CONFIG_SECCOMP_FILTER
 #include <linux/file.h>
 #include <linux/filter.h>
@@ -1074,6 +1072,14 @@ void secure_computing_strict(int this_syscall)
 	else
 		BUG();
 }
+int __secure_computing(const struct seccomp_data *sd)
+{
+	int this_syscall = sd ? sd->nr :
+		syscall_get_nr(current, current_pt_regs());
+
+	secure_computing_strict(this_syscall);
+	return 0;
+}
 #else
 
 #ifdef CONFIG_SECCOMP_FILTER
-- 
2.39.5



