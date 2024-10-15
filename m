Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167ED1C07F2;
	Tue, 15 Oct 2024 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996909; cv=none; b=T5IwuwOgBtDrqjdfsaIYwHT+qCnsQ3kF8vw0H3zhv/vNg1txWxA80ezzdVMRkJMubzqFXgCTQv/Djk9EZbatGsABK4ZvzfWVSUgHNGa2cglNv9tIBKUoudxtommmDrksC/zsKEOiEz6/ZDk4Z4eCtZW5ljM7+/bV38I/DOIUtFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996909; c=relaxed/simple;
	bh=ZT5bbBx9L29DndvrsyCuX19Dv6mDjOPKQkknB5RrJ3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUUQjW6yXYMT8bqFvHurRWSEV2Z0pil2cHyNgSOdb25SRiKXI88tz0LQRepsie89LrmBai++wvmxWh+Cdu0NrYJEpYegCLCWgkD4Zu1sp+wVrPq6f591sV29/lfbDgeeYnG35erlLc83AXFbYxmiG5yC5WO5E/wHgkJlhnzDsFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXLa+b/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXLa+b/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F36FC4CEC6;
	Tue, 15 Oct 2024 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996908;
	bh=ZT5bbBx9L29DndvrsyCuX19Dv6mDjOPKQkknB5RrJ3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXLa+b/+hMopw5rDwjP1t81MNUQEEbK7z8uXNCOLH5x9Ee1lyf0qmTQAinR76UjeG
	 zl26K3CtjYCGyjDqrtWPuvkl+Ln8QiKB8BlDcbrUSwd2/fBDChu/SKh/YS2RsFvqdY
	 joAXFTqzWAfoQWkyak8x5VvZcSvBXlXPvlvpUsZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/518] Input: ads7846 - ratelimit the spi_sync error message
Date: Tue, 15 Oct 2024 14:38:33 +0200
Message-ID: <20241015123917.193892325@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit ccbfea78adf75d3d9e87aa739dab83254f5333fa ]

In case the touch controller is not connected, this message keeps scrolling
on the console indefinitelly. Ratelimit it to avoid filling kernel logs.

"
ads7846 spi2.1: spi_sync --> -22
"

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240708211913.171243-1-marex@denx.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 1753288cedde..08a1eac2dfa2 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -819,7 +819,7 @@ static void ads7846_read_state(struct ads7846 *ts)
 		m = &ts->msg[msg_idx];
 		error = spi_sync(ts->spi, m);
 		if (error) {
-			dev_err(&ts->spi->dev, "spi_sync --> %d\n", error);
+			dev_err_ratelimited(&ts->spi->dev, "spi_sync --> %d\n", error);
 			packet->ignore = true;
 			return;
 		}
-- 
2.43.0



