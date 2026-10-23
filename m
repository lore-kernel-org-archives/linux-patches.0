Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773864;
	b=gz6A9IQkXe0JVGnYyA8Kp18dwUUuTZ8dphO/tU+X0k+ato8DQlKHr3eECSHu4HgOZKPF
	 wvOTermIwkRDTYESZgfxp6qSGGyDBKTDE7Hvp+govg6bn8m8if4lHFaybO2lvt7y0tT7K
	 fKr1HLnP5wcjFiVA+Eu1r4vBtqkmJ4W/ir4jYXiXGmm9qr9kvxaJgxuFoQSEMi806Ix35
	 ZMOAmrbxXIyWtjK+o+opaPtS9zu7+UOMqW8pm/uGBuq05It/cFuvY1vwuOMJCfML5qcQi
	 M8vmZVRN+D1KdIoTvVex0WiK4hcdT2ol7/Z0EcuGc4mBVdajWgiMxXz3WI1mqaLNrTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2Yv3rEhxRC8+t/8UF6JqTjgT5ywkOMzY+GCvSx9yEY=;
	b=erUXk9a1Mwkld7VpMgVmBN1tNM2po+FMwiD6o+rR3cww1Z7FypLi6wOH1CweKWlWEQud
	 oE492TcyaasGpr7X5uL9HXdksy9BDkwJBr9pxQ2RwzCTQorFg6xMHovtb0dO06+1kIWbQ
	 pvPsHiAzu7DM9YtpnjMrbuymNvsS3MAvHf0Jf6BNsWrHeZMv9LJpqm5K2U5IB/yU77aTS
	 o+OuwnF8hJean75tz/E5qLU02ik/ZvYQL3FpQrp0XvV3DYkYVM23QsYYjZ4JdqKCrvnT3
	 zAdDWd8mVGM+Zb1ekW/IvAw0dn1Biij8b+VWXbfXwd50mUu8wLf5iecqJtMlkDNiowg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6GQLtWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA803606A31B;
	Fri, 23 Oct 2026 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6GQLtWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3721F01825;
	Fri, 23 Oct 2026 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773863;
	bh=Z2Yv3rEhxRC8+t/8UF6JqTjgT5ywkOMzY+GCvSx9yEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6GQLtWiCoZa5rgTfUuNrxiBkJQfRKSCzRIL8WX3Vtv+EVscjvyNeq50sh7WNeBrB
	 /sjaTq+1YCfyx3lDCnJKvmEZrs12q8rofLkvxDslXNxbV2iPjqylyfWtK1baWQLi8L
	 TEt2T/C7ARoKlT2RYT7Gg2p9pKAjmJxjJPZTL78Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michael Reeves <michael.reeves077@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/193] regmap: Drop map lock during cache init and exit
Date: Fri, 23 Oct 2026 18:35:17 +0200
Message-ID: <20261023163715.154790954@linuxfoundation.org>
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

From: Michael Reeves <michael.reeves077@gmail.com>

[ Upstream commit abff0a48b110fe52d43999b4cb7c793a510a6bf1 ]

On systems with CONFIG_PROVE_RAW_LOCK_NESTING enabled, Apple GPIO probe
triggers an "Invalid wait context" lockdep warning.

The driver uses a regmap with a raw spinlock and REGCACHE_FLAT. During
regcache_init(), regcache_flat_init() allocates memory while holding the
raw spinlock. The memory allocator can acquire a non-raw spinlock, which
causes an invalid raw-to-non-raw lock nesting error. The abbreviated call
chain is:

  apple_gpio_pinctrl_probe
    regcache_init
      regcache_flat_init
        __kmalloc_noprof
          __pcs_replace_empty_main
            refill_objects
              _raw_spin_lock_irqsave

Cache allocation occurs before the regmap is published, cache destruction
occurs after users have stopped accessing it, and regmap_reinit_cache()
requires callers to prevent concurrent access. Remove the outer map lock
from cache initialization and destruction. Keep it for cache population
and normal register access.

The Maple cache still uses its internal spinlock during teardown. That
lock can also be acquired from hard IRQ context during register access.
Add Maple-state irqsave helpers and use them during teardown to preserve
the lock's IRQ-safe lockdep state.

Fixes: fd4ebc07b4df ("regmap: Hold the regmap lock when allocating and freeing the cache")
Suggested-by: Mark Brown <broonie@kernel.org>
Suggested-by: Liam R. Howlett <liam@infradead.org>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20261006-regcache-lifecycle-submit-v3-2-37bdd82fd47c@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 9 +++++++--
 drivers/base/regmap/regcache.c       | 6 ------
 include/linux/maple_tree.h           | 4 ++++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 9cf0384ce7b95..38a648efa6069 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -295,16 +295,21 @@ static int regcache_maple_exit(struct regmap *map)
 	struct maple_tree *mt = map->cache;
 	MA_STATE(mas, mt, 0, UINT_MAX);
 	unsigned int *entry;
+	unsigned long flags;
 
 	/* if we've already been called then just return */
 	if (!mt)
 		return 0;
 
-	mas_lock(&mas);
+	/*
+	 * Register access may take the Maple lock from hard IRQ context, so
+	 * preserve its IRQ-safe lockdep state during teardown.
+	 */
+	mas_lock_irqsave(&mas, flags);
 	mas_for_each(&mas, entry, UINT_MAX)
 		kfree(entry);
 	__mt_destroy(mt);
-	mas_unlock(&mas);
+	mas_unlock_irqrestore(&mas, flags);
 
 	kfree(mt);
 	map->cache = NULL;
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e3f53d03340d7..57757adad1f56 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -215,9 +215,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	if (map->cache_ops->init) {
 		dev_dbg(map->dev, "Initializing %s cache\n",
 			map->cache_ops->name);
-		map->lock(map->lock_arg);
 		ret = map->cache_ops->init(map);
-		map->unlock(map->lock_arg);
 		if (ret)
 			goto err_free;
 	}
@@ -235,9 +233,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 err_exit:
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n", map->cache_ops->name);
-		map->lock(map->lock_arg);
 		map->cache_ops->exit(map);
-		map->unlock(map->lock_arg);
 	}
 err_free:
 	kfree(map->reg_defaults);
@@ -261,9 +257,7 @@ void regcache_exit(struct regmap *map)
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n",
 			map->cache_ops->name);
-		map->lock(map->lock_arg);
 		map->cache_ops->exit(map);
-		map->unlock(map->lock_arg);
 	}
 }
 
diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 2ba53c0654678..983a57400563b 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -470,9 +470,13 @@ struct ma_wr_state {
 };
 
 #define mas_lock(mas)           spin_lock(&((mas)->tree->ma_lock))
+#define mas_lock_irqsave(mas, flags) \
+		spin_lock_irqsave(&((mas)->tree->ma_lock), flags)
 #define mas_lock_nested(mas, subclass) \
 		spin_lock_nested(&((mas)->tree->ma_lock), subclass)
 #define mas_unlock(mas)         spin_unlock(&((mas)->tree->ma_lock))
+#define mas_unlock_irqrestore(mas, flags) \
+		spin_unlock_irqrestore(&((mas)->tree->ma_lock), flags)
 
 /*
  * Special values for ma_state.node.
-- 
2.53.0



