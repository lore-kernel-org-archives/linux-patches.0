Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C8719E825;
	Thu, 15 Aug 2024 13:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728944; cv=none; b=ekQBkJ2O5UOZBel0cKks1E6pzpgc+rPPy4wZu3Kb+J6eQC7N/NR774+VLVZpJg3XsyLvN6fCdn32g65qrjjJ4SA0ZJx5RCqqL3qu2mRdNY/sqRq8nqqihmjVWvMB9x+zQmHGtcEEYpLxY6Xjm4E9Qm8f9EoNLKMGwCEI3RYVnVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728944; c=relaxed/simple;
	bh=oPVOTaZwwe71sFqE1q8yc0r83DjS+Y4owXUUDnQ87LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j77jtfSdg215w3UqylKPXtN+xPcXE2H+yvXbvLgYHzLCJhwGkjP3NV07HZhBtDse5YDEk2oJfcRgSnjAXraQS2IaRhogHzfiEESQkFYlYWx1GWAbVmfPXPAVdDlsXpDFuKQxbPliNobyZ7N08d0nVT2XrTQomoh1mdzaxhfaKI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhX/H6v8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhX/H6v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553CFC4AF0A;
	Thu, 15 Aug 2024 13:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728943;
	bh=oPVOTaZwwe71sFqE1q8yc0r83DjS+Y4owXUUDnQ87LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhX/H6v8SY7le0T2W8iHNBoDrG/bWMP2LeCyYUi9yPrS7bCAUmlqKnEk/vuxock3s
	 oGGdlBJ3XKYw4KRN6k8GRDGYepQldpLXup7HLhnBKS/8bPnLYZXmxi5YUeXeqVBdj9
	 1QvHHlg0ARr3sm5byc/9E0VhDUIARheuPRKNsOrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Jean Delvare <jdelvare@suse.de>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/196] i2c: smbus: Dont filter out duplicate alerts
Date: Thu, 15 Aug 2024 15:24:38 +0200
Message-ID: <20240815131858.234116803@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit dca0dd28fa5e0a1ec41a623dbaf667601fc62331 ]

Getting the same alert twice in a row is legal and normal,
especially on a fast device (like running in qemu).  Kind of
like interrupts.  So don't report duplicate alerts, and deliver
them normally.

[JD: Fixed subject]

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Stable-dep-of: f6c29f710c1f ("i2c: smbus: Send alert notifications to all devices if source not found")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-smbus.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 5a1dd7f13bacb..46d7399e2ebe9 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -75,7 +75,6 @@ static irqreturn_t smbus_alert(int irq, void *d)
 {
 	struct i2c_smbus_alert *alert = d;
 	struct i2c_client *ara;
-	unsigned short prev_addr = 0;	/* Not a valid address */
 
 	ara = alert->ara;
 
@@ -99,18 +98,12 @@ static irqreturn_t smbus_alert(int irq, void *d)
 		data.addr = status >> 1;
 		data.type = I2C_PROTOCOL_SMBUS_ALERT;
 
-		if (data.addr == prev_addr) {
-			dev_warn(&ara->dev, "Duplicate SMBALERT# from dev "
-				"0x%02x, skipping\n", data.addr);
-			break;
-		}
 		dev_dbg(&ara->dev, "SMBALERT# from dev 0x%02x, flag %d\n",
 			data.addr, data.data);
 
 		/* Notify driver for the device which issued the alert */
 		device_for_each_child(&ara->adapter->dev, &data,
 				      smbus_do_alert);
-		prev_addr = data.addr;
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



