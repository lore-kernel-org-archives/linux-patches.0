Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA01433BE;
	Tue, 14 May 2024 10:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682195; cv=none; b=r8GRbeTmNFBgbyjJ2AfIE2wfe95ZYKrNkNYs7YfIa6ooP6NEtOvyPUJIBMD0GRXc1T5T136S5x1MkYe9fXa0h6Bou/bVN2yAZHXsanVc2BxLcbTe9wsonHP9qbdTQOYhLZVEM+bRlfkSotrI8QvnkioNlnvN0Nt8KFLZ2TB0FFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682195; c=relaxed/simple;
	bh=R5zqzPcmy5LVpG48ZunQDR1s0t7eSTWgpKm1tCpTPfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrT6pTu3Vbl7GJVHScXtt/AL/fUHLUw16527eARrFmQYqTVr2N+613aeOICkcljibKMBX/dwh5zJlIhG/2N0M3njQknAwGGGVhvFSHqC2ThKUdJ+6yC/XmA4voB791pLI4n3eoA9ZIPtFMjGVJXblWnKwJqRfD+2QQOKXMvK0BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCkre9iD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCkre9iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0749C32786;
	Tue, 14 May 2024 10:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682195;
	bh=R5zqzPcmy5LVpG48ZunQDR1s0t7eSTWgpKm1tCpTPfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCkre9iDOa9KinXFXqpP2zbSeg4JSPYunrCjQP7wbnLMrMkaFxM0ZX+cPK16jwddQ
	 AYnM/3zLLeuxxa/5OmxBOKxhmerf0110vQ/Cxe4cqscE3iRh3GYhSgsNtt54DYKJWb
	 IrNDgo1W0cNCpcV+mK8Psy3CGOajK2EtvN4MxkdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 027/336] regmap: Add regmap_read_bypassed()
Date: Tue, 14 May 2024 12:13:51 +0200
Message-ID: <20240514101039.630673446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 6db77d8e45f92..4ae399c30f0f2 100644
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



