Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F2640315B;
	Tue, 21 Jul 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654858; cv=none; b=s6GWsr6dc7Xai1bCkT4/X5hk6OI0rB1/mR0yIwxIpcqPWKHjZkaopKxsVKn1YxOf88jQBBc59XB9H0RCWsv7MGx5F2qvc8gH287SBGSPjdrE/KoCJ5Rkk5Ae8IfJOXInlSf/jZwTQqYCyM62LyUvPrZWd5xWc5gc7U+XorCkpos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654858; c=relaxed/simple;
	bh=nzqZyhigwT2xDzx229cRW8X1lFzrQnYQ5lID9u16SVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/OI7x+24A1uGg63iRwRLZQkbTpomyf7ylfzrfJUry/ikTuVzdLhIGspiURoR2slwKkebkyvVIC4dL9Vg10ewYbt/fIUop8myJpsA5V0sjJUBFd73BG87t7GSdIiQjmfFBl90Yl4bi9+SAfjE578Nkm3kf0IRnXdL+W1LKeQupI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiAKCJM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiAKCJM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57C41F000E9;
	Tue, 21 Jul 2026 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654857;
	bh=MwB2CgI1ViSp0/I9oVqzuyMdcAJBDSdqFlvH5QWnKMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiAKCJM4CeU672K3tIopSZTDA8GOktH2RHJwA75wOg6emHtHmWavpHFpg/QZXcYs2
	 d1W/5XUtGkRFlB0AdssU4bA9snAb9GCEHm6fmR/ifSZrFzpQ649pF/eheO+yfwIdoU
	 ogZ19hkx91BAYaeOXssi/dp89Asm+e05qtfUg2mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.1 1864/2077] dma-buf: dma-fence: Fix potential NULL pointer dereference
Date: Tue, 21 Jul 2026 17:25:37 +0200
Message-ID: <20260721152636.698890027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit 035219a760edb35ae9a9e96beba7f122e26a997b upstream.

The commit mentioned in the fixes tag below introduced a mechanism
through which fence producers can fully decouple from fence consumers.
This, desirable, mechanism is based on the fence's signaled-bit as the
"decoupling point".

A sophisticated interaction between RCU and atomic instructions attempts
to ensure that fence consumers can still interact with fence producers
through the dma_fence_ops (callback pointers into the producer).

This is the desired behavior: to check for decoupling, the signaled-bit
is first checked. If it's not yet signaled, RCU ensures that the ops
pointer cannot yet be NULL.

Hereby, dma_fence_signal_timestamp_locked() first sets the signaled-bit,
and then sets the ops pointer to NULL. Readers first load the ops
pointer, and then check through the signaled-bit whether the pointer can
legally be accessed.

These set and load operations could occur out of order on weakly ordered
platforms. This problem can be solved very elegantly by using the ops
pointer itself as the synchronization point. The pointer is either NULL,
or cannot become NULL while it is being used thanks to RCU.

Replace the signaled-bit check in dma_fence_timeline_name() and
dma_fence_driver_name().

Cc: stable@vger.kernel.org
Fixes: f4cc3ab824d6 ("dma-buf: protected fence ops by RCU v8")
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20260629075636.2513214-2-phasta@kernel.org
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -1168,7 +1168,7 @@ const char __rcu *dma_fence_driver_name(
 
 	/* RCU protection is required for safe access to returned string */
 	ops = rcu_dereference(fence->ops);
-	if (!dma_fence_test_signaled_flag(fence))
+	if (ops)
 		return (const char __rcu *)ops->get_driver_name(fence);
 	else
 		return (const char __rcu *)"detached-driver";
@@ -1201,7 +1201,7 @@ const char __rcu *dma_fence_timeline_nam
 
 	/* RCU protection is required for safe access to returned string */
 	ops = rcu_dereference(fence->ops);
-	if (!dma_fence_test_signaled_flag(fence))
+	if (ops)
 		return (const char __rcu *)ops->get_timeline_name(fence);
 	else
 		return (const char __rcu *)"signaled-timeline";


