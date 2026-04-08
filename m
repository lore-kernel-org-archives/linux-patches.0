Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3A12494F0;
	Wed,  8 Apr 2026 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672346; cv=none; b=gKOO+GWckGe7P7RAULgVoXbkr5EXH6y4V/MBKVl/CzrDMwcd9QXDrWutXG/DpTn24I1dyPmCX298oJMX8QibwOM2hKOVcFAFM8zZTl04JR01704CFj2Y8l+0vXceK0aPPBwnEWtUpFUp0QDRt8qdSH6EJB+Lgjj2Zmhl2uPYmro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672346; c=relaxed/simple;
	bh=oTmWVIac8cHhBkFnAKGYQ5C5x7bzWa8ssvUtbHcgNLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCWIlQongCZHjFT3swNElDqDZd90coqOsV7Yt81nIdSYZ5DlNuhpEpsX2XXU1CL72mwoVzK253Yt9NplNzrF4eVhjtRWcharEAF3ND9gkfe4v0itxuGCyhG8f6P0EgsHADjRwM8SIuK3OMU6fERsvhm9LTQYcwuYTCpNDgiEknQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+ZYjBIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+ZYjBIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3387C19421;
	Wed,  8 Apr 2026 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672346;
	bh=oTmWVIac8cHhBkFnAKGYQ5C5x7bzWa8ssvUtbHcgNLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+ZYjBIHQMEq/6kuzCgUNSR6f8s5BJ3V02Kr2WJ/cz8ZqawY8UAfDeM3zJ1YLec8g
	 x4eKwOTiqKknAYhXd9o5TJHSTaFI5+ZNjC6cbKoyp0RG6tMsmWp4+ruDYQT/DC7hM9
	 LaWGtXuovDeUDc+ac3/i46n7Gl54nxmzOI+0I++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 284/312] hwmon: (pmbus/core) Add lock and unlock functions
Date: Wed,  8 Apr 2026 20:03:21 +0200
Message-ID: <20260408175944.364490228@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit a7ac37183ac2a0cc46d857997b2dd24997ca2754 ]

Debugfs operations may set the page number, which must be done
atomically with the subsequent i2c operation. Lock the update_lock
in the debugfs functions and provide a function for pmbus drivers
to lock and unlock the update_lock.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20230412161526.252294-2-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 3075a3951f77 ("hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus.h      |    2 ++
 drivers/hwmon/pmbus/pmbus_core.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -510,6 +510,8 @@ int pmbus_get_fan_rate_device(struct i2c
 			      enum pmbus_fan_mode mode);
 int pmbus_get_fan_rate_cached(struct i2c_client *client, int page, int id,
 			      enum pmbus_fan_mode mode);
+int pmbus_lock_interruptible(struct i2c_client *client);
+void pmbus_unlock(struct i2c_client *client);
 int pmbus_update_fan(struct i2c_client *client, int page, int id,
 		     u8 config, u8 mask, u16 command);
 struct dentry *pmbus_get_debugfs_dir(struct i2c_client *client);
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3049,8 +3049,13 @@ static int pmbus_debugfs_get(void *data,
 {
 	int rc;
 	struct pmbus_debugfs_entry *entry = data;
+	struct pmbus_data *pdata = i2c_get_clientdata(entry->client);
 
+	rc = mutex_lock_interruptible(&pdata->update_lock);
+	if (rc)
+		return rc;
 	rc = _pmbus_read_byte_data(entry->client, entry->page, entry->reg);
+	mutex_unlock(&pdata->update_lock);
 	if (rc < 0)
 		return rc;
 
@@ -3067,7 +3072,11 @@ static int pmbus_debugfs_get_status(void
 	struct pmbus_debugfs_entry *entry = data;
 	struct pmbus_data *pdata = i2c_get_clientdata(entry->client);
 
+	rc = mutex_lock_interruptible(&pdata->update_lock);
+	if (rc)
+		return rc;
 	rc = pdata->read_status(entry->client, entry->page);
+	mutex_unlock(&pdata->update_lock);
 	if (rc < 0)
 		return rc;
 
@@ -3083,10 +3092,15 @@ static ssize_t pmbus_debugfs_mfr_read(st
 {
 	int rc;
 	struct pmbus_debugfs_entry *entry = file->private_data;
+	struct pmbus_data *pdata = i2c_get_clientdata(entry->client);
 	char data[I2C_SMBUS_BLOCK_MAX + 2] = { 0 };
 
+	rc = mutex_lock_interruptible(&pdata->update_lock);
+	if (rc)
+		return rc;
 	rc = pmbus_read_block_data(entry->client, entry->page, entry->reg,
 				   data);
+	mutex_unlock(&pdata->update_lock);
 	if (rc < 0)
 		return rc;
 
@@ -3420,6 +3434,22 @@ struct dentry *pmbus_get_debugfs_dir(str
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_get_debugfs_dir, PMBUS);
 
+int pmbus_lock_interruptible(struct i2c_client *client)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+
+	return mutex_lock_interruptible(&data->update_lock);
+}
+EXPORT_SYMBOL_NS_GPL(pmbus_lock_interruptible, PMBUS);
+
+void pmbus_unlock(struct i2c_client *client)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+
+	mutex_unlock(&data->update_lock);
+}
+EXPORT_SYMBOL_NS_GPL(pmbus_unlock, PMBUS);
+
 static int __init pmbus_core_init(void)
 {
 	pmbus_debugfs_dir = debugfs_create_dir("pmbus", NULL);


