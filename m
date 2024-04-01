Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E5F481B8;
	Mon,  1 Apr 2024 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987239; cv=none; b=l7u6rnBbJ2P9fSYP4r3QH+k1mzeVVB5UYxDoVsZBWoA6honrABA4PUQCjQjSsEMAL3e4givsdizragxernQzIYkqRWyH65S1r6Ru0jhAVmHVTz/n3xUAInAllKASkwYiMKBZqbhcTFjZkzCY71lc5tvVaOHfVy0CA5cbCHBPT/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987239; c=relaxed/simple;
	bh=cdiA7QGYYUdaeinylAKAo+zVafBkoPh6u5roKiuTUEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVV8CBA9VhBkNAvDvLXa95ELHeMoUyY7zwPZsURPhDpbYUc7Jh5tyb2sELpjFo/JY3sGsKI+q6jvWhuQNMQrRv1H+ALFbXCeN+lN0rKdxuOCEaFnuAKMWUqFJpBCOtsPWOrnW+9Ca0xnXhSDQLcL5Jg7QAYxgR4Xv5FEN3bdCZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax7t2oJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax7t2oJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2873C433B2;
	Mon,  1 Apr 2024 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987239;
	bh=cdiA7QGYYUdaeinylAKAo+zVafBkoPh6u5roKiuTUEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ax7t2oJfSCHb4nA91mVZt2EPALE1hsMa3cbnBDCv2dFvp4xXZftPgGi/2LVnVbjMy
	 40crSIJvWiv+G9ZRB/TzU7YW2kHupWJaRey2RGGRpBgL3z59dOrn9mT8NsnnZBzW63
	 7EWBBlfqTUwm5MfqIxnwfmbn04FH0Jpy27unva5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 199/399] LoongArch: Define the __io_aw() hook as mmiowb()
Date: Mon,  1 Apr 2024 17:42:45 +0200
Message-ID: <20240401152555.121043105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



