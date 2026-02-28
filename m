Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F3234252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301766; cv=none; b=WVcH4q4GqTZmlP5FkEnSRDWh2cVYx2ap2D+IdVs6OZ945rKQAsvSriqYdJ8xxjfNlnoIDWjRDBQfQbgNxyLAuZQxWsxxMIaaZw4UWcWcl/oFxcoy6HIqU1JIkLaAws+KKfuVb9E5zY1q+OiEufPLfpjYbyCveliVWm2kc+4WU3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301766; c=relaxed/simple;
	bh=77Hk88sFSaJHpUN7w7qEhKdAicJk8xUKi32/mctBhow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODAdZy6hcVIlqpi8XNeBKtdSZfTDhmY39xmBlUuvaz3Zou/F+hPjPbaZOlPGFQXw9mQvLOQ7D1iFGMFItUWmGJjr6RF9Xa/f9dYqTKzPQvbqUoyM/0DFSrGRIc8l52RninfFDA9K3bFW/xk2IvtY/oFZUjZ8GOKoM5t0bipR9qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XctdzwqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XctdzwqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F51C19425;
	Sat, 28 Feb 2026 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301765;
	bh=77Hk88sFSaJHpUN7w7qEhKdAicJk8xUKi32/mctBhow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XctdzwqQ7fRQXsUdfg95VvpUEUPlmUu7xzd7zPGgu71+Gdcvgxqs9iDp5b4myAOSJ
	 JpHWl0l3DJqwCrsKYS/T30x4wLWacmKtBB2nPBlI/9sxKXfawEQKUrYf6f0uTcGFWG
	 g08h192v887tvP/G2PXqXkLHdKcGRav4bAKIE/7PHyuPIRdDb+prP9G9OLiXdiJq/6
	 bC3zzgvj/GUydI+mVkV3h5sjq9dbRvOAbDRA9XonHMY1M6ypTyVtyszpZxXhvojTuG
	 CjartffbmTGM24kfxWcx1EPnBb7Hf+zN/bgFsVSDxL0xPyTsx02h3ABtyitrT+Z+gr
	 CIk5AoGzXHenQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Carl Lee <carl.lee@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/385] hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification
Date: Sat, 28 Feb 2026 12:56:34 -0500
Message-ID: <20260228180011.1568201-172-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Carl Lee <carl.lee@amd.com>

[ Upstream commit 9e33c1dba22431bea9b2bf48adf56859e52fc7ec ]

When MPQ8785 reports VOUT_MODE as VID mode, mpq8785_identify()
configures the driver for direct mode. The subsequent
pmbus_identify_common() check then fails due to a mismatch
between the reported mode and the configured mode, causing
device initialization to fail.

Override the reported VOUT_MODE to direct mode to keep the
driver configuration consistent with the reported mode and
allow successful device initialization.

This does not change how voltages are interpreted, but avoids
a false identification failure caused by mismatched mode
handling.

Fixes: f20b4a931130c ("hwmon: Add driver for MPS MPQ8785 Synchronous Step-Down Converter")
Signed-off-by: Carl Lee <carl.lee@amd.com>
Link: https://lore.kernel.org/r/20260210-dt-bindings-hwmon-pmbus-mpq8785-add-mpq8786-support-v3-1-84636ccfe76f@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/mpq8785.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/hwmon/pmbus/mpq8785.c b/drivers/hwmon/pmbus/mpq8785.c
index c8343fee38d9a..7c08f64a7f0a9 100644
--- a/drivers/hwmon/pmbus/mpq8785.c
+++ b/drivers/hwmon/pmbus/mpq8785.c
@@ -45,6 +45,33 @@ static int mpq8785_identify(struct i2c_client *client,
 	return 0;
 };
 
+static int mpq8785_read_byte_data(struct i2c_client *client, int page, int reg)
+{
+	int ret;
+
+	switch (reg) {
+	case PMBUS_VOUT_MODE:
+		ret = pmbus_read_byte_data(client, page, reg);
+		if (ret < 0)
+			return ret;
+
+		if ((ret >> 5) == 1) {
+			/*
+			 * The MPQ8785 chip reports VOUT_MODE as VID mode, but the driver
+			 * treats VID as direct mode. Without this, identification would fail
+			 * due to mode mismatch.
+			 * This override ensures the reported mode matches the driver
+			 * configuration, allowing successful initialization.
+			 */
+			return PB_VOUT_MODE_DIRECT;
+		}
+
+		return ret;
+	default:
+		return -ENODATA;
+	}
+}
+
 static int mpm82504_read_word_data(struct i2c_client *client, int page,
 				   int phase, int reg)
 {
@@ -121,6 +148,7 @@ static int mpq8785_probe(struct i2c_client *client)
 		break;
 	case mpq8785:
 		info->identify = mpq8785_identify;
+		info->read_byte_data = mpq8785_read_byte_data;
 		break;
 	default:
 		return -ENODEV;
-- 
2.51.0

