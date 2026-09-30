Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303653749F6;
	Wed, 30 Sep 2026 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786123; cv=none; b=DPIFQaIMlIuf7yqPmQh7ALz7pybPBuwnlsD8eRKJzuWn2CQeAQHOW0FHP8Z7HtScY/JvnlZSKVJOLExRLMQu+04jnQja/NmjAjBHik6enyS1s8hCdQdMdi9h4c74NVjeJ/u32CzSJHyVt1w0YrC9QPPK6sZKIDMU1NWTSXGZwIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786123; c=relaxed/simple;
	bh=gZwSjGdzXZL+y3yuuygy/tF4+9A8fNWE57DXcYyVm5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK4yAYtYWqp0PpE91bcPK/iiiXTDIsmO6TpkGPNFu9+ZWI6nNgnBVRfQchpaZ+dmbqZ7Em5uuugBmujFrS3XhBl9DdfDF2mV6K0wKsUc364wUtMyLaPmzg0sMrk+5n1UJJ6BONQHugKsl2ielwSNrC+bbfXp1l6ux0BacVQ4PxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtLVLzV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtLVLzV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC431F000FF;
	Wed, 30 Sep 2026 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786121;
	bh=wWTr2lB2D49Cr5A/+TMTORSbLC9R+9luukgYoxoJ4NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtLVLzV/fW5RIBrI7fnGM4opNvnYfbYa+hjwtW/OOOs0y2frz9nrR5+e78VQXfW3V
	 I4qbMxt3EGp4Wu3LhdF6BtvRnQXXxNcBSetOmipF3N4FFyiVElgCqJuAaNMkqfooSc
	 BVtegHsB4YTWYSlJqYHWLLCpnBE5l2Xilu6KkNbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 751/982] hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676
Date: Wed, 30 Sep 2026 17:24:47 +0200
Message-ID: <20260930152432.885159550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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


