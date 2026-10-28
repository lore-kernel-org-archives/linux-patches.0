Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207605;
	b=N8qC0LwegDtfRxn83ov1TorEi4ClL/AEP8IDg6xrfUHXRRVHzHYAskZQzmbLGV3/makQ
	 9AUEqSANRl+A0Za418BqSrQgvBMuBaHHzPfU9Uud2cXgZjQ6NaKSr4TrF9ADi+TqrZFyq
	 XBcW9mEkyyzcgvBJrWVJ/XWu88VRHHNQH1384oreYzr/03CobSf/jht5blQtvUr2wY6BT
	 Z8qv0cGGmUg2W4kMEXycizVhp0dEKYCOt6xhHJ476HJjoW26X7zGuzlY1Xb7WhtKKuez1
	 BF99RnAgQ4YrwVo2BU5cD+S8GNzoitfshT5D6HZLN2MMM6UKcvHyzmCopP5exqUP1LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4msmo3hG3pma8LU2SGhtl6Tejwl+54T3teg6GhEvnLs=;
	b=Wr7BOKBdcxrQDLu1GOofB/s5YSCYjL48RQZhxakU5okcGj7JbGIovJzE7lfbc0/FAOvA
	 qP2Q80MxvA+7LUQQ0XVtvN9ZpaBeiT2b6xRXvyALVtlD4LcijI2tH9wfhAqU3XK204lEs
	 sj2zdJNalHaAKoa88aDEZb7IgOl9fKL1zhlW5eVCp8/Z4eAFB4vprRcL1gK1gX5eWUmtC
	 aE8yd6UKfflgM2009JXGAOspSOuC5pcb/kElnR0vBQt88u4NTD8tuAEPROJ1U5uFtNxMG
	 1wNHdcELFXgWnCwDGnkVDPf0KKZ00KWHbMjkucvRUwDiK7UimiA0YwMp/vtmKC94eVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMkee+nb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C9B606A32F;
	Wed, 28 Oct 2026 17:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMkee+nb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856F61F01828;
	Wed, 28 Oct 2026 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207605;
	bh=4msmo3hG3pma8LU2SGhtl6Tejwl+54T3teg6GhEvnLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMkee+nbAMf2Zdq4H/8+Cyu52Kgq9/xQkodSsKtLaxJMYqD/5qJ/0o2TyvmSia4Su
	 4yB0TCqSCVwJL6TjNxIHiCOPGirR0CtJJvYL/7hPvpa38EdSLVmTYa+3giUgX/ZYs3
	 rGcCOhTQY2kYQ2vl4PlkhGVYEmlC33ytfJMcubug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/247] regcache: Do not overwrite error code when finalizing cache after error
Date: Wed, 28 Oct 2026 17:57:21 +0100
Message-ID: <20261028165948.269563483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 9108f7fa493b4c88cbc09503e0c164244456bad5 ]

During regcache initialization, if an error occurs in the
cache_ops->populate callback, and if cache operations include an exit
callback, the error code from populate() is overwritten with the return
value from exit(). This hides the error condition from the caller of
regcache_init(), and can cause NULL pointer dereferences when the regcache
is later accessed.

Fixes: 94a3a95f0315 ("regcache: Add ->populate() callback to separate from ->init()")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20260616114429.1852456-1-flavra@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: abff0a48b110 ("regmap: Drop map lock during cache init and exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d2630a55bb50b..0e929e7ac68aa 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -216,7 +216,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n", map->cache_ops->name);
 		map->lock(map->lock_arg);
-		ret = map->cache_ops->exit(map);
+		map->cache_ops->exit(map);
 		map->unlock(map->lock_arg);
 	}
 err_free:
-- 
2.53.0



