Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A03B1C07C4;
	Tue, 15 Oct 2024 13:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997277; cv=none; b=r3dC9qsVI/JkqzXy3hxjOry0x3tjOIUe8UDevQhZL+wfNpaYYeOdsaZuVfN5g8NTE5AO+dH3Mf37gHSNFdYkacc9JtDEHTJ44zcmW5LaqmgTfCzr7Zi3lNiB38zc6B6AF+6kh5KJK0WHiFenWicxWPv1RdXaM8TfBVdwugveXjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997277; c=relaxed/simple;
	bh=d1UtYsQqOOs3N78CbE19jXiBGXdqhXOOh6LfloCe3vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/8nxgy9iq20XxBl0pnk4aqDE+ykQwqZXdiOlRG76/CeY8gYDkgOH9xVx4R3PjDw7+7ihWTCFTjjO8fcli+guADdyb43uUUqSd6+pPgK8ErKOw2bU49FdarEFeUyEoCjYDmHqyI0fNZl63Z9UP1EdDWI2Wpu9Zcdgw0qvJoq8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZh61ffP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZh61ffP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F2AC4CECF;
	Tue, 15 Oct 2024 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997277;
	bh=d1UtYsQqOOs3N78CbE19jXiBGXdqhXOOh6LfloCe3vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZh61ffPPIq4ipYAGVtB/mFTaVG5xyzebaucgCqLVF0/w+GO5p+DUVG2ax5Wh/TYI
	 PbKYvljt80jDTy+ZlGDJXxInqOYzRp2qVF28u4giIn55gR53+/l/83n0MNMs0JSt1C
	 1i195FDT7T9MF0B3TxtuFzj0It1ESXka4tduOKrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/518] i2c: Add i2c_get_match_data()
Date: Tue, 15 Oct 2024 14:40:08 +0200
Message-ID: <20241015123921.015222999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 564d73c4d9201526bd976b9379d2aaf1a7133e84 ]

Add i2c_get_match_data() to get match data for I2C, ACPI and
DT-based matching, so that we can optimize the driver code.

Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
[wsa: simplified var initialization]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 119abf7d1815 ("hwmon: (max16065) Fix alarm attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 19 +++++++++++++++++++
 include/linux/i2c.h         |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 6fac638e423ac..ef6d52a38b5c9 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -92,6 +92,25 @@ const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 }
 EXPORT_SYMBOL_GPL(i2c_match_id);
 
+const void *i2c_get_match_data(const struct i2c_client *client)
+{
+	struct i2c_driver *driver = to_i2c_driver(client->dev.driver);
+	const struct i2c_device_id *match;
+	const void *data;
+
+	data = device_get_match_data(&client->dev);
+	if (!data) {
+		match = i2c_match_id(driver->id_table, client);
+		if (!match)
+			return NULL;
+
+		data = (const void *)match->driver_data;
+	}
+
+	return data;
+}
+EXPORT_SYMBOL(i2c_get_match_data);
+
 static int i2c_device_match(struct device *dev, struct device_driver *drv)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 6cfb530b3d43f..63476bcf955d5 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -342,6 +342,8 @@ struct i2c_adapter *i2c_verify_adapter(struct device *dev);
 const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 					 const struct i2c_client *client);
 
+const void *i2c_get_match_data(const struct i2c_client *client);
+
 static inline struct i2c_client *kobj_to_i2c_client(struct kobject *kobj)
 {
 	struct device * const dev = kobj_to_dev(kobj);
-- 
2.43.0



