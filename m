Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F01519DFB;
	Thu, 17 Sep 2026 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664667; cv=none; b=JPLFcEYOkIOx6FrA4+e/gMmiergU+037ZYadyiQ8F9PRbu1jGc/Uw+LEnqulKzZ6nmsibcjBJ3+KAMKJot9ErrycCMmuLkJtYtJkXLnFCnUst+ralzJyQ7QRS5sQ+hYok7kdcZWzXCxl9T833bVUqKorCiIgZHSCPr8CwVhjsCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664667; c=relaxed/simple;
	bh=eBKYG9vMlfteGHDGJ+vaLXZP5GDPy+Z19mhsv/R6D/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+ATFwraRlCvE7hBBguEwnjI0DNHOGyyZKN020RXte29/TWjI5bliw1DcQiaa+Dk687saDfZ+XRk1r/FWuwzYsBzgGnIJVV/akMT+BTL5GxG+Zt/9bgjbi8/T19fg6ca7bp2ydZpqkNPDOCpiAG1ionFMxDkiP5BBmGtyM9jMsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfjIaqT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfjIaqT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E841F00898;
	Thu, 17 Sep 2026 17:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664666;
	bh=XgPwDvd/hFz+uYF3l2hHMIBGtpHWur+7MrX9HMJnQVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfjIaqT4gfPLFPgbrZIOv03m3wQ8iMaLl0XynSSVnJufUcCtPkF54TBr905b9pWn7
	 gMoQqLzm4h0WShcpT2cQ2/oiN7OW1ZXQFBiBk9D1JKV8xyF9kjMhYJjY00jTXdTQOg
	 s/5b5AVxf5gNtVoTOAOEsk6m5zijchDABg7Cos4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akashdeep Kaur <a-kaur@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0431/1250] mfd: tps65219: Make poweroff handler conditional on system-power-controller
Date: Thu, 17 Sep 2026 16:03:46 +0100
Message-ID: <20260917151603.701649034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7275dcdb7c44f..e52fbf1481fef 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -541,13 +541,15 @@ static int tps65219_probe(struct i2c_client *client)
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



