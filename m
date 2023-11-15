Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214743AD2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsdVBSH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B7EC4E765;
	Wed, 15 Nov 2023 20:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081527;
	bh=WyVVfF0CTGbq29/CQQwAa3k0TH0qInGTuP9v7PhmfZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsdVBSH1e3dveIMiHxDkvV3aKacXa8MNEv6f70KdC8sQ7m8aHJdeIzM2q+I1OtWsX
	 QYVWQvShl6KNHafue/PMaNf6DgvmEnwg2IDKhbu/m5gjDlyhC78/bGKGc2h4CrWMoG
	 Ob75X1ZUV37/OSzqxRdoqsTe9MKlz4GxMNhRphD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/244] regmap: prevent noinc writes from clobbering cache
Date: Wed, 15 Nov 2023 15:36:40 -0500
Message-ID: <20231115203600.841012292@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Wolsieffer <ben.wolsieffer@hefring.com>

[ Upstream commit 984a4afdc87a1fc226fd657b1cd8255c13d3fc1a ]

Currently, noinc writes are cached as if they were standard incrementing
writes, overwriting unrelated register values in the cache. Instead, we
want to cache the last value written to the register, as is done in the
accelerated noinc handler (regmap_noinc_readwrite).

Fixes: cdf6b11daa77 ("regmap: Add regmap_noinc_write API")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Link: https://lore.kernel.org/r/20231101142926.2722603-2-ben.wolsieffer@hefring.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 617d51a278497..7621b54975b57 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1683,17 +1683,19 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 	}
 
 	if (!map->cache_bypass && map->format.parse_val) {
-		unsigned int ival;
+		unsigned int ival, offset;
 		int val_bytes = map->format.val_bytes;
-		for (i = 0; i < val_len / val_bytes; i++) {
-			ival = map->format.parse_val(val + (i * val_bytes));
-			ret = regcache_write(map,
-					     reg + regmap_get_offset(map, i),
-					     ival);
+
+		/* Cache the last written value for noinc writes */
+		i = noinc ? val_len - val_bytes : 0;
+		for (; i < val_len; i += val_bytes) {
+			ival = map->format.parse_val(val + i);
+			offset = noinc ? 0 : regmap_get_offset(map, i / val_bytes);
+			ret = regcache_write(map, reg + offset, ival);
 			if (ret) {
 				dev_err(map->dev,
 					"Error in caching of register: %x ret: %d\n",
-					reg + regmap_get_offset(map, i), ret);
+					reg + offset, ret);
 				return ret;
 			}
 		}
-- 
2.42.0



