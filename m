Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EB521171A;
	Thu, 12 Dec 2024 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016390; cv=none; b=A3loYUlgZDwIByY7JY1gGwW6J3+h2yZR1aT0UylHu0xTcWIebzLfTaDHbcBftWNCTQsb/HlSSleSREWV5wIjIE0G4nf0uqF7Aa3DFLM3H4LSje6GjfXJ4ATg57ww2N3yUqMPPzybZEgtu8KueHqrqsr9hsD4dqZmzwAakaM/vIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016390; c=relaxed/simple;
	bh=TIxr09cVMGH6U+V8XWvLTtn0OMwI2SXRkPWHr+i8f/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ab4yjp5ZdtYInnfJb+8FdxhW5Lyk2Vk1Qlu9eK75hCr2rjVMKHj74xH11NsB3VX/sdJ4YT5LR7Gm2ZOyIFXOgyAjQ6lH17NXPSPUNKj4bmEykNGY15e2jb9ShkG408r7OtocAdYcz+WCLpFrnsy4sDSnXY5cN5ZYDDbF+diA4cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVlz6DRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVlz6DRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6302FC4CEE0;
	Thu, 12 Dec 2024 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016389;
	bh=TIxr09cVMGH6U+V8XWvLTtn0OMwI2SXRkPWHr+i8f/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVlz6DRcS0ZAgbt8Jua5nC/x2ylOWXTPPpV5/dK4wl4KUrPKjhHnrUH5AvyUy1RAU
	 OkMcd09/cteG6UHYFZt9vB4ks2xacV0ji2q6Jr3a6jGu2EByeF/6J2rjrgHL06wa4B
	 /2FxMLkPgubbOicTF3vX/+iooHeECAM6laqoP/9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.12 185/466] dma-buf: fix dma_fence_array_signaled v4
Date: Thu, 12 Dec 2024 15:55:54 +0100
Message-ID: <20241212144314.110518155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 78ac1c3558810486d90aa533b0039aa70487a3da upstream.

The function silently assumed that signaling was already enabled for the
dma_fence_array. This meant that without enabling signaling first we would
never see forward progress.

Fix that by falling back to testing each individual fence when signaling
isn't enabled yet.

v2: add the comment suggested by Boris why this is done this way
v3: fix the underflow pointed out by Tvrtko
v4: atomic_read_acquire() as suggested by Tvrtko

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12094
Cc: <stable@vger.kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241112121925.18464-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence-array.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-fence-array.c
+++ b/drivers/dma-buf/dma-fence-array.c
@@ -103,10 +103,36 @@ static bool dma_fence_array_enable_signa
 static bool dma_fence_array_signaled(struct dma_fence *fence)
 {
 	struct dma_fence_array *array = to_dma_fence_array(fence);
+	int num_pending;
+	unsigned int i;
 
-	if (atomic_read(&array->num_pending) > 0)
+	/*
+	 * We need to read num_pending before checking the enable_signal bit
+	 * to avoid racing with the enable_signaling() implementation, which
+	 * might decrement the counter, and cause a partial check.
+	 * atomic_read_acquire() pairs with atomic_dec_and_test() in
+	 * dma_fence_array_enable_signaling()
+	 *
+	 * The !--num_pending check is here to account for the any_signaled case
+	 * if we race with enable_signaling(), that means the !num_pending check
+	 * in the is_signalling_enabled branch might be outdated (num_pending
+	 * might have been decremented), but that's fine. The user will get the
+	 * right value when testing again later.
+	 */
+	num_pending = atomic_read_acquire(&array->num_pending);
+	if (test_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT, &array->base.flags)) {
+		if (num_pending <= 0)
+			goto signal;
 		return false;
+	}
 
+	for (i = 0; i < array->num_fences; ++i) {
+		if (dma_fence_is_signaled(array->fences[i]) && !--num_pending)
+			goto signal;
+	}
+	return false;
+
+signal:
 	dma_fence_array_clear_pending_error(array);
 	return true;
 }


