Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036450;
	b=D22k+KCJgxBzVcsnTJWrq2k4tZVmMb/n3nBieHxZPonUb7a9wvRLIF1h92ynkxgwxXOV
	 JikRy+ScAa/8eNDxJ/wXf4bMMdgAyRuMjoUeugy9EhlwuSt1ztqAGt2Amg4maxxfCju8w
	 99To218ToPzUwUk7oyXITwQZ6LJR9gTt566zLHroyotlV0Y0IN5DLGPOEvjwwOJajViqv
	 Q57sMJjeThShV8O1Q952A2s3rLzSk+pqQW1SaxjENbH0AAbptEBPgKBKMPt2HIJ5/aQM1
	 jtERuw201jKFtQwWUu9BQJiXZTDU7rdjm7wFatFNE1+l4I+cnqsTmJ6uPLpGc64X2tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+LVZkGVIql40VzRcdrRqyiyG1oyQX2kLe3r9il4QVzQ=;
	b=BKYPHkabUSbv38pTzSB8njKz1KYBeD8mstqFPWkykRnsojtYthydz0qf+G/2KXpIuImV
	 ObzgA3AEvukmEXAk0BfBT/WfAKAQjovfjPfEt37E04u9x5mGkiYMYzesX8IWJXmkHYwn/
	 kk6e3vf81IqgmRqAvCMOrGtMQHZpUGfOMLbP4j4QM3tMTsCgFWaNTAMTri8dhusvi5Ljd
	 k2C86iC71tgZfp3BSC/OaVoISJwsmvIVxfL9Ys+13XHc2I5VkSE5M5KvNIWCFWwremAcQ
	 8pbJM9iI3I5TJ/ibqUk7KtzuxMHedD9fxG8RfPJHUL+FFqcMSW0dmL/sM26Sj0N3djA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+VThvDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B3606A31C;
	Wed, 18 Nov 2026 21:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+VThvDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5841F000C4;
	Wed, 18 Nov 2026 21:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036450;
	bh=+LVZkGVIql40VzRcdrRqyiyG1oyQX2kLe3r9il4QVzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+VThvDw6tF8ZdFip39gIQ1KN7Ap2QpMscUFI9c9oE4sWjWo6jgGV1La8ELD2BlWv
	 3TilYWsdYeMW3jL6dkq6HCtx66Akh1/LoR2PSM899cr+WvSQ89mDxcxPNVBUS/e26m
	 j60JgOeL6lpVU/yUBxCs2lopsIdlcsM+mi/miFs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DAI RENJIE <drj19981414013@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Mark Brown <broonie@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1020/3318] resource: fix lost wakeup when waiting for a muxed region
Date: Wed, 18 Nov 2026 15:27:22 +0100
Message-ID: <20261118150350.483598966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DAI RENJIE <drj19981414013@gmail.com>

[ Upstream commit 405c00e43a9c72a0b9b318cc2d2e298386ffb58e ]

A task waiting for a muxed region can sleep forever in
TASK_UNINTERRUPTIBLE even though the region it waits for is already free.
__request_region_locked() queues itself on muxed_resource_wait and drops
resource_lock before setting TASK_UNINTERRUPTIBLE, while
__release_region() wakes the queue after dropping the same lock.  A wakeup
landing in between finds TASK_RUNNING, does not match TASK_NORMAL and is
discarded; callers hold a muxed region only across a bounded transaction,
so no further release is coming.  The task is unkillable and its caller
never returns.

The window is one store wide, but an interrupt is enough to hold the
waiter in it, and the machine this was seen on runs PREEMPT_DYNAMIC in its
voluntary default.  Since v6.11 spd5118 exports the DDR5 sensors of AMD
boards through i2c-piix4, which takes a muxed region per SMBus
transaction; a third of the in-tree users of request_muxed_region() are
hwmon drivers, so reading a world-readable attribute is all an
unprivileged user needs to drive the contention.  The blocked task sleeps
holding the i2c adapter bus lock, and 27 more piled up behind it.

Reproduced by building a kernel with the two orderings selectable at
runtime and a 2ms delay inside the window.  Switching only that knob, a
two-thread barriered reproducer loses the wakeup 200 times out of 200
before the fix and 0 out of 200 after it; without the delay it goes 20000
times through the wait path and loses none.

Fix it by setting the task state before dropping resource_lock, as
prepare_to_wait() does: the releasing side needs resource_lock to unlink
the resource, so it cannot reach the wakeup before the state is published.

Link: https://lore.kernel.org/20260821-b4-resource-muxed-lost-wakeup-v1-1-37eb6473a76c@gmail.com
Fixes: 8b6d043b7ee2 ("resource: shared I/O region support")
Signed-off-by: DAI RENJIE <drj19981414013@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Mark Brown <broonie@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index d61e040c7b6de..6203a9efa5b04 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1242,8 +1242,8 @@ static int __request_region_locked(struct resource *res, struct resource *parent
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
 			add_wait_queue(&muxed_resource_wait, &wait);
-			write_unlock(&resource_lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
+			write_unlock(&resource_lock);
 			schedule();
 			remove_wait_queue(&muxed_resource_wait, &wait);
 			write_lock(&resource_lock);
-- 
2.53.0



