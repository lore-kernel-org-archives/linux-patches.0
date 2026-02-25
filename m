Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E28E1F03DE;
	Wed, 25 Feb 2026 01:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983981; cv=none; b=qMJzn1DUXn/FtmVdNDUWIHUlRXEDgiYOn4piozUkxP4HZzog3LPWLJfg24N0vkC6nHEoMkk0nzxg/YyBeKLxO5wD2IAcbdaVS0p4qcZSs74LkAjwPwE4X5fjwnGWQjwH7UYg5loiPZ9wk5X3bBaZnY1Csv5tFbaXHYPtc9Lz5HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983981; c=relaxed/simple;
	bh=/Sv0cBfcompDCs4X1ayrWssKxoeLNKXHuPCOzyXooyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMyVjRgUCJBXB/rtOoKpY0ezvaO4gGcEum3Q+FzMfmFh8jJj+BJuvj/gKsVqaQxFYdgOOXF5w69U3o1LOP6gHehGYSho2FmwCWFz4O669l1tnID+yo/k4Iml3Zg4Moaa4FfwUO0ldak/2I6NbXmJzLrDZxywZtdBzVC9LwPnnrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOeKtMwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOeKtMwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15D0C2BC86;
	Wed, 25 Feb 2026 01:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983981;
	bh=/Sv0cBfcompDCs4X1ayrWssKxoeLNKXHuPCOzyXooyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOeKtMwAe/R5CGZx7vSdETncvL7U8MqAchbpVq412tnWHXHnCsGs5xL+XFgOvkLLX
	 1dSGupAN9mzJg2FMtr7/PuEYGzXoivsFjv6jt9KLh9w2oUMpu6M+rpucf3ng46rDd1
	 A/iZiwRE3aj3xb5ZP+PuZ+00w4kPcdyMyKsg317Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Lee <carl.lee@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 233/641] hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification
Date: Tue, 24 Feb 2026 17:19:19 -0800
Message-ID: <20260225012354.536695900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 1f56aaf4dde80..87bd039c77b9b 100644
--- a/drivers/hwmon/pmbus/mpq8785.c
+++ b/drivers/hwmon/pmbus/mpq8785.c
@@ -47,6 +47,33 @@ static int mpq8785_identify(struct i2c_client *client,
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
@@ -129,6 +156,7 @@ static int mpq8785_probe(struct i2c_client *client)
 		break;
 	case mpq8785:
 		info->identify = mpq8785_identify;
+		info->read_byte_data = mpq8785_read_byte_data;
 		break;
 	default:
 		return -ENODEV;
-- 
2.51.0



