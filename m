Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF658379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301710; cv=none; b=NCSWQHYo93w3Gh/ZTrTP4kIzn0bkyeRVo6oKaVv5QMs+J+h52zszpNkK9qvnHzNTKEbjmqFKMDRj1bHM9Sff5Sljfb8WOXu0Br//MT/9ne6m0MWQwfpKc8K5+5fTiFAtZm1mRJilkHirr6ErD/G4LASfk6t3EY7GXxrK5G3EzNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301710; c=relaxed/simple;
	bh=o9DcyQmgH4VN0oVPOnT2dMr2trRE1sThXi2QMZzeprc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIK5aA2aLpNSnjPf4I/gFLDV0vnTIWr+ErZ5SzxdZ4hX4I7nVzYhhPbPOaOhFncm2tiAVsGW4AzeJSpV5NkCmPu20Xw3G7WnPhALXmQcNBStqxhRwnsFtHKi4fu0ARQXUJX2lYBkiYFO4OC46TS4/W9b+S2MZ73mlrv8KM2Pnik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y76qgBGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y76qgBGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF2AC19424;
	Sat, 28 Feb 2026 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301710;
	bh=o9DcyQmgH4VN0oVPOnT2dMr2trRE1sThXi2QMZzeprc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y76qgBGvaVejYdSTxUttoLtfseycXtbtRugPBGDqNJcBEwr2uuiShwUTd0cSvyeoH
	 wJf7AyLa4YFJNL1NTS+9MDNZwqGG9v0d/WrFQwaEUI1lO07Mahuk1ugynFCNgIAW45
	 8nNJ+i0nBpg4e1H06N7S3QrhkMku5tMMb2Q0UjTbK6yzkiu4paonw7nPENLMprRlIh
	 UjlXDwDbQANjJz93yBYZgrD7GFN1rGq+s4bX2PrLw//r3qGrlAk28xzvK/exYJIcpo
	 tNfclfzBn8xLzXTiO1180EaShLHMQD9Lb4iRDSoSKuF691E0If30nX9UdAAovHdGlK
	 FkD+S70/G5Rcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/385] powerpc/uaccess: Move barrier_nospec() out of allow_read_{from/write}_user()
Date: Sat, 28 Feb 2026 12:55:27 -0500
Message-ID: <20260228180011.1568201-105-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2bb03d941e3e8..6737416dde9f0 100644
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
index 4f5a46a77fa2b..3987a5c33558b 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -301,6 +301,7 @@ do {								\
 	__typeof__(sizeof(*(ptr))) __gu_size = sizeof(*(ptr));	\
 								\
 	might_fault();					\
+	barrier_nospec();					\
 	allow_read_from_user(__gu_addr, __gu_size);		\
 	__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	prevent_read_from_user(__gu_addr, __gu_size);		\
@@ -329,6 +330,7 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	unsigned long ret;
 
+	barrier_nospec();
 	allow_read_write_user(to, from, n);
 	ret = __copy_tofrom_user(to, from, n);
 	prevent_read_write_user(to, from, n);
@@ -415,6 +417,7 @@ static __must_check __always_inline bool user_access_begin(const void __user *pt
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_write_user((void __user *)ptr, ptr, len);
 	return true;
 }
@@ -431,6 +434,7 @@ user_read_access_begin(const void __user *ptr, size_t len)
 
 	might_fault();
 
+	barrier_nospec();
 	allow_read_from_user(ptr, len);
 	return true;
 }
-- 
2.51.0

