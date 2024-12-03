Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B291FECA7;
	Tue,  3 Dec 2024 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239975; cv=none; b=gZ4r5b+kLbcBzDBQNHtJbx97wIMDmleBPFCMyE0cNWKw+45W+AdUU44rKLpyqCrF7am0T/ERQwgsKsw6VVjVU+aySmrQXmtRJZjDxse/s73Kdo2qRDtuMjCnXq+6JJeTM/IfFCSGo2y4+tQktGb7eWnuBLA6MXugSHdpvIRcp2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239975; c=relaxed/simple;
	bh=0vJWsU3bOfSmqX384HK+XEmH9vYsEtZh2Pwz6k6NDes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjnS/X36m0Co9msPiS16xzxK76G00qcETRVxkhs8jHgNCZ0I5DDQDFCI1+MJ8SGcsL756lnuAWl0HFczChh3NOOFQbMBKjFXxzpMFGagTO//v58T0gZFqVN7t5ukfuvDSDufmGFMZd5G/jaOF3H9ZjKwB8nkZbtKMzYtUAuUwBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKX3V1E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKX3V1E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79170C4CECF;
	Tue,  3 Dec 2024 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239974;
	bh=0vJWsU3bOfSmqX384HK+XEmH9vYsEtZh2Pwz6k6NDes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKX3V1E/tUHiaWu32N/aJvp6VmbYM/VSxGPozMa/REkS7tZlbY/85yKnB94ztlejX
	 D7SMNvz0bZfSTJ9+bkpSIib0jqiZ60Hy9EfO2ZnHlbXQvN+MtnELJUBoBoHtDV66O2
	 LzOQKfoJ8xaLbR/88mMV2dBGPzuIESeEF5KYGLpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 798/817] Rename .data.once to .data..once to fix resetting WARN*_ONCE
Date: Tue,  3 Dec 2024 15:46:10 +0100
Message-ID: <20241203144027.161390251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit dbefa1f31a91670c9e7dac9b559625336206466f ]

Commit b1fca27d384e ("kernel debug: support resetting WARN*_ONCE")
added support for clearing the state of once warnings. However,
it is not functional when CONFIG_LD_DEAD_CODE_DATA_ELIMINATION or
CONFIG_LTO_CLANG is enabled, because .data.once matches the
.data.[0-9a-zA-Z_]* pattern in the DATA_MAIN macro.

Commit cb87481ee89d ("kbuild: linker script do not match C names unless
LD_DEAD_CODE_DATA_ELIMINATION is configured") was introduced to suppress
the issue for the default CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=n case,
providing a minimal fix for stable backporting. We were aware this did
not address the issue for CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y. The
plan was to apply correct fixes and then revert cb87481ee89d. [1]

Seven years have passed since then, yet the #ifdef workaround remains in
place. Meanwhile, commit b1fca27d384e introduced the .data.once section,
and commit dc5723b02e52 ("kbuild: add support for Clang LTO") extended
the #ifdef.

Using a ".." separator in the section name fixes the issue for
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION and CONFIG_LTO_CLANG.

[1]: https://lore.kernel.org/linux-kbuild/CAK7LNASck6BfdLnESxXUeECYL26yUDm0cwRZuM4gmaWUkxjL5g@mail.gmail.com/

Fixes: b1fca27d384e ("kernel debug: support resetting WARN*_ONCE")
Fixes: dc5723b02e52 ("kbuild: add support for Clang LTO")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 include/linux/mmdebug.h           | 6 +++---
 include/linux/once.h              | 4 ++--
 include/linux/once_lite.h         | 2 +-
 include/net/net_debug.h           | 2 +-
 mm/internal.h                     | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bee5a71f4b41e..38d710f620efc 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -351,7 +351,7 @@
 	*(.data..shared_aligned) /* percpu related */			\
 	*(.data..unlikely)						\
 	__start_once = .;						\
-	*(.data.once)							\
+	*(.data..once)							\
 	__end_once = .;							\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 39a7714605a79..d7cb1e5ecbda9 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -46,7 +46,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 		}							\
 	} while (0)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(__ret_warn_once && !__warned)) {			\
@@ -66,7 +66,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	unlikely(__ret_warn);						\
 })
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)	({			\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(__ret_warn_once && !__warned)) {			\
@@ -77,7 +77,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 	unlikely(__ret_warn_once);					\
 })
 #define VM_WARN_ON_ONCE_MM(cond, mm)		({			\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(__ret_warn_once && !__warned)) {			\
diff --git a/include/linux/once.h b/include/linux/once.h
index bc714d414448a..30346fcdc7995 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -46,7 +46,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE(func, ...)						     \
 	({								     \
 		bool ___ret = false;					     \
-		static bool __section(".data.once") ___done = false;	     \
+		static bool __section(".data..once") ___done = false;	     \
 		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
 		if (static_branch_unlikely(&___once_key)) {		     \
 			unsigned long ___flags;				     \
@@ -64,7 +64,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE_SLEEPABLE(func, ...)						\
 	({									\
 		bool ___ret = false;						\
-		static bool __section(".data.once") ___done = false;		\
+		static bool __section(".data..once") ___done = false;		\
 		static DEFINE_STATIC_KEY_TRUE(___once_key);			\
 		if (static_branch_unlikely(&___once_key)) {			\
 			___ret = __do_once_sleepable_start(&___done);		\
diff --git a/include/linux/once_lite.h b/include/linux/once_lite.h
index b7bce4983638f..27de7bc32a061 100644
--- a/include/linux/once_lite.h
+++ b/include/linux/once_lite.h
@@ -12,7 +12,7 @@
 
 #define __ONCE_LITE_IF(condition)					\
 	({								\
-		static bool __section(".data.once") __already_done;	\
+		static bool __section(".data..once") __already_done;	\
 		bool __ret_cond = !!(condition);			\
 		bool __ret_once = false;				\
 									\
diff --git a/include/net/net_debug.h b/include/net/net_debug.h
index 1e74684cbbdbc..4a79204c8d306 100644
--- a/include/net/net_debug.h
+++ b/include/net/net_debug.h
@@ -27,7 +27,7 @@ void netdev_info(const struct net_device *dev, const char *format, ...);
 
 #define netdev_level_once(level, dev, fmt, ...)			\
 do {								\
-	static bool __section(".data.once") __print_once;	\
+	static bool __section(".data..once") __print_once;	\
 								\
 	if (!__print_once) {					\
 		__print_once = true;				\
diff --git a/mm/internal.h b/mm/internal.h
index 7da580dfae6c5..c791312eae764 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -42,7 +42,7 @@ struct folio_batch;
  * when we specify __GFP_NOWARN.
  */
 #define WARN_ON_ONCE_GFP(cond, gfp)	({				\
-	static bool __section(".data.once") __warned;			\
+	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
 	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
-- 
2.43.0



