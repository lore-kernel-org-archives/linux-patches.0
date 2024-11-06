Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456F1DE3B8;
	Wed,  6 Nov 2024 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896295; cv=none; b=Eo9IBZ/5BAB7MRn1toVVOlM8ZcMKK1AixLiF3d1AzR/cQyYM4A5MjE3JjlbQaFjJc5UgpqZ3nANBQLlltIr71F7Lq1EmhTN0LUTxWEbT44G1kB+O+gqtr5w8aBAcIO0D6BL/liJ8nyRZQ4hfgsk+1y6LriqrF6IvrGeQPTENfaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896295; c=relaxed/simple;
	bh=XnQjWmapWaqkaE1405LZEGPD5IIXpf7Dx6vkwwUNLdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLIBjM+st9N+387jn02OiLSNgzLEu9lALjz4Mq/Wl5gp7JneeZVXnIocxoUcnj2PKaAlI+ufIvynngf0Zc+JgV6DpJnxdmTdKO1KinzpBQo82nkXh5yLgiulnVZVFDOdHliVjEY00ylXYwJKx+uEHpLYVEpSH9N6sd87x4Q/01w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0TxX51r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0TxX51r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AE5C4CECD;
	Wed,  6 Nov 2024 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896295;
	bh=XnQjWmapWaqkaE1405LZEGPD5IIXpf7Dx6vkwwUNLdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0TxX51rQSmvr7d4JrIhd9WKUUUnmcMx8fQpOEaG6rXgw3uAqmUaBIE9wHL9+8Hu5
	 O1KBqFNDeMxasvfWqloDe4/KMXFtx5AiDAM2ENuZu5VD30ONvy4hB7zHFFR16/99FI
	 jg2a6ikLIWhUG/VMmOib4qtzsO97gHDzDrA+/RI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Oliver Graute <oliver.graute@kococonnector.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 154/245] Input: edt-ft5x06 - fix regmap leak when probe fails
Date: Wed,  6 Nov 2024 13:03:27 +0100
Message-ID: <20241106120323.020045453@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit bffdf9d7e51a7be8eeaac2ccf9e54a5fde01ff65 ]

The driver neglects to free the instance of I2C regmap constructed at
the beginning of the edt_ft5x06_ts_probe() method when probe fails.
Additionally edt_ft5x06_ts_remove() is freeing the regmap too early,
before the rest of the device resources that are managed by devm are
released.

Fix this by installing a custom devm action that will ensure that the
regmap is released at the right time during normal teardown as well as
in case of probe failure.

Note that devm_regmap_init_i2c() could not be used because the driver
may replace the original regmap with a regmap specific for M06 devices
in the middle of the probe, and using devm_regmap_init_i2c() would
result in releasing the M06 regmap too early.

Reported-by: Li Zetao <lizetao1@huawei.com>
Fixes: 9dfd9708ffba ("Input: edt-ft5x06 - convert to use regmap API")
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Graute <oliver.graute@kococonnector.com>
Link: https://lore.kernel.org/r/ZxL6rIlVlgsAu-Jv@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/edt-ft5x06.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index e70415f189a55..126b0ed85aa50 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -1121,6 +1121,14 @@ static void edt_ft5x06_ts_set_regs(struct edt_ft5x06_ts_data *tsdata)
 	}
 }
 
+static void edt_ft5x06_exit_regmap(void *arg)
+{
+	struct edt_ft5x06_ts_data *data = arg;
+
+	if (!IS_ERR_OR_NULL(data->regmap))
+		regmap_exit(data->regmap);
+}
+
 static void edt_ft5x06_disable_regulators(void *arg)
 {
 	struct edt_ft5x06_ts_data *data = arg;
@@ -1154,6 +1162,16 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client)
 		return PTR_ERR(tsdata->regmap);
 	}
 
+	/*
+	 * We are not using devm_regmap_init_i2c() and instead install a
+	 * custom action because we may replace regmap with M06-specific one
+	 * and we need to make sure that it will not be released too early.
+	 */
+	error = devm_add_action_or_reset(&client->dev, edt_ft5x06_exit_regmap,
+					 tsdata);
+	if (error)
+		return error;
+
 	chip_data = device_get_match_data(&client->dev);
 	if (!chip_data)
 		chip_data = (const struct edt_i2c_chip_data *)id->driver_data;
@@ -1347,7 +1365,6 @@ static void edt_ft5x06_ts_remove(struct i2c_client *client)
 	struct edt_ft5x06_ts_data *tsdata = i2c_get_clientdata(client);
 
 	edt_ft5x06_ts_teardown_debugfs(tsdata);
-	regmap_exit(tsdata->regmap);
 }
 
 static int edt_ft5x06_ts_suspend(struct device *dev)
-- 
2.43.0



