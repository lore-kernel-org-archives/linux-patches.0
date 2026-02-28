Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CD7346AD3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302086; cv=none; b=GDRbKgfJOLdb5CetPfiyuYf4csZ8ULp0ecOHLBk6GlWlw2BPJgeYQrYuMuH/EDfr16DejZcAKhLflFgW/Se6C4bz4DRS6tPgGCNUbhpEkFk0yW3ZBC9Xchd3GX/FbOCpFHl7T6skci7lsZ5UOUmHidd7G8Q5lV5TumekPAp2pZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302086; c=relaxed/simple;
	bh=KeB7BkWdLC6C0RRKErmHrpcrRwiICZRtiLXFCDWqGHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZq09Y3XQp/dekRqiMw7xPacosLmoR6HQSDCRHRUQFdUSw+kNr0Nv0ZuqX8gaJH0+FMQfoS7c8EV0NQVBYyflq2HrQySVDtdVroHMK9ue+ZbQMP2gkx22/mwvqnqCeSz2PkSMaevIt7b2RmmLAOc+XUVjehLSpfUlS1x4P6jFlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjfI2TZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjfI2TZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AFBC116D0;
	Sat, 28 Feb 2026 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302085;
	bh=KeB7BkWdLC6C0RRKErmHrpcrRwiICZRtiLXFCDWqGHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjfI2TZ4usQ9u8vP1FqN43Lu+k3RFhYNoggYCg4iqITC6Vm1EXp6s3+raJkLsaTlm
	 JGiy9yKsN3BVxd42P1KJGtTyIDGNkFB+MB3jsgLFamRbMlnfmOvlkigfEnOyFb3XY9
	 redFG9gHkJ2sCfLP5VyQvJ7h1X7zngicRWDKJMwG9yMC65pykf3Glj+ju7TRO9lo24
	 NkY12U2F5uE60XQdl/wtBR/xygWX/zkBatmhNVsls+TrqFaXf8cX5UmMzEZK4trQB1
	 W9pJ+g7+Tk8AEyCw6J+tCAL8zWz7SjSoMwd3ZiPL/SSVbIhT7JkajdTKrYEJm8Widn
	 vlpQ0ZDM1XE8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/283] powerpc/uaccess: Move barrier_nospec() out of allow_read_{from/write}_user()
Date: Sat, 28 Feb 2026 13:03:30 -0500
Message-ID: <20260228180709.1583486-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 5fbc09eb0b4f4b1a4b33abebacbeee0d29f195e9 ]

Commit 74e19ef0ff80 ("uaccess: Add speculation barrier to
copy_from_user()") added a redundant barrier_nospec() in
copy_from_user(), because powerpc is already calling
barrier_nospec() in allow_read_from_user() and
allow_read_write_user(). But on other architectures that
call to barrier_nospec() was missing. So change powerpc
instead of reverting the above commit and having to fix
other architectures one by one. This is now possible
because barrier_nospec() has also been added in
copy_from_user_iter().

Move barrier_nospec() out of allow_read_from_user() and
allow_read_write_user(). This will also allow reuse of those
functions when implementing masked user access which doesn't
require barrier_nospec().

Don't add it back in raw_copy_from_user() as it is already called
by copy_from_user() and copy_from_user_iter().

Fixes: 74e19ef0ff80 ("uaccess: Add speculation barrier to copy_from_user()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/f29612105c5fcbc8ceb7303808ddc1a781f0f6b5.1766574657.git.chleroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kup.h     | 2 --
 arch/powerpc/include/asm/uaccess.h | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index ad7e8c5aec3f8..63223b7e520f0 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -134,7 +134,6 @@ static __always_inline void kuap_assert_locked(void)
 
 static __always_inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(NULL, from, size, KUAP_READ);
 }
 
@@ -146,7 +145,6 @@ static __always_inline void allow_write_to_user(void __user *to, unsigned long s
 static __always_inline void allow_read_write_user(void __user *to, const void __user *from,
 						  unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(to, from, size, KUAP_READ_WRITE);
 }
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index a81bd825087cd..ec7f001d03d01 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -290,6 +290,7 @@ do {								\
 	__typeof__(sizeof(*(ptr))) __gu_size = sizeof(*(ptr));	\
 								\
 	might_fault();					\
+	barrier_nospec();					\
 	allow_read_from_user(__gu_addr, __gu_size);		\
 	__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	prevent_read_from_user(__gu_addr, __gu_size);		\
@@ -318,6 +319,7 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
 
+	barrier_nospec();
 	allow_read_write_user(to, from, n);
 	ret = __copy_tofrom_user(to, from, n);
 	prevent_read_write_user(to, from, n);
@@ -404,6 +406,7 @@ static __must_check __always_inline bool user_access_begin(const void __user *pt
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_write_user((void __user *)ptr, ptr, len);
 	return true;
 }
@@ -420,6 +423,7 @@ user_read_access_begin(const void __user *ptr, size_t len)
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_from_user(ptr, len);
 	return true;
 }
-- 
2.51.0

