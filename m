Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773858;
	b=vQGAhHxjDygKQv4X2qcK/ncbOkvX5kBZzIl/CUigHjOR/NKMHdxjX9kJeRESARQRaqE2
	 37I2gM1ip7gGEX3ShHw8PNNkFVcVHtoDKp3ueXd8eB0moA0ekWjgyFtihVfXlkULaJ6YC
	 ++BfaSVhzFLClxfNmZ/vA1uIftHekijpYOaTM0EKxliqjXiPpPU4pYGYoTlk0mr6P3udi
	 0hX9o6WlBlNTkIpBRZoKxEBkmbKb2XgsWsWGIR68gUbqivRuCknLBgsoh7MgDmHCtLSB6
	 BYev9OYEvNwsQv/1waZ7TfO7mxST3Q3MViuwLf7dIIhndrRfKgaBD2sigwo/F7c7aIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ebKZkeMZ+TIoGqVZ6YMBHhPWzhF2O+fR+BlLgEsYjqQ=;
	b=AvS0Stgy+UONg4S3TKcScglnAbCLKVeWaGbriO87jA3e0wEudZNooKNI9JUIEP4A1iZo
	 oIMPAJj6BvfSv3GZeK50925feN2s9QTOMI/LUWQE4pgoT4eoc8l5/f1+/VXZ3MUpO3j3D
	 JzSWolkgM2U8gOrl+OaBwov3+9qdk1LPt6iHQMGyDmknNCIUME1SbrZjDg+5sF3fxUS6k
	 1zfpMIzl+z4aq0T2QjCQs7VHIBXt5lRDMfr7OU6rAjgGzS/mnw3yrOipOgiQ62f5+jJGU
	 G1VtR+f+FFGWTRLO17QIZ1Tp0kB2c4kIQsjIvOfcEK7TQZW9rciB7hbr1l5BlQnz2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJexxzXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3A606A33A;
	Fri, 23 Oct 2026 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJexxzXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3143B1F01825;
	Fri, 23 Oct 2026 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773857;
	bh=ebKZkeMZ+TIoGqVZ6YMBHhPWzhF2O+fR+BlLgEsYjqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJexxzXplQymbpHxPBJN8N4bYfKPuA0+qgMTe+Qkn3bph/L4puV3d+U7UrvipeO7c
	 3eJypmL1czq8I8HEe7vfca0/QVgkvSEEnZqqvQT2WO2dQxgyo7JDThYm8aLHQOnA+4
	 BMwIvWTBORp2Rg3U60I1b0lHwhhbagbdTG5klB4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/193] regcache: Do not overwrite error code when finalizing cache after error
Date: Fri, 23 Oct 2026 18:35:16 +0200
Message-ID: <20261023163715.128347378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 149945690cdf1..e3f53d03340d7 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -236,7 +236,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
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



