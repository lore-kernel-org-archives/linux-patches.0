Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36CB36C9EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302338; cv=none; b=qX+KxHKK9qo+kmAIoKith+bBlnGXHCmB2H5dp98NdikctK2LBoSnjWb7SrqlaiNZGD5Lh5e1+JH1WJZKH9Gc7lSxsdoZGUCfFllMkp3SSQBU/85iwiXjawkBC/0SAzVfZqy0+AaWUdEslGiYavRg424cW9izPOvRVeAcuxRRyxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302338; c=relaxed/simple;
	bh=6ZxmtBtTxQjqQyCAXN+7opXGUs8LRTAUIr/hP8f0kL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slKmzRUpjODxDrUizHm1xk/yTKC/q68XY1o54BzFH84HusDsjRjQz3OPaNtyIZoTX42PoPQK6JQNQg5uI9d+f2gg5Dcybi9gEYreOavlHrFtZBM8mBQ8FNGkvQ2x2AZkRdxqNRUzfYplNuULJ4qilwBC+WcY+2OjaYk5qooM9sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5yqR8Y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5yqR8Y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122A3C19425;
	Sat, 28 Feb 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302338;
	bh=6ZxmtBtTxQjqQyCAXN+7opXGUs8LRTAUIr/hP8f0kL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5yqR8Y+FAVvbnBaTwXTC277WGSGQ+RjLeIPQ8pPKVY1yS6PbGLSII0IEKWf/NigS
	 liGt6bu3D2h3GhqvTe1+f4U+Nk/wdu/0DM9iWh6OYEDLf2eUGgS+GgpVx0/61GqyhC
	 92dcYxrlFpuHa3OB07DMCPs11JXym4xFqO36SkG6Jg4Fzju5XvWHxxaME7fEnBRJWj
	 2mcUs1asl6sqmQ3FtcxkMazeJYySx+HhiJMcasE1GeHgO3mbwXHRvnRhUdmTB4xAkO
	 bADWrzaPkDCSGatjnALwfX8XqgwV+3ULmdKxxtWPnMc/FaHRGndHgtUZghxEhe5y8J
	 qlbMSEpGGBxfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/232] powerpc/uaccess: Move barrier_nospec() out of allow_read_{from/write}_user()
Date: Sat, 28 Feb 2026 13:08:33 -0500
Message-ID: <20260228181127.1592657-60-sashal@kernel.org>
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
index d751ddd081108..6ee6601f5d4e9 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -163,7 +163,6 @@ static __always_inline void restore_user_access(unsigned long flags)
 
 static __always_inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(NULL, from, size, KUAP_READ);
 }
 
@@ -175,7 +174,6 @@ static __always_inline void allow_write_to_user(void __user *to, unsigned long s
 static __always_inline void allow_read_write_user(void __user *to, const void __user *from,
 						  unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(to, from, size, KUAP_READ_WRITE);
 }
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 63e7c3107cc88..0d874e343b9f6 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -285,6 +285,7 @@ do {								\
 	__typeof__(sizeof(*(ptr))) __gu_size = sizeof(*(ptr));	\
 								\
 	might_fault();					\
+	barrier_nospec();					\
 	allow_read_from_user(__gu_addr, __gu_size);		\
 	__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	prevent_read_from_user(__gu_addr, __gu_size);		\
@@ -313,6 +314,7 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
 
+	barrier_nospec();
 	allow_read_write_user(to, from, n);
 	ret = __copy_tofrom_user(to, from, n);
 	prevent_read_write_user(to, from, n);
@@ -401,6 +403,7 @@ static __must_check inline bool user_access_begin(const void __user *ptr, size_t
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_write_user((void __user *)ptr, ptr, len);
 	return true;
 }
@@ -417,6 +420,7 @@ user_read_access_begin(const void __user *ptr, size_t len)
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_from_user(ptr, len);
 	return true;
 }
-- 
2.51.0

