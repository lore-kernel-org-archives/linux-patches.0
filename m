Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046268;
	b=mkQvTatyYGhekMU1d9/3Ol9jdujvcbY6O//drE/3nRiKZENrbN5XZFydmMBlIwqan9Qi
	 qZboaul1KYaOvY2xMTN34g7JCIbggJGiZUC7WXYsUpnyME8FRXssftN49YgMjek8VrTU2
	 C50/Rzr2HEEcxPLZxlkkWXoEIK2hdWuVSgvQMSq6nnpsvWuCcPZrvk9zNaC3oL797pAKP
	 FkXBrY5EfyerGMxvg9RI8POkRGMammdXFLULioAe4WZ80a77iaExZJjvuKL0h03ZFYelM
	 1hVmlLOU/ubHaTwvTKoZ0uphxvIvxNb1pQ7ijpMsswdMwnzuv1AqbFYxhRk2gmd+jWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tKfXS89ST2GcrFecYTY0asrcKU5SNVQPuu9ts7a+QRY=;
	b=sRZhNsEAK9Q7Cj/kvuNSiCotozyuSHNXgV+WOq+Ny/5Mg/SC5FIe4PfIgVJJ4SX1gkbo
	 /hNsfJkfjPsLhYQP397fcbDadHKMN4pgHKn5cAFbDitQcXhaK/E5OSEzQy2hbbyKjg8yP
	 ljz0tA6D57DOCZZOdhA6E0eAIv+eqQoiRAGs0N3KBZqDVYMY/ZMyzv3NS1szzt+kqxbe0
	 VklJTPMsEkODTkR2/6WznBoUNACvVuVcQQvtnI5ztupFV/cGFZLZa3HyhAm6ac9G8Oaw5
	 4u5fV5zdd9sUKT4xNDp69BMgFqih155EvY0jvMP95sKtwx+k7uD3uTTW0F/7g4xlQFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGoYdXVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C7A606A31C;
	Wed, 18 Nov 2026 23:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGoYdXVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713821F000C5;
	Wed, 18 Nov 2026 23:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046268;
	bh=tKfXS89ST2GcrFecYTY0asrcKU5SNVQPuu9ts7a+QRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGoYdXVogCDjYzBj3EMT2YKOiIF+bzMooMga7YlXYh2sMSkq9rl0sYq2HcNLretxd
	 EUmjF/toR+5mD2RLkeEpSTheYvvUBN3gxCzyvxA/Cp1bszjIiBddOF92dhmmCmoIzM
	 ubs3y+b2vSU92QPVOrmQJJ8qhu+d0T6XNqpP9m5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1221/2857] drm/i915/gem: Reset err for each fence entry
Date: Wed, 18 Nov 2026 15:37:35 +0100
Message-ID: <20261118150245.536645480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8dc53b4d1ebd3..059d153fbc4fd 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2769,7 +2769,6 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 	u64 __user *user_values;
 	struct eb_fence *f;
 	u64 nfences;
-	int err = 0;
 
 	nfences = timeline_fences->fence_count;
 	if (!nfences)
@@ -2807,6 +2806,7 @@ add_timeline_fence_array(struct i915_execbuffer *eb,
 		struct drm_syncobj *syncobj;
 		struct dma_fence *fence = NULL;
 		u64 point;
+		int err = 0;
 
 		if (__copy_from_user(&user_fence,
 				     user_fences++,
-- 
2.53.0



