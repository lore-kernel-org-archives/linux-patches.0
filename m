Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195B3BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3K16g1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01DAC433C9;
	Wed, 15 Nov 2023 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077811;
	bh=Ra5QKiMrgzVT3gcxVyCS0HVeGm0GE6Gw+e7qWPpI0tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3K16g1c+AiCNBVZDUPs9RVo72PTWiE32SOpT4sif+lsC1M+a80VYIqUegQjicTow
	 7iRdSULgeAt52v08w7Dv6ufMfMEO0nGMTO9cM2pIXCRzkk1iWkeUBIahunFSAfKbX3
	 spkCtKjvejuOf0bKe3sV6mkQy5dkh5vAmwQH1QEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 533/603] regmap: prevent noinc writes from clobbering cache
Date: Wed, 15 Nov 2023 14:17:58 -0500
Message-ID: <20231115191648.769451324@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 234a84ecde8b1..ea61577471994 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1620,17 +1620,19 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
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



