Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984A63E315F;
	Wed, 30 Sep 2026 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796548; cv=none; b=LgBPBwq2yvs3At6hFgI75CujThQto5kIS6Coi9KYhmtiUTl/fe3XhykSyn+h0ZQDhrbz8ew74B+J+O8wRcKde6HjdLTQU+BddoD0EUfrmj0FCYlkiXbN2JxwrRQgSVVBPvCOcmK1VhxpwdDKxneqXYvp0Q1CcVCO6ZgP8bZqurU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796548; c=relaxed/simple;
	bh=lUJLyGJGCSFm9yUjjozTmTazkQXVO0PAoBKIPyaEdHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6h9d4WnfPVk+yc80yIbcKxy1W/4qmQdmv0H5zwNT2onlKp7YzJq1mdKnnvzoY13crDbg0d1kV1GH78835T0F0u7FDHTTgAqKvBK4UYQb2+Nx3ZivCrcUxtxjEXhD61rHINgXhTygCjQbY4qGPufcCbjsdJvXaySmoWnSeBtGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlsugrC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlsugrC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B2C1F000FF;
	Wed, 30 Sep 2026 19:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796547;
	bh=mJ1/I04cQhqPhQKfYq9OWgeLnex+PbSWEh0UiPVWzYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlsugrC9JBz+iwYj3uHa9f/xKWzrx2DmQcgVxWh7eFAQKnr0DgcT1VvU1wQ8MHMLB
	 bIr24coC+j0Cm7CGi0Mxqgdnpb4MhyiOAnO5TP/XkalNg2d1Ham0chujnK0uD440yL
	 j7KRO+V2Y6tdjrVA7BtqwmkN70aUqT6MeLG1OaCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0907/1193] hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676
Date: Wed, 30 Sep 2026 17:26:31 +0200
Message-ID: <20260930152454.393902346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 089070b51ccbac411462a30a454690274c6e4270 upstream.

tps53676_identify() derives the number of PMBus pages but does not
ensure that page 0 is selected for single-page configurations.
pmbus_set_page() does not update the PAGE register when info->pages is
1, so if boot firmware leaves PAGE set to another value subsequent
register accesses may target the wrong page.

For single-page devices, select page 0 explicitly.

Fixes: cb3d37b59012 ("hwmon: (pmbus/tps53679) Add support for TI TPS53676")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://patch.msgid.link/20260916235406.681131-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/tps53679.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -181,6 +181,15 @@ static int tps53676_identify(struct i2c_
 	if (phases_b > 0) {
 		info->pages = 2;
 		info->phases[1] = phases_b;
+	} else {
+		/*
+		 * pmbus_set_page() does not update the PAGE register on
+		 * single-page devices, so select page 0 explicitly in case
+		 * the boot firmware left the device on another page.
+		 */
+		ret = i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+		if (ret < 0)
+			return ret;
 	}
 	return 0;
 }


