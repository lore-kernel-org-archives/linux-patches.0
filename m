Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5C299920;
	Sat, 12 Sep 2026 10:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208560; cv=none; b=MQUU4rfQZ2+RH5w1Byt25YEPqqT5qiCrz+LuB6Sqb+qUjBh00Kaql2pYeMaJwDnfvQaVY8i2pjzDtdp9zW86cgitj9yn2XBdcaXL2oBIFRdihWHUH0NDduQTQpDXoKmHbjc8/jUpRvZ1ru8s2yCQfx7TtMgMdG/O8J6Q/kyy3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208560; c=relaxed/simple;
	bh=xQKK0f9a0wU6fyq6WTAVicbHOJruHHhGZBN+pqmy3CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ3p/1B+OkX5FNRub6f5YjyleSIICnuM6q9GnE0P6+J/OylU4x5lsS0aK63g79iL5HGlpgB4M6b9ljc1rQ48Ofz3eqq07o94uGcqcZCNoZL34/ielcMY3bX2mWgXj5hU8grCPltoF0Caj/HWPECvQRp3jB/yglVsExoXh34GUL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci3oDtny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci3oDtny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344701F000FF;
	Sat, 12 Sep 2026 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208559;
	bh=FQZkwc8klp9vl5S47GtuYNhswILzKl02GK4ycF17P+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ci3oDtnyYZ1aZFDy0i8yr+kNgOLCGyeSj4jssdb1BpSRoKpDURXBuXJYz8xR6hxip
	 IXULyLHaL8wyc5P8lJlazM3iji8JJX2YFh62Y7ECs3GYvAyOQp06+eEYoGGm2ZquPx
	 rK3GG+UWRTDJ0dqLQ7Y3VR1gBuOe9TE0RpYBAgac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0640/1518] s390/syscalls: Add pt_regs parameter to SYSCALL_DEFINE0() syscall wrapper
Date: Sat, 12 Sep 2026 08:46:49 +0200
Message-ID: <20260912065637.907261068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 7afb095df3e3c2f0d2f27d2d27bbe574ca9479f0 ]

All system call wrappers should match the sys_call_ptr_t type. This is not
the case for system calls without parameters. Add the missing pt_regs
parameter there too.

Note: this is currently not a problem, since the parameter is unused.
However it prevents to create a correctly typed system call table in
C. With the current assembler implementation this works because of
missing type checking.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: dc161efb6df8 ("s390/vdso: Pass --eh-frame-hdr to the linker")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/syscall_wrapper.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/syscall_wrapper.h b/arch/s390/include/asm/syscall_wrapper.h
index 35c1d1b860d88..bf1ff5e9242d4 100644
--- a/arch/s390/include/asm/syscall_wrapper.h
+++ b/arch/s390/include/asm/syscall_wrapper.h
@@ -38,22 +38,22 @@
  * named __s390x_sys_*()
  */
 #define COMPAT_SYSCALL_DEFINE0(sname)					\
-	long __s390_compat_sys_##sname(void);				\
+	long __s390_compat_sys_##sname(struct pt_regs *__unused);	\
 	ALLOW_ERROR_INJECTION(__s390_compat_sys_##sname, ERRNO);	\
-	long __s390_compat_sys_##sname(void)
+	long __s390_compat_sys_##sname(struct pt_regs *__unused)
 
 #define SYSCALL_DEFINE0(sname)						\
 	SYSCALL_METADATA(_##sname, 0);					\
-	long __s390_sys_##sname(void);					\
+	long __s390_sys_##sname(struct pt_regs *__unused);		\
 	ALLOW_ERROR_INJECTION(__s390_sys_##sname, ERRNO);		\
-	long __s390x_sys_##sname(void);					\
+	long __s390x_sys_##sname(struct pt_regs *__unused);		\
 	ALLOW_ERROR_INJECTION(__s390x_sys_##sname, ERRNO);		\
 	static inline long __do_sys_##sname(void);			\
-	long __s390_sys_##sname(void)					\
+	long __s390_sys_##sname(struct pt_regs *__unused)		\
 	{								\
 		return __do_sys_##sname();				\
 	}								\
-	long __s390x_sys_##sname(void)					\
+	long __s390x_sys_##sname(struct pt_regs *__unused)		\
 	{								\
 		return __do_sys_##sname();				\
 	}								\
@@ -104,10 +104,10 @@
 
 #define SYSCALL_DEFINE0(sname)						\
 	SYSCALL_METADATA(_##sname, 0);					\
-	long __s390x_sys_##sname(void);					\
+	long __s390x_sys_##sname(struct pt_regs *__unused);		\
 	ALLOW_ERROR_INJECTION(__s390x_sys_##sname, ERRNO);		\
 	static inline long __do_sys_##sname(void);			\
-	long __s390x_sys_##sname(void)					\
+	long __s390x_sys_##sname(struct pt_regs *__unused)		\
 	{								\
 		return __do_sys_##sname();				\
 	}								\
-- 
2.53.0



