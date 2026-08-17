Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AB422541;
	Mon, 17 Aug 2026 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979083; cv=none; b=ObaDEakR5utPCnZ+R6eM92ZqKdrS7uQtT5Q9DwTA7yEhERe1P8GJfD0Wa9IrwlztfHFoebSmY/zvyTI71lSl5WmAff2MtXBEX6EJ0TmQInbTJlCGRRb0NPTKj+LqIp5bTl6sR+StQ5DHK+LxdjZVUGr2WV7pfQXTZmixHb5+Kc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979083; c=relaxed/simple;
	bh=mW7qRxdSnpTinQ921ZaAlYe7wM/L7OJg7mJrxPHfqy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPvQobER4vODeCmpHuU6+TO7gdVdPt5aM7pEewl/YfbDK2q01a271+yzX+Yl8+HdgWJA23xJCWV1kKoVXjejVkVhaeeQ1fur99p8MwYUBtKH8WQbHK9dmN59hOlvHY1aYEmsMgDkx2VqiynoMdHeKY0B8KOfTHnFKwBpFBd/PIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJV9VXbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJV9VXbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1501F1F00A3F;
	Mon, 17 Aug 2026 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979081;
	bh=kEn43EQ/LMIeCTYuVCd2RxQca5YJyJPNfM0Nx8egjfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJV9VXbSMiWxarg45YZs7RKWuV+0gUV2rbLXAIAXys+RbYYpuXf9A7IVGN9MbYUU3
	 W6UM4rP0rU3p8+yDRYp6zXXL0AjCZzZEhpJJBnH4E7kDwqyhbC9RkN6kvMsLVqvC3U
	 BuQobcs7gPMFuioDIo7iFIy5TCqU7Qel3qPsM5u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/609] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Mon, 17 Aug 2026 15:26:37 +0200
Message-ID: <20260817132547.080785796@linuxfoundation.org>
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

[ Upstream commit 94c87871b051d7ad758828a805215a2ec194512a ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 40c3a44542257 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 18da3e013c20b7..62f9372f2d3551 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -558,6 +558,7 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 out_hw_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



