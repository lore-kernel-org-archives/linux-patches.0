Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3248B319611;
	Mon, 13 Oct 2025 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369293; cv=none; b=ZQhwScit/O/ntCmegG54hORibtoke2kbkH0xv0UhkmZ/8YCiBOZH2WMXL52H8aR25reLu9Z//vROGVHP/uYNRO/g3Q84wSLOqa6Un3UR1WZ47bl/fPxljikyOyE+GirYn9er5x3XZKp13fpCQCyK099OcYoiNeapDuSC8GjxWhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369293; c=relaxed/simple;
	bh=sWcVLhs3OYus4UZrC3M3Qddip2QGBtIy3h58Z8LHEqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoQLmrCi1x4dyMiDAZxThnf6lBqd24PO8haXXfrwBAa7goyK49iQ4ldIEgpQgt2R9I+8Xxqob3P6Sa0LbicaoZGf0I5dInvJtmM0x5upPviU5fMGhrTayKjj2j8KO5iE3Nnjb6i7LEWSUhknP3/aEiw6PQtjlRju7urGqRBrXns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4f9MKmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4f9MKmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC996C116B1;
	Mon, 13 Oct 2025 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369293;
	bh=sWcVLhs3OYus4UZrC3M3Qddip2QGBtIy3h58Z8LHEqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4f9MKmyy8SmD6bIvrxHn2L3AzWuhFt1OJWasxX4NPGAq0yEn5iix1OiwHjUcbpG+
	 LrlE3nQiLHB862xcx7YNPBYsyvLUIoCRlI8sz9+myDIF4jS2z5IZwYPXfh3pS4/aWW
	 Fv+oF9gB9ngt4COISMb2bk1cSjA4/VRKsZUulCOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Qi Xi <xiqi2@huawei.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 194/563] once: fix race by moving DO_ONCE to separate section
Date: Mon, 13 Oct 2025 16:40:55 +0200
Message-ID: <20251013144418.310115483@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Xi <xiqi2@huawei.com>

[ Upstream commit edcc8a38b5ac1a3dbd05e113a38a25b937ebefe5 ]

The commit c2c60ea37e5b ("once: use __section(".data.once")") moved
DO_ONCE's ___done variable to .data.once section, which conflicts with
DO_ONCE_LITE() that also uses the same section.

This creates a race condition when clear_warn_once is used:

Thread 1 (DO_ONCE)             Thread 2 (DO_ONCE)
__do_once_start
    read ___done (false)
    acquire once_lock
execute func
__do_once_done
    write ___done (true)      __do_once_start
    release once_lock             // Thread 3 clear_warn_once reset ___done
                                  read ___done (false)
                                  acquire once_lock
                              execute func
schedule once_work            __do_once_done
once_deferred: OK             write ___done (true)
static_branch_disable         release once_lock
                              schedule once_work
                              once_deferred:
                                  BUG_ON(!static_key_enabled)

DO_ONCE_LITE() in once_lite.h is used by WARN_ON_ONCE() and other warning
macros. Keep its ___done flag in the .data..once section and allow resetting
by clear_warn_once, as originally intended.

In contrast, DO_ONCE() is used for functions like get_random_once() and
relies on its ___done flag for internal synchronization. We should not reset
DO_ONCE() by clear_warn_once.

Fix it by isolating DO_ONCE's ___done into a separate .data..do_once section,
shielding it from clear_warn_once.

Fixes: c2c60ea37e5b ("once: use __section(".data.once")")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 include/linux/once.h              | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e9..8efbe8c4874ee 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -361,6 +361,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	__start_once = .;						\
 	*(.data..once)							\
 	__end_once = .;							\
+	*(.data..do_once)						\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
diff --git a/include/linux/once.h b/include/linux/once.h
index 30346fcdc7995..449a0e34ad5ad 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -46,7 +46,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE(func, ...)						     \
 	({								     \
 		bool ___ret = false;					     \
-		static bool __section(".data..once") ___done = false;	     \
+		static bool __section(".data..do_once") ___done = false;     \
 		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
 		if (static_branch_unlikely(&___once_key)) {		     \
 			unsigned long ___flags;				     \
@@ -64,7 +64,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE_SLEEPABLE(func, ...)						\
 	({									\
 		bool ___ret = false;						\
-		static bool __section(".data..once") ___done = false;		\
+		static bool __section(".data..do_once") ___done = false;	\
 		static DEFINE_STATIC_KEY_TRUE(___once_key);			\
 		if (static_branch_unlikely(&___once_key)) {			\
 			___ret = __do_once_sleepable_start(&___done);		\
-- 
2.51.0



