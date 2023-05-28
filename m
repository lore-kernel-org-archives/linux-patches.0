Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F9B611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3443AC433EF;
	Sun, 28 May 2023 19:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301396;
	bh=DCVNbjGMGfIbz2CpfFSPJzI4jiwj0IB8pQKaeMtyeCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glap5Niv5FSavotllpuO4Ytv4HA9x7/WOQ51e0sDgEecfyKF497M7IpbC8LmdYj0R
	 /61thUVcLWuPonNphTIjD8dfR1HoBo/DRS2yNwC0tdPGxRl3r85CQIOqq9m32S9j1e
	 eNgOr3tzEeTIJyKIX7LVc/081n4lL7Dz6NSbtSME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/132] regmap: cache: Return error in cache sync operations for REGCACHE_NONE
Date: Sun, 28 May 2023 20:09:13 +0100
Message-Id: <20230528190834.009575311@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit fd883d79e4dcd2417c2b80756f22a2ff03b0f6e0 ]

There is no sense in doing a cache sync on REGCACHE_NONE regmaps.
Instead of panicking the kernel due to missing cache_ops, return an error
to client driver.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20230313071812.13577-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 773560348337f..b78e4b6e2c9da 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -347,6 +347,9 @@ int regcache_sync(struct regmap *map)
 	const char *name;
 	bool bypass;
 
+	if (WARN_ON(map->cache_type == REGCACHE_NONE))
+		return -EINVAL;
+
 	BUG_ON(!map->cache_ops);
 
 	map->lock(map->lock_arg);
@@ -416,6 +419,9 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 	const char *name;
 	bool bypass;
 
+	if (WARN_ON(map->cache_type == REGCACHE_NONE))
+		return -EINVAL;
+
 	BUG_ON(!map->cache_ops);
 
 	map->lock(map->lock_arg);
-- 
2.39.2



