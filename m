Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB751E2834;
	Wed, 25 Feb 2026 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983160; cv=none; b=ErsZyHv+VgEJDmvGcaxIW4UG7HsCuHDIiaFraZ+l77rjqQcULAw4akVXCn4nnMuwkvAZKORiDBZC8tNVczQiooelBft/kjHBNV1YqFZJVS3MvhvZzocBdX5Wvt6yOamlLVsWnsIRHUwbyX1Pl0J46mURkY9yk6pjzSEJ8hAahag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983160; c=relaxed/simple;
	bh=k0CWLz721y279tmIyf2UunUK99d+vXjpT9BJXp5XnO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7YMIDmnaf4W6sRo5co/yy2m0ZIw/MF/FAig4NRPq3OXCWIsptOlTlo1UuV66nFZ/lp0+NaLgUFvKHN2nM4gKVm9zfx/7kovKRAn+uQtUF0eZLQsczy+JtVhhoykoBpHwF+KCGptU1FaJm5r6eZFJiVS0dyxUAlpvivFLmRTxQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm9i7cve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm9i7cve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A943DC116D0;
	Wed, 25 Feb 2026 01:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983160;
	bh=k0CWLz721y279tmIyf2UunUK99d+vXjpT9BJXp5XnO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm9i7cveUikT3rZjlzm3rmsYQ/kftTSNpTwQQSzig6s6yocrPP6Vv58i0z8Y6jqhv
	 MRkupLBpqEOCutFhwt7NKE1QL5LhyGmz2qKOqCyITDop5j/cLWfx0663I+EvisZ6vO
	 AnzJMVKLiv0h3g1wI3quik3vuJ561DDi+9ArHWOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Lee <carl.lee@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 314/781] hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification
Date: Tue, 24 Feb 2026 17:17:03 -0800
Message-ID: <20260225012407.402493502@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



