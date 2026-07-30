Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247333914ED;
	Thu, 30 Jul 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423820; cv=none; b=BqV1L9rZSpK0vbDLBkgnVp7pLfzYcIk0Hm6rvUjqaHMrr3z6yNHsOCqvnWT26Hmdu3eMTPBIeI69OekogrJWX8ohq5XkSyiqajAKdnyfHb3ErFZnFbiK6I0uDyywBRCclWkE9u9iwMmTvCoHl+50Oo8NhSddWr+uVl3ItN74A3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423820; c=relaxed/simple;
	bh=1xsy/g1khiPZln65DYt/pd6UVGriO4i/9Z8KJK7XRJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl4bLOzOYp2Cv9Q7aBgJl4IpKM36WQ2CxC9qgfaI1cNvjvLJc4cm9+4sZ7WtvkRnPLdqmPi/uQqspVS+QjjxfO6hufiDJ9QER1NKROIHiWnBDt9UY2Wt+ZFWl/DTHNCOzD1Ki7KjpJnwWySELzmMPKbVOjTGci6O79Whb3DEAh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoum1wzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoum1wzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0CF1F000E9;
	Thu, 30 Jul 2026 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423819;
	bh=JDJT6fkQfnm6JgtAPVesJGIcn1B9/DLFVmLNUQL4zdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoum1wzGGWxVCzRy11Vabxu6cop6X79zZpr2KnVgBuXgGYCws0wNxGMy+qs7fa7cB
	 5TTW5PgGsJ+aCIkchOjJ5qfwaXUqcOdnxrduKVxUKIWc/lUFQ4wrTCasPgvo42dMRo
	 nxk03VgtaiVDtq+U/rHmAK5a9P7fmtehFR+3rDEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/675] hwmon: (gigabyte_waterforce) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:20 +0200
Message-ID: <20260730141448.748828247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit ff0c5c53d08274e200b48a4d53aa078265e873cb ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 42ac68e3d4ba0 ("hwmon: Add driver for Gigabyte AORUS Waterforce AIO coolers")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gigabyte_waterforce.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/gigabyte_waterforce.c b/drivers/hwmon/gigabyte_waterforce.c
index 27487e215bddff..4eea05f8b569c2 100644
--- a/drivers/hwmon/gigabyte_waterforce.c
+++ b/drivers/hwmon/gigabyte_waterforce.c
@@ -371,13 +371,15 @@ static int waterforce_probe(struct hid_device *hdev, const struct hid_device_id
 	if (IS_ERR(priv->hwmon_dev)) {
 		ret = PTR_ERR(priv->hwmon_dev);
 		hid_err(hdev, "hwmon registration failed with %d\n", ret);
-		goto fail_and_close;
+		goto fail_and_io_stop;
 	}
 
 	waterforce_debugfs_init(priv);
 
 	return 0;
 
+fail_and_io_stop:
+	hid_device_io_stop(hdev);
 fail_and_close:
 	hid_hw_close(hdev);
 fail_and_stop:
-- 
2.53.0



