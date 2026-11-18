Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037546;
	b=pGwLyKMmXe/DYEl58/YrWOTq44J21A8Fz97lptCNWVgWrsdSQXClTzzyJsFRjI9swoC6
	 upkPrf6f8+ZrcrT300p+l+QNNdP9dU/I66jSV8df4W3xe+toXHpeqXQGivth9ofylO087
	 sk5+4jnLaBonWijisXhhuzGnspPO6Ghl/YrAhIXcB2Btz+e7TjU9tx5VPHhp7GAyX8Y2y
	 Wt4TvjR9zya6Bryg70gQssUq3w4ZLXwPvpn2JzDEswY94pCSlcoyaNq5t2QY+rHfrgPI4
	 vPCvJ48fN6RXIGpOAC9Xsf06fmU6X64QzqYcHUuct42d0VoL6yjDrh7w3xKGdix0qQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1dkanmh9EDDPdIPTRrrh9zfETEqgj6CCZ9t2H9Ogng8=;
	b=b+oqPv5N5aYE4jqA5WiSY6Bite51iWcaf8vz0AQJ6+avMoFAvdqaj7HBOnNsaDJj8ii1
	 k7/IPusR6YSImlMWKKCChudgZFSUmqV+wHp4rQx2L/YNdcfipdscXDzggACRoy8ru18Gg
	 GzJDrPd9bDMFqNtlehyvX8Bg+g+rPfH/xCCvOeVy832FFUA7d40vtm63z19dh0Nr2PKCH
	 G6xSdxRU4PWEOia47fzfyUapgWUM+FKD9WmPn8XQpgpHHtJ60Lywrzdh64iqwgEEh5Qge
	 GdUpP+VsKGuPeeDc4uJVQ+k/5g9MCMqm/oW8OSkNz+uXVsvA0LRlOAeBNlgWaBCIeug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yb07J9os;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF30F606A320;
	Wed, 18 Nov 2026 21:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yb07J9os
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056031F000C4;
	Wed, 18 Nov 2026 21:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037546;
	bh=1dkanmh9EDDPdIPTRrrh9zfETEqgj6CCZ9t2H9Ogng8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yb07J9os6HYG5Mmhi7X6o8mtWfSJON0ZrgDxwf8IhKK85FT6FB3i0g27OB72KqQhK
	 6UF/5zWtRdRG5dYgsNPJYxmbJIy+iW81MnU0mJ9hd24TxXqFvyh1fKm5nsJbDqvSrK
	 6zr/bxGXd+T56+iGkQiZt82WV8KG8ZbaLexRmTH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1436/3318] drm/i915/gem: Reset err for each fence entry
Date: Wed, 18 Nov 2026 15:34:18 +0100
Message-ID: <20261118150403.879645089@linuxfoundation.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 31643dc89818d9b65bf42ecb1c67c99b64146fba ]

If dma_fence_chain_find_seqno() failed once, 'err' will store val in
the following loop. May causing returns '-EINVAL' even though that
entry never called dma_fence_chain_find_seqno() at all.

Fixes: 13149e8bafc4 ("drm/i915: add syncobj timeline support")
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Cc: <stable@vger.kernel.org> # v5.10+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20261027072832.726435-1-yaolu@kylinos.cn
(cherry picked from commit 4e9db08db75f55c920986ac929cfd82a4ee99f41)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index a3519fb5e29d2..011aaee6f4440 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2796,7 +2796,6 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 	u64 __user *user_values;
 	struct eb_fence *f;
 	u64 nfences;
-	int err = 0;
 
 	nfences = timeline_fences->fence_count;
 	if (!nfences)
@@ -2834,6 +2833,7 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 		struct drm_syncobj *syncobj;
 		struct dma_fence *fence = NULL;
 		u64 point;
+		int err = 0;
 
 		if (__copy_from_user(&user_fence,
 				     user_fences++,
-- 
2.53.0



