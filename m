Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9B446823;
	Mon, 17 Aug 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979963; cv=none; b=UH+kDb5tSydcwoFqt969dbgKQgXQPtlbX3KfxHeKN7sm9DCPmh6UuFxdp2EhYstrre2EiHze7jYg06S9T0NN3K59H7eS7y3B+pMMUjFWo49f40CUHDRyLmvO8aCjorsXeeFGxzMI8hIUCEoqRzK6jQGvaYVZI6ZOxmrGQIEMUFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979963; c=relaxed/simple;
	bh=p9cEQ47QhWzD+U4aJG1MPtLEbLEUgoaYowsDfriYeMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGVlqBYb+w1WhJIEiOufLfaX/urwfuyRng2YhqIN2+pp0eiECErPgZGJtCG+MTdbL2A/PbUciMbfNHADnAQaP75bKnMBTAgSvj1Gmb322P3ZPhv+8wNgace2M/XwAWwFNgS/VMxlucQAZlB4Y1ljdRGv2DyFqsBdN1wfv++k6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXv1Wy11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXv1Wy11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5EE1F000E9;
	Mon, 17 Aug 2026 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979953;
	bh=FZb1BHGimpTIzExn3kspN3R3FpAzztQBeYYIG+C1LeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXv1Wy116NOCJ91/NJFWT37wCAL5whKMGKorws3h+U3jfViy+JToFE4hYSOJZP5iF
	 YeUZn6jVq6+knm2U6xtcrScD1TN7A7tEYDMYsvURn9qmASlyT8pgXCtUgfZpBtG0do
	 1M01Wta6yV1K2ioT2tSa2YzfCkVKDaEYa2r5A7gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 366/609] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Mon, 17 Aug 2026 15:31:02 +0200
Message-ID: <20260817132556.533029326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a19038a200f18d9e74ac30081797917d0886e16b ]

pmbus_update_byte_data() is supposed to return a negative error code or 0.
However, if no change is made to the register, it actually returns the
register value. This can result in problems if the calling code explicitly
expects to see an error code or 0.

Fix it to return 0 on success or the error code as expected.

Fixes: 11c119986f270 ("hwmon: (pmbus) add helpers for byte write and read modify write")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 1715fafc4152f..d69fd8ca66eb5 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -442,7 +442,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_update_byte_data, PMBUS);
 
-- 
2.53.0



