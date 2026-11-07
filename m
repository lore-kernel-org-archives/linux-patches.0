Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062215;
	b=fFkutD5F778SxYEqZj0emePlmh0WA8sKJn5Qbr1w9uXO63+kH1qUU6qVvU5mm4Fs95Sj
	 WMXSchMX4F7/O7FAqnB4RS5kB7Out8mdZw7M3Nojzdx7ug3WoyB3KUTBUp29VaAn0emno
	 oKc9giF+K7cN92LX3tUGtWq8GQOuWrRUOmXQU3pFMN88iRDr27N5LvwnQm40UMjIyGpTE
	 07NdfgFiu5+KsUoW8DwnI7WPZfGNYeTpDMpaXyc8oaVVIhcdI/GObdcaf3XFmMx6OgRBX
	 9AXScmwjhNsgXGe2y3HoZuJCMU4ynnSoFA1SGqItwWpPwns0Fi+4luuV0TsPQDQeFjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7qhvcln9riQ9YIKsGcpQ1lIe0GSBPNvuBmTmIJye69g=;
	b=SFnxObY078+MxeIB9ZbTvmpXyxtGSnqIGzyPGbAAFj9JXciJY9bxCOr7dXpSHQHCeIM4
	 o8VPQMKR0IxaDF40aXRZSZkoXIOP1DbRU6jMEf0uCLtQNn0YcCm3vaszQ76887MPXjizu
	 HMKuje69HukueRyV2svZEvNQshQpNneEcN6cH5NJXgwnCEtAOwgBcJRetOPvVO2FVsLCH
	 f/MhTPv4T2odqUWT4GrupfTb1v8bK/ws/aAl9qF1XaeQiGnVjP8ef+7ECBbGZbDmnzA/B
	 ZvbZ3xG88FBiOOHWT+vIadpUp9IHgabt8tEEDMwhfe2gUXOuoEJfDfnzXtRQKYjUmCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5qFPFc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC223606A326;
	Sat,  7 Nov 2026 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5qFPFc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4511F0089F;
	Sat,  7 Nov 2026 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062214;
	bh=7qhvcln9riQ9YIKsGcpQ1lIe0GSBPNvuBmTmIJye69g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5qFPFc39Dw4wUIo2vnrUVHe5CIOFYck7cx/c4lzXkrCEPS/qKedroXbZknux3wbO
	 KcsXI6/UdQu43h01R0aX1NjR4bn1deTvS1M1gCb2GYkh2PxvLY855uhj+139WMRL5C
	 tSiWUPfRAALBuwa6xwUm1Mn8WSHvo3l7pR+JsyDE=
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
Subject: [PATCH 6.12 1169/1536] resource: fix lost wakeup when waiting for a muxed region
Date: Sat,  7 Nov 2026 08:53:05 -0500
Message-ID: <20261107135030.566522204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2922e5c85ef65..5b0e2c43ff7da 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1283,8 +1283,8 @@ static int __request_region_locked(struct resource *res, struct resource *parent
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



