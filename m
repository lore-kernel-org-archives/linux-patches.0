Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7BC37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302539; cv=none; b=p7w4t2j8oWyLVAmU2eVpzDya8vV7NNyRjwsRDHlQNXc4BEgDYErvMesen0mCFuLIADFnbXosDAZwE7qlWSpihRS5d5B5Efe+/+hARGRrw01yfIgqSpLK7kLj7glyt85LIy1yP1MADRnx9TEiR+H0k0DY6O45w/m3t/gv9h/1TCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302539; c=relaxed/simple;
	bh=UNrchGeV8kDcwdhSg4Q/Cv1EoZZJ4XVcWrWkkePnwBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoBYGkA7whUNQIJ4HSUTqiggfY3ZvO+qCRbLlkl/nGjrGbGx/pBarOYmEQUvsWnWnd4urKIp0l1KGhJroLrMue6Mq1+20Gzk1UWRXUU4OpZnjQLo8QHmLlEqNqFwjxM3B10kE71/hgdTBhY+YKoc58UTlqoW1kmvCK1M2w/qBD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uu5tqXR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uu5tqXR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA77C116D0;
	Sat, 28 Feb 2026 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302539;
	bh=UNrchGeV8kDcwdhSg4Q/Cv1EoZZJ4XVcWrWkkePnwBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu5tqXR8AzLVO/WbUErAoW5rqqCO4S35sMeB3EWOrRESR5z/FrPxPdLPDPcFps/l8
	 OnelkIwdcik0EJw4WLo9WX7/WYBpwoeY+QNy7ZRkwD1SZhW98XKbN/xEg9uFG2cjRD
	 +qx2jE6AcxMqUwgVGgKtYCEIXXbXCudeeO++1A0JaqGCVuabWsSZd7bd/6VNcDT39t
	 mveq25dCVc5uHdX1xAoUNC4PN0fnZZfAB+BByh2ie8C5+CcRH81o9zsdeiFBx9jxDV
	 3d3iR+jGaXLirsnPT4m/JEjCUgDWhKto85eTiSGVd6tlqarf7ibXuq9ZTJDD2NYXNv
	 K2QkMxfeg4pYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/164] powerpc/uaccess: Move barrier_nospec() out of allow_read_{from/write}_user()
Date: Sat, 28 Feb 2026 13:12:59 -0500
Message-ID: <20260228181505.1600663-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 34ff86e3686ea..eb048b6be6d83 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -81,7 +81,6 @@ static __always_inline void setup_kup(void)
 
 static __always_inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(NULL, from, size, KUAP_READ);
 }
 
@@ -93,7 +92,6 @@ static __always_inline void allow_write_to_user(void __user *to, unsigned long s
 static __always_inline void allow_read_write_user(void __user *to, const void __user *from,
 						  unsigned long size)
 {
-	barrier_nospec();
 	allow_user_access(to, from, size, KUAP_READ_WRITE);
 }
 
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 6013a7fc74ba7..7781f6dd51390 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -276,6 +276,7 @@ do {								\
 	__typeof__(sizeof(*(ptr))) __gu_size = sizeof(*(ptr));	\
 								\
 	might_fault();					\
+	barrier_nospec();					\
 	allow_read_from_user(__gu_addr, __gu_size);		\
 	__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	prevent_read_from_user(__gu_addr, __gu_size);		\
@@ -304,6 +305,7 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
 
+	barrier_nospec();
 	allow_read_write_user(to, from, n);
 	ret = __copy_tofrom_user(to, from, n);
 	prevent_read_write_user(to, from, n);
@@ -392,6 +394,7 @@ static __must_check inline bool user_access_begin(const void __user *ptr, size_t
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_write_user((void __user *)ptr, ptr, len);
 	return true;
 }
@@ -408,6 +411,7 @@ user_read_access_begin(const void __user *ptr, size_t len)
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_from_user(ptr, len);
 	return true;
 }
-- 
2.51.0

