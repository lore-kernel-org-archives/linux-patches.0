Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEA213F435;
	Tue, 15 Oct 2024 11:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992661; cv=none; b=kGT/LpC26EQ2xcf6aMeNPMnG6b8MUKxQmRbpc5ie15+L0BERli1pQpc5htnkjLINR0ZMkCGko1V31Pr3Xiy1LtIBpxA2jV6V+He5WtlAXhAfmhg6h6wJtgI5LLTvz5Orj0eodXhJhiCe23kND1hXAP8vNjPofSl87EqxJlI2dEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992661; c=relaxed/simple;
	bh=d3VECnFT2LX+lFxCaqwFyUP6Pdtdg375AJDzDTMkIEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYKCUWJkz1sQzakgssf6y91MHvWTEsEa9QwaK2ndcPjTnU7iCzYgHg+gbezrJOzuKNEqTBrnD43mFV9kGr3Y4WSNJ8eVaRFMgz2TtkeMTzYzbh8H1gkxf1mEEzHsX3qSC+uvBbI+ZRQtexN8lLd/92wkE8xO1T993OYb7QO1eDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvjdLSxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvjdLSxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9F8C4CEC6;
	Tue, 15 Oct 2024 11:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992661;
	bh=d3VECnFT2LX+lFxCaqwFyUP6Pdtdg375AJDzDTMkIEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvjdLSxlx+JlEQSt2+aMcvTC/PJX4JAjOFrEexd4U6pD8iy941SwvvESVjvovalkV
	 MBYNlRgZxOrAeXo2VdILsPyGzRGQ/hnFZtDoV7npUXbTQbWH63KP68KTks6WLdCklR
	 w/lbSiuj7tvvH1gS+6JKC+/i55HNfpIq/ZSlsi5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/691] i2c: Add i2c_get_match_data()
Date: Tue, 15 Oct 2024 13:21:38 +0200
Message-ID: <20241015112446.310248531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index dccd94ee138e2..b163ef91aabab 100644
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
index 2fb2f83bd5015..8bcc0142c32c2 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -349,6 +349,8 @@ struct i2c_adapter *i2c_verify_adapter(struct device *dev);
 const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 					 const struct i2c_client *client);
 
+const void *i2c_get_match_data(const struct i2c_client *client);
+
 static inline struct i2c_client *kobj_to_i2c_client(struct kobject *kobj)
 {
 	struct device * const dev = kobj_to_dev(kobj);
-- 
2.43.0



