Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FA84AED7;
	Mon,  1 Apr 2024 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989860; cv=none; b=RM2OUYwh3KtOBDUerMPoeRuSDE69bBEhy6Ot7ORxWLxxJx1aFDOwOGL8q8bfbsQLT7PUy2AbFpqXIwaEaqxAsJTsOGGROFPYMz0z9U9LR8aIdPAT0mLeePzZGjTO3SrhAZHslEwV67ck8kcGs5zdB1MUSbi/216jq4n0hb5uFCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989860; c=relaxed/simple;
	bh=6PUi2Soxd1XNmau6acYtpe5mkToew0QdcensuVOGhPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT1//9h8aTkn75FCv+5O6w/oUsj3rvxDhwN/EEBETdQ1mFw0yD2gV6LyMucahJHdgeOOCMnZfPAZ9KVjHmsSJE+mP5ZFvLWHcX4Y4foW+SBzSZbOv4e241UxNIE1oEsXx3lyb3TV+vf4P3kkYRkQDyiPygwleXIlcbuuu0c8/uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kjo47z1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kjo47z1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4395C433F1;
	Mon,  1 Apr 2024 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989860;
	bh=6PUi2Soxd1XNmau6acYtpe5mkToew0QdcensuVOGhPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kjo47z1q/rko7E1WqQ4y0P6osMAnY0LyG4F7TZWCk1K0G1XHmUzoVt6PjVU4l1cnv
	 YL5gvD4A8eEZBdGd8jKRdRUzsDs7fTvrzPfzmwVZYgzoO64WrjV5WdGvA2KEJivSmw
	 ceLtCeKedfMqRZw4/c2HySWCLCrf/TUN3pAuNBsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/396] LoongArch: Define the __io_aw() hook as mmiowb()
Date: Mon,  1 Apr 2024 17:43:43 +0200
Message-ID: <20240401152553.131761490@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 9c68ece8b2a5c5ff9b2fcaea923dd73efeb174cd ]

Commit fb24ea52f78e0d595852e ("drivers: Remove explicit invocations of
mmiowb()") remove all mmiowb() in drivers, but it says:

"NOTE: mmiowb() has only ever guaranteed ordering in conjunction with
spin_unlock(). However, pairing each mmiowb() removal in this patch with
the corresponding call to spin_unlock() is not at all trivial, so there
is a small chance that this change may regress any drivers incorrectly
relying on mmiowb() to order MMIO writes between CPUs using lock-free
synchronisation."

The mmio in radeon_ring_commit() is protected by a mutex rather than a
spinlock, but in the mutex fastpath it behaves similar to spinlock. We
can add mmiowb() calls in the radeon driver but the maintainer says he
doesn't like such a workaround, and radeon is not the only example of
mutex protected mmio.

So we should extend the mmiowb tracking system from spinlock to mutex,
and maybe other locking primitives. This is not easy and error prone, so
we solve it in the architectural code, by simply defining the __io_aw()
hook as mmiowb(). And we no longer need to override queued_spin_unlock()
so use the generic definition.

Without this, we get such an error when run 'glxgears' on weak ordering
architectures such as LoongArch:

radeon 0000:04:00.0: ring 0 stalled for more than 10324msec
radeon 0000:04:00.0: ring 3 stalled for more than 10240msec
radeon 0000:04:00.0: GPU lockup (current fence id 0x000000000001f412 last fence id 0x000000000001f414 on ring 3)
radeon 0000:04:00.0: GPU lockup (current fence id 0x000000000000f940 last fence id 0x000000000000f941 on ring 0)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)
radeon 0000:04:00.0: scheduling IB failed (-35).
[drm:radeon_gem_va_ioctl [radeon]] *ERROR* Couldn't update BO_VA (-35)

Link: https://lore.kernel.org/dri-devel/29df7e26-d7a8-4f67-b988-44353c4270ac@amd.com/T/#t
Link: https://lore.kernel.org/linux-arch/20240301130532.3953167-1-chenhuacai@loongson.cn/T/#t
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/Kbuild      |  1 +
 arch/loongarch/include/asm/io.h        |  2 ++
 arch/loongarch/include/asm/qspinlock.h | 18 ------------------
 3 files changed, 3 insertions(+), 18 deletions(-)
 delete mode 100644 arch/loongarch/include/asm/qspinlock.h

diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/asm/Kbuild
index 93783fa24f6e9..dede0b422cfb9 100644
--- a/arch/loongarch/include/asm/Kbuild
+++ b/arch/loongarch/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += early_ioremap.h
 generic-y += qrwlock.h
+generic-y += qspinlock.h
 generic-y += rwsem.h
 generic-y += segment.h
 generic-y += user.h
diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
index c486c2341b662..4a8adcca329b8 100644
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -71,6 +71,8 @@ extern void __memcpy_fromio(void *to, const volatile void __iomem *from, size_t
 #define memcpy_fromio(a, c, l) __memcpy_fromio((a), (c), (l))
 #define memcpy_toio(c, a, l)   __memcpy_toio((c), (a), (l))
 
+#define __io_aw() mmiowb()
+
 #include <asm-generic/io.h>
 
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
deleted file mode 100644
index 34f43f8ad5912..0000000000000
--- a/arch/loongarch/include/asm/qspinlock.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_QSPINLOCK_H
-#define _ASM_QSPINLOCK_H
-
-#include <asm-generic/qspinlock_types.h>
-
-#define queued_spin_unlock queued_spin_unlock
-
-static inline void queued_spin_unlock(struct qspinlock *lock)
-{
-	compiletime_assert_atomic_type(lock->locked);
-	c_sync();
-	WRITE_ONCE(lock->locked, 0);
-}
-
-#include <asm-generic/qspinlock.h>
-
-#endif /* _ASM_QSPINLOCK_H */
-- 
2.43.0



