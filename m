Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0353436C9E7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302293; cv=none; b=OIGPi87mloerPfk6s1DtLK55jHDMHwl3pRuzQoSDrB1BjXdP2phd3zGuuu109dviAEBWg/edqF8eq9kdd0stT/xyDJE7bm5uNpTR+XJ9P3QCIZ5n5VhCmnt4wqbW5tgRRrU/FBfdr9li1x/RyoV7WBngM6HOtoz24AMk85bYvIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302293; c=relaxed/simple;
	bh=gOCrc03Zt2BRdjdRb1MkdQ0rU2Y1j7AzOQadYecUgeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZTqMCEpxrlsTMOcxBA9gkzS+8Vy2/eLKZ7eJREq43DLAgrCWgw6XHjptrOJixVGznm3vF+IG3POisn3WsgeTQCi+vL5FeqN46DYrn/nYNRTiiTjU7rtKSx5Xu+w/liNqMeb1Y/Gcx38/Ykz8RQa7AW7hRDxU+Yy9AWnyA2KkuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTt6YyvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTt6YyvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DBBC116D0;
	Sat, 28 Feb 2026 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302292;
	bh=gOCrc03Zt2BRdjdRb1MkdQ0rU2Y1j7AzOQadYecUgeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTt6YyvD9Hy5PyJOKknpypUK48aIjh3hra+HY6+bX1DXuqbVV/EzmVwblRRJ69GsO
	 krURnwWdz8LTjISc2od+W/qTJUP0U6JfiGApqXhV1R2CCm2chjpbfWtRO8kGQQ0XL0
	 IpPqMgrPgpiYUlQ41rTV2PYb0gvGBbwM04Vx2Aqf21RI8OOkrbUyGk2J0v7zPD/1m7
	 IQteYWanIDsC6P60QpxudvUZc0Jyq3SkLFxg+UedsEuY0QUG1P5Y15tLqSOOwlgaGI
	 NLMKBNcM460Ilwog4/C4Re9RoXkVZ6tv1ZhwcTOj2ZKR2mqY7BTcl6iAaU5i7ThBOg
	 k/Mxa15vEX+tQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnd Bergmann <arnd@arndb.de>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/232] audit: avoid missing-prototype warnings
Date: Sat, 28 Feb 2026 13:07:38 -0500
Message-ID: <20260228181127.1592657-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e455ca40dbcf2cd50d1e59bf4b2752b300bcdad4 ]

Building with 'make W=1' reveals two function definitions without
a previous prototype in the audit code:

lib/compat_audit.c:32:5: error: no previous prototype for 'audit_classify_compat_syscall' [-Werror=missing-prototypes]
kernel/audit.c:1813:14: error: no previous prototype for 'audit_serial' [-Werror=missing-prototypes]

The first one needs a declaration from linux/audit.h but cannot
include that header without causing conflicting (compat) syscall number
definitions, so move the it into linux/audit_arch.h.

The second one is declared conditionally based on CONFIG_AUDITSYSCALL
but needed as a local function even when that option is disabled, so
move the declaration out of the #ifdef block.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: 76489955c6d4 ("audit: move the compat_xxx_class[] extern declarations to audit_arch.h")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/audit.h      | 2 --
 include/linux/audit_arch.h | 2 ++
 kernel/audit.h             | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3608992848d3c..6efadd7f60a55 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -129,8 +129,6 @@ extern unsigned compat_dir_class[];
 extern unsigned compat_chattr_class[];
 extern unsigned compat_signal_class[];
 
-extern int audit_classify_compat_syscall(int abi, unsigned syscall);
-
 /* audit_names->type values */
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
 #define	AUDIT_TYPE_NORMAL	1	/* a "normal" audit record */
diff --git a/include/linux/audit_arch.h b/include/linux/audit_arch.h
index 8fdb1afe251a1..0e34d673ef171 100644
--- a/include/linux/audit_arch.h
+++ b/include/linux/audit_arch.h
@@ -21,4 +21,6 @@ enum auditsc_class_t {
 	AUDITSC_NVALS /* count */
 };
 
+extern int audit_classify_compat_syscall(int abi, unsigned syscall);
+
 #endif
diff --git a/kernel/audit.h b/kernel/audit.h
index c57b008b9914e..94738bce40b27 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -259,8 +259,8 @@ extern struct tty_struct *audit_get_tty(void);
 extern void audit_put_tty(struct tty_struct *tty);
 
 /* audit watch/mark/tree functions */
-#ifdef CONFIG_AUDITSYSCALL
 extern unsigned int audit_serial(void);
+#ifdef CONFIG_AUDITSYSCALL
 extern int auditsc_get_stamp(struct audit_context *ctx,
 			      struct timespec64 *t, unsigned int *serial);
 
-- 
2.51.0

