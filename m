Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7941D90CD;
	Tue, 15 Oct 2024 11:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992180; cv=none; b=PXVUApaGR+H5bLBpHglqIfCeJi2IcK8aoYHAvqXnPOIS7jX+jwakh1BkvNKFJd1QECYjLsP+2xPgTZnj18ApJlrcKISUgc/0CjslhjT7UVH1JP5EhnrxNoolQnWrmBLIKWrtOs2vWzI+2kaR7WigxpbIFjASrF5KcxQQnjs9Nd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992180; c=relaxed/simple;
	bh=QdBNaIx5xfzvLUvh1PbQLwjItMWn5/z/fbZltXcfV2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IMfJMij8HzM9NgPyTPtpUHadj5sx3yfCui/X0T9JZ8MgsSHoNEGZJ5vdWKFUwMBV7JAbVO0sfgECHXIcCI+xmZiJ4CnujYMOVjIh0ROfZaCYqSIJ4haU3Bz1boA5Bt7aAcoe6tDwz8If9GQ6SEWVecRokAFH59l6rDiSzAzmpnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnI8806B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnI8806B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704C3C4CEC6;
	Tue, 15 Oct 2024 11:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992179;
	bh=QdBNaIx5xfzvLUvh1PbQLwjItMWn5/z/fbZltXcfV2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnI8806Br8+J7B86UR8Ffio6NN5ADK6F+XNiyHZvPNRz4L/7qjb9Tz3ANwA3j7u+S
	 +yR4oqpHMhya1siOTxNb9hs70LMo1dkIzZbw0Jev9pz82r1lXP3dGhulBOCizgMmOg
	 FlMWJyyqhSyKozPOv3rXm4/KnVEQ0tr3buXNmlGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/691] hwmon: (pmbus) Introduce and use write_byte_data callback
Date: Tue, 15 Oct 2024 13:19:48 +0200
Message-ID: <20241015112441.933816675@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mårten Lindahl <marten.lindahl@axis.com>

[ Upstream commit 5de3e13f7f6b496bd7bd9ff4d2b915b7d3e67cda ]

Some of the pmbus core functions uses pmbus_write_byte_data, which does
not support driver callbacks for chip specific write operations. This
could potentially influence some specific regulator chips that for
example need a time delay before each data access.

Lets add support for driver callback with _pmbus_write_byte_data.

Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Link: https://lore.kernel.org/r/20220428144039.2464667-2-marten.lindahl@axis.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 20471071f198 ("hwmon: (pmbus) Conditionally clear individual status bits for pmbus rev >= 1.2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus.h      |  2 ++
 drivers/hwmon/pmbus/pmbus_core.c | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index ef3a8ecde4df..e2a570930bd7 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -438,6 +438,8 @@ struct pmbus_driver_info {
 	int (*read_byte_data)(struct i2c_client *client, int page, int reg);
 	int (*read_word_data)(struct i2c_client *client, int page, int phase,
 			      int reg);
+	int (*write_byte_data)(struct i2c_client *client, int page, int reg,
+			      u8 byte);
 	int (*write_word_data)(struct i2c_client *client, int page, int reg,
 			       u16 word);
 	int (*write_byte)(struct i2c_client *client, int page, u8 value);
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 63b616ce3a6e..cc9ce5b2f0f2 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -276,6 +276,24 @@ static int _pmbus_write_word_data(struct i2c_client *client, int page, int reg,
 	return pmbus_write_word_data(client, page, reg, word);
 }
 
+/*
+ * _pmbus_write_byte_data() is similar to pmbus_write_byte_data(), but checks if
+ * a device specific mapping function exists and calls it if necessary.
+ */
+static int _pmbus_write_byte_data(struct i2c_client *client, int page, int reg, u8 value)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	const struct pmbus_driver_info *info = data->info;
+	int status;
+
+	if (info->write_byte_data) {
+		status = info->write_byte_data(client, page, reg, value);
+		if (status != -ENODATA)
+			return status;
+	}
+	return pmbus_write_byte_data(client, page, reg, value);
+}
+
 int pmbus_update_fan(struct i2c_client *client, int page, int id,
 		     u8 config, u8 mask, u16 command)
 {
@@ -290,7 +308,7 @@ int pmbus_update_fan(struct i2c_client *client, int page, int id,
 
 	to = (from & ~mask) | (config & mask);
 	if (to != from) {
-		rv = pmbus_write_byte_data(client, page,
+		rv = _pmbus_write_byte_data(client, page,
 					   pmbus_fan_config_registers[id], to);
 		if (rv < 0)
 			return rv;
@@ -397,7 +415,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	tmp = (rv & ~mask) | (value & mask);
 
 	if (tmp != rv)
-		rv = pmbus_write_byte_data(client, page, reg, tmp);
+		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
 	return rv;
 }
@@ -912,7 +930,7 @@ static int pmbus_get_boolean(struct i2c_client *client, struct pmbus_boolean *b,
 
 	regval = status & mask;
 	if (regval) {
-		ret = pmbus_write_byte_data(client, page, reg, regval);
+		ret = _pmbus_write_byte_data(client, page, reg, regval);
 		if (ret)
 			goto unlock;
 	}
-- 
2.43.0



