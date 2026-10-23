Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773855;
	b=OuL9D6BjqnpxS6D9emdxWnClzBdLA4dHnkny0ZYL49v2RmW40N+9a7CVrKan5eRvf8Ix
	 WzPG9e9cgVrvOJoRcJZrMJgouq+2tr+q7L0DW7mbaQ+kfB3/adli1zxI2R/u8ygaMmGHD
	 n6ZAmVd6A5wcjhMSosVsZWwZA0nlUkJ8UI/xRuh9YAZH4/ROvPcdYW2/lbee0k3BxCXd1
	 fzZLFhIr3zlbztROSgAAiFCBM57/QNekG2RQ+ZrAQxlXGAkmv6Rq6foHfQH53F6eF4dcC
	 bOoxsVOi0tL3PbYORD3lM6v4zQ/DHeq3UVb2VXDJ3KyIAEObcd3KkF7mad/+LlQAVog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BGVE8uSb08IX4tyvDbhrs8usVYaxfzrTpmvCN7htH+c=;
	b=BviAd87jvos41kMDKR8mdvxIDNvZ2MYV/UqAYyodZwmbQ9mt6VSEmpvbo4bw4DaICctB
	 A5263+mybD/9Lqi/rLppmJuVAlVIZG3+pPNCNcW++2KcJHI8iRdORRFNIVqey9r6d0ypn
	 EiHH14bcPy0lB7rvS34Aj7lmpx87ss5sRWtNPMVHoDn4iFcv4sxbQIjEhY3b2pIe/03f8
	 59K4gKOrlNlzgSQt6YpVnHNZtcuzibawN1HurA0/Fd54mrcL5rG+UuC6msmPPVafdkdAI
	 0L925IdPRNvhq6ibVaGvUm3+xs3eMe7QbVx7ziUX3xstD2nwEAhxlfTdUFSyqRszjFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tDvyxVGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3890260A2604;
	Fri, 23 Oct 2026 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tDvyxVGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533C61F01828;
	Fri, 23 Oct 2026 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773854;
	bh=BGVE8uSb08IX4tyvDbhrs8usVYaxfzrTpmvCN7htH+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDvyxVGa4n7BjNcTbAF035k+C7DALn7Mzzf9T/lCVdMovMxRgrCSgHd5FZWmuJ0ga
	 B/4kPyvU0i/5v7Pv3Wm2UB+gOihJXEaK5HJik0tJb47l3xfV4LK+zcgRsxWbr4ooW3
	 +YYxy33HEOApcSrTTfoPgWoG+RX+My1uwuP7xIuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/193] regcache: Add ->populate() callback to separate from ->init()
Date: Fri, 23 Oct 2026 18:35:15 +0200
Message-ID: <20261023163715.104520614@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 94a3a95f03154d8d4c6206950a7f6ef9a30baec6 ]

In the future changes we would like to change the flow of the cache handling.
Add ->populate() callback in order to prepare for that.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251031080540.3970776-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: abff0a48b110 ("regmap: Drop map lock during cache init and exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/internal.h |  1 +
 drivers/base/regmap/regcache.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 6f31240ee4a9a..6efed02c21c5f 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -186,6 +186,7 @@ struct regcache_ops {
 	enum regcache_type type;
 	int (*init)(struct regmap *map);
 	int (*exit)(struct regmap *map);
+	int (*populate)(struct regmap *map);
 #ifdef CONFIG_DEBUG_FS
 	void (*debugfs_init)(struct regmap *map);
 #endif
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index c7650fa434add..149945690cdf1 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -221,8 +221,24 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 		if (ret)
 			goto err_free;
 	}
+
+	if (map->num_reg_defaults && map->cache_ops->populate) {
+		dev_dbg(map->dev, "Populating %s cache\n", map->cache_ops->name);
+		map->lock(map->lock_arg);
+		ret = map->cache_ops->populate(map);
+		map->unlock(map->lock_arg);
+		if (ret)
+			goto err_exit;
+	}
 	return 0;
 
+err_exit:
+	if (map->cache_ops->exit) {
+		dev_dbg(map->dev, "Destroying %s cache\n", map->cache_ops->name);
+		map->lock(map->lock_arg);
+		ret = map->cache_ops->exit(map);
+		map->unlock(map->lock_arg);
+	}
 err_free:
 	kfree(map->reg_defaults);
 	if (map->cache_free)
-- 
2.53.0



