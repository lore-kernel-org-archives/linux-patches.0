Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E74DB67E;
	Wed,  8 Apr 2026 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672680; cv=none; b=ilJvJi9Ia/+bz7ptYymg0/0GlIvGV8Rzu0/BxRKfZnv2GRW8f/p7q3dI90SDFODA0foDmVjzQwvEXtmHtbzXwLZWHKq+swP+lm+uFQ0J9vcUEC/dZyNbe2UzoxVTKnw3c6EA3MQyltCFoQfAbHbaH/GKjiZMq1wVJGb1D6tkukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672680; c=relaxed/simple;
	bh=j4bqR8JwmWNDowABuEOViQTbbCwEJCZVgnOY19LDBnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AA1kL5yjOqqCJUr0eS/tjXeIMpEz+q7PWPMtqG8+A+enaC5TpnzZkLTy6dQ6fGegLtCJBSJYx64m6oWolKcHVinEf+hivoOdcQ4Na8FdcFHxJX2m+moxWXEVLSz/hBRQJrieM0RlXIp1kL0Xx2jhad6f0UIJ4zL8blfRCKdpkP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAOQcMwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAOQcMwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A67C19421;
	Wed,  8 Apr 2026 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672680;
	bh=j4bqR8JwmWNDowABuEOViQTbbCwEJCZVgnOY19LDBnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAOQcMwKsLG/Y4c1yArmZQVTIv+FdZqy5ly9f/J0XrxVnyxJxLVqeZ0JFrYPi9Ly4
	 f93h0WFbiN9hvzXUZArq3KbLasdeM07JdxpP8bUva7CFoGUUpetiH6O0kTEGnZPml+
	 8yM3mCO9R0aUmR0M0VREw4dGcXTZmbogMR0/h7AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/160] hwmon: (pxe1610) Check return value of page-select write in probe
Date: Wed,  8 Apr 2026 20:02:34 +0200
Message-ID: <20260408175915.705861698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

[ Upstream commit ccf70c41e562b29d1c05d1bbf53391785e09c6fb ]

pxe1610_probe() writes PMBUS_PAGE to select page 0 but does not check
the return value. If the write fails, subsequent register reads operate
on an indeterminate page, leading to silent misconfiguration.

Check the return value and propagate the error using dev_err_probe(),
which also handles -EPROBE_DEFER correctly without log spam.

Fixes: 344757bac526 ("hwmon: (pmbus) Add Infineon PXE1610 VR driver")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260329170925.34581-4-sanman.pradhan@hpe.com
[groeck: Fix "Fixes" SHA]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pxe1610.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pxe1610.c b/drivers/hwmon/pmbus/pxe1610.c
index e2790a682dc80..d37e389b50d76 100644
--- a/drivers/hwmon/pmbus/pxe1610.c
+++ b/drivers/hwmon/pmbus/pxe1610.c
@@ -104,7 +104,10 @@ static int pxe1610_probe(struct i2c_client *client)
 	 * By default this device doesn't boot to page 0, so set page 0
 	 * to access all pmbus registers.
 	 */
-	i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+	ret = i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+	if (ret < 0)
+		return dev_err_probe(&client->dev, ret,
+				     "Failed to set page 0\n");
 
 	/* Read Manufacturer id */
 	ret = i2c_smbus_read_block_data(client, PMBUS_MFR_ID, buf);
-- 
2.53.0



