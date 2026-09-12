Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C098637CD32;
	Sat, 12 Sep 2026 10:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209541; cv=none; b=NWsjFAsTkTSB7WVTjrYEym5LtAIHgrBxOQqmJpJH/begkBBEpJnw4lsvGFtVdhJHcw6zMcTJgdiwu1spJ9vNjWhvrZ8aSDKrE/J/p7o0aiPZ6yK9tXnnkozrpFdMBjYprF5ZUrZgTva52vfMdvESjo5OGKFNKmgrZx7Q+KzkTew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209541; c=relaxed/simple;
	bh=rnVzw/yZhZYb429juBPGIixQSJk8gmO1LHj/DkDiVt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2WY70qNTXhf6IyqZUJPZkXGSzPdoVmeNwfswscwvzg6KM57xe6M3m6UdDb+uxeIXJj3vP2BTfeHuQc3+cIrAd3HvlwyWA0uFV9y+cz59JahEkR5tQIEuNLx2gDj4A38f88GjCSBrGjSkf0xB2EDD06nPcZI9ySYSeodNcm6ABE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL/WxkFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL/WxkFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3A01F000FF;
	Sat, 12 Sep 2026 10:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209538;
	bh=MyVH8Umb8TWDGdXk7Bm/yZ2/H9MNMfI88qbKcAGBXn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vL/WxkFu2Kik+Tccc42RloyTrGgY7ve3rdrTkpysgzQEkR0M66Ux20SMtYJPeT8mk
	 WxwCD4YrmTOmkMlmesYx3F5T2CyqjouOZlmiEbR6Ks51WzzIn1V2mXSM9SLBfkmsve
	 ED2iotOSIWczPFwyIKlRsxFBrTG7/HGZF4wdILks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0842/1518] HID: i2c-hid: Fix "(null)" output when reading report descriptor fails
Date: Sat, 12 Sep 2026 08:50:11 +0200
Message-ID: <20260912065642.488591580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ai Chao <aichao@kylinos.cn>

[ Upstream commit 8da0f0951deec9f0728ed2d9c54ded1c344b7542 ]

When i2c-hid fails to read the HID report descriptor during device
initialization, the error message prints as:

  hid (null): reading report descriptor failed

The HID device name is set in hid_add_device() after calling
hdev->ll_driver->parse(), so when i2c_hid_parse() fails and calls
hid_err(), the device name has not been set yet, resulting in "(null)"
output.

Use dev_err(&client->dev, ...) instead of hid_err(hid, ...) because
the I2C client device is fully initialized with a proper name, providing
meaningful error messages for debugging.

Before: hid (null): reading report descriptor failed
After:  i2c_hid i2c-TPD0001:00: reading report descriptor failed

Fixes: 4a200c3b9a40 ("HID: i2c-hid: introduce HID over i2c specification implementation")

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index e0a302544cef4..6d407cbed1886 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -790,7 +790,7 @@ static int i2c_hid_parse(struct hid_device *hid)
 					    ihid->hdesc.wReportDescRegister,
 					    rdesc, rsize);
 		if (ret) {
-			hid_err(hid, "reading report descriptor failed\n");
+			dev_err(&client->dev, "reading report descriptor failed\n");
 			goto out;
 		}
 	}
-- 
2.53.0



