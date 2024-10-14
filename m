Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DDC1ABECB;
	Mon, 14 Oct 2024 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917658; cv=none; b=dh47J2ji/WG6eZ2InPs6NcjwRSmKFtX/zuScCrl8lN9SSlFY0/uyXwxT2PL5wx8Ujf+BtVy/MOTc/WZsaCmieWtzM5Jl+D6TZ1UYcAFvPuwyJQoKvd+4bGLXYXHsZ81W5wUzCPksY6EPGCXYyS6uSzmXLsK1KRsZJ3AJwbwsYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917658; c=relaxed/simple;
	bh=Z9ThiFPvG+fwnLNWYhE9rMTCZeBfp1z8OsM+lcR9ujs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLm8w7+3WIfdlu+3DAPKYApVDSSZM6ROri+6Hm8XPHDjJI2F1BR0V2Hmv2+To3Yktdjz/vqjXau32RQg4XNtD2Hp5Y4cM4xCap4a4pyxiX8JLZs9w0WCwbG5LxxYm53EgSz8cdct1tVu5x4KhdBG2Ns71ZeAOa1oY+WEN057f1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WN3lSQnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WN3lSQnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ECFC4CEC3;
	Mon, 14 Oct 2024 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917657;
	bh=Z9ThiFPvG+fwnLNWYhE9rMTCZeBfp1z8OsM+lcR9ujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WN3lSQnzVkbLjhpz+OlQWagfwNmfzQpgDcXobH5GC0XjLqA30KE7+/ONCXxSH7R8G
	 vzQhY9HfAGksDW5GAjri2arDhBbSAfB6RE+h0RJ5NxFKTyYjkq3Rg00YYCf9KIHa+A
	 mdX+xPMsZmMk0K+/+d7HMZPLAm0PwDk3lx+w26aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/798] i2c: Add i2c_get_match_data()
Date: Mon, 14 Oct 2024 16:10:42 +0200
Message-ID: <20241014141221.390180515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d6a879f1542c5..643c7f1e5bfd4 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -113,6 +113,25 @@ const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
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
index 35e296d9e1c55..4f5285b87a7f0 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -362,6 +362,8 @@ struct i2c_adapter *i2c_verify_adapter(struct device *dev);
 const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 					 const struct i2c_client *client);
 
+const void *i2c_get_match_data(const struct i2c_client *client);
+
 static inline struct i2c_client *kobj_to_i2c_client(struct kobject *kobj)
 {
 	struct device * const dev = kobj_to_dev(kobj);
-- 
2.43.0



