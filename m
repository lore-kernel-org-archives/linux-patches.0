Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E93536998C;
	Wed, 30 Sep 2026 18:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794513; cv=none; b=lzYE9EG8dG6uaJT097FlwFTO7NE/xabxQNMf6dWGrBIahal4W5wWrB2tK+QHDl++ZOWj34InCQTftODdkRW7QUnHjOGISHTtl3EZ0T8mj+m6oIyXfAk6C6jhOwwjTUHagl6PEo6FvvrX0P1atIgjlmuRkLnJlc7/SWmRFLZwYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794513; c=relaxed/simple;
	bh=AqIZePh2gDvYiz8K35omXmHqQS3TSWD/qRduSfWLjiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAGGAHMRB2WXjZSjp3B8AAAgMpYV3pCZJM+or8bapLe9JHD1kNFReCMEeZv1swxXibJJeOV+dajtFhd38iWqC/tkAoogJx45hst0O/HOBywarfd4bzKRiLv6QzBN0gePoMbQJMX3eNNB6kbt3FMtU1Esd8sQl2rbWmk5u00LwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBc8PYU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBc8PYU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81781F000FF;
	Wed, 30 Sep 2026 18:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794512;
	bh=Fg55+Orah52Wya2eF3Z9uFl+uTpSzyuAH3rDkVAlM+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBc8PYU3kA3VmTCBYGP0D5p5V1JOBJWnXd+gnzyX2M7xipH5Qdnyfm1io6tLqDz+o
	 KNE2O2IQE4QXn6Poe68cbsNb5+h6/E0y05VJWC8rt2Famxq3ps+J0Y4XYvQJoogOLb
	 +geBSyCXPcaL9Gp6iiUJ6l1OI6APLPXMjX8L/Xqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akashdeep Kaur <a-kaur@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0238/1193] mfd: tps65219: Make poweroff handler conditional on system-power-controller
Date: Wed, 30 Sep 2026 17:15:22 +0200
Message-ID: <20260930152439.477750029@linuxfoundation.org>
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

From: Akashdeep Kaur <a-kaur@ti.com>

[ Upstream commit 104cd764a031bfe2ffe253adce9581384a78c16e ]

Currently, the TPS65219 driver unconditionally registers a poweroff
handler. This causes issues on systems where a different component
(such as TF-A firmware) should handle system poweroff instead.

Make the poweroff handler registration conditional based on the
"system-power-controller" device tree property. This follows the
standard kernel pattern where only the designated power controller
registers for system poweroff operations.

On systems where the property is absent, the PMIC will not register
a poweroff handler, allowing other poweroff mechanisms to function.

Signed-off-by: Akashdeep Kaur <a-kaur@ti.com>
Link: https://patch.msgid.link/20260401112257.1248437-3-a-kaur@ti.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65219.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index 72a5f51fe32a5..c2cee7db1508d 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -280,13 +280,15 @@ static int tps65219_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	ret = devm_register_power_off_handler(tps->dev,
-					      tps65219_power_off_handler,
-					      tps);
-	if (ret) {
-		dev_err(tps->dev, "failed to register power-off handler: %d\n", ret);
-		return ret;
+	if (of_device_is_system_power_controller(tps->dev->of_node)) {
+		ret = devm_register_power_off_handler(tps->dev,
+						      tps65219_power_off_handler,
+						      tps);
+		if (ret)
+			return dev_err_probe(tps->dev, ret,
+					     "Failed to register power-off handler\n");
 	}
+
 	return 0;
 }
 
-- 
2.53.0



