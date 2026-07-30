Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0803F3438B7;
	Thu, 30 Jul 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425688; cv=none; b=EjYOSrqcCFdqyiJa370RCXUkmg+kMo73KbQxfcpH63KnLjlITk200ftMB99vu9lDkYkqncr75HtCbmGmS/k5KPn+nWC43O0OzJzvgSvwZnauq5de+1qMxN8IkBtfCrHitPBqXlhXmm1tP/xgFCGf5WR94glB6WEA6l3BIed5DOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425688; c=relaxed/simple;
	bh=LkhtF3kyPIhh+uwzOtpOIu3f01ZmfDlWwM18gyV/0kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8A90gkGBQE6jx+vDAqysJxh5NtIaIiGGxlVIUIwEWAr+nZgF/2Bs4GFKchEDTfWKSrPYggOaj0wTMNUmWmjaOhrSTmrLZFElBbVJSZ8ilRWGi7OEUZIzNi8GpDZnoBqqKzlRLToLJET/So+Q+9lCVq/TeekRcWsKX5qOvi49A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueL13kj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueL13kj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D891F00A3A;
	Thu, 30 Jul 2026 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425686;
	bh=N6YHvn3AoZkhBqPlpOR/fdpOj6y0gE4POqdF9G5Rdao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueL13kj06mIlPiDNsNBKjOXCYRZLBjiEEMSsTclM5/w6BUGM7O8iNf/d7WVq4JiDi
	 WKxTRLopZ6RszR+geNw1sVZvlErwZeCi3fqoP06NowKo2t2mBaX/BJ9HUOkeJezFPm
	 p+KAopitCVLrOwBHvu8NzpalINdFWUXV91g88C6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/602] hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:51 +0200
Message-ID: <20260730141438.900460717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 59d104b54b0b42e30fd2a68d24ee5c49dcc54d1e ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 53e68c20aeb1e ("hwmon: add driver for NZXT RGB&Fan Controller/Smart Device v2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index c2d1173f42fefb..6f8febda4277c9 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -774,7 +774,7 @@ static int nzxt_smart2_hid_probe(struct hid_device *hdev,
 
 out_hw_close:
 	hid_hw_close(hdev);
-
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



