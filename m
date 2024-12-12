Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6A621B91D;
	Thu, 12 Dec 2024 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018012; cv=none; b=Z5j2CZggTOQ9pYMINn96dbnX7sM5kWTIyd3I6DxlEy19wky40DzGJTXdpC/Fupb7i7t76K2PNVdfQOX73BQS4h/eYaAsIRk48oRs2/HouFuheSdqRO7MJrAaYRzguSGCdpQYo9Tgu99iYaJGr0h65bVjPAb5jpIu7dFhFrgeZAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018012; c=relaxed/simple;
	bh=1SCLVJVkGWfH9gBnYCTTM0JS+44MHKQ1G8urEd6fKjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLpuft9voxASV7Vaj1aoKrRn5K25vPD+tqY/PWQZh/IRYBn/tT8e+Kzpi0lKXsD9SmJysmRn3rEN6QI+Fl38oZpCHagk5HVWefOUOaIw4sMYdLkYXxCfVIYyTD8XVOSmQDuIls8IdXeQ5HkbLZkbGoXE54IoRi78PyenduufGao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gxf7J/Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gxf7J/Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF780C4CECE;
	Thu, 12 Dec 2024 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018012;
	bh=1SCLVJVkGWfH9gBnYCTTM0JS+44MHKQ1G8urEd6fKjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gxf7J/ZpGO/FN9fHy9mRxrUZ6/83HCfbE+NnwG0aSV/a/5CiSV2fOyTAlaOJ68uuP
	 yfRbjluF1gvBM82Y2e4SaKoVlUBPuGlc0a1FazZJQDMQ17FHrKJ2P9qnrmreq/cM0C
	 Xg43X55rN0Jx5oaztuldsSePoodAVguqMerSeaO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.6 173/356] dma-buf: fix dma_fence_array_signaled v4
Date: Thu, 12 Dec 2024 15:58:12 +0100
Message-ID: <20241212144251.469163279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


