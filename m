Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE242D24B7;
	Tue, 10 Mar 2026 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141093; cv=none; b=mAfnGtEqlGP2ljsbr+dz63J1LGweeLmsXuI5d4C5Mf6k7ESVqmd+ph2vmG0j7U68ZqPsEJCBSfMqSWk7KORPD9B7yUP9kb23kMRAsiLSQVyLrox3ZBuypl5B4JC/ThAvMxFI8/FKcXQYHp0Ij43nDAsxqksqCqbr1Djn2BARnmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141093; c=relaxed/simple;
	bh=zrofDdAf/ffu9FZESZlvcsRid+lWMQBNvFGw19p05aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ5gW8Bji0Ddc1pENvSTOqBFTAvBeCKEWCW92WTMjFsJWW/WMJEeRu+AKxHuWOfKxaQ3StNkrkj76jOtomBKLyBzeWjmru/JdHDWnmp65c9BuTvp3HGihLdwe7KCWkvdagQa2b13WzMZ7Vi/HUojzdCerEjmd1ZJFihEKdhqTbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjqBaXB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjqBaXB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79379C19423;
	Tue, 10 Mar 2026 11:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141093;
	bh=zrofDdAf/ffu9FZESZlvcsRid+lWMQBNvFGw19p05aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjqBaXB3ac85iCjlY/UANpnsvyrJR8zmDZvyNXj9U74oSeNEvO03RxSKdz41V0gin
	 xuRZPksAvdCgfgL5Lph2TFaDjZrFNixP4OOzysfOlz1B5e+4X+nUYIe0Yz46NlxrkM
	 EeS59YURy5DUsThdbBs3SDsZ1/Z9G/c/WSV5A0QT1MD3CNWamdwa974sLj/RfJMFMH
	 PvjDV6LSJsag2YTGFw4FbJKDcqNekMLLpERGa5QcCL4JwyerszNv25eh2QHuRH+SBm
	 ugt0OfIEvqF69JBeOYB2iLcxQFCtawOusehaNFR0MuECMi54w/w2eL/w2rnsfyHbDf
	 UnQSfucyPjP2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 093/311] uaccess: Fix scoped_user_read_access() for 'pointer to const'
Date: Tue, 10 Mar 2026 07:02:20 -0400
Message-ID: <ee8977e1e9f4182743069aec255f0cd1363792ff.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08 ]

If a 'const struct foo __user *ptr' is used for the address passed to
scoped_user_read_access() then you get a warning/error

  uaccess.h:691:1: error: initialization discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]

for the

  void __user *_tmpptr = __scoped_user_access_begin(mode, uptr, size, elbl)

assignment.

Fix by using 'auto' for both _tmpptr and the redeclaration of uptr.
Replace the CLASS() with explicit __cleanup() functions on uptr.

Fixes: e497310b4ffb ("uaccess: Provide scoped user access regions")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Reviewed-and-tested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h | 54 +++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 1f3804245c066..809e4f7dfdbd4 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -647,36 +647,22 @@ static inline void user_access_restore(unsigned long flags) { }
 /* Define RW variant so the below _mode macro expansion works */
 #define masked_user_rw_access_begin(u)	masked_user_access_begin(u)
 #define user_rw_access_begin(u, s)	user_access_begin(u, s)
-#define user_rw_access_end()		user_access_end()
 
 /* Scoped user access */
-#define USER_ACCESS_GUARD(_mode)				\
-static __always_inline void __user *				\
-class_user_##_mode##_begin(void __user *ptr)			\
-{								\
-	return ptr;						\
-}								\
-								\
-static __always_inline void					\
-class_user_##_mode##_end(void __user *ptr)			\
-{								\
-	user_##_mode##_access_end();				\
-}								\
-								\
-DEFINE_CLASS(user_ ##_mode## _access, void __user *,		\
-	     class_user_##_mode##_end(_T),			\
-	     class_user_##_mode##_begin(ptr), void __user *ptr)	\
-								\
-static __always_inline class_user_##_mode##_access_t		\
-class_user_##_mode##_access_ptr(void __user *scope)		\
-{								\
-	return scope;						\
-}
 
-USER_ACCESS_GUARD(read)
-USER_ACCESS_GUARD(write)
-USER_ACCESS_GUARD(rw)
-#undef USER_ACCESS_GUARD
+/* Cleanup wrapper functions */
+static __always_inline void __scoped_user_read_access_end(const void *p)
+{
+	user_read_access_end();
+};
+static __always_inline void __scoped_user_write_access_end(const void *p)
+{
+	user_write_access_end();
+};
+static __always_inline void __scoped_user_rw_access_end(const void *p)
+{
+	user_access_end();
+};
 
 /**
  * __scoped_user_access_begin - Start a scoped user access
@@ -750,13 +736,13 @@ USER_ACCESS_GUARD(rw)
  *
  * Don't use directly. Use scoped_masked_user_$MODE_access() instead.
  */
-#define __scoped_user_access(mode, uptr, size, elbl)					\
-for (bool done = false; !done; done = true)						\
-	for (void __user *_tmpptr = __scoped_user_access_begin(mode, uptr, size, elbl); \
-	     !done; done = true)							\
-		for (CLASS(user_##mode##_access, scope)(_tmpptr); !done; done = true)	\
-			/* Force modified pointer usage within the scope */		\
-			for (const typeof(uptr) uptr = _tmpptr; !done; done = true)
+#define __scoped_user_access(mode, uptr, size, elbl)				\
+for (bool done = false; !done; done = true)					\
+	for (auto _tmpptr = __scoped_user_access_begin(mode, uptr, size, elbl);	\
+	     !done; done = true)						\
+		/* Force modified pointer usage within the scope */		\
+		for (const auto uptr  __cleanup(__scoped_user_##mode##_access_end) = \
+		     _tmpptr; !done; done = true)
 
 /**
  * scoped_user_read_access_size - Start a scoped user read access with given size
-- 
2.51.0

