Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20F554903;
	Tue, 14 May 2024 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684601; cv=none; b=Ks7ppGpP2Ud+FOyU//Uo4+NJPq0UGw9nYYw4/+gmo4ScHT7tG1wHbX15ppQWYdV6SYcyYVH+Gqi5AvTt5fDq08/DwhRuxblL638FZDRPFKyBw6wiw0Q5zgxHjvxT/WfYDZTsUiUia7BTyhEZfbDR8YwHDc1jPGfZaCzl/BeS8cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684601; c=relaxed/simple;
	bh=AFFOUQkc56urMx9pIznOwSjs/B1NeA94AQY0tsRepNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDtbkKfrgddNlN+HbCFoRnzWx+osOugfxq3kyzFOygB6tgZGJhsOYedSILHPlu8rv4CSt9DcFHoyXRavwY3z5UXTetD9YOHa7ySFyhKyxcz2fbB+dG3y0drHo+No1qTcNQK6St55COxbE+cYuHeHBgyLzmodCTO55XQ9xSQdTWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgNvAEZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgNvAEZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E14C2BD10;
	Tue, 14 May 2024 11:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684601;
	bh=AFFOUQkc56urMx9pIznOwSjs/B1NeA94AQY0tsRepNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgNvAEZVcXuYtgkxQVJ34gQrhgdB2UHUDSVhN22mF5x1ZgM36FnolhLMmpg6F6apa
	 bfkDG08ABJQ6aEg3a42KEyWdMv4vNIBxT4OcV81dxdO9HYkMNJN18v1QG8fspSLMMV
	 d/WTnRfgknhV37Gto5+AftyqItOdcbG1DAOM8JKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/301] regmap: Add regmap_read_bypassed()
Date: Tue, 14 May 2024 12:15:01 +0200
Message-ID: <20240514101033.384057809@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 70ee853eec5693fefd8348a2b049d9cb83362e58 ]

Add a regmap_read_bypassed() to allow reads from the hardware registers
while the regmap is in cache-only mode.

A typical use for this is to keep the cache in cache-only mode until
the hardware has reached a valid state, but one or more status registers
must be polled to determine when this state is reached.

For example, firmware download on the cs35l56 can take several seconds if
there are multiple amps sharing limited bus bandwidth. This is too long
to block in probe() so it is done as a background task. The device must
be soft-reset to reboot the firmware and during this time the registers are
not accessible, so the cache should be in cache-only. But the driver must
poll a register to detect when reboot has completed.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 8a731fd37f8b ("ASoC: cs35l56: Move utility functions to shared file")
Link: https://msgid.link/r/20240408101803.43183-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 37 ++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |  8 ++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ea61577471994..c5b5241891a5a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2836,6 +2836,43 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 }
 EXPORT_SYMBOL_GPL(regmap_read);
 
+/**
+ * regmap_read_bypassed() - Read a value from a single register direct
+ *			    from the device, bypassing the cache
+ *
+ * @map: Register map to read from
+ * @reg: Register to be read from
+ * @val: Pointer to store read value
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_read_bypassed(struct regmap *map, unsigned int reg, unsigned int *val)
+{
+	int ret;
+	bool bypass, cache_only;
+
+	if (!IS_ALIGNED(reg, map->reg_stride))
+		return -EINVAL;
+
+	map->lock(map->lock_arg);
+
+	bypass = map->cache_bypass;
+	cache_only = map->cache_only;
+	map->cache_bypass = true;
+	map->cache_only = false;
+
+	ret = _regmap_read(map, reg, val);
+
+	map->cache_bypass = bypass;
+	map->cache_only = cache_only;
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_read_bypassed);
+
 /**
  * regmap_raw_read() - Read raw data from the device
  *
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index c9182a47736ef..113261287af28 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -1225,6 +1225,7 @@ int regmap_multi_reg_write_bypassed(struct regmap *map,
 int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 			   const void *val, size_t val_len);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
+int regmap_read_bypassed(struct regmap *map, unsigned int reg, unsigned int *val);
 int regmap_raw_read(struct regmap *map, unsigned int reg,
 		    void *val, size_t val_len);
 int regmap_noinc_read(struct regmap *map, unsigned int reg,
@@ -1734,6 +1735,13 @@ static inline int regmap_read(struct regmap *map, unsigned int reg,
 	return -EINVAL;
 }
 
+static inline int regmap_read_bypassed(struct regmap *map, unsigned int reg,
+				       unsigned int *val)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regmap_raw_read(struct regmap *map, unsigned int reg,
 				  void *val, size_t val_len)
 {
-- 
2.43.0



